%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_chat的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_chat).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------

mod_chat_zone_c2s(<<Type:8,WordsLen:16,Words:WordsLen/binary>>) ->
    {ok, {mod_chat_zone_c2s,Type,Words}}.

mod_chat_person_c2s(<<Player_idLen:16,Player_id:Player_idLen/binary,WordsLen:16,Words:WordsLen/binary>>) ->
    {ok, {mod_chat_person_c2s,Player_id,Words}}.

mod_chat_gm_command_c2s(<<WordsLen:16,Words:WordsLen/binary>>) ->
    {ok, {mod_chat_gm_command_c2s,Words}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_chat_zone_s2c({mod_chat_zone_s2c,Type,Player_id,Nick_name,Words}) ->
    {ok, [<<Type:8>>,pt:packstring(Player_id),pt:packstring(Nick_name),pt:packstring(Words)]}.


mod_chat_person_s2c({mod_chat_person_s2c,Player_id,Nick_name,Words}) ->
    {ok, [pt:packstring(Player_id),pt:packstring(Nick_name),pt:packstring(Words)]}.


mod_chat_person_offline_s2c({mod_chat_person_offline_s2c,Player_id}) ->
    {ok, [pt:packstring(Player_id)]}.


