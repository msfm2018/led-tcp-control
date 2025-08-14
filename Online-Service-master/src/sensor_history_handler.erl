-module(sensor_history_handler).

-include("common.hrl").
-export([init/2]).

%% 把 YYYY-MM-DD 转成当天 00:00:00 的 Unix 时间戳（秒）
parse_time(undefined) -> ignore;
parse_time(Bin) ->
    Parts = binary:split(Bin, <<"-">>, [global]),
    case Parts of
        [YBin, MBin, DBin] ->
            case [binary_to_integer_safe(YBin),
                  binary_to_integer_safe(MBin),
                  binary_to_integer_safe(DBin)] of
                [Y, M, D] when is_integer(Y), is_integer(M), is_integer(D) ->
                    DT = {{Y, M, D}, {0, 0, 0}},
                    calendar:datetime_to_gregorian_seconds(DT) - 62167219200;
                _ -> ignore
            end;
        _ -> ignore
    end.

binary_to_integer_safe(Bin) ->
    case catch binary_to_integer(Bin) of
        I when is_integer(I) -> I;
        _ -> error
    end.

init(Req0=#{method := <<"GET">>}, State) ->

IdBin = cowboy_req:binding(id, Req0),

  P0 = cowboy_req:qs(Req0),

    %% 解析查询参数 ?from=YYYY-MM-DD&to=YYYY-MM-DD
    QsMap = maps:from_list(cowboy_req:parse_qs(Req0)),
  
    FromTs = parse_time(maps:get(<<"from">>, QsMap, undefined)),
    ToTs   = parse_time(maps:get(<<"to">>,   QsMap, undefined)),



    case catch binary_to_integer(IdBin) of
        Id when is_integer(Id) ->
            Records = get_history(Id, 50, FromTs, ToTs),  % 默认 50 条
            Json = json:encode(Records),
            % Req2 = cowboy_req:reply(200,
            %     #{<<"content-type">> => <<"application/json">>},
            %     Json, Req0),

              
                Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
                {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req2),
                {ok, Resp, State};


         
        _ ->
            % Req2 = cowboy_req:reply(400,
            %     #{<<"content-type">> => <<"text/plain">>},
            %     <<"Invalid ID">>, Req0),

                Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
                {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, <<"Invalid ID">>, Req2),
           
            {ok, Resp, State}
    end.

%% 查询历史数据，可选按天过滤，按时间升序返回
get_history(Id, Limit, From, To) ->
    F = fun() ->
        Records = mnesia:select(sensor_history,
            [{#sensor_history{id = Id, timestamp = '$1', temperature = '$2', humidity = '$3'},
              [],
              ['$_']}]),
        Sorted = lists:sort(fun(A,B) ->
            A#sensor_history.timestamp < B#sensor_history.timestamp
        end, Records),  %% <- 这里改成 < 升序

        Filtered = lists:filter(fun(R) ->
            Ts = R#sensor_history.timestamp,
            (From == ignore orelse Ts >= From) andalso
            (To   == ignore orelse Ts < To + 86400)
        end, Sorted),
        lists:sublist(Filtered, Limit)
    end,
    case mnesia:transaction(F) of
        {atomic, List} ->
            [#{id => R#sensor_history.id,
               timestamp => R#sensor_history.timestamp,
               temperature => R#sensor_history.temperature,
               humidity => R#sensor_history.humidity}
             || R <- List];
        {aborted, Reason} -> #{error => Reason}
    end.

%% 查询历史数据，可选按天过滤
get_history1(Id, Limit, From, To) ->
    F = fun() ->
        Records = mnesia:select(sensor_history,
            [{#sensor_history{id = Id, timestamp = '$1', temperature = '$2', humidity = '$3'},
              [],
              ['$_']}]),
        Sorted = lists:sort(fun(A,B) ->
            A#sensor_history.timestamp > B#sensor_history.timestamp
        end, Records),
        Filtered = lists:filter(fun(R) ->
            Ts = R#sensor_history.timestamp,
            (From == ignore orelse Ts >= From) andalso
            (To   == ignore orelse Ts < To + 86400)  %% 覆盖到当天结束
        end, Sorted),
        lists:sublist(Filtered, Limit)
    end,
    case mnesia:transaction(F) of
        {atomic, List} ->
            [#{id => R#sensor_history.id,
               timestamp => R#sensor_history.timestamp,
               temperature => R#sensor_history.temperature,
               humidity => R#sensor_history.humidity}
             || R <- List];
        {aborted, Reason} -> #{error => Reason}
    end.

  %   # 查 ID=123 最近 50 条（不加时间过滤）
  % curl "http://127.0.0.1:8999/history/123"
  
  % # 查 2023-08-14 之后的
  % curl "http://127.0.0.1:8999/history/123?from=2023-08-14"
  
  % # 查 2023-08-14 到 2023-08-18 之间的
  % curl "http://127.0.0.1:8999/history/123?from=2023-08-14&to=2023-08-18"
  