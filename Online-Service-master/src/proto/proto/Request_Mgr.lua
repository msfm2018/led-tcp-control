------------------------------------------------
--- 文件自动生成
---
--- 根据协议ｘｍｌ自动生成
---
--- 请勿手动修改
------------------------------------------------
local Request_Base = import("app.Net.common.Request_Base")
local Request_Mgr = class("Request_Mgr", Request_Base)

-- 构造函数 --
function Request_Mgr:ctor()
self.super:ctor()
end

function Request_Mgr:registerMsg()
    NetMgr:Instance():registBroadcastHandler("1-0", require("app.Net.proto.response.Response_mod_player_ask_gateway_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-1", require("app.Net.proto.response.Response_mod_player_login_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-2", require("app.Net.proto.response.Response_mod_player_regist_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-5", require("app.Net.proto.response.Response_mod_player_alluser_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-6", require("app.Net.proto.response.Response_mod_player_ask_self_data_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-7", require("app.Net.proto.response.Response_mod_player_sync_time_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-8", require("app.Net.proto.response.Response_mod_player_sync_coin_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-9", require("app.Net.proto.response.Response_mod_player_min_camp_id_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-10", require("app.Net.proto.response.Response_mod_player_attrlist_s2c"))
    NetMgr:Instance():registBroadcastHandler("1-254", require("app.Net.proto.response.Response_mod_player_errno_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-1", require("app.Net.proto.response.Response_mod_event_eventlist_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-3", require("app.Net.proto.response.Response_mod_event_joinevent_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-4", require("app.Net.proto.response.Response_mod_event_exitevent_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-5", require("app.Net.proto.response.Response_mod_event_completeevent_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-6", require("app.Net.proto.response.Response_mod_event_received_event_list_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-8", require("app.Net.proto.response.Response_mod_event_received_event_over_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-11", require("app.Net.proto.response.Response_mod_event_award_info_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-12", require("app.Net.proto.response.Response_mod_event_all_award_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-14", require("app.Net.proto.response.Response_mod_event_dispear_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-15", require("app.Net.proto.response.Response_mod_event_world_not_normal_id_list_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-21", require("app.Net.proto.response.Response_mod_part_event_ranklist_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-22", require("app.Net.proto.response.Response_mod_feature_id_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-23", require("app.Net.proto.response.Response_mod_set_camp_evet_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-24", require("app.Net.proto.response.Response_mod_event_limit_info_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-25", require("app.Net.proto.response.Response_mod_event_request_quest_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-26", require("app.Net.proto.response.Response_mod_event_request_redpacket_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-28", require("app.Net.proto.response.Response_mod_event_featurevent_review_list_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-29", require("app.Net.proto.response.Response_mod_event_small_featurereviewevent_score_s2c"))
    NetMgr:Instance():registBroadcastHandler("2-30", require("app.Net.proto.response.Response_mod_event_sign_on_info_s2x"))
    NetMgr:Instance():registBroadcastHandler("3-0", require("app.Net.proto.response.Response_mod_goods_allgoodslist_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-1", require("app.Net.proto.response.Response_mod_goods_goods_detail_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-2", require("app.Net.proto.response.Response_mod_goods_delete_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-3", require("app.Net.proto.response.Response_mod_goods_add_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-4", require("app.Net.proto.response.Response_mod_goods_produce_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-5", require("app.Net.proto.response.Response_mod_goods_produce_pet_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-7", require("app.Net.proto.response.Response_mod_goods_pet_up_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-9", require("app.Net.proto.response.Response_mod_goods_attribute_change_s2c"))
    NetMgr:Instance():registBroadcastHandler("3-11", require("app.Net.proto.response.Response_mod_goods_produce_sheet_s2c"))
    NetMgr:Instance():registBroadcastHandler("4-0", require("app.Net.proto.response.Response_mod_chat_zone_s2c"))
    NetMgr:Instance():registBroadcastHandler("4-1", require("app.Net.proto.response.Response_mod_chat_person_s2c"))
    NetMgr:Instance():registBroadcastHandler("4-2", require("app.Net.proto.response.Response_mod_chat_person_offline_s2c"))
    NetMgr:Instance():registBroadcastHandler("5-0", require("app.Net.proto.response.Response_mod_task_get_list_s2c"))
    NetMgr:Instance():registBroadcastHandler("5-1", require("app.Net.proto.response.Response_mod_task_compelte_task_s2c"))
    NetMgr:Instance():registBroadcastHandler("6-0", require("app.Net.proto.response.Response_mod_email_id_list_sc2"))
    NetMgr:Instance():registBroadcastHandler("6-1", require("app.Net.proto.response.Response_mod_email_title_list_s2c"))
    NetMgr:Instance():registBroadcastHandler("6-2", require("app.Net.proto.response.Response_mod_email_detail_s2c"))
    NetMgr:Instance():registBroadcastHandler("6-3", require("app.Net.proto.response.Response_mod_email_delete_s2c"))
    NetMgr:Instance():registBroadcastHandler("6-4", require("app.Net.proto.response.Response_mod_email_delete_all_s2c"))
    NetMgr:Instance():registBroadcastHandler("6-5", require("app.Net.proto.response.Response_mod_email_get_goods_s2c"))
    NetMgr:Instance():registBroadcastHandler("6-6", require("app.Net.proto.response.Response_mod_email_get_goods_all_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-0", require("app.Net.proto.response.Response_mod_auction_get_auction_id_list_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-1", require("app.Net.proto.response.Response_mod_auction_get_auction_page_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-2", require("app.Net.proto.response.Response_mod_auction_get_template_page_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-3", require("app.Net.proto.response.Response_mod_auction_get_record_detail_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-4", require("app.Net.proto.response.Response_mod_auction_sell_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-5", require("app.Net.proto.response.Response_mod_auction_cancel_sell_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-6", require("app.Net.proto.response.Response_mod_auction_self_record_s2c"))
    NetMgr:Instance():registBroadcastHandler("7-7", require("app.Net.proto.response.Response_mod_auction_buy_s2c"))
    NetMgr:Instance():registBroadcastHandler("8-0", require("app.Net.proto.response.Response_mod_achievement_completed_s2c"))
    NetMgr:Instance():registBroadcastHandler("8-1", require("app.Net.proto.response.Response_mod_achievement_points_s2c"))
    NetMgr:Instance():registBroadcastHandler("8-2", require("app.Net.proto.response.Response_mod_achievement_complete_s2c"))
end
function Request_Mgr:mod_player_ask_gateway_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(1, 0, _ba)
end
function Request_Mgr:mod_player_login_c2s(_id,_pwd,_x,_y)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_id)
    _ba:writeStringUShort(_pwd)
    _ba:writeInt(_x)
    _ba:writeInt(_y)
    NetMgr:Instance():SendSocketData(1, 1, _ba)
end

function Request_Mgr:mod_player_regist_c2s(_id,_name,_pwd,_camp_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_id)
    _ba:writeStringUShort(_name)
    _ba:writeStringUShort(_pwd)
    _ba:writeUInt(_camp_id)
    NetMgr:Instance():SendSocketData(1, 2, _ba)
end

function Request_Mgr:mod_player_setgps_c2s(_x,_y)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeInt(_x)
    _ba:writeInt(_y)
    NetMgr:Instance():SendSocketData(1, 3, _ba)
end

function Request_Mgr:mod_player_setuserdata_c2s(_citycode,_cityname,_address)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_citycode)
    _ba:writeStringUShort(_cityname)
    _ba:writeStringUShort(_address)
    NetMgr:Instance():SendSocketData(1, 4, _ba)
end

function Request_Mgr:mod_player_alluser_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(1, 5, _ba)
end
function Request_Mgr:mod_player_ask_self_data_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(1, 6, _ba)
end
function Request_Mgr:mod_player_sync_time_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(1, 7, _ba)
end
function Request_Mgr:mod_player_attrlist_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(1, 10, _ba)
end
function Request_Mgr:mod_player_herat_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(1, 255, _ba)
end
function Request_Mgr:mod_event_eventlist_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(2, 1, _ba)
end
function Request_Mgr:mod_event_worldeventlist_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(2, 2, _ba)
end
function Request_Mgr:mod_event_joinevent_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 3, _ba)
end

function Request_Mgr:mod_event_exitevent_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 4, _ba)
end

function Request_Mgr:mod_event_received_event_list_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(2, 6, _ba)
end
function Request_Mgr:mod_event_pet_joinevent_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 9, _ba)
end

function Request_Mgr:mod_event_return_pet_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 10, _ba)
end

function Request_Mgr:mod_event_set_normal_xy_c2s(_list)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUShort(#_list)
    for i1 = 1, #_list do
        _ba:writeStringUShort(_list[i1]["_key"])
        _ba:writeInt(_list[i1]["_x"])
        _ba:writeInt(_list[i1]["_y"])
    end
    NetMgr:Instance():SendSocketData(2, 13, _ba)
end

function Request_Mgr:mod_event_world_not_normal_id_list_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(2, 15, _ba)
end
function Request_Mgr:mod_event_ask_world_not_normal_list_c2s(_id_list)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUShort(#_id_list)
    for i1 = 1, #_id_list do
        _ba:writeLongLong(_id_list[i1]["_id"])
    end
    NetMgr:Instance():SendSocketData(2, 16, _ba)
end

function Request_Mgr:mod_event_featureeventlist_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(2, 17, _ba)
end
function Request_Mgr:mod_event_set_feature_xy_c2s(_list)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUShort(#_list)
    for i1 = 1, #_list do
        _ba:writeStringUShort(_list[i1]["_key"])
        _ba:writeInt(_list[i1]["_x"])
        _ba:writeInt(_list[i1]["_y"])
    end
    NetMgr:Instance():SendSocketData(2, 18, _ba)
end

function Request_Mgr:mod_part_event_eventlist_c2s(_player_x,_player_y)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeLongLong(_player_x)
    _ba:writeLongLong(_player_y)
    NetMgr:Instance():SendSocketData(2, 19, _ba)
end

function Request_Mgr:mod_part_event_ranklist_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 20, _ba)
end

function Request_Mgr:mod_event_small_event_score_c2s(_key,_playerscore)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    _ba:writeLongLong(_playerscore)
    NetMgr:Instance():SendSocketData(2, 21, _ba)
end

function Request_Mgr:mod_feature_id_c2s(_feature_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_feature_id)
    NetMgr:Instance():SendSocketData(2, 22, _ba)
end

function Request_Mgr:mod_set_camp_evet_c2s(_key,_campid)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    _ba:writeUInt(_campid)
    NetMgr:Instance():SendSocketData(2, 23, _ba)
end

function Request_Mgr:mod_event_limit_info_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 24, _ba)
end

function Request_Mgr:mod_event_request_quest_c2s(_key,_quest_id,_quest_num)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    _ba:writeInt(_quest_id)
    _ba:writeInt(_quest_num)
    NetMgr:Instance():SendSocketData(2, 25, _ba)
end

function Request_Mgr:mod_event_request_redpacket_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 26, _ba)
end

function Request_Mgr:mod_event_petfondventlist_c2s(_pet_x,_pet_y)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeLongLong(_pet_x)
    _ba:writeLongLong(_pet_y)
    NetMgr:Instance():SendSocketData(2, 27, _ba)
end

function Request_Mgr:mod_event_featurevent_review_list_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(2, 28, _ba)
end
function Request_Mgr:mod_event_small_featurereviewevent_score_c2s(_key,_playerscore)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    _ba:writeLongLong(_playerscore)
    NetMgr:Instance():SendSocketData(2, 29, _ba)
end

function Request_Mgr:mod_event_sign_on_info_c2s(_key)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    NetMgr:Instance():SendSocketData(2, 30, _ba)
end

function Request_Mgr:mod_event_slidemap_fondventlist_c2s(_focus_x,_focus_y)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeLongLong(_focus_x)
    _ba:writeLongLong(_focus_y)
    NetMgr:Instance():SendSocketData(2, 31, _ba)
end

function Request_Mgr:mod_goods_allgoodslist_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(3, 0, _ba)
end
function Request_Mgr:mod_goods_goods_detail_c2s(_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    NetMgr:Instance():SendSocketData(3, 1, _ba)
end

function Request_Mgr:mod_goods_delete_c2s(_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    NetMgr:Instance():SendSocketData(3, 2, _ba)
end

function Request_Mgr:mod_goods_produce_c2s(_sheet_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_sheet_id)
    NetMgr:Instance():SendSocketData(3, 4, _ba)
end

function Request_Mgr:mod_goods_produce_pet_c2s(_style,_id1,_id2,_id3,_id4,_id5)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeByte(_style)
    _ba:writeUInt(_id1)
    _ba:writeUInt(_id2)
    _ba:writeUInt(_id3)
    _ba:writeUInt(_id4)
    _ba:writeUInt(_id5)
    NetMgr:Instance():SendSocketData(3, 5, _ba)
end

function Request_Mgr:mod_goods_dispatch_pet_c2s(_key,_x,_y,_time,_pet_pos_list)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_key)
    _ba:writeInt(_x)
    _ba:writeInt(_y)
    _ba:writeUInt(_time)
    _ba:writeUShort(#_pet_pos_list)
    for i1 = 1, #_pet_pos_list do
        _ba:writeByte(_pet_pos_list[i1]["_pet"])
    end
    NetMgr:Instance():SendSocketData(3, 6, _ba)
end

function Request_Mgr:mod_goods_pet_up_c2s(_pet,_goods_id1,_goods_id2)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeByte(_pet)
    _ba:writeUInt(_goods_id1)
    _ba:writeUInt(_goods_id2)
    NetMgr:Instance():SendSocketData(3, 7, _ba)
end

function Request_Mgr:mod_goods_undispatch_pet_c2s(_pet)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeByte(_pet)
    NetMgr:Instance():SendSocketData(3, 8, _ba)
end

function Request_Mgr:mod_goods_use_c2s(_goods_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_goods_id)
    NetMgr:Instance():SendSocketData(3, 10, _ba)
end

function Request_Mgr:mod_goods_produce_sheet_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(3, 11, _ba)
end
function Request_Mgr:mod_chat_zone_c2s(_type,_words)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeByte(_type)
    _ba:writeStringUShort(_words)
    NetMgr:Instance():SendSocketData(4, 0, _ba)
end

function Request_Mgr:mod_chat_person_c2s(_player_id,_words)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_player_id)
    _ba:writeStringUShort(_words)
    NetMgr:Instance():SendSocketData(4, 1, _ba)
end

function Request_Mgr:mod_chat_gm_command_c2s(_words)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeStringUShort(_words)
    NetMgr:Instance():SendSocketData(4, 255, _ba)
end

function Request_Mgr:mod_task_get_list_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(5, 0, _ba)
end
function Request_Mgr:mod_task_compelte_task_c2s(_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    NetMgr:Instance():SendSocketData(5, 1, _ba)
end

function Request_Mgr:mod_email_id_list_c2s(_type)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeByte(_type)
    NetMgr:Instance():SendSocketData(6, 0, _ba)
end

function Request_Mgr:mod_email_title_list_c2s(_id_list)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUShort(#_id_list)
    for i1 = 1, #_id_list do
        _ba:writeUInt(_id_list[i1]["_id"])
    end
    NetMgr:Instance():SendSocketData(6, 1, _ba)
end

function Request_Mgr:mod_email_detail_c2s(_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    NetMgr:Instance():SendSocketData(6, 2, _ba)
end

function Request_Mgr:mod_email_delete_c2s(_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    NetMgr:Instance():SendSocketData(6, 3, _ba)
end

function Request_Mgr:mod_email_delete_all_c2s(_type,_status)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeByte(_type)
    _ba:writeByte(_status)
    NetMgr:Instance():SendSocketData(6, 4, _ba)
end

function Request_Mgr:mod_email_get_goods_c2s(_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    NetMgr:Instance():SendSocketData(6, 5, _ba)
end

function Request_Mgr:mod_email_get_goods_all_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(6, 6, _ba)
end
function Request_Mgr:mod_auction_get_auction_id_list_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(7, 0, _ba)
end
function Request_Mgr:mod_auction_get_auction_page_c2s(_id,_page,_time)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    _ba:writeUInt(_page)
    _ba:writeUInt(_time)
    NetMgr:Instance():SendSocketData(7, 1, _ba)
end

function Request_Mgr:mod_auction_get_template_page_c2s(_id,_template_id,_time)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    _ba:writeUInt(_template_id)
    _ba:writeUInt(_time)
    NetMgr:Instance():SendSocketData(7, 2, _ba)
end

function Request_Mgr:mod_auction_get_record_detail_c2s(_id,_record_id,_template_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    _ba:writeLongLong(_record_id)
    _ba:writeUInt(_template_id)
    NetMgr:Instance():SendSocketData(7, 3, _ba)
end

function Request_Mgr:mod_auction_sell_c2s(_id,_goods_id,_num,_price,_time)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    _ba:writeUInt(_goods_id)
    _ba:writeUInt(_num)
    _ba:writeUInt(_price)
    _ba:writeUInt(_time)
    NetMgr:Instance():SendSocketData(7, 4, _ba)
end

function Request_Mgr:mod_auction_cancel_sell_c2s(_id,_record_id)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_id)
    _ba:writeLongLong(_record_id)
    NetMgr:Instance():SendSocketData(7, 5, _ba)
end

function Request_Mgr:mod_auction_self_record_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(7, 6, _ba)
end
function Request_Mgr:mod_auction_buy_c2s(_auction_id,_record_id,_num)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeUInt(_auction_id)
    _ba:writeLongLong(_record_id)
    _ba:writeUInt(_num)
    NetMgr:Instance():SendSocketData(7, 7, _ba)
end

function Request_Mgr:mod_achievement_completed_c2s(_type)
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")
    _ba:writeByte(_type)
    NetMgr:Instance():SendSocketData(8, 0, _ba)
end

function Request_Mgr:mod_achievement_points_c2s()
    local _ba = self.super.getByteArray()
    _ba:setEndian("ENDIAN_BIG")    NetMgr:Instance():SendSocketData(8, 1, _ba)
end


return Request_Mgr