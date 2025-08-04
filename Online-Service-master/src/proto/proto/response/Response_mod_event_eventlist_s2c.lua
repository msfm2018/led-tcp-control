-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_event_eventlist_s2c = class("Response_mod_event_eventlist_s2c", Response_Base)
local mod_event_eventlist_s2c_Data = import("app.Net.proto.data.mod_event_eventlist_s2c_Data")
function Response_mod_event_eventlist_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_event_eventlist_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    local len_mod_event_eventlist_s2c_list = data:readUShort()
    self.info._event_list = {}
    for i1 = 1, len_mod_event_eventlist_s2c_list do
        self.info._event_list[i1] = {}
        _len = data:readUShort()
        self.info._event_list[i1]["_key"] = data:readTCharLen(_len)
        self.info._event_list[i1]["_id"] = data:readLongLong()
        _len = data:readUShort()
        self.info._event_list[i1]["_name"] = data:readTCharLen(_len)
        self.info._event_list[i1]["_type"] = data:readInt()
        _len = data:readUShort()
        self.info._event_list[i1]["_desc"] = data:readTCharLen(_len)
        self.info._event_list[i1]["_x"] = data:readInt()
        self.info._event_list[i1]["_y"] = data:readInt()
        self.info._event_list[i1]["_area"] = data:readByte()
        self.info._event_list[i1]["_start_time"] = data:readLongLong()
        self.info._event_list[i1]["_end_time"] = data:readLongLong()
        self.info._event_list[i1]["_participate_num"] = data:readInt()
    local len_mod_event_eventlist_s2c_event_conditions = data:readUShort()
    self.info._event_list[i1]["_conditions"] = {}
    for i2 = 1, len_mod_event_eventlist_s2c_event_conditions do
        self.info._event_list[i1]["_conditions"][i2] = {}
        self.info._event_list[i1]["_conditions"][i2]["_k"] = data:readByte()
        self.info._event_list[i1]["_conditions"][i2]["_v"] = data:readInt()
    end
    local len_mod_event_eventlist_s2c_event_award = data:readUShort()
    self.info._event_list[i1]["_award"] = {}
    for i2 = 1, len_mod_event_eventlist_s2c_event_award do
        self.info._event_list[i1]["_award"][i2] = {}
        self.info._event_list[i1]["_award"][i2]["_time"] = data:readUInt()
        self.info._event_list[i1]["_award"][i2]["_drop_id"] = data:readUInt()
    end
    local len_mod_event_eventlist_s2c_event_award1 = data:readUShort()
    self.info._event_list[i1]["_award1"] = {}
    for i2 = 1, len_mod_event_eventlist_s2c_event_award1 do
        self.info._event_list[i1]["_award1"][i2] = {}
        self.info._event_list[i1]["_award1"][i2]["_template"] = data:readUInt()
        self.info._event_list[i1]["_award1"][i2]["_num"] = data:readUInt()
    end
        self.info._event_list[i1]["_state"] = data:readInt()
        self.info._event_list[i1]["_camp"] = data:readInt()
        self.info._event_list[i1]["_player_camp"] = data:readInt()
        self.info._event_list[i1]["_player_score"] = data:readInt()
        self.info._event_list[i1]["_limit_player_max_num"] = data:readInt()
        self.info._event_list[i1]["_limit_event_max_times"] = data:readInt()
        self.info._event_list[i1]["_limit_player_also_num"] = data:readInt()
        self.info._event_list[i1]["_limit_event_also_times"] = data:readInt()
        self.info._event_list[i1]["_wave_number_standard"] = data:readInt()
    end
    if nil == dataMap["mod_event_eventlist_s2c_Data"] then
        dataMap["mod_event_eventlist_s2c_Data"] = mod_event_eventlist_s2c_Data:create()
    end
    dataMap["mod_event_eventlist_s2c_Data"]:serialize(self.info)
end

return Response_mod_event_eventlist_s2c;