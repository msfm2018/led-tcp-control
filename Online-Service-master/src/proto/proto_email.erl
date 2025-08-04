%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_email的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_email).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------

mod_email_id_list_c2s(<<Type:8>>) ->
    {ok, {mod_email_id_list_c2s,Type}}.

mod_email_title_list_c2s_list(<<__Len:16, __B/binary>>) ->
    mod_email_title_list_c2s_list(__Len, __B, []).
mod_email_title_list_c2s_list(0, __B, __L) ->
    {__L, __B};
mod_email_title_list_c2s_list(__Len, __B, __L) ->
    <<Id:32, __IdBinary/binary>> = __B,
    mod_email_title_list_c2s_list(__Len - 1, __IdBinary, [{mod_email_title_list_c2s_list,Id}|__L]).
mod_email_title_list_c2s(__B) ->
    {Id_list, __Id_listBinary} = mod_email_title_list_c2s_list(__B),
    {ok, {mod_email_title_list_c2s,Id_list}}.

mod_email_detail_c2s(<<Id:32>>) ->
    {ok, {mod_email_detail_c2s,Id}}.

mod_email_delete_c2s(<<Id:32>>) ->
    {ok, {mod_email_delete_c2s,Id}}.

mod_email_delete_all_c2s(<<Type:8,Status:8>>) ->
    {ok, {mod_email_delete_all_c2s,Type,Status}}.

mod_email_get_goods_c2s(<<Id:32>>) ->
    {ok, {mod_email_get_goods_c2s,Id}}.
mod_email_get_goods_all_c2s(<<>>) -> 
    {ok, {mod_email_get_goods_all_c2s}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_email_id_list_sc2_mod_email_id_list_sc2_list(L) ->
    NL = [[<<Id:32>>]
    || {mod_email_id_list_sc2_list,Id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_email_id_list_sc2({mod_email_id_list_sc2,Type,Id_list}) ->
    {ok, [<<Type:8>>,mod_email_id_list_sc2_mod_email_id_list_sc2_list(Id_list)]}.


mod_email_title_list_s2c_mod_email_title_list_s2c_list(L) ->
    NL = [[<<Id:32>>,pt:packstring(Sender_name),<<Type:8>>,<<Read_flag:8>>,<<Goods_flag:8>>,<<Send_time:32>>,pt:packstring(Title)]
    || {mod_email_title_list_s2c_list,Id,Sender_name,Type,Read_flag,Goods_flag,Send_time,Title} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_email_title_list_s2c({mod_email_title_list_s2c,Id_list}) ->
    {ok, [mod_email_title_list_s2c_mod_email_title_list_s2c_list(Id_list)]}.


mod_email_detail_s2c_mod_email_detail_s2c_goods_list(L) ->
    NL = [[<<Template:32>>,<<Num:32>>]
    || {mod_email_detail_s2c_goods_list,Template,Num} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_email_detail_s2c({mod_email_detail_s2c,Id,Sender_id,Content,Goods_list}) ->
    {ok, [<<Id:32>>,pt:packstring(Sender_id),pt:packstring(Content),mod_email_detail_s2c_mod_email_detail_s2c_goods_list(Goods_list)]}.


mod_email_delete_s2c({mod_email_delete_s2c,Id}) ->
    {ok, [<<Id:32>>]}.


mod_email_delete_all_s2c({mod_email_delete_all_s2c,Type,Status}) ->
    {ok, [<<Type:8>>,<<Status:8>>]}.


mod_email_get_goods_s2c({mod_email_get_goods_s2c,Id}) ->
    {ok, [<<Id:32>>]}.


mod_email_get_goods_all_s2c({mod_email_get_goods_all_s2c}) -> 
    {ok, [<<>>]}.

