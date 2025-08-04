-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_email_id_list_sc2 = class("Response_mod_email_id_list_sc2", Response_Base)
local mod_email_id_list_sc2_Data = import("app.Net.proto.data.mod_email_id_list_sc2_Data")
function Response_mod_email_id_list_sc2:ctor()

end
--复写父类的decode方法
function  Response_mod_email_id_list_sc2:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    self.info._type = data:readByte()
    local len_mod_email_id_list_sc2_list = data:readUShort()
    self.info._id_list = {}
    for i1 = 1, len_mod_email_id_list_sc2_list do
        self.info._id_list[i1] = {}
        self.info._id_list[i1]["_id"] = data:readUInt()
    end
    if nil == dataMap["mod_email_id_list_sc2_Data"] then
        dataMap["mod_email_id_list_sc2_Data"] = mod_email_id_list_sc2_Data:create()
    end
    dataMap["mod_email_id_list_sc2_Data"]:serialize(self.info)
end

return Response_mod_email_id_list_sc2;