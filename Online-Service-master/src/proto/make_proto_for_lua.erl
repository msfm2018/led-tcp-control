%% -*- coding: latin-1 -*-
%%%-------------------------------------------------------------------
%%% @author wulei
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2014 下午7:34
%%%-------------------------------------------------------------------
-module(make_proto_for_lua).
-author("wulei").

-include_lib("xmerl/include/xmerl.hrl").

%% API
-compile(export_all).

start() ->
    case file:read_file("error.xml") of
        {error, _EReason} ->
            throw(_EReason);
        {ok, EXml} ->
            EXmlStr = binary_to_list(iolist_to_binary(EXml)),
            case xmerl_scan:string(EXmlStr, [{space, normalize}]) of
                {error, _EReason} ->
                    throw(_EReason);
                {_EElement, [_|_] = ERest} ->
                    throw(ERest);
                {EElement, []} ->
                    ok = handle_error_xml(EElement)
            end
    end,
    case file:read_file("proto.xml") of
        {error, _Reason} ->
            throw(_Reason);
        {ok, Xml} ->
            XmlStr = binary_to_list(iolist_to_binary(Xml)),
            case xmerl_scan:string(XmlStr, [{space, normalize}]) of
                {error, _Reason} ->
                    throw(_Reason);
                {_Element, [_|_] = Rest} ->
                    throw(Rest);
                {Element, []} ->
                    ok = handle(Element)
            end
    end.

-define(L2A(A), list_to_atom(A)).
-define(L2I(A), list_to_integer(A)).
-define(P(F,A),io:format(F,A)).

