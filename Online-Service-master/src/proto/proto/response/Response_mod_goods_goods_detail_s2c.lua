-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_goods_goods_detail_s2c = class("Response_mod_goods_goods_detail_s2c", Response_Base)
local mod_goods_goods_detail_s2c_Data = import("app.Net.proto.data.mod_goods_goods_detail_s2c_Data")
function Response_mod_goods_goods_detail_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_goods_goods_detail_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    self.info._id = data:readUInt()
    self.info._template = data:readUInt()
    self.info._get_time = data:readUInt()
    self.info._num = data:readUInt()
    _len = data:readUShort()
    self.info._key = data:readTCharLen(_len)
    self.info._dispatch_time = data:readUInt()
    local len_mod_goods_goods_detail_s2c_attribute = data:readUShort()
    self.info._attributes_list = {}
    for i1 = 1, len_mod_goods_goods_detail_s2c_attribute do
        self.info._attributes_list[i1] = {}
        self.info._attributes_list[i1]["_key1"] = data:readByte()
        self.info._attributes_list[i1]["_key2"] = data:readByte()
        self.info._attributes_list[i1]["_value"] = data:readUInt()
    end
    if nil == dataMap["mod_goods_goods_detail_s2c_Data"] then
        dataMap["mod_goods_goods_detail_s2c_Data"] = mod_goods_goods_detail_s2c_Data:create()
    end
    dataMap["mod_goods_goods_detail_s2c_Data"]:serialize(self.info)
end

return Response_mod_goods_goods_detail_s2c;