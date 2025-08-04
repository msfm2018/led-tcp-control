-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_event_sign_on_info_s2x = class("Response_mod_event_sign_on_info_s2x", Response_Base)
local mod_event_sign_on_info_s2x_Data = import("app.Net.proto.data.mod_event_sign_on_info_s2x_Data")
function Response_mod_event_sign_on_info_s2x:ctor()

end
--复写父类的decode方法
function  Response_mod_event_sign_on_info_s2x:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    _len = data:readUShort()
    self.info._key = data:readTCharLen(_len)
    self.info.selfscore = data:readLongLong()
    self.info.totalscore = data:readLongLong()
    self.info.totalplayernum = data:readLongLong()
    if nil == dataMap["mod_event_sign_on_info_s2x_Data"] then
        dataMap["mod_event_sign_on_info_s2x_Data"] = mod_event_sign_on_info_s2x_Data:create()
    end
    dataMap["mod_event_sign_on_info_s2x_Data"]:serialize(self.info)
end

return Response_mod_event_sign_on_info_s2x;