%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_scene的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_scene).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
mod_scene_move_xy_c2s(<<Rx:32,Ry:32,Dx:32,Dy:32>>) ->
    {ok, {mod_scene_move_xy_c2s,Rx,Ry,Dx,Dy}}.
mod_scene_jump_c2s(<<AccnameLen:16,Accname:AccnameLen/binary>>) ->
    {ok, {mod_scene_jump_c2s,Accname}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_scene_new_player_s2c_mod_scene_new_player_s2c_player_list(L) ->
    NL = [[pt:packstring(Accname),<<Job:32>>,<<X:32>>,<<Y:32>>,<<Weapon:32>>]
    || {mod_scene_new_player_s2c_player_list,Accname,Job,X,Y,Weapon} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_scene_new_player_s2c({mod_scene_new_player_s2c,Player_list}) ->
    {ok, [mod_scene_new_player_s2c_mod_scene_new_player_s2c_player_list(Player_list)]}.


mod_scene_del_player_s2c_mod_scene_del_player_s2c_player_list(L) ->
    NL = [[pt:packstring(Accname)]
    || {mod_scene_del_player_s2c_player_list,Accname} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_scene_del_player_s2c({mod_scene_del_player_s2c,Player_list}) ->
    {ok, [mod_scene_del_player_s2c_mod_scene_del_player_s2c_player_list(Player_list)]}.


mod_scene_move_xy_s2c({mod_scene_move_xy_s2c,Accname,Rx,Ry,Dx,Dy}) ->
    {ok, [pt:packstring(Accname),<<Rx:32>>,<<Ry:32>>,<<Dx:32>>,<<Dy:32>>]}.


mod_scene_jump_s2c({mod_scene_jump_s2c,Accname}) ->
    {ok, [pt:packstring(Accname)]}.


