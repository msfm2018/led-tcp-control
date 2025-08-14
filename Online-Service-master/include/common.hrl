%%%-------------------------------------------------------------------
%%% @author ASUS
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 十二月 2014 下午4:50
%%%-------------------------------------------------------------------
-author("ASUS").

-ifndef(COMMON_HRL).
-define(COMMON_HRL, true).


-include("log_common.hrl").
%% -include("un_common.hrl").
%% -include("un_su_ets.hrl").
-include("error.hrl").
-include("server.hrl").

% -record(mnesia_config, {thresholds}).

%% 历史温湿度记录
-record(sensor_history, {
    id,          % 设备 ID
    timestamp,   % 时间戳（秒）
    temperature, % 温度
    humidity     % 湿度
}).


-define(ENV_ETS, my_erlang_env_ets).
-define(CONF_ETS, my_conf_ets).

-define(GAME_POOL, game_pool).
-define(LOG_POOL, log_pool).

-define(TCP_OPTIONS,      [binary, {packet, 0}, {reuseaddr, true}, {nodelay, true}, {delay_send, false}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).
-define(TCP_OPTIONS_ONCE, [binary, {packet, 2}, {reuseaddr, true}, {nodelay, true}, {delay_send, false}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).

-define(TCP_OPTIONS0,     [binary, {packet, 0}, {reuseaddr, true}, {nodelay, true}, {delay_send, false}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).
-define(TCP_OPTIONS2,     [binary, {packet, 2}, {reuseaddr, true}, {nodelay, true}, {delay_send, false}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).

-define(TCP_OPTIONS_S2S,  [binary, {packet, 2}, {recbuf, 10485760}, {sndbuf, 10485760}, {high_watermark, 131072}, {reuseaddr, true}, {nodelay, true}, {delay_send, false}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).

-define(SYNC_SEND(Socket, Data), catch erlang:port_command(Socket, Data, [force])).
%% 网关最大连接数
-define(MAX_GATEWAY_CONNECTIONS, 10000).
-define(CONNECTION_FIRST_DATA_TIME, 5000).  % 连接建立成功之后 在这个时间之内没有发数据则断开
-define(HEART_BREAK_TIME, 120000).   % 心跳时长
-define(HEART_BREAK_CLIENT_TIME, 50000).   % 客户端心跳包间隔
-define(HEART_BREAK_TIME_HTTP, 5000).   % http连接超时时长

-define(SEND_MAX_SECONDS, 4294967). % send_after 的最大秒数
%% work_process 参数
-record(work_process_param, {
    id_key = undefined,
    num,
    type,
    call_back = undefined
}).

%% alone 启动的tcp连接进程是否挂在supervisor下，加上这个用来观察以后效率情况，觉得可以不挂在supervisor下
-record(t_tcp_sup_options, {
    is_websocket = false,
    t_tcp_sup_name = t_tcp_sup,
    t_client_sup_name = t_client_sup,
    t_accept_sup_name = t_accept_sup,
    t_listen_server_name = t_listen_server,
    port = 8888,
    acceptor_num = 10,
    max_connections = 10000,
    tcp_opts = ?TCP_OPTIONS_ONCE,
    call_back = undefined,
    alone = false
}).

%% pg2_agent 参数
-record(pg2_agent_options,{
    pg2_name,
    name,   % 这个name只是用来注册名称时用的
    type = local,   % type 用来是local或者global
    callback
}).

-record(cluster_server_option, {
    name,
    callback = undefined
}).

-record(cluster_client_options, {
    name,
    connect_node,
    callback = undefined,
    reconnect_time = 2000   % 重连时间
}).

-record(tcp_client_opts, {
    name,
    ip,
    port,
    tcp_opts = ?TCP_OPTIONS_ONCE,
    callback
}).

%%%-----------------------------------------
%%%  定义一些函数宏
%%%-----------------------------------------
-define(TO_L(A), lib_change:to_list(A)).
-define(TO_A(A), lib_change:to_atom(A)).
-define(TO_B(A), lib_change:to_binary(A)).
-define(TO_I(A), lib_change:to_integer(A)).
-define(TO_T(A), lib_change:to_tuple(A)).

%% "[]" -> []
-define(STRING_TO_TERM(A), lib_change:list_to_term(A)).
%% [] -> "[]"
-define(TERM_TO_STRING(A), lists:flatten(io_lib:format("~w",[A]))).
%% 数据中存的 "[{xxx}]"　等形式　　　　取出来后是<<"[{xxx}]">> 这个define将转换为 [{xxx}]
-define(DB_STRING_TO_TERM(A), ?STRING_TO_TERM(?TO_L(A))).

-define(NOW, lib_time:nowseconds()).
-define(NOWS,lib_time:nowms()).
-define(CONFIG(Type), config:lookup(Type)).
-define(CONFIG(Type, Key), config:lookup(Type, Key)).
-define(SET_CONFIG(Type, Value), config:set(Type, Value)).

%% 向下取整
-define(TRUNC(A), erlang:trunc(A)).

-define(CHECK(A),
    case A of
        true -> ok;
        _ -> ?THROW(A)
    end).

-define(IF(A, B), ((A) andalso (B))).
-define(IF(A, B, C),
    (case (A) of
        true -> (B);
        _ -> (C)
    end)).

-define(MONITOR_PROCESS(A), erlang:monitor(process, A)).
-define(TRAP_EXIT, erlang:process_flag(trap_exit, true)).
-define(PRIORITY, erlang:process_flag(priority, high)).
-define(TRACE_STACK, erlang:process_info(self(), current_stacktrace)).

-define(UNDEFINED, undefined).
-define(NULL, null).

-ifdef(TEST).
-define(LOG_LEVEL, 5).
-else.
-define(LOG_LEVEL, 3).
-endif.

-define(R_FIELDS(Record), record_info(fields, Record)).
-define(THROW(E), throw({error, E})).
-define(THROW_ERROR, error).
-define(APP_START(A), server_sup:start_app(A)).
-define(ETS_LOOKUP_ELEMENT(TABLE, KEY, POS), lib_normal:ets_lookup_element(TABLE, KEY, POS)).


%%%-----------------------------------------
%%%  定义一些函数宏 end
%%%-----------------------------------------


%%%-----------------------------------------
%%%  定义数据库操作
%%%-----------------------------------------
-define(SELECT_ROW(TABLE, FIELDS, WHERE), db_mysql:select_row(?GAME_POOL, TABLE, FIELDS, WHERE)).
-define(SELECT_ONE(TABLE, FIELDS, WHERE), db_mysql:select_one(?GAME_POOL, TABLE, FIELDS, WHERE)).
-define(SELECT_ALL(TABLE, FIELDS, WHERE), db_mysql:select_all(?GAME_POOL, TABLE, FIELDS, WHERE)).
-define(INSERT(TABLE, FIELDS, VALUES), db_mysql:insert(?GAME_POOL, TABLE, FIELDS, VALUES)).
-define(UPDATE(TABLE, FIELD_VALUES_LIST, WHERE), db_mysql:update(?GAME_POOL, TABLE, FIELD_VALUES_LIST, WHERE)).
-define(UPDATE(TABLE, FIELDS, VALUES, K, V), db_mysql:update(?GAME_POOL, TABLE, FIELDS, VALUES, K, V)).

-define(SELECT_ROW(GAME_POOL, TABLE, FIELDS, WHERE), db_mysql:select_row(GAME_POOL, TABLE, FIELDS, WHERE)).
-define(SELECT_ONE(GAME_POOL, TABLE, FIELDS, WHERE), db_mysql:select_one(GAME_POOL, TABLE, FIELDS, WHERE)).
-define(SELECT_ALL(GAME_POOL, TABLE, FIELDS, WHERE), db_mysql:select_all(GAME_POOL, TABLE, FIELDS, WHERE)).
-define(INSERT(GAME_POOL, TABLE, FIELDS, VALUES), db_mysql:insert(GAME_POOL, TABLE, FIELDS, VALUES)).
-define(UPDATE(GAME_POOL, TABLE, FIELD_VALUES_LIST, WHERE), db_mysql:update(GAME_POOL, TABLE, FIELD_VALUES_LIST, WHERE)).
-define(UPDATE(GAME_POOL, TABLE, FIELDS, VALUES, K, V), db_mysql:update(GAME_POOL, TABLE, FIELDS, VALUES, K, V)).

-define(DB_SELECT_ONE_NULL, null).
-define(DB_SELECT_ROW_NULL, null).
-define(DB_SELECT_ALL_NULL, []).

%% 定义数据脏标记
-define(DBFLAG_NOCHANGE, 0).
-define(DBFLAG_INSERT, 1).
-define(DBFLAG_UPDATE, 2).

%%%-----------------------------------------
%%%  定义数据库操作 end
%%%-----------------------------------------

%%%-----------------------------------------
%%%  定义ｔｉｍｅｒ记录
%%%-----------------------------------------
%% 存盘timer
-record(player_save_timer, {
    time
}).

%% 每天零点定时器
-record(player_int24_timer, {
    time
}).

%% 针对某个模块的timer
-record(player_timer,{
    mod,
    function,
    time
}).

%%%-----------------------------------------
%%%  定义ｔｉｍｅｒ记录　ｅｎｄ
%%%-----------------------------------------

%%%-----------------------------------------
%%%  ｅｔｓ表
%%%-----------------------------------------
%% ｉｄ表
-define(ID_TABLE, id_table).

%% kv_cache表
-define(KV_TABLE, kv_table).


%% un
-define(EXTERNAL_NODE_ACCEPT_INFO, external_node_accept_info).
%% un   end


-define(ETS_READ_CONCURRENCY, {read_concurrency, true}).
-define(ETS_WRITE_CONCURRENCY, {write_concurrency, true}).

%%%-----------------------------------------
%%%  ｅｔｓ表 end
%%%-----------------------------------------

-define(IDKEY_GNUM(Node), {gnum, Node}).
-endif.