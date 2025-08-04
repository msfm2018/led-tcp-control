-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_event_world_not_normal_id_list_s2c = class("Response_mod_event_world_not_normal_id_list_s2c", Response_Base)
local mod_event_world_not_normal_id_list_s2c_Data = import("app.Net.proto.data.mod_event_world_not_normal_id_list_s2c_Data")
function Response_mod_event_world_not_normal_id_list_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_event_world_not_normal_id_list_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    local len_mod_event_world_not_normal_id_list_s2c_list = data:readUShort()
    self.info._id_list = {}
    for i1 = 1, len_mod_event_world_not_normal_id_list_s2c_list do
        self.info._id_list[i1] = {}
        self.info._id_list[i1]["_id"] = data:readLongLong()
    end
    if nil == dataMap["mod_event_world_not_normal_id_list_s2c_Data"] then
        dataMap["mod_event_world_not_normal_id_list_s2c_Data"] = mod_event_world_not_normal_id_list_s2c_Data:create()
    end
    dataMap["mod_event_world_not_normal_id_list_s2c_Data"]:serialize(self.info)
end

return Response_mod_event_world_not_normal_id_list_s2c;