-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_part_event_ranklist_s2c = class("Response_mod_part_event_ranklist_s2c", Response_Base)
local mod_part_event_ranklist_s2c_Data = import("app.Net.proto.data.mod_part_event_ranklist_s2c_Data")
function Response_mod_part_event_ranklist_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_part_event_ranklist_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    _len = data:readUShort()
    self.info._key = data:readTCharLen(_len)
    _len = data:readUShort()
    self.info._playerid = data:readTCharLen(_len)
    self.info._eventscore = data:readUInt()
    self.info._playercamp = data:readUInt()
    local len_mod_part_event_ranklist_s2c_list = data:readUShort()
    self.info._rank = {}
    for i1 = 1, len_mod_part_event_ranklist_s2c_list do
        self.info._rank[i1] = {}
        _len = data:readUShort()
        self.info._rank[i1]["_playerid"] = data:readTCharLen(_len)
        _len = data:readUShort()
        self.info._rank[i1]["_playerName"] = data:readTCharLen(_len)
        self.info._rank[i1]["_playerScore"] = data:readLongLong()
        self.info._rank[i1]["_playercamp"] = data:readUInt()
    end
    local len_mod_part_event_sumscorelist_s2c_list = data:readUShort()
    self.info._scorelist = {}
    for i1 = 1, len_mod_part_event_sumscorelist_s2c_list do
        self.info._scorelist[i1] = {}
        self.info._scorelist[i1]["_campid"] = data:readInt()
        self.info._scorelist[i1]["_scores"] = data:readInt()
    end
    if nil == dataMap["mod_part_event_ranklist_s2c_Data"] then
        dataMap["mod_part_event_ranklist_s2c_Data"] = mod_part_event_ranklist_s2c_Data:create()
    end
    dataMap["mod_part_event_ranklist_s2c_Data"]:serialize(self.info)
end

return Response_mod_part_event_ranklist_s2c;