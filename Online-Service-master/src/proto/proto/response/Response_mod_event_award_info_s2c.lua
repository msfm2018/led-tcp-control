-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_event_award_info_s2c = class("Response_mod_event_award_info_s2c", Response_Base)
local mod_event_award_info_s2c_Data = import("app.Net.proto.data.mod_event_award_info_s2c_Data")
function Response_mod_event_award_info_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_event_award_info_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    _len = data:readUShort()
    self.info._key = data:readTCharLen(_len)
    local len_mod_event_award_info_s2c_goods_list = data:readUShort()
    self.info._list = {}
    for i1 = 1, len_mod_event_award_info_s2c_goods_list do
        self.info._list[i1] = {}
        self.info._list[i1]["_template"] = data:readUInt()
        self.info._list[i1]["_num"] = data:readUInt()
    end
    local len_mod_event_award_info_s2c_pet_list = data:readUShort()
    self.info._pet_hurt_list = {}
    for i1 = 1, len_mod_event_award_info_s2c_pet_list do
        self.info._pet_hurt_list[i1] = {}
        self.info._pet_hurt_list[i1]["_pet_goods_id"] = data:readUInt()
    local len_mod_event_award_info_s2c_hurt_list = data:readUShort()
    self.info._pet_hurt_list[i1]["_list"] = {}
    for i2 = 1, len_mod_event_award_info_s2c_hurt_list do
        self.info._pet_hurt_list[i1]["_list"][i2] = {}
        self.info._pet_hurt_list[i1]["_list"][i2]["_attack_type"] = data:readByte()
        self.info._pet_hurt_list[i1]["_list"][i2]["_attack_count"] = data:readUShort()
        self.info._pet_hurt_list[i1]["_list"][i2]["_hurt"] = data:readUInt()
    end
    end
    if nil == dataMap["mod_event_award_info_s2c_Data"] then
        dataMap["mod_event_award_info_s2c_Data"] = mod_event_award_info_s2c_Data:create()
    end
    dataMap["mod_event_award_info_s2c_Data"]:serialize(self.info)
end

return Response_mod_event_award_info_s2c;