-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_task_compelte_task_s2c = class("Response_mod_task_compelte_task_s2c", Response_Base)
local mod_task_compelte_task_s2c_Data = import("app.Net.proto.data.mod_task_compelte_task_s2c_Data")
function Response_mod_task_compelte_task_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_task_compelte_task_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    self.info._id = data:readUInt()
    if nil == dataMap["mod_task_compelte_task_s2c_Data"] then
        dataMap["mod_task_compelte_task_s2c_Data"] = mod_task_compelte_task_s2c_Data:create()
    end
    dataMap["mod_task_compelte_task_s2c_Data"]:serialize(self.info)
end

return Response_mod_task_compelte_task_s2c;