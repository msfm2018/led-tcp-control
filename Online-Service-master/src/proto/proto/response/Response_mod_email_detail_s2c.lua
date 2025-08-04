-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_email_detail_s2c = class("Response_mod_email_detail_s2c", Response_Base)
local mod_email_detail_s2c_Data = import("app.Net.proto.data.mod_email_detail_s2c_Data")
function Response_mod_email_detail_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_email_detail_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    self.info._id = data:readUInt()
    _len = data:readUShort()
    self.info._sender_id = data:readTCharLen(_len)
    _len = data:readUShort()
    self.info._content = data:readTCharLen(_len)
    local len_mod_email_detail_s2c_goods_list = data:readUShort()
    self.info._goods_list = {}
    for i1 = 1, len_mod_email_detail_s2c_goods_list do
        self.info._goods_list[i1] = {}
        self.info._goods_list[i1]["_template"] = data:readUInt()
        self.info._goods_list[i1]["_num"] = data:readUInt()
    end
    if nil == dataMap["mod_email_detail_s2c_Data"] then
        dataMap["mod_email_detail_s2c_Data"] = mod_email_detail_s2c_Data:create()
    end
    dataMap["mod_email_detail_s2c_Data"]:serialize(self.info)
end

return Response_mod_email_detail_s2c;