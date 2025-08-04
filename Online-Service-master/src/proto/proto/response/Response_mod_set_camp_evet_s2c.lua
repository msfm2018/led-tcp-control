-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_set_camp_evet_s2c = class("Response_mod_set_camp_evet_s2c", Response_Base)
local mod_set_camp_evet_s2c_Data = import("app.Net.proto.data.mod_set_camp_evet_s2c_Data")
function Response_mod_set_camp_evet_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_set_camp_evet_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    _len = data:readUShort()
    self.info._key = data:readTCharLen(_len)
    self.info._campid = data:readUInt()
    if nil == dataMap["mod_set_camp_evet_s2c_Data"] then
        dataMap["mod_set_camp_evet_s2c_Data"] = mod_set_camp_evet_s2c_Data:create()
    end
    dataMap["mod_set_camp_evet_s2c_Data"]:serialize(self.info)
end

return Response_mod_set_camp_evet_s2c;