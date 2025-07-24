-module(toppage_h).


-export([init/2]).



    init(Req0=#{method := <<"GET">>}, State) ->
        handle_get(Req0, State),
        {ok, Req0, State};

    

    init(Req0, State) ->
        {ok, cowboy_req:reply(405, #{<<"content-type">> => <<"text/plain">>}, <<"Method Not Allowed">>, Req0), State}.


    handle_get(Req, _State) ->
        Qs = cowboy_req:parse_qs(Req),
    
    % Qs 是 [{<<"a">>, <<"abc">>}] 格式的列表
    io:format("Parsed Query String: ~p~n", [Qs]),

    % 获取某个参数的值
    A = proplists:get_value(<<"a">>, Qs, <<"not_found">>),
    io:format("Value of a: ~p~n", [A]),

    Response =A,% jsx:encode(#{ <<"result">> => A }),

    %   //  Response = <<"mygod">>,

        Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
        Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req1),
        Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
        cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Response, Req3).

