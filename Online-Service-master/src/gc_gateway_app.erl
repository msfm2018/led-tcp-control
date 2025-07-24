-module(gc_gateway_app).  %cowboy 2.13

-behaviour(application).
-include("common.hrl").

-export([start/2]).
-export([quit/0]).
-export([stop/1]).
-export([run/0]).

start(_StartType, _StartArgs) ->

  {ok, Pid} = server_sup:start_link(?MODULE),
  application:ensure_all_started(cowboy),

  %% 建一张 set：Key = Id, Value = #{t => Temperature, h => Humidity}
  ets:new(sensor_latest, [named_table, public, set,{read_concurrency, true},{write_concurrency, true}]),

  ets:new(socket_map, [named_table, public, set, {read_concurrency, true}, {write_concurrency, true}]),

  % %% 定义Cowboy路由
  Dispatch = cowboy_router:compile([
  {'_', [
      {"/s", sensor_ws_handler, []} , %% 留着也行
      {"/test", toppage_h, []} , %% 测试 stm32 http get数据
      {"/led/set", led_set_handler, []},
      %% get post 接口 curl -X POST http://127.0.0.1:8999/gp -d "{\"type\":\"0x01\", \"id\":123, \"temperature\":25.3, \"humidity\":60}" -H "Content-Type: application/json"
      % curl -v http://127.0.0.1:8999/gp  
      {"/gp", sensor_httget_post_handler, []} , 

      {"/latest", sensor_http_handler, []}   %% tcp接口使用
  ]}
  ]),
  % %% 启动Cowboy HTTP服务器
  {ok, _} = cowboy:start_clear(http, [{port, 8999}], #{env => #{dispatch => Dispatch}}),
  websocket_sup:start_link(),

  reloader:start(?MODULE),
  run(),

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


