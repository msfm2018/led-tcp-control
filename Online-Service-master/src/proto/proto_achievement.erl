%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_achievement的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_achievement).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------

mod_achievement_completed_c2s(<<Type:8>>) ->
    {ok, {mod_achievement_completed_c2s,Type}}.
mod_achievement_points_c2s(<<>>) -> 
    {ok, {mod_achievement_points_c2s}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_achievement_completed_s2c_mod_achievement_completed_s2c_list(L) ->
    NL = [[<<Id:32>>]
    || {mod_achievement_completed_s2c_list,Id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_achievement_completed_s2c({mod_achievement_completed_s2c,Type,List}) ->
    {ok, [<<Type:8>>,mod_achievement_completed_s2c_mod_achievement_completed_s2c_list(List)]}.


mod_achievement_points_s2c({mod_achievement_points_s2c,Points}) ->
    {ok, [<<Points:32>>]}.


mod_achievement_complete_s2c_mod_achievement_complete_s2c_list(L) ->
    NL = [[<<Id:32>>]
    || {mod_achievement_complete_s2c_list,Id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_achievement_complete_s2c({mod_achievement_complete_s2c,List}) ->
    {ok, [mod_achievement_complete_s2c_mod_achievement_complete_s2c_list(List)]}.


