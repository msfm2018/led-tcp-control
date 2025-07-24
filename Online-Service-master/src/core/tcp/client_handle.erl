

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
  {ok, {PeerIp, PeerPort}} = inet:peername(Socket),
  _ = try CallBack(Socket, {connected, PeerIp, PeerPort})
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

    handle_info(timeout, S = #state{socket = Sock, call_back = CB, waiting_first = true}) ->
        CB(Sock, {timeout, first_data}),
        {stop, {tcp_closed, Sock}, S};
    
    handle_info(timeout, S = #state{socket = Sock, call_back = CB, waiting_first = false, timeout_count = Count}) ->
            NewCount = Count + 1,
            if
                NewCount >= 3 -> % 連續3次超時後關閉
                    CB(Sock, {timeout, heartbeat}),
                    {stop, {timeout, heartbeat}, S};
                true ->
                    CB(Sock, {timeout, heartbeat}),
                    {noreply, S#state{timeout_count = NewCount}, ?HEART_BREAK_TIME}
            end;

    
    handle_info({tcp_closed, Socket}, State) ->
        {stop, {tcp_closed, Socket}, State};
    
    handle_info(_Any, State) ->
        logger:warning("Unexpected message: ~p, State: ~p", [_Any, State]),
        {noreply, State, ?HEART_BREAK_TIME}.


terminate(Reason, #state{socket=Socket, call_back = CallBack}) ->
    logger:info("Terminating with reason: ~p, Socket: ~p", [Reason, Socket]),
    try CallBack(Socket, {terminate, Reason})
    catch
        Type:Error -> logger:error("Callback error in terminate: ~p:~p", [Type, Error])
    end,
    catch gen_tcp:close(Socket),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.