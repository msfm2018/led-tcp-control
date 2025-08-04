%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_player的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_player).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------

mod_player_login_c2s(<<Id:32,TokenLen:16,Token:TokenLen/binary>>) ->
    {ok, {mod_player_login_c2s,Id,Token}}.

mod_device_data_c2s(<<Id:32,TemperatureLen:16,Temperature:TemperatureLen/binary,HumidityLen:16,Humidity:HumidityLen/binary>>) ->
    {ok, {mod_device_data_c2s,Id,Temperature,Humidity}}.
mod_player_herat_c2s(<<>>) -> 
    {ok, {mod_player_herat_c2s}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_player_login_s2c({mod_player_login_s2c}) -> 
    {ok, [<<>>]}.

mod_device_data_s2c({mod_device_data_s2c}) -> 
    {ok, [<<>>]}.

mod_player_errno_s2c({mod_player_errno_s2c,Error_id}) ->
    {ok, [<<Error_id:16>>]}.


