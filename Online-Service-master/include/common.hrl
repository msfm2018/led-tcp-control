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



-record(tb1, {id , ip,port, cpu , mem }).
-define(Tb1,tb1).




-record(localcfg, {id,port,acceptor_num,externalip}).
-define(LocalCfg,localcfg).

-define(SYNC_SEND(Socket, Data), catch erlang:port_command(Socket, Data, [force])).
%% 网关最大连接数
-define(CONNECTION_FIRST_DATA_TIME, 20000).  % 连接建立成功之后 在这个时间之内没有发数据则断开
-define(HEART_BREAK_TIME, 15000).   % 15s 心跳时长

-define(ACCEPT_TIMEOUT, 60000). % 60秒
% -define(CONNECTION_FIRST_DATA_TIME, 5000). % 5秒
% -define(HEART_BREAK_TIME, 30000). % 30秒


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
    tcp_opts =undefined,
    call_back = undefined,
    alone = false
}).



-define(IF(A, B), ((A) andalso (B))).
-define(IF(A, B, C),
    (case (A) of
        true -> (B);
        _ -> (C)
    end)).


-define(MONITOR_PROCESS(A), erlang:monitor(process, A)).
-define(TRAP_EXIT, erlang:process_flag(trap_exit, true)).

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





-define(ETS_READ_CONCURRENCY, {read_concurrency, true}).
-define(ETS_WRITE_CONCURRENCY, {write_concurrency, true}).

%%%-----------------------------------------
%%%  ｅｔｓ表 end
%%%-----------------------------------------

-define(IDKEY_GNUM(Node), {gnum, Node}).
-endif.