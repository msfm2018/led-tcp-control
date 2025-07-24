%%%-----------------------------------------------------------------
%%% 文件：sensor_http_handler.erl
%%%-----------------------------------------------------------------
-module(sensor_http_handler).
-export([init/2]).



    init(Req0, _Opts) ->
        All = [V || {_Id, V} <- ets:tab2list(sensor_latest)],
        Body = json:encode(All),
    
        %% 允许所有域访问
        RespHeaders = #{
            <<"content-type">>                => <<"application/json">>,
            <<"access-control-allow-origin">> => <<"*">>,
            <<"access-control-allow-methods">> => <<"GET, OPTIONS">>,
            <<"access-control-allow-headers">> => <<"content-type">>
        },
        Req = cowboy_req:reply(200, RespHeaders, Body, Req0),
        {ok, Req, undefined}.
    