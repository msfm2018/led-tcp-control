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
            Decoded=json:decode(Body),
            io:format("更新 Decoded 表:~p~n",[Decoded]),
            case validate_config(Decoded) of
                    {ok, Config} ->
                        % 更新 ETS 表（只插入一次）
                    io:format("更新 ETS 表:~p~n",[Config]),
                  A=  ets:lookup(sensor_alarm_config, thresholds),
                  io:format("sensor_alarm_config:~p~n",A),
                %            #{hum_high => 70,hum_low => 20,temp_high => 40,temp_low => 0}
                %   Config = #{temp_high => TH, temp_low => TL, hum_high => HH, hum_low => HL},
                %   ets:insert(sensor_alarm_config, {thresholds, Config}),
                  

                        ets:insert(sensor_alarm_config, {thresholds, Config}),
                        % 保存到 Mnesia
                        io:format("修改数据:~p~n",[Config]),
                        gc_gateway_app:save_alarm_config(Config),
                        % save_alarm_config(Config),

                        % 构造成功响应
                        Json = json:encode(#{code => 0, msg => <<"threshold updated">>}),
                        Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
                        {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req2),
                        {ok, Resp, State};
                    {error, Reason} ->
                        io:format("Reason:~p~n",Reason),
                        % 构造错误响应
                        Json = json:encode(#{code => 1, msg => Reason}),
                        Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
                        {ok, Resp} = cowboy_req:reply(400, #{<<"content-type">> => <<"application/json">>}, Json, Req2),
                        {ok, Resp, State}
                end;
            % case json:decode(Body) of

            %     % #{<<"temp_high">> := TH,
            %     %   <<"temp_low">> := TL,
            %     %   <<"hum_high">> := HH,
            %     %   <<"hum_low">> := HL} ->
                    
            %     %     Config = #{temp_high => TH, temp_low => TL, hum_high => HH, hum_low => HL},
            %     %     ets:insert(sensor_alarm_config, {thresholds, Config}),
                    
            %     %     ets:insert(sensor_alarm_config, {thresholds, Config}),
            %     %     gc_gateway_app:save_alarm_config(Config), % Save to Mnesia

            %     %     Json = json:encode(#{code => 0, msg => <<"threshold updated">>}),
            %     %     Req10 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
            %     %     {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req10),
            %     %     {ok, Resp, State};

            %     % _ ->
            %     %     Json = json:encode(#{code => 1, msg => <<"invalid input">>}),
            %     %     Req10 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
            %     %     {ok, Resp} = cowboy_req:reply(400, #{<<"content-type">> => <<"application/json">>}, Json, Req10),
            %     %     {ok, Resp, State}
            % end;
        {more, _, _} ->
            {ok, Req0, State}
    end.

% 验证 Config 格式
% #{<<"hum_high">> => 40,<<"hum_low">> => 20,<<"temp_high">> => 40,
            %    <<"temp_low">> => 0}
validate_config(#{<<"temp_high">> := TH, <<"temp_low">> := TL, <<"hum_high">> := HH, <<"hum_low">> := HL}) ->
    io:format("---------------------------------------------~n"),
    case is_number(TH) andalso is_number(TL) andalso is_number(HH) andalso is_number(HL) of
        true ->
            io:format("+++++++++++++++++++++~n"),
            {ok, #{temp_high => TH, temp_low => TL, hum_high => HH, hum_low => HL}};
        false ->
            io:format("********************~n"),
            {error, <<"invalid_number">>}
    end;
validate_config(_) ->
    {error, <<"missing_fields">>}.



    save_alarm_config(Config) ->
        io:format("$$$$$$$$$$$$$$$$$$$$$$$$$$$~p~n", [Config]),
          case mnesia:dirty_write({mnesia_config, thresholds, Config}) of
              ok ->
                  io:format("保存 mnesia_config 到 Mnesia：~p~n", [Config]);
              {error, Reason} ->
                  io:format("保存 mnesia_config 到 Mnesia 失败：~p~n", [Reason]),
                  throw({mnesia_write_failed, Reason})
          end.
%     curl -X POST http://127.0.0.1:8999/alarm/threshold \
% -H "Content-Type: application/json" \
% -d '{"temp_high":40.5,"temp_low":10.0,"hum_high":80,"hum_low":30}'
