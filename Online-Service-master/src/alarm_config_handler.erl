-module(alarm_config_handler).
-export([init/2]).

init(Req0=#{method := <<"OPTIONS">>}, State) ->
    %% 跨域处理
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
    Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req1),
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
    {ok, Resp} = cowboy_req:reply(200, Req3),
    {ok, Resp, State};

init(Req0=#{method := <<"POST">>}, State) ->
    case cowboy_req:read_body(Req0) of
        {ok, Body, Req1} ->
            io:format("设置阈值: ~p~n", [Body]),
            case json:decode(Body) of
                #{<<"temp_high">> := TH,
                  <<"temp_low">> := TL,
                  <<"hum_high">> := HH,
                  <<"hum_low">> := HL} ->
                    
                    Config = #{temp_high => TH, temp_low => TL, hum_high => HH, hum_low => HL},
                    ets:insert(sensor_alarm_config, {thresholds, Config}),
                    
                    Json = json:encode(#{code => 0, msg => <<"threshold updated">>}),
                    Req10 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
                    {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req10),
                    {ok, Resp, State};

                _ ->
                    Json = json:encode(#{code => 1, msg => <<"invalid input">>}),
                    Req10 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
                    {ok, Resp} = cowboy_req:reply(400, #{<<"content-type">> => <<"application/json">>}, Json, Req10),
                    {ok, Resp, State}
            end;
        {more, _, _} ->
            {ok, Req0, State}
    end.


%     curl -X POST http://127.0.0.1:8999/alarm/threshold \
% -H "Content-Type: application/json" \
% -d '{"temp_high":40.5,"temp_low":10.0,"hum_high":80,"hum_low":30}'
