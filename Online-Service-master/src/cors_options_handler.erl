-module(cors_options_handler).
-export([init/2]).
init(Req0, _Opts) ->
    H = #{
      <<"access-control-allow-origin">>  => <<"*">>,
      <<"access-control-allow-methods">> => <<"GET, OPTIONS">>,
      <<"access-control-allow-headers">> => <<"content-type">>,
      <<"access-control-max-age">>       => <<"86400">>
    },
    Req = cowboy_req:reply(204, H, <<>>, Req0),
    {ok, Req, undefined}.