handle_error_xml(#xmlElement{content = Content}) ->
    ElementList = get_xmlElementList(Content, []),
    HeadSrc =
        "------------------------------------------------
--- 文件自动生成
---
--- 根据error.xml生成
---
--- 请勿手动修改
------------------------------------------------

cc.exports.error_msg_const = {
",
    make_error_hrl(HeadSrc, ElementList),
    ok.

make_error_hrl(Src, []) ->
    NewSrc = Src ++ "}\n\n",
    ok = file:write_file("proto\\error_msg\\error_msg.lua", NewSrc),
    ok;
make_error_hrl(Src, [H|L]) ->
    Id = get_xml_attribute_value(id, H#xmlElement.attributes),
    Desc = erlang:binary_to_list(unicode:characters_to_binary(get_xml_attribute_value(desc, H#xmlElement.attributes))), % 文件中读的需要处理
    NewSrc = Src ++ "    [\"" ++ Id ++ "\"] = \"" ++ Desc ++ "\",\n",
    make_error_hrl(NewSrc, L).


handle(#xmlElement{content = Content}) ->
    ElementList = get_xmlElementList(Content, []),
    %% 创建Request_mgr脚本
    make_request_mgr(ElementList, "", ""),
    %% 创建 Response脚本
    make_response(ElementList),
    %% 创建 Data 脚本
    make_data(ElementList),
    ok.

%% @doc 生成各个response脚本
make_data([]) ->
    ok;
make_data([H|L]) ->
    make_data_mod(H),
    make_data(L).

%% @doc 处理xml中的每一个module
make_data_mod(O) ->
    case get_xmlElementList(O#xmlElement.content ,[]) of
        [] ->
            ok;
        ProtoList ->
            F = fun(E) ->
                Type = get_xml_attribute_value(type, E#xmlElement.attributes),
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
                if
                    Type =:= "1" ->
                        Src = "-----------------\n-- 自动生成\n-- 请勿手动修改\n-----------------\n\n"
                            ++ "local Data_Base = import(\"app.Net.common.Data_Base\")\n"
                            ++ "local " ++ ProtoName ++ "_Data = class(\"" ++ ProtoName ++ "_Data\", Data_Base)\n"
                            ++ "--构造函数\n"
                            ++ "function " ++ ProtoName ++ "_Data:ctor()\n    self.super:ctor(\""++ ProtoName ++"_Data\")\nend\n"
                            ++ "function "++ ProtoName ++"_Data:serialize(data)\n\nend\n\n",
                        NewSrc1 = Src ++ "return "++ ProtoName ++ "_Data\n",
                        OneFileName = "proto\\data\\" ++ ProtoName ++ "_Data.lua",
                        ok = file:write_file(OneFileName, NewSrc1);
                    true ->
                        ok
                end
            end,
            lists:foreach(F, ProtoList)
    end,
    ok.

%% @doc 生成各个response脚本
make_response([]) ->
    ok;
make_response([H|L]) ->
    make_response_mod(H),
    make_response(L).

%% @doc 处理xml中的每一个module
make_response_mod(O) ->
    case get_xmlElementList(O#xmlElement.content ,[]) of
        [] ->
            ok;
        ProtoList ->
            F = fun(E) ->
                Type = get_xml_attribute_value(type, E#xmlElement.attributes),
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
                if
                    Type =:= "1" ->
                        Src = "-----------------\n-- 自动生成\n-- 请勿手动修改\n-----------------\n\n"
                            ++ "local Response_Base = import(\"app.Net.common.Response_Base\")\n"
                            ++ "local Response_" ++ ProtoName ++ " = class(\"Response_" ++ ProtoName ++ "\", Response_Base)\n"
                            ++ "local " ++ ProtoName ++ "_Data = import(\"app.Net.proto.data." ++ ProtoName ++ "_Data\")\n"
                            ++ "function Response_" ++ ProtoName ++ ":ctor()\n\n" ++ "end\n"
                            ++ "--复写父类的decode方法\n"
                            ++ "function  Response_"++ ProtoName ++ ":decode(data)\n"
                            ++ "    self.super.decode(data);\n"
                            ++ "    self.info = {}\n    local _len = 0\n",
                        % 解析数据
                        NewSrc = case get_xmlElementList(E#xmlElement.content, []) of
                                     [] ->
                                         Src;
                                     ParamList ->
                                         F_forloop = fun(Eforloop, Accforloop) ->
                                             case Eforloop#xmlElement.name of
                                                 loop ->
                                                     [Eforloop | Accforloop];
                                                 value ->
                                                     Accforloop
                                             end
                                         end,
                                         LoopList = lists:foldl(F_forloop, [], ParamList),% 先把所有loop弄出来
                                         F_forParam = fun(Eforparam, Accforparam) ->
                                             ParamName = get_xml_attribute_value(name, Eforparam#xmlElement.attributes),
                                             case Eforparam#xmlElement.name of
                                                 loop ->
                                                     Accforparam;
                                                 value ->
                                                     case get_xml_attribute_value(type, Eforparam#xmlElement.attributes) of
                                                         "uint8" ->
                                                             Accforparam ++ "    self.info._"++ ParamName ++ " = data:readByte()\n";
                                                         "uint16" ->
                                                             Accforparam ++ "    self.info._"++ ParamName ++ " = data:readUShort()\n";
                                                         "uint32" ->
                                                             Accforparam ++ "    self.info._"++ ParamName ++ " = data:readUInt()\n";
                                                         "uint64" ->
                                                             Accforparam ++ "    self.info."++ ParamName ++ " = data:readLongLong()\n";
                                                         "int8" ->
                                                             Accforparam ++ "    self.info._"++ ParamName ++ " = data:readByte()\n";
                                                         "int16" ->
                                                             Accforparam ++ "    self.info._"++ ParamName ++ " = data:readShort()\n";
                                                         "int32" ->
                                                             Accforparam ++ "    self.info._"++ ParamName ++ " = data:readInt()\n";
                                                         "int64" ->
                                                             Accforparam ++ "    self.info._"++ ParamName ++ " = data:readLongLong()\n";
                                                         "string" ->
                                                             Accforparam ++ "    _len = data:readUShort()\n    self.info._"++ ParamName ++ " = data:readTCharLen(_len)\n";
                                                         "bytes" ->
                                                             Accforparam ++ "    _len = data:readUShort()\n    self.info._"++ ParamName ++ " = data:readTCharLen(_len)\n";
                                                         "loop" ->
                                                             LoopType = get_xml_attribute_value(looptype, Eforparam#xmlElement.attributes),
                                                             serializedataloop(Accforparam, LoopType, "_" ++ ParamName, LoopList, 1)
                                                     end
                                             end
                                         end,
                                         lists:foldl(F_forParam, Src, ParamList)
                                 end,
                        NewSrc1 = NewSrc ++ "    if nil == dataMap[\""++ ProtoName ++"_Data\"] then\n"
                            ++ "        dataMap[\"" ++ ProtoName ++ "_Data\"] = " ++ ProtoName ++ "_Data:create()\n"
                            ++ "    end\n"
                            ++ "    dataMap[\"" ++ ProtoName ++ "_Data\"]:serialize(self.info)\n"
                            ++ "end\n\n"
                            ++ "return Response_" ++ ProtoName ++ ";",
                        OneFileName = "proto\\response\\Response_" ++ ProtoName ++ ".lua",
                        ok = file:write_file(OneFileName, NewSrc1);
                    true ->
                        ok
                end
            end,
            lists:foreach(F, ProtoList)
    end,
    ok.

%% @doc 生成 Request_Mgr.lua  打包数据脚本
make_request_mgr([], Src1, Src2) ->
    Src_Head =
"------------------------------------------------
--- 文件自动生成
---
--- 根据协议ｘｍｌ自动生成
---
--- 请勿手动修改
------------------------------------------------
local Request_Base = import(\"app.Net.common.Request_Base\")
local Request_Mgr = class(\"Request_Mgr\", Request_Base)

-- 构造函数 --
function Request_Mgr:ctor()
self.super:ctor()
end

",
    Register_Fun = "function Request_Mgr:registerMsg()\n" ++ Src2 ++ "end\n",
    Src = Src_Head ++ Register_Fun ++ Src1 ++ "\n\nreturn Request_Mgr",
    ok = file:write_file("proto\\Request_Mgr.lua", Src),
    ok;
make_request_mgr([H|L], Src1, Src2) ->
    Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
    _ModName = get_xml_attribute_value(modname, H#xmlElement.attributes),
    _ErlName = get_xml_attribute_value(erlname, H#xmlElement.attributes),
    ProtoList = get_xmlElementList(H#xmlElement.content,[]),
    F11 = fun(E, {Acc1, Acc2}) ->
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "0" ->  % 客户端给服务器发送  打包函数生成
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
                ProtoId = get_xml_attribute_value(protoid, E#xmlElement.attributes),
                Srcaaa = case get_xmlElementList(E#xmlElement.content, []) of
                             [] ->
                                 NewAcc1 = Acc1 ++ "function Request_Mgr:" ++ ProtoName ++ "()\n" ++ "    local _ba = self.super.getByteArray()\n"
                                     ++ "    _ba:setEndian(\"ENDIAN_BIG\")"
                                     ++ "    NetMgr:Instance():SendSocketData("++ Modid ++ ", " ++ ProtoId ++ ", _ba)\n"
                                     ++ "end\n"
                                 ,
                                 NewAcc1;
                             ParamList ->
                                 NewAcc1 = Acc1 ++ "function Request_Mgr:" ++ ProtoName ++ "(",
                                 F_forloop = fun(Eforloop, Accforloop) ->
                                     case Eforloop#xmlElement.name of
                                         loop ->
                                             [Eforloop | Accforloop];
                                         value ->
                                             Accforloop
                                     end
                                 end,
                                 LoopList = lists:foldl(F_forloop, [], ParamList),% 先把所有loop弄出来
                                 F_forfunction = fun(Eforfunction, Accforfunction) ->
                                     case Eforfunction#xmlElement.name of
                                         value ->
                                             Accforfunction ++ "_" ++ get_xml_attribute_value(name, Eforfunction#xmlElement.attributes) ++ ",";
                                         _ ->
                                             Accforfunction
                                     end
                                 end,
                                 NewAcc2 = drop_do(lists:foldl(F_forfunction, NewAcc1, ParamList)) ++ ")\n",% 函数的参数
                                 NewAcc3 = NewAcc2 ++ "    local _ba = self.super.getByteArray()\n"
                                     ++"    _ba:setEndian(\"ENDIAN_BIG\")\n",
                                 F_forfunction1 = fun(Eforfunction, Accforfunction) ->
                                     case Eforfunction#xmlElement.name of
                                         value ->
                                             ParamName = get_xml_attribute_value(name, Eforfunction#xmlElement.attributes),
                                             case get_xml_attribute_value(type, Eforfunction#xmlElement.attributes) of
                                                 "uint8" ->
                                                     Accforfunction ++ "    _ba:writeByte(_"++ ParamName ++ ")\n";
                                                 "uint16" ->
                                                     Accforfunction ++ "    _ba:writeUShort(_"++ ParamName ++ ")\n";
                                                 "uint32" ->
                                                     Accforfunction ++ "    _ba:writeUInt(_"++ ParamName ++ ")\n";
                                                 "uint64" ->
                                                     Accforfunction ++ "    _ba:writeLongLong(_"++ ParamName ++ ")\n";
                                                 "int8" ->
                                                     Accforfunction ++ "    _ba:writeByte(_"++ ParamName ++ ")\n";
                                                 "int16" ->
                                                     Accforfunction ++ "    _ba:writeShort(_"++ ParamName ++ ")\n";
                                                 "int32" ->
                                                     Accforfunction ++ "    _ba:writeInt(_"++ ParamName ++ ")\n";
                                                 "int64" ->
                                                     Accforfunction ++ "    _ba:writeLongLong(_"++ ParamName ++ ")\n";
                                                 "string" ->
                                                     Accforfunction ++ "    _ba:writeStringUShort(_"++ ParamName ++ ")\n";
                                                 "bytes" ->
                                                     Accforfunction ++ "    _ba:writeStringUShort(_"++ ParamName ++ ")\n";
                                                 "loop" ->
                                                     LoopType = get_xml_attribute_value(looptype, Eforfunction#xmlElement.attributes),
                                                     writeloop(Accforfunction, LoopType, "_" ++ ParamName, LoopList, 1)
                                             end;
                                         _ ->
                                             Accforfunction
                                     end
                                 end,
                                 NewAcc4 = lists:foldl(F_forfunction1, NewAcc3, ParamList),
                                 NewAcc4 ++ "    NetMgr:Instance():SendSocketData("++ Modid ++ ", " ++ ProtoId ++ ", _ba)\n" ++ "end\n\n"
                         end,
                {Srcaaa, Acc2};
            "1" ->
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
                ProtoId = get_xml_attribute_value(protoid, E#xmlElement.attributes),
                NewAcc2 = Acc2 ++ "    NetMgr:Instance():registBroadcastHandler(\"" ++ Modid ++"-" ++ ProtoId ++ "\", require(\"app.Net.proto.response.Response_"++ ProtoName ++"\"))\n",
                {Acc1, NewAcc2}
        end
    end,
    {NewSrc1, NewSrc2} = lists:foldl(F11, {Src1, Src2}, ProtoList),
    make_request_mgr(L, NewSrc1, NewSrc2).

get_xmlElementList([], L) ->
    lists:reverse(L);
get_xmlElementList([#xmlElement{} = XmlElement|L1], L) ->
    get_xmlElementList(L1, [XmlElement|L]);
get_xmlElementList([_|L1], L) ->
    get_xmlElementList(L1, L).


%% 在#xmlElement.attributes 中找
%% return list : "player"  "1"
get_xml_attribute_value(Name, Attributes) ->
    case lists:keyfind(Name, #xmlAttribute.name, Attributes) of
        false ->
            throw({unkown_xml_name, Name, Attributes});
        #xmlAttribute{value = Value} ->
            Value
    end.

%% 将第一个字符转换为大写
first_up("") ->
    "";
first_up([H|L]) ->
    [string:to_upper(H)|L].

%% 如果是,结尾，去掉,
drop_do(L) ->
    case lists:last(L) =:= $, of
        true ->
            lists:sublist(L, length(L) - 1);
        _ ->
            L
    end.

find_loop(ParamName, []) ->
    io:format("no loop ~p~n", [ParamName]),
    throw("no loop ");
find_loop(ParamName, [H|LoopList]) ->
    case get_xml_attribute_value(name, H#xmlElement.attributes) of
        ParamName ->
            H;
        _ ->
            find_loop(ParamName, LoopList)
    end.

writeloop(Accforfunction, LoopType, TableName, LoopList, Count) ->
    Index = "i"++ erlang:integer_to_list(Count),
    Accforfunction1 = Accforfunction ++ "    _ba:writeUShort(#"++ TableName ++ ")\n",
    LoopElement = find_loop(LoopType, LoopList),  %% 找到对应的loop
    F = fun(E, Acc) ->
        IndexName = get_xml_attribute_value(name, E#xmlElement.attributes),
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "uint8" ->
                Acc ++ "        _ba:writeByte("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "uint16" ->
                Acc ++ "        _ba:writeUShort("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "uint32" ->
                Acc ++ "        _ba:writeUInt("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "uint64" ->
                Acc ++ "        _ba:writeLongLong("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "int8" ->
                Acc ++ "        _ba:writeByte("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "int16" ->
                Acc ++ "        _ba:writeShort("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "int32" ->
                Acc ++ "        _ba:writeInt("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "int64" ->
                Acc ++ "        _ba:writeLongLong("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "string" ->
                Acc ++ "        _ba:writeStringUShort("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "bytes" ->
                Acc ++ "        _ba:writeStringUShort("++ TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"])\n";
            "loop" ->
                writeloop(Acc, get_xml_attribute_value(looptype, E#xmlElement.attributes), TableName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"]", LoopList, Count + 1)
        end
    end,
    TableElements = get_xmlElementList(LoopElement#xmlElement.content, []),
    Accforfunction2 = Accforfunction1 ++  "    for i" ++ erlang:integer_to_list(Count) ++ " = 1, #"++ TableName ++ " do\n",
    Accforfunction3 = lists:foldl(F, Accforfunction2, TableElements),
    Accforfunction3 ++ "    end\n".

serializedataloop(Accforparam, LoopType, ParamName, LoopList, Count) ->
    Index = "i"++ erlang:integer_to_list(Count),
    Accforparam1 = Accforparam ++ "    local len_" ++ LoopType ++ " = data:readUShort()\n    self.info." ++ ParamName ++ " = {}\n",
    LoopElement = find_loop(LoopType, LoopList),  %% 找到对应的loop
    F = fun(E, Acc) ->
        IndexName = get_xml_attribute_value(name, E#xmlElement.attributes),
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "uint8" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readByte()\n";
            "uint16" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readUShort()\n";
            "uint32" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readUInt()\n";
            "uint64" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readLongLong()\n";
            "int8" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readByte()\n";
            "int16" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readShort()\n";
            "int32" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readInt()\n";
            "int64" ->
                Acc ++ "        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readLongLong()\n";
            "string" ->
                Acc ++ "        _len = data:readUShort()\n        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readTCharLen(_len)\n";
            "bytes" ->
                Acc ++ "        _len = data:readUShort()\n        self.info."++ ParamName ++ "[" ++ Index ++ "][\"_" ++ IndexName ++ "\"] = data:readTCharLen(_len)\n";
            "loop" ->
                serializedataloop(Acc, get_xml_attribute_value(looptype, E#xmlElement.attributes), ParamName ++ "[i" ++ erlang:integer_to_list(Count) ++ "][\"_" ++ IndexName ++ "\"]", LoopList, Count + 1)
        end
    end,
    Accforparam2 = Accforparam1 ++  "    for " ++ Index ++ " = 1, len_" ++ LoopType ++ " do\n"
    ++ "        self.info." ++ ParamName ++ "[" ++ Index ++ "] = {}\n"
    ,
    TableElements = get_xmlElementList(LoopElement#xmlElement.content, []),
    Accforparam3 = lists:foldl(F, Accforparam2, TableElements),
    Accforparam3 ++ "    end\n".
