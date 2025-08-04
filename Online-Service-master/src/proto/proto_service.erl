%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_service的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_service).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
mod_service_login_c2s(<<Service_id:16>>) ->
    {ok, {mod_service_login_c2s,Service_id}}.
mod_service_content_c2s(<<Service_id:16,ContentLen:16,Content:ContentLen/binary>>) ->
    {ok, {mod_service_content_c2s,Service_id,Content}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_service_login_s2c({mod_service_login_s2c,Service_id}) ->
    {ok, [<<Service_id:16>>]}.


mod_service_content_s2c({mod_service_content_s2c,Service_id,Content}) ->
    {ok, [<<Service_id:16>>,pt:packstring(Content)]}.


