-module(gc_gateway_app).  %cowboy 2.13

-behaviour(application).
-include("common.hrl").

-export([start/2]).
-export([quit/0]).
-export([stop/1]).
-export([run/0]).
-export([save_alarm_config/1]).



start(_StartType, _StartArgs) ->

% Start Mnesia
SchemaDir = filename:join(["Mnesia." ++ atom_to_list(node())]),
case filelib:is_dir(SchemaDir) of
  false ->
    io:format("Creating Mnesia schema at ~s~n", [SchemaDir]),
    ok = mnesia:create_schema([node()]);
  true ->
    io:format("Mnesia schema already exists at ~s~n", [SchemaDir])
end,
ok = mnesia:start(),


% 告警记录表
    case mnesia:create_table(mnesia_config, [
      {attributes, [key, value]},
      {disc_copies, [node()]}, % Persistent storage on disk
      {type, set}
    ]) of
      {atomic, ok} ->
        io:format("Mnesia table mnesia_config created~n");
      {aborted, {already_exists, _}} ->
        io:format("Mnesia table mnesia_config already exists~n");
      {aborted, Reason} ->
                io:format("Mnesia 表创建失败：~p~n", [Reason]),
                throw({mnesia_create_table_failed, Reason})
    end,


% 创建历史温湿度表
case mnesia:create_table(sensor_history, [
    {attributes, record_info(fields, sensor_history)},
    {disc_copies, [node()]},
    {type, bag}   % 同一个 ID 允许多条记录
]) of
    {atomic, ok} ->
        io:format("Mnesia 表 sensor_history 创建成功~n");
    {aborted, {already_exists, _}} ->
        io:format("Mnesia 表 sensor_history 已存在~n");
    {aborted, R} ->
        io:format("创建 sensor_history 表失败: ~p~n", [R]),
        throw({mnesia_create_table_failed, R})
end,




  {ok, Pid} = server_sup:start_link(?MODULE),
  case application:ensure_all_started(cowboy) of
    {ok, Apps} ->
        io:format("Cowboy 启动完成：~p~n", [Apps]);
    {error, CowboyReason} ->
        io:format("Cowboy 启动失败：~p~n", [CowboyReason]),
        throw({cowboy_start_failed, CowboyReason})
  end,

  %% 建一张 set：Key = Id, Value = #{t => Temperature, h => Humidity}
  ets:new(sensor_latest, [named_table, public, set,{read_concurrency, true},{write_concurrency, true}]),

  % 温湿度告警阈值
  ets:new(sensor_alarm_config, [named_table, public, set, {read_concurrency, true}, {write_concurrency, true}]),
  % 每个设备对应的 socket
  ets:new(socket_map, [named_table, public, set, {read_concurrency, true}, {write_concurrency, true}]),               

  io:format("从 Mnesia 加载 sensor_alarm_config 到 ETS...~n"),
  load_alarm_config_from_mnesia(),

  % 如果 ETS 表为空，插入默认阈值
  case ets:lookup(sensor_alarm_config, thresholds) of
      [] ->
        DefaultConfig = #{temp_high => 40.0, temp_low => 0.0, hum_high => 70, hum_low => 20},
        ets:insert(sensor_alarm_config, {thresholds, DefaultConfig}),
        save_alarm_config(DefaultConfig), % 保存到 Mnesia
        io:format("插入默认阈值到 ETS 和 Mnesia：~p~n", [DefaultConfig]);
      _ ->
        io:format("已从 Mnesia 加载阈值到 ETS~n")
    end,

  io:format("配置 Cowboy 路由...~n"),
  % %% 定义Cowboy路由
  Dispatch = cowboy_router:compile([
  {'_', [
     {"/alarm/threshold", alarm_config_handler, []},%%告警阈值
     {"/alarm/threshold/get", alarm_get_handler, []},
      {"/s", sensor_ws_handler, []} , %% 留着也行
      {"/test", toppage_h, []} , %% 测试 stm32 http get数据
      {"/led/set", led_set_handler, []},
      %% get post 接口 curl -X POST http://127.0.0.1:8999/gp -d "{\"type\":\"0x01\", \"id\":123, \"temperature\":25.3, \"humidity\":60}" -H "Content-Type: application/json"
      % curl -v http://127.0.0.1:8999/gp  
      {"/gp", sensor_httget_post_handler, []} , 
      {"/history/:id", sensor_history_handler, []}, %curl http://127.0.0.1:8999/history/123
      {"/latest", sensor_http_handler, []}   %% tcp接口使用
  
  ]}
  ]),
  % %% 启动Cowboy HTTP服务器

  io:format("启动 Cowboy HTTP 服务器...~n"),
  case cowboy:start_clear(http, [{port, 8999}], #{env => #{dispatch => Dispatch}}) of
    {ok, _} ->
        io:format("Cowboy HTTP 服务器启动完成~n");
    {error, HttpReason} ->
        io:format("Cowboy HTTP 服务器启动失败：~p~n", [HttpReason]),
        throw({cowboy_http_start_failed, HttpReason})
  end,

  websocket_sup:start_link(),

  io:format("启动 reloader...~n"),
  reloader:start(?MODULE),
  io:format("reloader 启动完成~n"),

  % 运行 TCP 服务
  io:format("启动 TCP 服务...~n"),
  run(),
  io:format("TCP 服务启动完成~n"),

  io:format("应用启动完成~n"),
  {ok, Pid}.

quit() ->
  exit(whereis(?MODULE), kill).

stop(_State) ->  
  ok = cowboy:stop_listener(http),
  ok.

run() ->
  Opt = #t_tcp_sup_options{
    is_websocket=false,
    t_tcp_sup_name = hub_client_gc_wc,
    port = 8888,
    acceptor_num = 30,
    max_connections = infinity,% MaxConnection,
    tcp_opts = [binary, {packet, 0}, {reuseaddr, true}, {nodelay, true}, {delay_send, false}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}],
    call_back = fun hub_client_gc_wc:loop/2,
    alone = true
  },
  t_tcp_sup:start_child(?MODULE, Opt),
  ok.


% 从 Mnesia 加载数据到 ETS
load_alarm_config_from_mnesia() ->
  case mnesia:dirty_read(mnesia_config, thresholds) of
    [{mnesia_config, thresholds, Value}] ->
      ets:insert(sensor_alarm_config, {thresholds, Value}),
      io:format("从 Mnesia 加载 mnesia_config 到 ETS：~p~n", [Value]);
    [] ->
      io:format("Mnesia 中没有 mnesia_config 数据~n");
    {error, Reason} ->
            io:format("从 Mnesia 读取 mnesia_config 失败：~p~n", [Reason]),
            throw({mnesia_read_failed, Reason})
  end.

% 保存数据到 Mnesia
save_alarm_config(Config) ->
    case mnesia:dirty_write({mnesia_config, thresholds, Config}) of
        ok ->
            io:format("保存 mnesia_config 到 Mnesia：~p~n", [Config]);
        {error, Reason} ->
            io:format("保存 mnesia_config 到 Mnesia 失败：~p~n", [Reason]),
            throw({mnesia_write_failed, Reason})
    end.

