%% -*- coding: latin-1 -*-
%%%-------------------------------------------------------------------
%%% @author a
%%% @copyright (C) 2015
%%% @doc
%%% 生成C#
%%% @end
%%% Created : 2016-04-07
%%%-------------------------------------------------------------------
-module('make_proto_for_c3').

-include_lib("xmerl/include/xmerl.hrl").

%% API
-compile(export_all).

start() ->
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

handle(#xmlElement{content = Content}) ->
    ElementList = get_xmlElementList(Content, []),
    make_c2s(ElementList),
    make_s2c(ElementList),
    ok.

%% 生成协议打包类
make_c2s([]) ->
    ok;
make_c2s([H|L]) ->
    make_c2s_one(H),
    make_c2s(L).

make_c2s_one(H) ->
    Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
    ProtoList = get_xmlElementList(H#xmlElement.content,[]),
    F11 = fun(E) ->
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "0" ->  % 客户端给服务器发送  打包函数生成
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
                ProtoId = get_xml_attribute_value(protoid, E#xmlElement.attributes),
                case get_xmlElementList(E#xmlElement.content, []) of
                    [] ->  % 没有参数 直接写了
                        Src =  "using System.Text;\nusing System;\nusing System.Linq;\nusing System.Collections.Generic;\n\n"
                            ++ "public class " ++ ProtoName ++ " {\n"
                            ++ "    public static byte[] pack (){\n"
                            ++ "        byte[] __mod_and_proto = new byte[2];\n"
                            ++ "        __mod_and_proto [0] = " ++ Modid ++ ";\n"
                            ++ "        __mod_and_proto [1] = " ++ ProtoId ++ ";\n"
                            ++ "        byte[] __byteHead = MyCovert.Covert((short)2);\n"
                            ++ "        byte[] __data = new byte[4];\n"
                            ++ "        __byteHead.CopyTo (__data, 0);\n"
                            ++ "        __mod_and_proto.CopyTo (__data, 2);\n"
                            ++ "        return __data;\n"
                            ++ "    }\n"
                            ++ "}\n"
                        ,
                        ok = file:write_file("c4proto\\pack\\" ++ ProtoName ++ ".cs", Src),
                        ok;
                    ParamList ->
                        Src =  "using System.Text;\nusing System;\nusing System.Linq;\nusing System.Collections.Generic;\n\n"
                            ++ "public class " ++ ProtoName ++ " {\n",
                        F_forloop = fun(Eforloop, {Accforloop, AccLoopList}) ->
                            case Eforloop#xmlElement.name of
                                loop ->
                                    ParamName1 = get_xml_attribute_value(name, Eforloop#xmlElement.attributes),
                                    Accforloop1 = Accforloop ++ "    public class _" ++ ParamName1 ++ " {\n",
                                    ParamList1 = get_xmlElementList(Eforloop#xmlElement.content, []),
                                    FFF = fun(EFFF, AccFFF) ->
                                        ParamNameFFF = get_xml_attribute_value(name, EFFF#xmlElement.attributes),
                                        case get_xml_attribute_value(type, EFFF#xmlElement.attributes) of
                                            "uint8" ->
                                                AccFFF ++ "        public byte _" ++ ParamNameFFF ++ ";\n";
                                            "uint16" ->
                                                AccFFF ++ "        public ushort _" ++ ParamNameFFF ++ ";\n";
                                            "uint32" ->
                                                AccFFF ++ "        public uint _" ++ ParamNameFFF ++ ";\n";
                                            "uint64" ->
                                                AccFFF ++ "        public ulong _" ++ ParamNameFFF ++ ";\n";
                                            "int8" ->
                                                AccFFF ++ "        public byte _" ++ ParamNameFFF ++ ";\n";
                                            "int16" ->
                                                AccFFF ++ "        public short _" ++ ParamNameFFF ++ ";\n";
                                            "int32" ->
                                                AccFFF ++ "        public int _" ++ ParamNameFFF ++ ";\n";
                                            "int64" ->
                                                AccFFF ++ "        public long _" ++ ParamNameFFF ++ ";\n";
                                            "string" ->
                                                AccFFF ++ "        public byte[] _" ++ ParamNameFFF ++ ";\n";
                                            "bytes" ->
                                                AccFFF ++ "        public byte[] _" ++ ParamNameFFF ++ ";\n";
                                            "loop" ->
                                                LoopTypeFFF = get_xml_attribute_value(looptype, EFFF#xmlElement.attributes),
                                                AccFFF ++ "        public List<_" ++ LoopTypeFFF ++ "> _" ++ ParamNameFFF ++ ";\n"
                                        end
                                    end,
                                    {lists:foldl(FFF, Accforloop1, ParamList1) ++ "    }\n", [Eforloop | AccLoopList]};
                                value ->
                                    {Accforloop, AccLoopList}
                            end
                        end,
                        {Src1, LoopList} = lists:foldl(F_forloop, {Src, []}, ParamList),% 先把所有loop写成类 并将所有loop弄出来

                        % 写Pack函数参数
                        F_forpack = fun(EF_forpack, AccF_forpack) ->
                            case EF_forpack#xmlElement.name of
                                value ->
                                    ParamNameEF_forpack = get_xml_attribute_value(name, EF_forpack#xmlElement.attributes),
                                    case get_xml_attribute_value(type, EF_forpack#xmlElement.attributes) of
                                        "uint8" ->
                                            AccF_forpack ++ "byte _" ++ ParamNameEF_forpack ++ ",";
                                        "uint16" ->
                                            AccF_forpack ++ "ushort _" ++ ParamNameEF_forpack ++ ",";
                                        "uint32" ->
                                            AccF_forpack ++ "uint _" ++ ParamNameEF_forpack ++ ",";
                                        "uint64" ->
                                            AccF_forpack ++ "ulong _" ++ ParamNameEF_forpack ++ ",";
                                        "int8" ->
                                            AccF_forpack ++ "byte _" ++ ParamNameEF_forpack ++ ",";
                                        "int16" ->
                                            AccF_forpack ++ "short _" ++ ParamNameEF_forpack ++ ",";
                                        "int32" ->
                                            AccF_forpack ++ "int _" ++ ParamNameEF_forpack ++ ",";
                                        "int64" ->
                                            AccF_forpack ++ "long _" ++ ParamNameEF_forpack ++ ",";
                                        "string" ->
                                            AccF_forpack ++ "string _" ++ ParamNameEF_forpack ++ ",";
                                        "bytes" ->
                                            AccF_forpack ++ "byte[] _" ++ ParamNameEF_forpack ++ ",";
                                        "loop" ->
                                            LoopTypeAccF_forpack = get_xml_attribute_value(looptype, EF_forpack#xmlElement.attributes),
                                            AccF_forpack ++ "List<_" ++ LoopTypeAccF_forpack ++ "> _" ++ ParamNameEF_forpack ++ ","
                                    end;
                                _ ->
                                    AccF_forpack
                            end
                        end,
                        Src2 = Src1 ++ "    public static byte[] pack(",
                        Src3 = lists:foldl(F_forpack, Src2, ParamList),
                        Src4 = drop_do(Src3) ++ ") {\n",
                        % 写Pack函数封装体
                        F_forpack1 = fun(EF_forpack1, AccF_forpack1) ->
                            case EF_forpack1#xmlElement.name of
                                value ->
                                    ParamNameEF_forpack = get_xml_attribute_value(name, EF_forpack1#xmlElement.attributes),
                                    case get_xml_attribute_value(type, EF_forpack1#xmlElement.attributes) of
                                        "uint8" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "uint16" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "uint32" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "uint64" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "int8" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "int16" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "int32" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "int64" ->
                                            AccF_forpack1 ++ "        __list.AddRange (MyCovert.Covert(_" ++ ParamNameEF_forpack ++ "));\n";
                                        "string" ->
                                            AccF_forpack1 ++ "        __stringParam = new ASCIIEncoding ().GetBytes (_" ++ ParamNameEF_forpack ++ ");\n"
                                                ++ "        __stringParamLen = MyCovert.Covert ((short)__stringParam.Length);\n"
                                                ++ "        __list.AddRange (__stringParamLen);\n        __list.AddRange (__stringParam);\n";
                                        "bytes" ->
                                            AccF_forpack1 ++ "        __stringParam = _" ++ ParamNameEF_forpack ++ ";\n"
                                                ++ "        __stringParamLen = MyCovert.Covert ((short)__stringParam.Length);\n"
                                                ++ "        __list.AddRange (__stringParamLen);\n        __list.AddRange (__stringParam);\n";
                                        "loop" ->
                                            % 写入长度
                                            AccF_forpack2 = AccF_forpack1 ++ "        __stringParamLen = MyCovert.Covert ((short)_" ++ ParamNameEF_forpack ++ ".Count);\n"
                                                ++ "        __list.AddRange (__stringParamLen);\n"
                                            ,
                                            % 循环写入对应loop的所有参数
                                            LoopTypeAccF_forpack1 = get_xml_attribute_value(looptype, EF_forpack1#xmlElement.attributes),

                                            write_loop(AccF_forpack2, LoopList, LoopTypeAccF_forpack1, ParamNameEF_forpack, 0)
                                    end;
                                _ ->
                                    AccF_forpack1
                            end
                        end,
                        Src5 = Src4 ++ "        List<byte> __list = new List<byte>();\n        byte[] __mod_and_proto = new byte[2];\n"
                            ++ "        __mod_and_proto [0] = " ++ Modid ++ ";\n"
                            ++ "        __mod_and_proto [1] = " ++ ProtoId ++ ";\n"
                            ++ "        __list.AddRange (__mod_and_proto);\n"
                            ++ "        byte[] __stringParam;\n"
                            ++ "        byte[] __stringParamLen;\n"
                        ,
                        Src6 = lists:foldl(F_forpack1, Src5, ParamList),
                        Src7 = Src6 ++ "        byte[] __content = __list.ToArray ();\n"
                            ++ "        byte[] __byteHead = MyCovert.Covert((short)__content.Length);\n"
                            ++ "        byte[] __data = new byte[__byteHead.Length + __content.Length];\n"
                            ++ "        __byteHead.CopyTo (__data, 0);\n"
                            ++ "        __content.CopyTo (__data, __byteHead.Length);\n"
                            ++ "        return __data;\n    }\n}\n",
                        ok = file:write_file("c4proto\\pack\\" ++ ProtoName ++ ".cs", Src7)
                end,
                ok;
            _ ->
                ok
        end
    end,
    lists:foreach(F11, ProtoList).

%% 生成解析类 parse_data
make_s2c(L) ->
    make_parse_data(L),
    ok.

make_parse_data(L) ->
    Src = "using UnityEngine;\nusing System.Collections;\nusing System;\n"
    ++ "public class parse_data {\n    public static void parse(byte[] _data){\n"
    ++ "        int _modId = _data [0];\n"
    ++ "        int _protoId = _data [1];\n"
    ,
    make_parse_data(Src, L, 0).

make_parse_data(Src, [], _) ->
    Src1 = Src ++ "        else{\n            Debug.Log(\"unkown _modId:\" + _modId);\n        }\n    }\n}\n",
    ok = file:write_file("c4proto\\parse_data.cs", Src1);
make_parse_data(Src, [H|L], Flag) ->
    Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
    if
        Flag =:= 0 ->
            Src1 = Src ++ "        if(_modId == " ++ Modid ++ "){\n"
                ++ "            switch(_protoId){\n"
            ;
        true ->
            Src1 = Src ++ "        else if(_modId == " ++ Modid ++ "){\n"
                ++ "            switch(_protoId){\n"
    end,

    ProtoList = get_xmlElementList(H#xmlElement.content,[]),
    F = fun(EF, AF) ->
        case get_xml_attribute_value(type, EF#xmlElement.attributes) of
            "1" ->
                FProtoId = get_xml_attribute_value(protoid, EF#xmlElement.attributes),
                FProtoname = get_xml_attribute_value(protoname, EF#xmlElement.attributes),
                % 生成对应解析类
                make_s2c_class(EF),
                % 生成代码自动调用
                AF ++ "            case " ++ FProtoId ++ ":\n" ++ "                " ++ FProtoname ++ ".parse_data(_data);\n                break;\n";
            _ ->
                AF
        end
    end,
    Src2 = lists:foldl(F, Src1, ProtoList),
    Src3 = Src2 ++ "            default:\n" ++ "                Debug.Log(\"unkown protoid :\" + _protoId);\n                break;\n            }\n        }\n",
    make_parse_data(Src3, L, 1).

make_s2c_class(Proto) ->
    Protoname = get_xml_attribute_value(protoname, Proto#xmlElement.attributes),
    Src = "using UnityEngine;\n"
        ++"using System.Collections;\n"
        ++"using System;\n"
        ++"using System.Collections.Generic;\n"
        ++ "public class " ++ Protoname ++ "{\n"
    ,

    NewSrc = case get_xmlElementList(Proto#xmlElement.content, []) of
                 [] ->
                     % 没有东西 直接输出
                     Src ++ "    public static void parse_data(byte[] __data){\n"
                         ++ "        " ++ Protoname ++ " __object = new " ++ Protoname ++ "();\n"
                         ++ "        handle(__object);\n    }\n"
                         ++ "    public static void handle(" ++ Protoname ++ " __object){\n\n\n" ++ "    }\n";
                 ParamList ->
                     F_forloop = fun(Eforloop, {Accforloop, AccLoopList}) ->
                         case Eforloop#xmlElement.name of
                             loop ->
                                 ParamName1 = get_xml_attribute_value(name, Eforloop#xmlElement.attributes),
                                 Accforloop1 = Accforloop ++ "    public class _" ++ ParamName1 ++ " {\n",
                                 ParamList1 = get_xmlElementList(Eforloop#xmlElement.content, []),
                                 FFF = fun(EFFF, AccFFF) ->
                                     ParamNameFFF = get_xml_attribute_value(name, EFFF#xmlElement.attributes),
                                     case get_xml_attribute_value(type, EFFF#xmlElement.attributes) of
                                         "uint8" ->
                                             AccFFF ++ "        public byte _" ++ ParamNameFFF ++ ";\n";
                                         "uint16" ->
                                             AccFFF ++ "        public ushort _" ++ ParamNameFFF ++ ";\n";
                                         "uint32" ->
                                             AccFFF ++ "        public uint _" ++ ParamNameFFF ++ ";\n";
                                         "uint64" ->
                                             AccFFF ++ "        public ulong _" ++ ParamNameFFF ++ ";\n";
                                         "int8" ->
                                             AccFFF ++ "        public byte _" ++ ParamNameFFF ++ ";\n";
                                         "int16" ->
                                             AccFFF ++ "        public short _" ++ ParamNameFFF ++ ";\n";
                                         "int32" ->
                                             AccFFF ++ "        public int _" ++ ParamNameFFF ++ ";\n";
                                         "int64" ->
                                             AccFFF ++ "        public long _" ++ ParamNameFFF ++ ";\n";
                                         "string" ->
                                             AccFFF ++ "        public string _" ++ ParamNameFFF ++ ";\n";
                                         "bytes" ->
                                             AccFFF ++ "        public byte[] _" ++ ParamNameFFF ++ ";\n";
                                         "loop" ->
                                             LoopTypeFFF = get_xml_attribute_value(looptype, EFFF#xmlElement.attributes),
                                             AccFFF ++ "        public List<_" ++ LoopTypeFFF ++ "> _" ++ ParamNameFFF ++ " = new List<_" ++ LoopTypeFFF ++ ">();\n"
                                     end
                                 end,
                                 {lists:foldl(FFF, Accforloop1, ParamList1) ++ "    }\n", [Eforloop | AccLoopList]};
                             value ->
                                 {Accforloop, AccLoopList}
                         end
                     end,
                     % 先把所有loop写成类 并将所有loop弄出来
                     {Src1, LoopList} = lists:foldl(F_forloop, {Src, []}, ParamList),
                     % 定义成员变量
                     F2 = fun(EF2, AccF2) ->
                        case EF2#xmlElement.name of
                            value ->
                                NameF2 = get_xml_attribute_value(name, EF2#xmlElement.attributes),
                                case get_xml_attribute_value(type, EF2#xmlElement.attributes) of
                                    "uint8" ->
                                        AccF2 ++ "    public byte _" ++ NameF2 ++ ";\n";
                                    "uint16" ->
                                        AccF2 ++ "    public ushort _" ++ NameF2 ++ ";\n";
                                    "uint32" ->
                                        AccF2 ++ "    public uint _" ++ NameF2 ++ ";\n";
                                    "uint64" ->
                                        AccF2 ++ "    public ulong _" ++ NameF2 ++ ";\n";
                                    "int8" ->
                                        AccF2 ++ "    public byte _" ++ NameF2 ++ ";\n";
                                    "int16" ->
                                        AccF2 ++ "    public short _" ++ NameF2 ++ ";\n";
                                    "int32" ->
                                        AccF2 ++ "    public int _" ++ NameF2 ++ ";\n";
                                    "int64" ->
                                        AccF2 ++ "    public long _" ++ NameF2 ++ ";\n";
                                    "string" ->
                                        AccF2 ++ "    public string _" ++ NameF2 ++ ";\n";
                                    "bytes" ->
                                        AccF2 ++ "    public byte[] _" ++ NameF2 ++ ";\n";
                                    "loop" ->
                                        LoopTypeF2 = get_xml_attribute_value(looptype, EF2#xmlElement.attributes),
                                        AccF2 ++ "    public List<_" ++ LoopTypeF2 ++ "> _" ++ NameF2 ++ " = new List<_" ++ LoopTypeF2 ++ ">();\n"
                                end;
                            _ ->
                                AccF2
                        end
                     end,
                     Src2 = lists:foldl(F2, Src1, ParamList),
                     % parse_data函数
                     Src3 = Src2 ++ "    public static void parse_data(byte[] __data){\n"
                         ++ "        " ++ Protoname ++ " __object = new " ++ Protoname ++ "();\n"
                         ++ "        int __pos = 2;\n"
                         ++ "        int __arrayLen = 0;\n"
                         ++ "        byte[] __temp;\n"
                     ,
                     Src4 = write_parse_data(ParamList, Src3, LoopList),
                     % handle函数体
                     Src4 ++ "        handle(__object);\n    }\n"
                     ++ "    public static void handle( " ++ Protoname ++ " __object){\n\n\n" ++ "    }\n"
             end,

    NewSrc1 = NewSrc ++ "}\n",
    ok = file:write_file("c4proto\\parse\\" ++ Protoname ++ ".cs", NewSrc1).

write_parse_data([], Src, _) ->
    Src;
write_parse_data([H|L], Src, LoopList) ->
    case H#xmlElement.name of
        value ->
            ParamName = get_xml_attribute_value(name, H#xmlElement.attributes),
            case get_xml_attribute_value(type, H#xmlElement.attributes) of
                "uint8" ->
                    Src1 = Src ++ "        __object._" ++ ParamName ++ " = __data[__pos];\n"
                    ++ "        __pos += 1;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "uint16" ->
                    Src1 = Src ++ "        __temp = new byte[2];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 2);\n"
                        ++ "        __object._" ++ ParamName ++" = MyCovert.ByteToUShort(__temp);\n"
                        ++ "        __pos += 2;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "uint32" ->
                    Src1 = Src ++ "        __temp = new byte[4];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 4);\n"
                        ++ "        __object._" ++ ParamName ++" = MyCovert.ByteToUInt(__temp);\n"
                        ++ "        __pos += 4;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "uint64" ->
                    Src1 = Src ++ "        __temp = new byte[8];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 8);\n"
                        ++ "        __object._" ++ ParamName ++" = MyCovert.ByteToULong(__temp);\n"
                        ++ "        __pos += 8;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "int8" ->
                    Src1 = Src ++ "        __object._" ++ ParamName ++ " = __data[__pos];\n"
                        ++ "        __pos += 1;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "int16" ->
                    Src1 = Src ++ "        __temp = new byte[2];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 2);\n"
                        ++ "        __object._" ++ ParamName ++" = MyCovert.ByteToShort(__temp);\n"
                        ++ "        __pos += 2;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "int32" ->
                    Src1 = Src ++ "        __temp = new byte[4];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 4);\n"
                        ++ "        __object._" ++ ParamName ++" = MyCovert.ByteToInt(__temp);\n"
                        ++ "        __pos += 4;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "int64" ->
                    Src1 = Src ++ "        __temp = new byte[8];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 8);\n"
                        ++ "        __object._" ++ ParamName ++" = MyCovert.ByteToLong(__temp);\n"
                        ++ "        __pos += 8;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "string" ->
                    Src1 = Src ++ "        __temp = new byte[2];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 2);\n"
                        ++ "        __pos += 2;\n"
                        ++ "        __temp = new byte[MyCovert.ByteToUShort(__temp)];\n        Array.Copy(__data, __pos, __temp, 0, __temp.Length);\n"
                        ++ "        __pos += __temp.Length;\n"
                        ++ "        __object._" ++ ParamName ++" = MyCovert.ByteToString(__temp);\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "bytes" ->
                    Src1 = Src ++ "        __temp = new byte[2];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 2);\n"
                        ++ "        __pos += 2;\n"
                        ++ "        __temp = new byte[MyCovert.ByteToUShort(__temp)];\n        Array.Copy(__data, __pos, __temp, 0, __temp.Length);\n"
                        ++ "        __pos += __temp.Length;\n"
                        ++ "        __object._" ++ ParamName ++" = __temp;\n"
                    ,
                    write_parse_data(L, Src1, LoopList);
                "loop" ->
                    LoopType = get_xml_attribute_value(looptype, H#xmlElement.attributes),
                    Src1 = write_parse_loop(Src, LoopList, LoopType, ParamName, 0),
                    write_parse_data(L, Src1, LoopList)
            end;
        _ ->
            write_parse_data(L, Src, LoopList)
    end.


write_parse_loop(Src, LoopList, LoopType, ParamName, Num) ->
    % 写入长度
    Src1 = Src ++ "        __temp = new byte[2];\n" ++ "        Array.Copy(__data, __pos, __temp, 0, 2);\n"
        ++ "        __pos += 2;\n"
        ++ "        __arrayLen = MyCovert.ByteToUShort(__temp);\n"
        ++ "        for(int i" ++ erlang:integer_to_list(Num) ++ " = 1; i" ++ erlang:integer_to_list(Num) ++ " <= __arrayLen; i" ++ erlang:integer_to_list(Num) ++ "++){\n"
        ++ "            _" ++ LoopType ++ " __temp" ++ erlang:integer_to_list(Num) ++ " = new _" ++ LoopType ++ "();\n"
    ,
    % 循环写入对应loop的所有参数
    LoopElement = find_loop(LoopType, LoopList),
    TableElements = get_xmlElementList(LoopElement#xmlElement.content, []),
    F = fun(E, Acc) ->
        IndexName = get_xml_attribute_value(name, E#xmlElement.attributes),
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "uint8" ->
                Acc ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = __data[__pos];\n"
                    ++ "            __pos += 1;\n";
            "uint16" ->
                Acc ++ "            __temp = new byte[2];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 2);\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = MyCovert.ByteToUShort(__temp);\n"
                    ++ "            __pos += 2;\n";
            "uint32" ->
                Acc ++ "            __temp = new byte[4];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 4);\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = MyCovert.ByteToUInt(__temp);\n"
                    ++ "            __pos += 4;\n";
            "uint64" ->
                Acc ++ "            __temp = new byte[8];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 8);\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = MyCovert.ByteToULong(__temp);\n"
                    ++ "            __pos += 8;\n";
            "int8" ->
                Acc ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = __data[__pos];\n"
                    ++ "            __pos += 1;\n";
            "int16" ->
                Acc ++ "            __temp = new byte[2];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 2);\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = MyCovert.ByteToShort(__temp);\n"
                    ++ "            __pos += 2;\n";
            "int32" ->
                Acc ++ "            __temp = new byte[4];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 4);\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = MyCovert.ByteToInt(__temp);\n"
                    ++ "            __pos += 4;\n";
            "int64" ->
                Acc ++ "            __temp = new byte[8];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 8);\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._"++ IndexName ++ " = MyCovert.ByteToLong(__temp);\n"
                    ++ "            __pos += 8;\n";
            "string" ->
                Acc ++ "            __temp = new byte[2];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 2);\n"
                    ++ "            __pos += 2;\n"
                    ++ "            __temp = new byte[MyCovert.ByteToUShort(__temp)];\n            Array.Copy(__data, __pos, __temp, 0, __temp.Length);\n"
                    ++ "            __pos += __temp.Length;\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._" ++ IndexName ++" = MyCovert.ByteToString(__temp);\n"
              ;
            "bytes" ->
                Acc ++ "            __temp = new byte[2];\n" ++ "            Array.Copy(__data, __pos, __temp, 0, 2);\n"
                    ++ "            __pos += 2;\n"
                    ++ "            __temp = new byte[MyCovert.ByteToUShort(__temp)];\n            Array.Copy(__data, __pos, __temp, 0, __temp.Length);\n"
                    ++ "            __pos += __temp.Length;\n"
                    ++ "            __temp" ++ erlang:integer_to_list(Num) ++ "._" ++ IndexName ++" = __temp;\n"
               ;
            "loop" ->
                % 循环写入对应loop的所有参数
                LoopType1 = get_xml_attribute_value(looptype, E#xmlElement.attributes),
                write_parse_loop(Acc, LoopList, LoopType1, IndexName, Num + 1)
        end
    end,
    Src2 = lists:foldl(F, Src1, TableElements),
    if
        Num =:= 0 ->
            Src2 ++ "            __object._" ++ ParamName ++ ".Add(__temp" ++ erlang:integer_to_list(Num) ++ ");\n        }\n";
        true ->
            Src2 ++ "            __temp" ++ erlang:integer_to_list(Num - 1) ++ "._" ++ ParamName ++ ".Add(__temp" ++ erlang:integer_to_list(Num) ++ ");\n        }\n"
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

write_loop(Src, LoopList, LoopType, ParamName, Count) ->
    if
        Count =:= 0 ->
            Src1 = Src ++ "        foreach(_" ++ LoopType ++ " __temp" ++ erlang:integer_to_list(Count) ++ " in _" ++ ParamName ++ "){\n";
        true ->
            Src1 = Src ++ "        foreach(_" ++ LoopType ++ " __temp" ++ erlang:integer_to_list(Count) ++ " in __temp" ++ erlang:integer_to_list(Count - 1) ++ "._" ++ ParamName ++ "){\n"
    end,
    LoopElement = find_loop(LoopType, LoopList),
    TableElements = get_xmlElementList(LoopElement#xmlElement.content, []),
    F = fun(E, Acc) ->
        IndexName = get_xml_attribute_value(name, E#xmlElement.attributes),
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "uint8" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "uint16" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "uint32" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "uint64" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "int8" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "int16" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "int32" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "int64" ->
                Acc ++ "        __list.AddRange (MyCovert.Covert(__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ "));\n";
            "string" ->
                Acc ++ "        __stringParam = new ASCIIEncoding ().GetBytes (__temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ ");\n"
                    ++ "        __stringParamLen = MyCovert.Covert ((short)__stringParam.Length);\n"
                    ++ "        __list.AddRange (__stringParamLen);\n        __list.AddRange (__stringParam);\n";
            "bytes" ->
                Acc ++ "        __stringParam = __temp" ++ erlang:integer_to_list(Count) ++ "._" ++ IndexName ++ ";\n"
                    ++ "        __stringParamLen = MyCovert.Covert ((short)__stringParam.Length);\n"
                    ++ "        __list.AddRange (__stringParamLen);\n        __list.AddRange (__stringParam);\n";
            "loop" ->
                write_loop(Acc, LoopList, get_xml_attribute_value(looptype, E#xmlElement.attributes), IndexName, Count + 1)
        end
    end,
    Src2 = lists:foldl(F, Src1, TableElements),
    Src2 ++ "        }\n".



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
