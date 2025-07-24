-module(sensor_httget_post_handler).
-export([init/2]).

% init(Req, State) ->
%     Method = cowboy_req:method(Req),
%     case Method of
%         <<"GET">> -> handle_get(Req, State);
%         <<"POST">> -> handle_post(Req, State);
%         _ -> {ok, cowboy_req:reply(405, #{<<"content-type">> => <<"text/plain">>}, <<"Method Not Allowed">>, Req), State}
%     end.

    init(Req0=#{method := <<"GET">>}, State) ->
        % Req = cowboy_req:reply(200, #{
        %     <<"content-type">> => <<"text/plain">>
        % }, <<"Hello world!">>, Req0),
        handle_get(Req0, State),
        {ok, Req0, State};

        init(Req0=#{method := <<"POST">>}, State) ->
        % Req = cowboy_req:reply(200, #{
        %     <<"content-type">> => <<"text/plain">>
        % }, <<"Hello world!">>, Req0),
        handle_post(Req0, State),
        {ok, Req0, State};

    init(Req0, State) ->
        {ok, cowboy_req:reply(405, #{<<"content-type">> => <<"text/plain">>}, <<"Method Not Allowed">>, Req0), State}.


    handle_get(Req, _State) ->
        % 假设 sensor_latest 是 ETS 表

        All = [V || {_Id, V} <- ets:tab2list(sensor_latest)],
        Response = json:encode(All),

        Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
        Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req1),
        Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
        cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Response, Req3).



handle_post(Req, State) ->
    {ok, Body, Req2} = cowboy_req:read_body(Req),
    logger:info("Received body: ~p", [Body]),
    {Status, Response} = case safe_decode(Body) of
        {ok, #{<<"type">> := <<"0x01">>, <<"id">> := _Id, <<"temperature">> := T, <<"humidity">> := H} = Map} ->
            case is_number(T) andalso is_number(H) andalso (T >= -50) andalso (T <  150) andalso (H >= 0) andalso (H <  100) of
                true ->
                    receive_data(Req2, <<"0x01">>, Map),
                    {200, <<"Temperature and humidity data received successfully">>};
                false ->
                    {400, <<"Invalid temperature or humidity values">>}
            end;
        {ok, _} ->
            {400, <<"Invalid data format">>};
        {error, _} ->
            {400, <<"JSON parsing failed">>}
    end,
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req2),
    Req4 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST">>, Req3),
    Req5 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req4),
    {ok, cowboy_req:reply(Status, #{<<"content-type">> => <<"text/plain">>}, Response, Req5), State}.


safe_decode(Bin0) ->
    try
        {ok, json:decode(Bin0)}
    catch
        error:Reason -> {error, Reason}
    end.

receive_data(_Req, <<"0x01">>, #{<<"id">> := Id, <<"temperature">> := T, <<"humidity">> := H} = Map) ->
    logger:info("温湿度: ID=~p, T=~p, H=~p", [Id, T, H]),
    ets:insert(sensor_latest, {Id, Map}).