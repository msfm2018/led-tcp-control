%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_auction的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_auction).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
mod_auction_get_auction_id_list_c2s(<<>>) -> 
    {ok, {mod_auction_get_auction_id_list_c2s}}.

mod_auction_get_auction_page_c2s(<<Id:32,Page:32,Time:32>>) ->
    {ok, {mod_auction_get_auction_page_c2s,Id,Page,Time}}.

mod_auction_get_template_page_c2s(<<Id:32,Template_id:32,Time:32>>) ->
    {ok, {mod_auction_get_template_page_c2s,Id,Template_id,Time}}.

mod_auction_get_record_detail_c2s(<<Id:32,Record_id:64,Template_id:32>>) ->
    {ok, {mod_auction_get_record_detail_c2s,Id,Record_id,Template_id}}.

mod_auction_sell_c2s(<<Id:32,Goods_id:32,Num:32,Price:32,Time:32>>) ->
    {ok, {mod_auction_sell_c2s,Id,Goods_id,Num,Price,Time}}.

mod_auction_cancel_sell_c2s(<<Id:32,Record_id:64>>) ->
    {ok, {mod_auction_cancel_sell_c2s,Id,Record_id}}.
mod_auction_self_record_c2s(<<>>) -> 
    {ok, {mod_auction_self_record_c2s}}.

mod_auction_buy_c2s(<<Auction_id:32,Record_id:64,Num:32>>) ->
    {ok, {mod_auction_buy_c2s,Auction_id,Record_id,Num}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_auction_get_auction_id_list_s2c_mod_auction_get_auction_id_list_s2c_list(L) ->
    NL = [[<<Id:32>>]
    || {mod_auction_get_auction_id_list_s2c_list,Id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_auction_get_auction_id_list_s2c({mod_auction_get_auction_id_list_s2c,Default_id,Auction_id_list}) ->
    {ok, [<<Default_id:32>>,mod_auction_get_auction_id_list_s2c_mod_auction_get_auction_id_list_s2c_list(Auction_id_list)]}.


mod_auction_get_auction_page_s2c_mod_auction_get_auction_page_s2c_list(L) ->
    NL = [[<<Template_id:32>>,<<Min_price:32>>,<<All_count:32>>]
    || {mod_auction_get_auction_page_s2c_list,Template_id,Min_price,All_count} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_auction_get_auction_page_s2c({mod_auction_get_auction_page_s2c,Id,Page,Time,All_page_count,List}) ->
    {ok, [<<Id:32>>,<<Page:32>>,<<Time:32>>,<<All_page_count:32>>,mod_auction_get_auction_page_s2c_mod_auction_get_auction_page_s2c_list(List)]}.


mod_auction_get_template_page_s2c_mod_auction_get_template_page_s2c_list(L) ->
    NL = [[<<Record_id:64>>,<<Price:32>>,<<Count:32>>]
    || {mod_auction_get_template_page_s2c_list,Record_id,Price,Count} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_auction_get_template_page_s2c({mod_auction_get_template_page_s2c,Id,Time,Template_id,List}) ->
    {ok, [<<Id:32>>,<<Time:32>>,<<Template_id:32>>,mod_auction_get_template_page_s2c_mod_auction_get_template_page_s2c_list(List)]}.


mod_auction_get_record_detail_s2c_mod_auction_get_record_detail_s2c_attribute_list(L) ->
    NL = [[<<Key:8>>,<<Value:32>>]
    || {mod_auction_get_record_detail_s2c_attribute_list,Key,Value} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_auction_get_record_detail_s2c({mod_auction_get_record_detail_s2c,Id,Record_id,Template_id,List}) ->
    {ok, [<<Id:32>>,<<Record_id:64>>,<<Template_id:32>>,mod_auction_get_record_detail_s2c_mod_auction_get_record_detail_s2c_attribute_list(List)]}.


mod_auction_sell_s2c({mod_auction_sell_s2c,Result}) ->
    {ok, [<<Result:8>>]}.


mod_auction_cancel_sell_s2c_mod_auction_cancel_sell_s2c_list(L) ->
    NL = [[<<Id:32>>,<<Record_id:64>>]
    || {mod_auction_cancel_sell_s2c_list,Id,Record_id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_auction_cancel_sell_s2c({mod_auction_cancel_sell_s2c,List}) ->
    {ok, [mod_auction_cancel_sell_s2c_mod_auction_cancel_sell_s2c_list(List)]}.


mod_auction_self_record_s2c_mod_auction_self_record_s2c_list(L) ->
    NL = [[<<Auction_id:32>>,<<Record_id:64>>,<<Start_time:64>>,<<End_time:64>>,<<Template:32>>,<<Num:32>>,<<Price:32>>]
    || {mod_auction_self_record_s2c_list,Auction_id,Record_id,Start_time,End_time,Template,Num,Price} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_auction_self_record_s2c({mod_auction_self_record_s2c,List}) ->
    {ok, [mod_auction_self_record_s2c_mod_auction_self_record_s2c_list(List)]}.


mod_auction_buy_s2c({mod_auction_buy_s2c,Result}) ->
    {ok, [<<Result:8>>]}.


