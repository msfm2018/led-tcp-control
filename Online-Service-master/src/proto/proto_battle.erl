%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_battle的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_battle).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
mod_battle_attack_c2s(<<SrcAccnameLen:16,SrcAccname:SrcAccnameLen/binary,DesAccnameLen:16,DesAccname:DesAccnameLen/binary,Skill:32>>) ->
    {ok, {mod_battle_attack_c2s,SrcAccname,DesAccname,Skill}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_battle_attack_s2c({mod_battle_attack_s2c,SrcAccname,DesAccname,Skill}) ->
    {ok, [pt:packstring(SrcAccname),pt:packstring(DesAccname),<<Skill:32>>]}.


