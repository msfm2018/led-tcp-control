%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_task的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_task).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
mod_task_get_list_c2s(<<>>) -> 
    {ok, {mod_task_get_list_c2s}}.

mod_task_compelte_task_c2s(<<Id:32>>) ->
    {ok, {mod_task_compelte_task_c2s,Id}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_task_get_list_s2c_mod_task_get_list_s2c_list(L) ->
    NL = [[<<Id:32>>]
    || {mod_task_get_list_s2c_list,Id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_task_get_list_s2c({mod_task_get_list_s2c,Id_list}) ->
    {ok, [mod_task_get_list_s2c_mod_task_get_list_s2c_list(Id_list)]}.


mod_task_compelte_task_s2c({mod_task_compelte_task_s2c,Id}) ->
    {ok, [<<Id:32>>]}.


