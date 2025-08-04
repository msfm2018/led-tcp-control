-----------------
-- 自动生成
-- 请勿手动修改
-----------------

local Response_Base = import("app.Net.common.Response_Base")
local Response_mod_player_ask_self_data_s2c = class("Response_mod_player_ask_self_data_s2c", Response_Base)
local mod_player_ask_self_data_s2c_Data = import("app.Net.proto.data.mod_player_ask_self_data_s2c_Data")
function Response_mod_player_ask_self_data_s2c:ctor()

end
--复写父类的decode方法
function  Response_mod_player_ask_self_data_s2c:decode(data)
    self.super.decode(data);
    self.info = {}
    local _len = 0
    _len = data:readUShort()
    self.info._id = data:readTCharLen(_len)
    _len = data:readUShort()
    self.info._name = data:readTCharLen(_len)
    self.info._x = data:readInt()
    self.info._y = data:readInt()
    self.info._citycode = data:readUInt()
    _len = data:readUShort()
    self.info._cityname = data:readTCharLen(_len)
    _len = data:readUShort()
    self.info._address = data:readTCharLen(_len)
    self.info.mileage = data:readLongLong()
    self.info._lv = data:readUInt()
    self.info.exp = data:readLongLong()
    self.info.coin = data:readLongLong()
    _len = data:readUShort()
    self.info._sign = data:readTCharLen(_len)
    self.info._pet1 = data:readUInt()
    self.info._pet2 = data:readUInt()
    self.info._pet3 = data:readUInt()
    self.info._pet4 = data:readUInt()
    self.info._pet5 = data:readUInt()
    self.info._pet6 = data:readUInt()
    self.info._feature_id = data:readUInt()
    self.info._camp_id = data:readUInt()
    if nil == dataMap["mod_player_ask_self_data_s2c_Data"] then
        dataMap["mod_player_ask_self_data_s2c_Data"] = mod_player_ask_self_data_s2c_Data:create()
    end
    dataMap["mod_player_ask_self_data_s2c_Data"]:serialize(self.info)
end

return Response_mod_player_ask_self_data_s2c;