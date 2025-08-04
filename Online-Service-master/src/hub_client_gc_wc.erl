%% coding: utf-8
-module(hub_client_gc_wc).
-include("common.hrl").
-include("proto_player.hrl").

-export([loop/2]).
-export([receive_data/3]).
-export([ handle_other/3]).

format_current_datetime() ->
        {{Year, Month, Day}, {Hour, Minute, Second}} = calendar:local_time(),
        io_lib:format("~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w",
                      [Year, Month, Day, Hour, Minute, Second]).


loop(Socket, {connected}) -> 
   
    case inet:peername(Socket) of
        {ok, {Ip, Port}} ->
            DateTimeStr = format_current_datetime(),
            IpStr = inet:ntoa(Ip),
            LogMsg = io_lib:format("~s - IP: ~s, Port: ~w", 
                                [DateTimeStr, IpStr, Port]),
            io:format("~s~n", [LogMsg]);
        {error, einval} ->
                io:format("Socket invalid  ~n");
        {error, Other} ->
                io:format("Unknown error in peername: ~p~n", [Other])
    end,
    ok;

loop(Socket, {terminate, Reason}) ->
    case inet:peername(Socket) of
        {ok, {Ip, Port}} ->
            DateTimeStr = format_current_datetime(),
            IpStr = inet:ntoa(Ip),
            LogMsg = io_lib:format("~s - IP: ~s, Port: ~w, Terminate Reason: ~p", 
                                   [DateTimeStr, IpStr, Port, Reason]),
            io:format("~s~n", [LogMsg]);
        {error, einval} ->
                io:format("Socket invalid when terminating: ~p~n", [Reason]);
        {error, Other} ->
                io:format("Unknown error in peername: ~p~n", [Other])
    end,
    ok;

loop(_Socket, <<>>) ->
    % 忽略空数据，通常是 TCP 流的末尾或不完整的数据包
  ok;

loop(Socket,  {timeout, first_data}) ->
  io:format("Initial data timeout for socket ~p. Closing connection.~n", [Socket]),
  ok;


loop(Socket, {timeout, heartbeat}) ->
    case inet:peername(Socket) of
        {ok, {Ip, Port}} ->
            IpStr = inet:ntoa(Ip),
            DateTimeStr = format_current_datetime(),
            LogMsg = io_lib:format("~s - IP: ~s, Port: ~w, Heartbeat Timeout ~n",
                                   [DateTimeStr, IpStr, Port]),
            io:format("~s~n", [LogMsg]),
            ok;
        {error, Reason} ->
            DateTimeStr = format_current_datetime(),
            LogMsg = io_lib:format("~s - Unknown peer (heartbeat timeout), reason: ~p~n",
                                   [DateTimeStr, Reason]),
            io:format("~s~n", [LogMsg]),
            ok
    end;



  loop(Socket, Data) ->
  io:format("~p~n",[Data]),
    try
        case proto:handle(Data) of
            % 心跳
            {client_request, mod_player, #mod_player_herat_c2s{}} ->  
                io:format("heart..........~n"),
                gen_tcp:send(Socket, <<"{\"type\":\"ack\"}\r\n">>),
                gen_server:cast(self(), reset_timeout),
                ok;

            % 注册id
            {client_request, mod_player, #mod_player_login_c2s{id = Id, token = _Token}}->
                ets:insert(socket_map, {Id, Socket}),
                gen_tcp:send(Socket, <<"oklogin\r\n">>),
                gen_server:cast(self(), reset_timeout),
                io:format("Device login successful: ID=~p ~p ~n", [Id,Socket]),
                ok;

            %  温湿度   
            {client_request, mod_player, #mod_device_data_c2s{id = Id, temperature=T,humidity=H}}->
                io:format("温湿度: ID=~p, T=~p, H=~p~n", [Id, T, H]),
                New = #{id => Id, temperature => T, humidity => H},
                ets:insert(sensor_latest, {Id, New}),
                gen_server:cast(self(), reset_timeout),
                ok;

            Other ->
                io:format("Unknown message: ~p~n", [Other])
            end
      
    catch
        _:Reason ->
            io:format("Error parsing data: ~p~n", [Reason]),
            receive_data(Socket, <<"raw">>, Data)

        % _ ->
            % receive_data(Socket, <<"raw">>, Data)
    end;

    loop(_Socket, UnexpectedMsg) ->
        logger:warning("Received unexpected message in loop: ~p", [UnexpectedMsg]),
        ok.


%%%-----------------------------------------------------------------
%%% 尚未实现的其它业务类型
%%%-----------------------------------------------------------------
handle_other(_Socket, Type, Map) ->
    io:format("Unhandled type: ~p, payload: ~p~n", [Type, Map]),
    ok.

   %%%-----------------------------------------------------------------
%%% 具体数据处理
%%%-----------------------------------------------------------------

receive_data(_Socket, <<"raw">>, Raw) ->
    io:format("无法解析的数据: ~p~n", [Raw]).