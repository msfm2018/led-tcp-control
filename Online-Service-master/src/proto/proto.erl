%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 根据协议ｘｍｌ自动生成
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto).
-compile(export_all).

-include( "proto_player.hrl").
-include( "proto_event.hrl").
-include( "proto_chat.hrl").
-include( "proto_task.hrl").
-include( "proto_email.hrl").
-include( "proto_auction.hrl").
-include( "proto_achievement.hrl").


handle(<<1:8, 1:8, Binary/binary>>) ->
    {ok, Tuple} = proto_player:mod_player_login_c2s(Binary),
    {client_request, mod_player, Tuple};
handle(<<1:8, 2:8, Binary/binary>>) ->
    {ok, Tuple} = proto_player:mod_device_data_c2s(Binary),
    {client_request, mod_player, Tuple};
handle(<<1:8, 255:8, Binary/binary>>) ->
    {ok, Tuple} = proto_player:mod_player_herat_c2s(Binary),
    {client_request, mod_player, Tuple};
handle(<<2:8, 1:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_eventlist_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 2:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_worldeventlist_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 3:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_joinevent_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 4:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_exitevent_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 6:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_received_event_list_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 9:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_pet_joinevent_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 10:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_return_pet_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 13:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_set_normal_xy_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 15:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_world_not_normal_id_list_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 16:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_ask_world_not_normal_list_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 17:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_featureeventlist_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 18:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_set_feature_xy_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 19:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_part_event_eventlist_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 20:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_part_event_ranklist_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 21:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_small_event_score_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 22:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_feature_id_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 23:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_set_camp_evet_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 24:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_limit_info_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 25:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_request_quest_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 26:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_request_redpacket_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 27:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_petfondventlist_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 28:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_featurevent_review_list_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 29:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_small_featurereviewevent_score_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<2:8, 30:8, Binary/binary>>) ->
    {ok, Tuple} = proto_event:mod_event_sign_on_info_c2s(Binary),
    {client_request, mod_event, Tuple};
handle(<<4:8, 0:8, Binary/binary>>) ->
    {ok, Tuple} = proto_chat:mod_chat_zone_c2s(Binary),
    {client_request, mod_chat, Tuple};
handle(<<4:8, 1:8, Binary/binary>>) ->
    {ok, Tuple} = proto_chat:mod_chat_person_c2s(Binary),
    {client_request, mod_chat, Tuple};
handle(<<4:8, 255:8, Binary/binary>>) ->
    {ok, Tuple} = proto_chat:mod_chat_gm_command_c2s(Binary),
    {client_request, mod_chat, Tuple};
handle(<<5:8, 0:8, Binary/binary>>) ->
    {ok, Tuple} = proto_task:mod_task_get_list_c2s(Binary),
    {client_request, mod_task, Tuple};
handle(<<5:8, 1:8, Binary/binary>>) ->
    {ok, Tuple} = proto_task:mod_task_compelte_task_c2s(Binary),
    {client_request, mod_task, Tuple};
handle(<<6:8, 0:8, Binary/binary>>) ->
    {ok, Tuple} = proto_email:mod_email_id_list_c2s(Binary),
    {client_request, mod_email, Tuple};
handle(<<6:8, 1:8, Binary/binary>>) ->
    {ok, Tuple} = proto_email:mod_email_title_list_c2s(Binary),
    {client_request, mod_email, Tuple};
handle(<<6:8, 2:8, Binary/binary>>) ->
    {ok, Tuple} = proto_email:mod_email_detail_c2s(Binary),
    {client_request, mod_email, Tuple};
handle(<<6:8, 3:8, Binary/binary>>) ->
    {ok, Tuple} = proto_email:mod_email_delete_c2s(Binary),
    {client_request, mod_email, Tuple};
handle(<<6:8, 4:8, Binary/binary>>) ->
    {ok, Tuple} = proto_email:mod_email_delete_all_c2s(Binary),
    {client_request, mod_email, Tuple};
handle(<<6:8, 5:8, Binary/binary>>) ->
    {ok, Tuple} = proto_email:mod_email_get_goods_c2s(Binary),
    {client_request, mod_email, Tuple};
handle(<<6:8, 6:8, Binary/binary>>) ->
    {ok, Tuple} = proto_email:mod_email_get_goods_all_c2s(Binary),
    {client_request, mod_email, Tuple};
