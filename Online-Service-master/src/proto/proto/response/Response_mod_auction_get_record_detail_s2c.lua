-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_auction_get_record_detail_s2c = class("Response_mod_auction_get_record_detail_s2c", Response_Base)
local mod_auction_get_record_detail_s2c_Data = import("app.Net.proto.data.mod_auction_get_record_detail_s2c_Data")
function Response_mod_auction_get_record_detail_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_auction_get_record_detail_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    self.info._id = data:readUInt()
    self.info.record_id = data:readLongLong()
    self.info._template_id = data:readUInt()
    local len_mod_auction_get_record_detail_s2c_attribute_list = data:readUShort()
    self.info._list = {}
    for i1 = 1, len_mod_auction_get_record_detail_s2c_attribute_list do
        self.info._list[i1] = {}
        self.info._list[i1]["_key"] = data:readByte()
        self.info._list[i1]["_value"] = data:readUInt()
    end
    if nil == dataMap["mod_auction_get_record_detail_s2c_Data"] then
        dataMap["mod_auction_get_record_detail_s2c_Data"] = mod_auction_get_record_detail_s2c_Data:create()
    end
    dataMap["mod_auction_get_record_detail_s2c_Data"]:serialize(self.info)
end

return Response_mod_auction_get_record_detail_s2c;