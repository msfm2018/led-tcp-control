%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块mod_event的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto_event).
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
mod_event_eventlist_c2s(<<>>) -> 
    {ok, {mod_event_eventlist_c2s}}.
mod_event_worldeventlist_c2s(<<>>) -> 
    {ok, {mod_event_worldeventlist_c2s}}.

mod_event_joinevent_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_event_joinevent_c2s,Key}}.

mod_event_exitevent_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_event_exitevent_c2s,Key}}.
mod_event_received_event_list_c2s(<<>>) -> 
    {ok, {mod_event_received_event_list_c2s}}.

mod_event_pet_joinevent_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_event_pet_joinevent_c2s,Key}}.

mod_event_return_pet_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_event_return_pet_c2s,Key}}.

mod_event_set_normal_xy_c2s_list(<<__Len:16, __B/binary>>) ->
    mod_event_set_normal_xy_c2s_list(__Len, __B, []).
mod_event_set_normal_xy_c2s_list(0, __B, __L) ->
    {__L, __B};
mod_event_set_normal_xy_c2s_list(__Len, __B, __L) ->
    <<__KeyLen:16, Key:__KeyLen/binary, __KeyBinary/binary>> = __B,
    <<X:32/signed, __XBinary/binary>> = __KeyBinary,
    <<Y:32/signed, __YBinary/binary>> = __XBinary,
    mod_event_set_normal_xy_c2s_list(__Len - 1, __YBinary, [{mod_event_set_normal_xy_c2s_list,Key,X,Y}|__L]).
mod_event_set_normal_xy_c2s(__B) ->
    {List, __ListBinary} = mod_event_set_normal_xy_c2s_list(__B),
    {ok, {mod_event_set_normal_xy_c2s,List}}.
mod_event_world_not_normal_id_list_c2s(<<>>) -> 
    {ok, {mod_event_world_not_normal_id_list_c2s}}.

mod_event_ask_world_not_normal_list_c2s_list(<<__Len:16, __B/binary>>) ->
    mod_event_ask_world_not_normal_list_c2s_list(__Len, __B, []).
mod_event_ask_world_not_normal_list_c2s_list(0, __B, __L) ->
    {__L, __B};
mod_event_ask_world_not_normal_list_c2s_list(__Len, __B, __L) ->
    <<Id:64, __IdBinary/binary>> = __B,
    mod_event_ask_world_not_normal_list_c2s_list(__Len - 1, __IdBinary, [{mod_event_ask_world_not_normal_list_c2s_list,Id}|__L]).
mod_event_ask_world_not_normal_list_c2s(__B) ->
    {Id_list, __Id_listBinary} = mod_event_ask_world_not_normal_list_c2s_list(__B),
    {ok, {mod_event_ask_world_not_normal_list_c2s,Id_list}}.
mod_event_featureeventlist_c2s(<<>>) -> 
    {ok, {mod_event_featureeventlist_c2s}}.

mod_event_set_feature_xy_c2s_list(<<__Len:16, __B/binary>>) ->
    mod_event_set_feature_xy_c2s_list(__Len, __B, []).
mod_event_set_feature_xy_c2s_list(0, __B, __L) ->
    {__L, __B};
mod_event_set_feature_xy_c2s_list(__Len, __B, __L) ->
    <<__KeyLen:16, Key:__KeyLen/binary, __KeyBinary/binary>> = __B,
    <<X:32/signed, __XBinary/binary>> = __KeyBinary,
    <<Y:32/signed, __YBinary/binary>> = __XBinary,
    mod_event_set_feature_xy_c2s_list(__Len - 1, __YBinary, [{mod_event_set_feature_xy_c2s_list,Key,X,Y}|__L]).
mod_event_set_feature_xy_c2s(__B) ->
    {List, __ListBinary} = mod_event_set_feature_xy_c2s_list(__B),
    {ok, {mod_event_set_feature_xy_c2s,List}}.

mod_part_event_eventlist_c2s(<<Player_x:64,Player_y:64>>) ->
    {ok, {mod_part_event_eventlist_c2s,Player_x,Player_y}}.

mod_part_event_ranklist_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_part_event_ranklist_c2s,Key}}.

mod_event_small_event_score_c2s(<<KeyLen:16,Key:KeyLen/binary,Playerscore:64>>) ->
    {ok, {mod_event_small_event_score_c2s,Key,Playerscore}}.

