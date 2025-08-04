-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_event_limit_info_s2c = class("Response_mod_event_limit_info_s2c", Response_Base)
local mod_event_limit_info_s2c_Data = import("app.Net.proto.data.mod_event_limit_info_s2c_Data")
function Response_mod_event_limit_info_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_event_limit_info_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    _len = data:readUShort()
    self.info._key = data:readTCharLen(_len)
    self.info._limit_player_max_num = data:readInt()
    self.info._limit_player_also_num = data:readInt()
    self.info._limit_event_max_times = data:readInt()
    self.info._limit_event_also_times = data:readInt()
    if nil == dataMap["mod_event_limit_info_s2c_Data"] then
        dataMap["mod_event_limit_info_s2c_Data"] = mod_event_limit_info_s2c_Data:create()
    end
    dataMap["mod_event_limit_info_s2c_Data"]:serialize(self.info)
end

return Response_mod_event_limit_info_s2c;