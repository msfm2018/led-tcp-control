

-module(client_handle).
-behaviour(gen_server).
-include("common.hrl").
-export([start/2, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-define(SERVER, ?MODULE).

-record(state, {
    call_back,
    socket,
    waiting_first = true  ,
    timeout_count = 0   
}).

start(Option, Socket) ->
    gen_server:start(?MODULE, [Option, Socket], []).

init([#t_tcp_sup_options{call_back = CallBack}, Socket]) ->
%   {ok, {PeerIp, PeerPort}} = inet:peername(Socket),
  _ = try CallBack(Socket, {connected})
      catch _:_ -> ok
      end,

    case inet:setopts(Socket, [{active, once}]) of
        ok -> {ok, #state{call_back = CallBack, socket = Socket, waiting_first = true}, ?CONNECTION_FIRST_DATA_TIME};
        {error, Reason} -> {stop, {inet_error, Reason}}
    end.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.


    handle_cast(reset_timeout, State) ->
        logger:info("Resetting timeout for socket: ~p", [State#state.socket]),
        {noreply,  State#state{timeout_count = 0}, ?HEART_BREAK_TIME};

    handle_cast(_Request, State) ->
        logger:warning("Unexpected cast: ~p", [_Request]),
        {noreply, State, ?HEART_BREAK_TIME}.
 
    
        handle_info({tcp, Socket, Data}, State = #state{socket=Socket, call_back=CallBack}) ->
            case inet:setopts(Socket, [{active, once}]) of
                ok ->
                    try CallBack(Socket, Data) of
                        stop -> {stop, normal, State};
                        _ -> {noreply, State#state{waiting_first = false}, ?HEART_BREAK_TIME}
                    catch
                        Type:Error ->
                            logger:error("Callback error: ~p:~p", [Type, Error]),
                            {stop, {callback_error, Error}, State}
                    end;
                {error, Reason} ->
                    {stop, {inet_error, Reason}, State}
            end;
    % 屏蔽超时
    % handle_info(timeout, State = #state{socket = Socket, call_back = CB, waiting_first = true}) ->
    %     CB(Socket, {timeout, first_data}),

    %     {stop, {tcp_closed, Socket}, State};
    
    % handle_info(timeout, S = #state{socket = Sock, call_back = CB, waiting_first = false, timeout_count = Count}) ->
    %         NewCount = Count + 1,
    %         if
    %             NewCount >= 3 -> % 連續3次超時後關閉
    %                 CB(Sock, {timeout, heartbeat}),
    %                 {stop, {timeout, heartbeat}, S};
    %             true ->
    %                 CB(Sock, {timeout, heartbeat}),
    %                 {noreply, S#state{timeout_count = NewCount}, ?HEART_BREAK_TIME}
    %         end;

    handle_info({turn_off_alarm, Id}, State) ->
        case ets:lookup(socket_map, Id) of
            [{Id, Map}] ->
                Socket1 = maps:get(socket, Map, undefined),
                gen_tcp:send(Socket1, <<"ledoff\r\n">>),
                NewMap = maps:put(alarm_light, off, Map),
                ets:insert(socket_map, {Id, NewMap}),
                io:format("定时熄灭设备 ~p 的报警灯~n", [Id]);
            _ ->
                io:format("报警灯关闭失败：未找到设备 ~p~n", [Id])
        end,
        {noreply, State, ?HEART_BREAK_TIME};
    

    handle_info({tcp_closed, _Socket}, State) ->
    %% 正常关闭，停止进程
    {stop, normal, State};

   

    handle_info(_Any, State) ->
        % io:format("Unexpected message: ~p, State: ~p", [_Any, State]),
        {noreply, State, ?HEART_BREAK_TIME}.


        terminate(Reason, #state{socket = Socket, call_back = _CallBack, waiting_first = true}) ->

        delete_socket_from_map(Socket),

            case Reason of
                {tcp_closed, Socket} ->
                    %% 是首次数据未到超时，跳过回调
                    io:format("First data timeout, skip terminate callback for socket ~p", [Socket]);
                _ ->
                    %% 其他原因可选是否回调（这里为了安全保守跳过）
                io:format("Waiting_first=true but unexpected reason: ~p", [Reason])
            end,
            
            catch    gen_tcp:send(Socket, <<"timeouterror">>),
            catch gen_tcp:close(Socket),
            ok;
        

terminate(Reason, #state{socket=Socket, call_back = CallBack}) ->
    delete_socket_from_map(Socket),

    try CallBack(Socket, {terminate, Reason})
    catch
        Type:Error ->   io:format("Callback error in terminate: ~p:~p~n", [Type, Error])
    end,
    catch gen_tcp:close(Socket),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

    delete_socket_from_map11111(Socket) ->
        case [Id || {Id, Sock} <- ets:tab2list(socket_map), Sock == Socket] of
            [FoundId] ->
                io:format("database delete id ~p~n",[FoundId]),
                ets:delete(socket_map, FoundId);
            _ ->
                io:format("database not foundid id ~n"),
                ok
        end.

        delete_socket_from_map(Socket) ->
            Matches = lists:filter(
              fun({Id, M}) -> maps:get(socket, M, undefined) == Socket end,
              ets:tab2list(socket_map)
            ),
            case Matches of
                [{FoundId, _}] ->
                    io:format("database delete id ~p~n",[FoundId]),
                    ets:delete(socket_map, FoundId);
                _ ->
                    io:format("database not found id~n"),
                    ok
            end.
        