mod_feature_id_c2s(<<Feature_id:32>>) ->
    {ok, {mod_feature_id_c2s,Feature_id}}.

mod_set_camp_evet_c2s(<<KeyLen:16,Key:KeyLen/binary,Campid:32>>) ->
    {ok, {mod_set_camp_evet_c2s,Key,Campid}}.

mod_event_limit_info_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_event_limit_info_c2s,Key}}.

mod_event_request_quest_c2s(<<KeyLen:16,Key:KeyLen/binary,Quest_id:32/signed,Quest_num:32/signed>>) ->
    {ok, {mod_event_request_quest_c2s,Key,Quest_id,Quest_num}}.

mod_event_request_redpacket_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_event_request_redpacket_c2s,Key}}.

mod_event_petfondventlist_c2s(<<Pet_x:64,Pet_y:64>>) ->
    {ok, {mod_event_petfondventlist_c2s,Pet_x,Pet_y}}.
mod_event_featurevent_review_list_c2s(<<>>) -> 
    {ok, {mod_event_featurevent_review_list_c2s}}.

mod_event_small_featurereviewevent_score_c2s(<<KeyLen:16,Key:KeyLen/binary,Playerscore:64>>) ->
    {ok, {mod_event_small_featurereviewevent_score_c2s,Key,Playerscore}}.

mod_event_sign_on_info_c2s(<<KeyLen:16,Key:KeyLen/binary>>) ->
    {ok, {mod_event_sign_on_info_c2s,Key}}.

