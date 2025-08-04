-module(alarm_get_handler).
-export([init/2]).

init(Req0=#{method := <<"OPTIONS">>}, State) ->
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
    Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, POST, OPTIONS">>, Req1),
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
    {ok, Resp} = cowboy_req:reply(200, Req3),
    {ok, Resp, State};

init(Req0=#{method := <<"GET">>}, State) ->
    %% 读取当前阈值配置
    ThresholdMap = case ets:lookup(sensor_alarm_config, thresholds) of
        [{thresholds, Conf}] -> Conf;
        _ -> #{temp_high => 100.0, temp_low => 0.0, hum_high => 100, hum_low => 0}
    end,

    %% 转成 JSON 格式
    JsonMap = #{
        <<"temp_high">> => maps:get(temp_high, ThresholdMap),
        <<"temp_low">>  => maps:get(temp_low, ThresholdMap),
        <<"hum_high">>  => maps:get(hum_high, ThresholdMap),
        <<"hum_low">>   => maps:get(hum_low, ThresholdMap)
    },

    Json = json:encode(JsonMap),

    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
    {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req1),
    {ok, Resp, State}.
    % curl http://127.0.0.1:8999/alarm/threshold/get