handle(<<7:8, 0:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_get_auction_id_list_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<7:8, 1:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_get_auction_page_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<7:8, 2:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_get_template_page_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<7:8, 3:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_get_record_detail_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<7:8, 4:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_sell_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<7:8, 5:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_cancel_sell_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<7:8, 6:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_self_record_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<7:8, 7:8, Binary/binary>>) ->
    {ok, Tuple} = proto_auction:mod_auction_buy_c2s(Binary),
    {client_request, mod_auction, Tuple};
handle(<<8:8, 0:8, Binary/binary>>) ->
    {ok, Tuple} = proto_achievement:mod_achievement_completed_c2s(Binary),
    {client_request, mod_achievement, Tuple};
handle(<<8:8, 1:8, Binary/binary>>) ->
    {ok, Tuple} = proto_achievement:mod_achievement_points_c2s(Binary),
    {client_request, mod_achievement, Tuple};
handle(<<ModId:8, ProtoId:8, _Binary/binary>>) ->
    throw({receive_unkown_cmd, ModId, ProtoId}).


pack(#mod_player_login_s2c{} = Tuple) ->
    {ok, IoList} = proto_player:mod_player_login_s2c(Tuple),
    [<<1:8, 1:8>>|IoList];
pack(#mod_device_data_s2c{} = Tuple) ->
    {ok, IoList} = proto_player:mod_device_data_s2c(Tuple),
    [<<1:8, 2:8>>|IoList];
pack(#mod_player_errno_s2c{} = Tuple) ->
    {ok, IoList} = proto_player:mod_player_errno_s2c(Tuple),
    [<<1:8, 254:8>>|IoList];
pack(#mod_event_eventlist_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_eventlist_s2c(Tuple),
    [<<2:8, 1:8>>|IoList];
pack(#mod_event_joinevent_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_joinevent_s2c(Tuple),
    [<<2:8, 3:8>>|IoList];
pack(#mod_event_exitevent_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_exitevent_s2c(Tuple),
    [<<2:8, 4:8>>|IoList];
pack(#mod_event_completeevent_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_completeevent_s2c(Tuple),
    [<<2:8, 5:8>>|IoList];
pack(#mod_event_received_event_list_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_received_event_list_s2c(Tuple),
    [<<2:8, 6:8>>|IoList];
pack(#mod_event_received_event_over_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_received_event_over_s2c(Tuple),
    [<<2:8, 8:8>>|IoList];
pack(#mod_event_award_info_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_award_info_s2c(Tuple),
    [<<2:8, 11:8>>|IoList];
pack(#mod_event_all_award_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_all_award_s2c(Tuple),
    [<<2:8, 12:8>>|IoList];
pack(#mod_event_dispear_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_dispear_s2c(Tuple),
    [<<2:8, 14:8>>|IoList];
pack(#mod_event_world_not_normal_id_list_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_world_not_normal_id_list_s2c(Tuple),
    [<<2:8, 15:8>>|IoList];
pack(#mod_part_event_ranklist_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_part_event_ranklist_s2c(Tuple),
    [<<2:8, 21:8>>|IoList];
pack(#mod_feature_id_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_feature_id_s2c(Tuple),
    [<<2:8, 22:8>>|IoList];
pack(#mod_set_camp_evet_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_set_camp_evet_s2c(Tuple),
    [<<2:8, 23:8>>|IoList];
pack(#mod_event_limit_info_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_limit_info_s2c(Tuple),
    [<<2:8, 24:8>>|IoList];
pack(#mod_event_request_quest_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_request_quest_s2c(Tuple),
    [<<2:8, 25:8>>|IoList];
pack(#mod_event_request_redpacket_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_request_redpacket_s2c(Tuple),
    [<<2:8, 26:8>>|IoList];
pack(#mod_event_featurevent_review_list_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_featurevent_review_list_s2c(Tuple),
    [<<2:8, 28:8>>|IoList];
pack(#mod_event_small_featurereviewevent_score_s2c{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_small_featurereviewevent_score_s2c(Tuple),
    [<<2:8, 29:8>>|IoList];
pack(#mod_event_sign_on_info_s2x{} = Tuple) ->
    {ok, IoList} = proto_event:mod_event_sign_on_info_s2x(Tuple),
    [<<2:8, 30:8>>|IoList];
pack(#mod_chat_zone_s2c{} = Tuple) ->
    {ok, IoList} = proto_chat:mod_chat_zone_s2c(Tuple),
    [<<4:8, 0:8>>|IoList];
pack(#mod_chat_person_s2c{} = Tuple) ->
    {ok, IoList} = proto_chat:mod_chat_person_s2c(Tuple),
    [<<4:8, 1:8>>|IoList];
pack(#mod_chat_person_offline_s2c{} = Tuple) ->
    {ok, IoList} = proto_chat:mod_chat_person_offline_s2c(Tuple),
    [<<4:8, 2:8>>|IoList];
pack(#mod_task_get_list_s2c{} = Tuple) ->
    {ok, IoList} = proto_task:mod_task_get_list_s2c(Tuple),
    [<<5:8, 0:8>>|IoList];
pack(#mod_task_compelte_task_s2c{} = Tuple) ->
    {ok, IoList} = proto_task:mod_task_compelte_task_s2c(Tuple),
    [<<5:8, 1:8>>|IoList];
pack(#mod_email_id_list_sc2{} = Tuple) ->
    {ok, IoList} = proto_email:mod_email_id_list_sc2(Tuple),
    [<<6:8, 0:8>>|IoList];
pack(#mod_email_title_list_s2c{} = Tuple) ->
    {ok, IoList} = proto_email:mod_email_title_list_s2c(Tuple),
    [<<6:8, 1:8>>|IoList];
pack(#mod_email_detail_s2c{} = Tuple) ->
    {ok, IoList} = proto_email:mod_email_detail_s2c(Tuple),
    [<<6:8, 2:8>>|IoList];
pack(#mod_email_delete_s2c{} = Tuple) ->
    {ok, IoList} = proto_email:mod_email_delete_s2c(Tuple),
    [<<6:8, 3:8>>|IoList];
pack(#mod_email_delete_all_s2c{} = Tuple) ->
    {ok, IoList} = proto_email:mod_email_delete_all_s2c(Tuple),
    [<<6:8, 4:8>>|IoList];
pack(#mod_email_get_goods_s2c{} = Tuple) ->
    {ok, IoList} = proto_email:mod_email_get_goods_s2c(Tuple),
    [<<6:8, 5:8>>|IoList];
pack(#mod_email_get_goods_all_s2c{} = Tuple) ->
    {ok, IoList} = proto_email:mod_email_get_goods_all_s2c(Tuple),
    [<<6:8, 6:8>>|IoList];
pack(#mod_auction_get_auction_id_list_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_get_auction_id_list_s2c(Tuple),
    [<<7:8, 0:8>>|IoList];
pack(#mod_auction_get_auction_page_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_get_auction_page_s2c(Tuple),
    [<<7:8, 1:8>>|IoList];
pack(#mod_auction_get_template_page_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_get_template_page_s2c(Tuple),
    [<<7:8, 2:8>>|IoList];
pack(#mod_auction_get_record_detail_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_get_record_detail_s2c(Tuple),
    [<<7:8, 3:8>>|IoList];
pack(#mod_auction_sell_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_sell_s2c(Tuple),
    [<<7:8, 4:8>>|IoList];
pack(#mod_auction_cancel_sell_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_cancel_sell_s2c(Tuple),
    [<<7:8, 5:8>>|IoList];
pack(#mod_auction_self_record_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_self_record_s2c(Tuple),
    [<<7:8, 6:8>>|IoList];
pack(#mod_auction_buy_s2c{} = Tuple) ->
    {ok, IoList} = proto_auction:mod_auction_buy_s2c(Tuple),
    [<<7:8, 7:8>>|IoList];
pack(#mod_achievement_completed_s2c{} = Tuple) ->
    {ok, IoList} = proto_achievement:mod_achievement_completed_s2c(Tuple),
    [<<8:8, 0:8>>|IoList];
pack(#mod_achievement_points_s2c{} = Tuple) ->
    {ok, IoList} = proto_achievement:mod_achievement_points_s2c(Tuple),
    [<<8:8, 1:8>>|IoList];
pack(#mod_achievement_complete_s2c{} = Tuple) ->
    {ok, IoList} = proto_achievement:mod_achievement_complete_s2c(Tuple),
    [<<8:8, 2:8>>|IoList];
pack(Tuple) ->
    throw({pack_unkown_msg, Tuple}).