%%% ------------------
%%% 服务器协议打包
%%% ------------------
mod_event_eventlist_s2c_mod_event_eventlist_s2c_event_conditions(L) ->
    NL = [[<<K:8>>,<<V:32/signed>>]
    || {mod_event_eventlist_s2c_event_conditions,K,V} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_eventlist_s2c_mod_event_eventlist_s2c_event_award(L) ->
    NL = [[<<Time:32>>,<<Drop_id:32>>]
    || {mod_event_eventlist_s2c_event_award,Time,Drop_id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_eventlist_s2c_mod_event_eventlist_s2c_event_award1(L) ->
    NL = [[<<Template:32>>,<<Num:32>>]
    || {mod_event_eventlist_s2c_event_award1,Template,Num} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_eventlist_s2c_mod_event_eventlist_s2c_list(L) ->
    NL = [[pt:packstring(Key),<<Id:64>>,pt:packstring(Name),<<Type:32/signed>>,pt:packstring(Desc),<<X:32/signed>>,<<Y:32/signed>>,<<Area:8>>,<<Start_time:64/signed>>,<<End_time:64/signed>>,<<Participate_num:32/signed>>,mod_event_eventlist_s2c_mod_event_eventlist_s2c_event_conditions(Conditions),mod_event_eventlist_s2c_mod_event_eventlist_s2c_event_award(Award),mod_event_eventlist_s2c_mod_event_eventlist_s2c_event_award1(Award1),<<State:32/signed>>,<<Camp:32/signed>>,<<Player_camp:32/signed>>,<<Player_score:32/signed>>,<<Limit_player_max_num:32/signed>>,<<Limit_event_max_times:32/signed>>,<<Limit_player_also_num:32/signed>>,<<Limit_event_also_times:32/signed>>,<<Wave_number_standard:32/signed>>]
    || {mod_event_eventlist_s2c_list,Key,Id,Name,Type,Desc,X,Y,Area,Start_time,End_time,Participate_num,Conditions,Award,Award1,State,Camp,Player_camp,Player_score,Limit_player_max_num,Limit_event_max_times,Limit_player_also_num,Limit_event_also_times,Wave_number_standard} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_eventlist_s2c({mod_event_eventlist_s2c,Event_list}) ->
    {ok, [mod_event_eventlist_s2c_mod_event_eventlist_s2c_list(Event_list)]}.


mod_event_joinevent_s2c({mod_event_joinevent_s2c,Key,Game_type,Error_id}) ->
    {ok, [pt:packstring(Key),<<Game_type:32/signed>>,<<Error_id:16>>]}.


mod_event_exitevent_s2c({mod_event_exitevent_s2c,Key}) ->
    {ok, [pt:packstring(Key)]}.


mod_event_completeevent_s2c({mod_event_completeevent_s2c,Key}) ->
    {ok, [pt:packstring(Key)]}.


mod_event_received_event_list_s2c_mod_event_received_event_list_s2c_list(L) ->
    NL = [[pt:packstring(Key)]
    || {mod_event_received_event_list_s2c_list,Key} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_received_event_list_s2c({mod_event_received_event_list_s2c,Event_list}) ->
    {ok, [mod_event_received_event_list_s2c_mod_event_received_event_list_s2c_list(Event_list)]}.


mod_event_received_event_over_s2c({mod_event_received_event_over_s2c,Key}) ->
    {ok, [pt:packstring(Key)]}.


mod_event_award_info_s2c_mod_event_award_info_s2c_goods_list(L) ->
    NL = [[<<Template:32>>,<<Num:32>>]
    || {mod_event_award_info_s2c_goods_list,Template,Num} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_award_info_s2c_mod_event_award_info_s2c_pet_list(L) ->
    NL = [[<<Pet_goods_id:32>>,mod_event_award_info_s2c_mod_event_award_info_s2c_hurt_list(List)]
    || {mod_event_award_info_s2c_pet_list,Pet_goods_id,List} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_award_info_s2c_mod_event_award_info_s2c_hurt_list(L) ->
    NL = [[<<Attack_type:8>>,<<Attack_count:16>>,<<Hurt:32>>]
    || {mod_event_award_info_s2c_hurt_list,Attack_type,Attack_count,Hurt} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_award_info_s2c({mod_event_award_info_s2c,Key,List,Pet_hurt_list}) ->
    {ok, [pt:packstring(Key),mod_event_award_info_s2c_mod_event_award_info_s2c_goods_list(List),mod_event_award_info_s2c_mod_event_award_info_s2c_pet_list(Pet_hurt_list)]}.


mod_event_all_award_s2c_mod_event_all_award_s2c_goods_list(L) ->
    NL = [[<<Template:32>>,<<Num:32>>]
    || {mod_event_all_award_s2c_goods_list,Template,Num} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_all_award_s2c({mod_event_all_award_s2c,Key,List}) ->
    {ok, [pt:packstring(Key),mod_event_all_award_s2c_mod_event_all_award_s2c_goods_list(List)]}.


mod_event_dispear_s2c_mod_event_dispear_s2c_list(L) ->
    NL = [[pt:packstring(Key)]
    || {mod_event_dispear_s2c_list,Key} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_dispear_s2c({mod_event_dispear_s2c,List}) ->
    {ok, [mod_event_dispear_s2c_mod_event_dispear_s2c_list(List)]}.


mod_event_world_not_normal_id_list_s2c_mod_event_world_not_normal_id_list_s2c_list(L) ->
    NL = [[<<Id:64>>]
    || {mod_event_world_not_normal_id_list_s2c_list,Id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_world_not_normal_id_list_s2c({mod_event_world_not_normal_id_list_s2c,Id_list}) ->
    {ok, [mod_event_world_not_normal_id_list_s2c_mod_event_world_not_normal_id_list_s2c_list(Id_list)]}.


mod_part_event_ranklist_s2c_mod_part_event_sumscorelist_s2c_list(L) ->
    NL = [[<<Campid:32/signed>>,<<Scores:32/signed>>]
    || {mod_part_event_sumscorelist_s2c_list,Campid,Scores} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_part_event_ranklist_s2c_mod_part_event_ranklist_s2c_list(L) ->
    NL = [[pt:packstring(Playerid),pt:packstring(PlayerName),<<PlayerScore:64>>,<<Playercamp:32>>]
    || {mod_part_event_ranklist_s2c_list,Playerid,PlayerName,PlayerScore,Playercamp} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_part_event_ranklist_s2c({mod_part_event_ranklist_s2c,Key,Playerid,Eventscore,Playercamp,Rank,Scorelist}) ->
    {ok, [pt:packstring(Key),pt:packstring(Playerid),<<Eventscore:32>>,<<Playercamp:32>>,mod_part_event_ranklist_s2c_mod_part_event_ranklist_s2c_list(Rank),mod_part_event_ranklist_s2c_mod_part_event_sumscorelist_s2c_list(Scorelist)]}.


mod_feature_id_s2c({mod_feature_id_s2c,Feature_id}) ->
    {ok, [<<Feature_id:32>>]}.


mod_set_camp_evet_s2c({mod_set_camp_evet_s2c,Key,Campid}) ->
    {ok, [pt:packstring(Key),<<Campid:32>>]}.


mod_event_limit_info_s2c({mod_event_limit_info_s2c,Key,Limit_player_max_num,Limit_player_also_num,Limit_event_max_times,Limit_event_also_times}) ->
    {ok, [pt:packstring(Key),<<Limit_player_max_num:32/signed>>,<<Limit_player_also_num:32/signed>>,<<Limit_event_max_times:32/signed>>,<<Limit_event_also_times:32/signed>>]}.


mod_event_request_quest_s2c_mod_event_quest_right_answer_list(L) ->
    NL = [[<<Right_answer:32/signed>>]
    || {mod_event_quest_right_answer_list,Right_answer} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_request_quest_s2c({mod_event_request_quest_s2c,Quest_id,Describe,Answer1,Answer2,Answer3,Right_answer_list}) ->
    {ok, [<<Quest_id:32/signed>>,pt:packstring(Describe),pt:packstring(Answer1),pt:packstring(Answer2),pt:packstring(Answer3),mod_event_request_quest_s2c_mod_event_quest_right_answer_list(Right_answer_list)]}.


mod_event_request_redpacket_s2c({mod_event_request_redpacket_s2c,Key,Score}) ->
    {ok, [pt:packstring(Key),<<Score:32/signed>>]}.


mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_conditions(L) ->
    NL = [[<<K:8>>,<<V:32/signed>>]
    || {mod_event_revieweventlist_conditions,K,V} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_award(L) ->
    NL = [[<<Time:32>>,<<Drop_id:32>>]
    || {mod_event_revieweventlist_award,Time,Drop_id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_award1(L) ->
    NL = [[<<Template:32>>,<<Num:32>>]
    || {mod_event_revieweventlist_award1,Template,Num} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_event_conditions(L) ->
    NL = [[<<K:8>>,<<V:32/signed>>]
    || {mod_event_revieweventlist_s2c_event_conditions,K,V} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_event_award(L) ->
    NL = [[<<Time:32>>,<<Drop_id:32>>]
    || {mod_event_revieweventlist_s2c_event_award,Time,Drop_id} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_event_award1(L) ->
    NL = [[<<Template:32>>,<<Num:32>>]
    || {mod_event_revieweventlist_s2c_event_award1,Template,Num} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_list(L) ->
    NL = [[pt:packstring(Key),<<Id:64>>,pt:packstring(Name),<<Type:32/signed>>,pt:packstring(Desc),<<X:32/signed>>,<<Y:32/signed>>,<<Area:8>>,<<Start_time:64/signed>>,<<End_time:64/signed>>,<<Participate_num:32/signed>>,mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_event_conditions(Conditions),mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_event_award(Award),mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_event_award1(Award1),<<State:32/signed>>,<<Camp:32/signed>>,<<Player_camp:32/signed>>,<<Player_score:32/signed>>,<<Limit_player_max_num:32/signed>>,<<Limit_event_max_times:32/signed>>,<<Limit_player_also_num:32/signed>>,<<Limit_event_also_times:32/signed>>,<<Wave_number_standard:32/signed>>]
    || {mod_event_revieweventlist_s2c_list,Key,Id,Name,Type,Desc,X,Y,Area,Start_time,End_time,Participate_num,Conditions,Award,Award1,State,Camp,Player_camp,Player_score,Limit_player_max_num,Limit_event_max_times,Limit_player_also_num,Limit_event_also_times,Wave_number_standard} <- L],
    Len = length(L),
    [<<Len:16>>|NL].
mod_event_featurevent_review_list_s2c({mod_event_featurevent_review_list_s2c,Event_list}) ->
    {ok, [mod_event_featurevent_review_list_s2c_mod_event_revieweventlist_s2c_list(Event_list)]}.


mod_event_small_featurereviewevent_score_s2c({mod_event_small_featurereviewevent_score_s2c,Key,Playerscore}) ->
    {ok, [pt:packstring(Key),<<Playerscore:64>>]}.


mod_event_sign_on_info_s2x({mod_event_sign_on_info_s2x,Key,Selfscore,Totalscore,Totalplayernum}) ->
    {ok, [pt:packstring(Key),<<Selfscore:64>>,<<Totalscore:64>>,<<Totalplayernum:64>>]}.


