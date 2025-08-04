-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_goods_attribute_change_s2c = class("Response_mod_goods_attribute_change_s2c", Response_Base)
local mod_goods_attribute_change_s2c_Data = import("app.Net.proto.data.mod_goods_attribute_change_s2c_Data")
function Response_mod_goods_attribute_change_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_goods_attribute_change_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    local len_mod_goods_attribute_change_s2c_list = data:readUShort()
    self.info._list = {}
    for i1 = 1, len_mod_goods_attribute_change_s2c_list do
        self.info._list[i1] = {}
        self.info._list[i1]["_goods_id"] = data:readUInt()
    local len_mod_goods_attribute_change_s2c_attribute_list = data:readUShort()
    self.info._list[i1]["_attributes_list"] = {}
    for i2 = 1, len_mod_goods_attribute_change_s2c_attribute_list do
        self.info._list[i1]["_attributes_list"][i2] = {}
        self.info._list[i1]["_attributes_list"][i2]["_key"] = data:readByte()
        self.info._list[i1]["_attributes_list"][i2]["_value"] = data:readUInt()
    end
    end
    if nil == dataMap["mod_goods_attribute_change_s2c_Data"] then
        dataMap["mod_goods_attribute_change_s2c_Data"] = mod_goods_attribute_change_s2c_Data:create()
    end
    dataMap["mod_goods_attribute_change_s2c_Data"]:serialize(self.info)
end

return Response_mod_goods_attribute_change_s2c;