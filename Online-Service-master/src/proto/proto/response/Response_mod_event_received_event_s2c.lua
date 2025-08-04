-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_event_received_event_s2c = class("Response_mod_event_received_event_s2c", Response_Base)
local mod_event_received_event_s2c_Data = import("app.Net.proto.data.mod_event_received_event_s2c_Data")
function Response_mod_event_received_event_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_event_received_event_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    self.info.id = data:readLongLong()
    _len = data:readUShort()
    self.info._name = data:readTCharLen(_len)
    self.info._type = data:readInt()
    _len = data:readUShort()
    self.info._desc = data:readTCharLen(_len)
    self.info._x = data:readInt()
    self.info._y = data:readInt()
    self.info._area = data:readByte()
    self.info._start_time = data:readInt()
    self.info._end_time = data:readInt()
    self.info._participate_num = data:readInt()
    local len_mod_event_received_event_s2c_conditions = data:readUShort()
    self.info._conditions = {}
    for i1 = 1, len_mod_event_received_event_s2c_conditions do
        self.info._conditions[i1] = {}
        self.info._conditions[i1]["_k"] = data:readByte()
        self.info._conditions[i1]["_v"] = data:readInt()
    end
    if nil == dataMap["mod_event_received_event_s2c_Data"] then
        dataMap["mod_event_received_event_s2c_Data"] = mod_event_received_event_s2c_Data:create()
    end
    dataMap["mod_event_received_event_s2c_Data"]:serialize(self.info)
end

return Response_mod_event_received_event_s2c;