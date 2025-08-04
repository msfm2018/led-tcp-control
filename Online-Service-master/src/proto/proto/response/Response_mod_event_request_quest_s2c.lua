-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_event_request_quest_s2c = class("Response_mod_event_request_quest_s2c", Response_Base)
local mod_event_request_quest_s2c_Data = import("app.Net.proto.data.mod_event_request_quest_s2c_Data")
function Response_mod_event_request_quest_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_event_request_quest_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    self.info._quest_id = data:readInt()
    _len = data:readUShort()
    self.info._describe = data:readTCharLen(_len)
    _len = data:readUShort()
    self.info._answer1 = data:readTCharLen(_len)
    _len = data:readUShort()
    self.info._answer2 = data:readTCharLen(_len)
    _len = data:readUShort()
    self.info._answer3 = data:readTCharLen(_len)
    local len_mod_event_quest_right_answer_list = data:readUShort()
    self.info._right_answer_list = {}
    for i1 = 1, len_mod_event_quest_right_answer_list do
        self.info._right_answer_list[i1] = {}
        self.info._right_answer_list[i1]["_right_answer"] = data:readInt()
    end
    if nil == dataMap["mod_event_request_quest_s2c_Data"] then
        dataMap["mod_event_request_quest_s2c_Data"] = mod_event_request_quest_s2c_Data:create()
    end
    dataMap["mod_event_request_quest_s2c_Data"]:serialize(self.info)
end

return Response_mod_event_request_quest_s2c;