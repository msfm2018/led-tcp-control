-module(led_set_handler).


-export([init/2]).



% curl -X POST http://127.0.0.1:8999/led/set -d "{\"type\":\"0x01\", \"id\":123, \"temperature\":25.3, \"humidity\":60}" -H "Content-Type: application/json"
% curl -X POST http://127.0.0.1:8999/led/set -d "{\"id\":123, \"cmd\":25.3}" -H "Content-Type: application/json"
init(Req0=#{method := <<"OPTIONS">>}, State) ->
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
    Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req1),
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
    {ok, Resp} = cowboy_req:reply(200, Req3),
    {ok, Resp, State};
init(Req0=#{method := <<"POST">>}, _State) ->

case cowboy_req:read_body(Req0) of
    {ok, Body, _Req2} ->
        % 解析 Body，做你的逻辑
 

        {ok, Body, _Req1} = cowboy_req:read_body(Req0),
        io:format("Received body: ~p", [Body]),
    
        case json:decode(Body) of
    
            #{<<"id">> := Id, <<"cmd">> := Cmd} ->
                case ets:lookup(socket_map, Id) of
                    [{Id, Socket}] ->
                        io:format("id cmd:~p~n",[Id]),
                        % 转发命令，比如 "LED_OFF"
                        case send_command(Socket, Cmd) of
                            ok ->
                                Reply = #{code => 0, msg => <<"sent">>};
                            {error, Reason} ->
                                Reply = #{code => 2, msg => list_to_binary(io_lib:format("Send failed: ~p", [Reason]))}
                        end;
                    [] ->
                        Reply = #{code => 1, msg => <<"device not online">>}
                end,
                % Json = <<"abc">>,%% 
                Json=  json:encode(Reply),
    
                Req10 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
                Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req10),
                Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
    
                {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req3),
                {ok, Resp, _State};
            Other ->
                io:format("~p~n",[Other]),
                Req10 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
                Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req10),
                Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
                {ok, Resp} = cowboy_req:reply(400, #{<<"content-type">> => <<"text/plain">>}, <<"Invalid JSON">>, Req3),
                {ok, Resp, _State}
        end;
    {more, PartialBody, _Req2} ->
        % 处理 Body 过长情况
 io:format("_PartialBody   ~p~n",PartialBody),
        {ok, Req0, _State}
end.



 
    send_command(Socket, <<"led_on">>) ->
        io:format("发送命令: led_on~n"),
        gen_tcp:send(Socket, <<"ledon\r\n">>);
    send_command(Socket, <<"led_off">>) ->
        io:format("发送命令: led_off~n"),
        gen_tcp:send(Socket, <<"ledoff\r\n">>);
    send_command(_, Cmd) ->
        io:format("无效命令: ~p~n", [Cmd]),
        {error, invalid_command}.


% -module(led_set_handler).
% -export([init/2]).

% init(Req=#{method := <<"GET">>}, State) ->
%     Qs = cowboy_req:parse_qs(Req),
%     A = proplists:get_value(<<"a">>, Qs, <<"0">>),
%     Value = case A of <<"1">> -> 1; _ -> 0 end,
%     ets:insert(sensor_latest, {led, Value}),
%     Response = integer_to_binary(Value),
%     Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
%     Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req1),
%     Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
%     cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Response, Req3),
 
%     {ok, Req1, State};

% init(Req, State) ->
%     Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
%     Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req1),
%     Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
%     cowboy_req:reply(405, #{}, <<"Method Not Allowed">>, Req3),


%     {ok, Req, State}.
