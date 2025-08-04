%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_login的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_login).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
mod_login_server_c2s(<<>>) -> 
    {ok, {mod_login_server_c2s}}.
mod_login_ask_gateway_c2s(<<>>) -> 
    {ok, {mod_login_ask_gateway_c2s}}.
mod_login_verification_c2s(<<AccnameLen:16,Accname:AccnameLen/binary,PasswordLen:16,Password:PasswordLen/binary,Time:32,VerificationLen:16,Verification:VerificationLen/binary>>) ->
    {ok, {mod_login_verification_c2s,Accname,Password,Time,Verification}}.
mod_login_register_c2s(<<AccnameLen:16,Accname:AccnameLen/binary,PasswordLen:16,Password:PasswordLen/binary,Time:32,VerificationLen:16,Verification:VerificationLen/binary>>) ->
    {ok, {mod_login_register_c2s,Accname,Password,Time,Verification}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_login_server_s2c({mod_login_server_s2c,Ip,Port}) ->
    {ok, [pt:packstring(Ip),<<Port:16>>]}.


mod_login_ask_gateway_s2c({mod_login_ask_gateway_s2c,Ip,Port,Time,Verification}) ->
    {ok, [pt:packstring(Ip),<<Port:16>>,<<Time:32>>,pt:packstring(Verification)]}.


mod_login_verification_s2c({mod_login_verification_s2c}) -> 
    {ok, [<<>>]}.

mod_login_register_s2c({mod_login_register_s2c}) -> 
    {ok, [<<>>]}.

