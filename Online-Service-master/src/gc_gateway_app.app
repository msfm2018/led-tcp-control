%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 7. 7月 2025 18:30
%%%-------------------------------------------------------------------
{application, gc_gateway_app, [
  {description, ""},
  {vsn, "1"},
  {registered, []},
  {applications, [
    kernel,
    stdlib,
    cowboy
  ]},
  {mod, {gc_gateway_app, []}},
  {env, []}
]}.