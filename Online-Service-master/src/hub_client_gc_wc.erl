%% coding: utf-8
-module(hub_client_gc_wc).
-include("common.hrl").


-export([loop/2]).
-export([receive_data/3]).
-export([safe_decode/1, process_line/2, handle_other/3]).

safe_decode(Bin0) ->
    try
        {ok, json:decode(Bin0)}
    catch
        error:Reason -> {error, Reason}
    end.
format_current_datetime() ->
        {{Year, Month, Day}, {Hour, Minute, Second}} = calendar:local_time(),
        io_lib:format("~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w",
                      [Year, Month, Day, Hour, Minute, Second]).





loop(_Socket, {connected, PeerIp, PeerPort}) -> 
    logger:info("Connected: ~p:~p", [PeerIp, PeerPort]),
    io:format("~p~n",[ { PeerIp, PeerPort}]),
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
% loop(Socket, {terminate, Reason}) ->
%     {ok, {Ip, Port}} = inet:peername(Socket),
%     {{Year, Month, Day}, {Hour, Minute, Second}} = calendar:local_time(),
%     DateTimeStr = io_lib:format("~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w", 
%                                 [Year, Month, Day, Hour, Minute, Second]),
%     IpStr = inet:ntoa(Ip), % 將 IP 元組轉為字符串
%     LogMsg = io_lib:format("~s - IP: ~s, Port: ~w, Terminate Reason: ~p", 
%                            [DateTimeStr, IpStr, Port, Reason]),
%     io:format("~s~n", [LogMsg]),

  
%             % % 尝试从 socket_map 找到对应 ID 并删除
%             % case [Id || {Id, Sock} <- ets:tab2list(socket_map), Sock == Socket] of
%             %     [FoundId] ->
%             %         io:format("database delete id ~p~n",[FoundId]),
%             %         ets:delete(socket_map, FoundId);
%             %     _ ->  
%             %         io:format("database not foundid id ~n"), 
%             %         ok
%             % end,

%   ok;

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



  loop(Socket, Data) when is_binary(Data)->
    try
        Lines = binary:split(Data, <<"\r\n">>, [global, trim]),
        lists:foreach(
            fun(Line) ->
                case Line of
                    <<>> ->
                        ok;
                    _ ->
                        process_line(Socket, Line)
                end
            end,
            Lines
        ),
        ok
    catch
        _ ->
            receive_data(Socket, <<"raw">>, Data)
    end;

    loop(_Socket, UnexpectedMsg) ->
        logger:warning("Received unexpected message in loop: ~p", [UnexpectedMsg]),
        ok.

%% 处理单行数据
process_line(Socket, Line) ->
    io:format("Line::::::::::::::;~p~n",[Line]),
    try
      
              case safe_decode(Line) of
                       %% ---------- 0x00 登录 ----------
                    {ok, #{<<"type">> := <<"0x00">>} = Map} ->
                        receive_data(Socket, <<"0x00">>, Map);
                %% ---------- 0x01 温湿度 ----------
                {ok, #{<<"type">> := <<"0x01">>} = Map} ->
                    receive_data(Socket, <<"0x01">>, Map);
        
                %% ---------- 0x07 心跳 ----------
                {ok, #{<<"type">> := <<"0x07">>} = Map} ->
                    receive_data(Socket, <<"0x07">>, Map);      %% 心跳包无需额外字段
        
                %% ---------- 其他类型，都交给 handle_other ----------
                {ok, #{<<"type">> := Type} = Map} ->
                    handle_other(Socket, Type, Map);

                %% ---------- JSON 解析失败 ----------
                {ok, OtherMap} -> % 成功解码但没有 'type' 字段或 'type' 字段不是二进制
                    logger:warning("JSON decoded, but missing 'type' field or 'type' is not binary: ~p", [OtherMap]),
                    receive_data(Socket, <<"raw">>, Line);

                %% ---------- JSON 解析失败 ----------
                {error, Reason} ->
                    io:format("JSON decode error: ~p~n", [Reason]),
                    receive_data(Socket, <<"raw">>, Line);
                _ ->
                    io:format("Unrecognized payload~n")
                    % {noreply, State}
            end
        %   end
          catch
            ERRORV ->
                io:format("单行处理错误: ~p~n", [ERRORV]),
                receive_data(Socket, <<"raw">>, Line)
        end.

%%%-----------------------------------------------------------------
%%% 尚未实现的其它业务类型
%%%-----------------------------------------------------------------
handle_other(_Socket, Type, Map) ->
    io:format("Unhandled type: ~p, payload: ~p~n", [Type, Map]),
    ok.

   %%%-----------------------------------------------------------------
%%% 具体数据处理
%%%-----------------------------------------------------------------
receive_data(Socket, <<"0x00">>, #{<<"id">> := Id, <<"token">> := _Token}) ->

   
            ets:insert(socket_map, {Id, Socket}),
            gen_tcp:send(Socket, <<"oklogin\r\n">>),
            gen_server:cast(self(), reset_timeout),
            io:format("Device login successful: ID=~p ~p ~n", [Id,Socket]); 



receive_data(_Socket, <<"0x01">>,
    #{<<"id">> := Id,
      <<"temperature">> := T,
      <<"humidity">> := H}) ->

          io:format("温湿度: ID=~p, T=~p, H=~p~n", [Id, T, H]),
          New = #{id => Id, temperature => T, humidity => H},
          ets:insert(sensor_latest, {Id, New}),
          gen_server:cast(self(), reset_timeout);
          





receive_data(Socket, <<"0x07">>, #{<<"id">> := _Id}) ->
    
    gen_tcp:send(Socket, <<"{\"type\":\"ack\"}\r\n">>),
    gen_server:cast(self(), reset_timeout),
    ok;

    receive_data(_Socket, <<"legacy">>, #{id := Id, data := DataValue}) ->
      io:format("收到旧格式数据: ID=~p, Data=~p~n", [Id, DataValue]),
      ok;

receive_data(_Socket, <<"raw">>, Raw) ->
    io:format("无法解析的数据: ~p~n", [Raw]).