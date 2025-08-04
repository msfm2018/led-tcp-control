%% -*- coding: latin-1 -*-
%%%-------------------------------------------------------------------
%%% @author wangpuzhen
%%% @copyright (C) 2015, <COMPANY> wolf beijing
%%% @doc
%%%
%%% @end
%%% Created : 2015-09-22
%%%-------------------------------------------------------------------
-module(make_proto_for_client).
-author("wangpuzhen").

-include_lib("xmerl/include/xmerl.hrl").

%% API
-compile(export_all).

start() ->
    case file:read_file("pp.xml") of
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
    make_msg_def(ElementList),
    make_proto(ElementList),
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 生成注册消息头文件
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

make_msg_def(L) ->

    %% 文件头
    MsgDef_Start =
"/*
 * 文件由make_proto_for_client自动生成
 *
 * 根据协议xml
 *
 * 请勿手动修改
 */
namespace Wolf.Util
{
    public enum MsgDefine
    {",

    %% 文件尾
    MsgDef_End =
"\n    }
}
",

    Src = make_msg_id(L, []),
    %io:format("Src:~p~n", [Src]),
    Dest = MsgDef_Start ++ Src ++ MsgDef_End,
    %% 默认为本地路径与当前SVN路径保持一致
    ok = file:write_file("../../../u3d/UN/Assets/Code/MsgModule/MsgDefine.cs", Dest).

make_msg_id([], Accu) ->
    Accu;
make_msg_id([H|L], Accu) ->
    ModId = get_xml_attribute_value(modid, H#xmlElement.attributes),
    %io:format("ModId:~p~n", [ModId]),
    ProtoList = get_xmlElementList(H#xmlElement.content,[]),

    F = fun(E, Acc) ->
        %io:format("F-> Acc:~p~n", [Acc]),
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "0" ->
                Acc;
            "1" ->
                %% 只需要注册服务器发给客户端的消息ID

                %% 得到协议ID
                ProtoId = get_xml_attribute_value(protoid, E#xmlElement.attributes),
                %% 得到协议名转成大写字母，作为消息宏
                ProtoName = string:to_upper(get_xml_attribute_value(protoname, E#xmlElement.attributes)),

                %% 行头
                LineHead = "\n        ",
                %% 模块ID左移8位与协议ID做按位或运算得到消息ID
                Val = (list_to_integer(ModId) bsl 8) bor list_to_integer(ProtoId),

                Acc ++ LineHead ++ ProtoName ++ " = " ++ integer_to_list(Val) ++ ",";
            Other ->
                io:format("unkown_type~n"),
                throw({unkown_type, Other})
        end
    end,

    %% 对一个模块内的s2c协议处理
    Src = lists:foldl(F, [], ProtoList),
    make_msg_id(L, Accu ++ Src).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 生成协议序列化与反序列化模块
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

make_proto([]) ->
    ok;
make_proto([H|L]) ->
    Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
    ModName = get_xml_attribute_value(modname, H#xmlElement.attributes),
    ErlName = get_xml_attribute_value(erlname, H#xmlElement.attributes),
    ProtoList = get_xmlElementList(H#xmlElement.content,[]),

    HeadSrc =
"/********************************************
 * 文件由make_proto_for_client自动生成
 *
 * "++ ModName ++" 模块协议
 *
 * 请勿手动修改
 ********************************************/

using System;

namespace Wolf.RPC
{
    /////////////////////////////////////////////
    // 客户端发给服务器的数据
    /////////////////////////////////////////////",

    %% 列表中的元素转为s2c类
    FLoop = fun(EL, {AccLM, AccLF}) ->
        TermNameL = get_xml_attribute_value(name, EL#xmlElement.attributes),
        DescL = erlang:binary_to_list(unicode:characters_to_binary(get_xml_attribute_value(desc, EL#xmlElement.attributes))) ++ " ",

        %io:format("#####TermNameL:~p", [TermNameL]),
        {TermNameL_M, TermNameL_F} = case get_xml_attribute_value(type, EL#xmlElement.attributes) of
            "uint8" ->
                {"\n            public Byte " ++ TermNameL ++ "; // " ++ DescL,
                 "\n                " ++ TermNameL++" = (Byte)(byte)VUInt8.Instance.Decode(data, ref nLen);"};
            "uint16" ->
                {"\n            public UInt16 " ++ TermNameL ++ "; // " ++ DescL,
                 "\n                " ++ TermNameL ++ " = (UInt16)(ushort)VUInt16.Instance.Decode(data, ref nLen);"};
            "uint32" ->
                {"\n            public UInt32 " ++ TermNameL ++ "; // " ++ DescL,
                 "\n                " ++ TermNameL ++ " = (UInt32)(uint)VUInt32.Instance.Decode(data, ref nLen);"};
            "uint64" ->
                {"\n            public UInt64 " ++ TermNameL ++ "; // " ++ DescL,
                 "\n                " ++ TermNameL ++ " = (UInt64)(ulong)VUInt64.Instance.Decode(data, ref nLen);"};
            "string" ->
                {"\n            public String " ++ TermNameL ++ "; // " ++ DescL,
                 "\n                " ++ TermNameL ++ " = (String)(string)VString.Instance.Decode(data, ref nLen);"};
            "bytes" ->
                {"\n            public Byte[] " ++ TermNameL ++ "; // " ++ DescL,
                 "\n                " ++ TermNameL ++ " = (Byte[])(byte[])VBytes.Instance.Decode(data, ref nLen);"};
            Other ->
                io:format("unkown_type~n"),
                throw({unkown_type, Other})
        end,
        {AccLM ++ TermNameL_M, AccLF ++ TermNameL_F}
    end,

    %% 列表中的元素转为c2s类
    FLop = fun(EL1, {AccLM1, AccLF1}) ->
        TermNameL1 = get_xml_attribute_value(name, EL1#xmlElement.attributes),
        Desc1 = erlang:binary_to_list(unicode:characters_to_binary(get_xml_attribute_value(desc, EL1#xmlElement.attributes))) ++ " ",

        {TermNameL_M1, TermNameL_F1} = case get_xml_attribute_value(type, EL1#xmlElement.attributes) of
                                           "uint8" ->
                                               {"\n            public Byte " ++ TermNameL1 ++ "; // " ++ Desc1,
                                                "\n                Proto.Instance.Push(VUInt8.Instance.Encode(" ++ TermNameL1 ++ "));"};
                                           "uint16" ->
                                               {"\n            public UInt16 " ++ TermNameL1 ++ "; // " ++ Desc1,
                                                "\n                Proto.Instance.Push(VUInt16.Instance.Encode(" ++ TermNameL1 ++ "));"};
                                           "uint32" ->
                                               {"\n            public UInt32 " ++ TermNameL1 ++ "; // " ++ Desc1,
                                                "\n                Proto.Instance.Push(VUInt32.Instance.Encode(" ++ TermNameL1 ++ "));"};
                                           "uint64" ->
                                               {"\n            public UInt64 " ++ TermNameL1 ++ "; // " ++ Desc1,
                                                "\n                Proto.Instance.Push(VUInt64.Instance.Encode(" ++ TermNameL1 ++ "));"};
                                           "string" ->
                                               {"\n            public String " ++ TermNameL1 ++ "; // " ++ Desc1,
                                                "\n                Proto.Instance.Push(VString.Instance.Encode(" ++ TermNameL1 ++ "));"};
                                           "bytes" ->
                                               {"\n            public Byte[] " ++ TermNameL1 ++ "; // " ++ Desc1,
                                                "\n                Proto.Instance.Push(VBytes.Instance.Encode(" ++ TermNameL1 ++ "));"};
                                         Other ->
                                             io:format("unkown_type~n"),
                                             throw({unkown_type, Other})
                                     end,
        {AccLM1 ++ TermNameL_M1, AccLF1 ++ TermNameL_F1}
    end,

    %% 先生成type为0的客户端发给服务器的类
    F0 = fun(E, Acc) ->
        ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
        ProtoId = get_xml_attribute_value(protoid, E#xmlElement.attributes),

        M_module = "\n        private UInt16 module = " ++ Modid ++ ";",
        M_proto = "\n        private UInt16 proto = " ++ ProtoId ++ ";",

        ClassH = "\n\n    public class " ++ ProtoName ++ "\n    {" ++ M_module ++ M_proto,
        ClassT = "\n    }",

        %% 发给服务器的和服务器返回的消息分开处理
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "1" ->
                %% 处理type为1服务器发给客户端的消息

                Funs_H2 = "\n\n        public bool deserialize(byte[] data)\n        {\n            Int32 nLen = 2;",
                Funs_T2 = "\n            return true;\n        }",

                case get_xmlElementList(E#xmlElement.content, []) of
                    [] ->
                        Acc ++ ClassH ++ Funs_H2 ++ Funs_T2 ++ ClassT;
                    SubList2 ->
                        F2 = fun(E2, {AccM2, AccF2}) ->
                            TermName2 = get_xml_attribute_value(name, E2#xmlElement.attributes),
                            {TermName2_M, TermName2_F} = case E2#xmlElement.name of
                                loop -> %% 列表
                                    case get_xmlElementList(E2#xmlElement.content, []) of
                                        [] ->
                                            {[], []};
                                        LoopCon ->
                                            LoopH = "\n        public class " ++ TermName2 ++ "\n        {",
                                            LoopFH = "\n\n            public void deserialize(byte[] data, ref int nLen)"
                                            ++ "\n            {",
                                            %io:format("@@@@@ LoopCon:~p", [LoopCon]),
                                            {LoopH_Acc, LoopFH_Acc} = lists:foldl(FLoop, {LoopH, LoopFH}, LoopCon),
                                            {"\n" ++ LoopH_Acc ++ LoopFH_Acc ++ "\n            }\n        }\n", []}
                                    end;
                                value -> %% 基本数据结构
                                    Desc2 = erlang:binary_to_list(unicode:characters_to_binary(get_xml_attribute_value(desc, E2#xmlElement.attributes))) ++ " ",
                                    case get_xml_attribute_value(type, E2#xmlElement.attributes) of
                                        "uint8" ->
                                            {"\n        public Byte " ++ TermName2 ++ "; // " ++ Desc2,
                                             "\n            "++TermName2++" = (Byte)(byte)VUInt8.Instance.Decode(data, ref nLen);"};
                                        "uint16" ->
                                            {"\n        public UInt16 " ++ TermName2 ++ "; // " ++ Desc2,
                                             "\n            "++TermName2++" = (UInt16)(ushort)VUInt16.Instance.Decode(data, ref nLen);"};
                                        "uint32" ->
                                            {"\n        public UInt32 " ++ TermName2 ++ "; // " ++ Desc2,
                                             "\n            "++TermName2++" = (UInt32)(uint)VUInt32.Instance.Decode(data, ref nLen);"};
                                        "uint64" ->
                                            {"\n        public UInt64 " ++ TermName2 ++ "; // " ++ Desc2,
                                             "\n            "++TermName2++" = (UInt64)(ulong)VUInt64.Instance.Decode(data, ref nLen);"};
                                        "string" ->
                                            {"\n        public String " ++ TermName2 ++ "; // " ++ Desc2,
                                             "\n            "++TermName2++" = (String)(string)VString.Instance.Decode(data, ref nLen);"};
                                        "bytes" ->
                                            {"\n        public Byte[] " ++ TermName2 ++ "; // " ++ Desc2,
                                             "\n            "++TermName2++" = (Byte[])(byte[])VBytes.Instance.Decode(data, ref nLen);"};
                                        "loop" ->
                                            LoopType = get_xml_attribute_value(looptype, E2#xmlElement.attributes),

                                            %% 反序列化类数组
                                            LoopDeseri = "\n\n            {"
                                            ++ "\n                UInt16 len = (UInt16)(ushort)VUInt16.Instance.Decode(data, ref nLen);"
                                            ++ "\n                if (len > 0)\n                {"
                                            ++ "\n                    " ++ TermName2 ++ " = new " ++ LoopType ++ "[len];\n"
                                            ++ "\n                    for (UInt16 i = 0; i < len; i++)\n                    {"
                                            ++ "\n                        " ++ TermName2 ++ "[i] = new " ++ LoopType ++ "();"
                                            ++ "\n                        " ++ TermName2 ++ "[i].deserialize(data, ref nLen);"
                                            ++ "\n                    }\n                }\n            }\n",

                                            {"\n        public " ++ LoopType ++ "[] " ++ TermName2 ++ ";", LoopDeseri};
                                        Other ->
                                            io:format("unkown_type~n"),
                                            throw({unkown_type, Other})
                                    end
                            end,
                            {AccM2 ++ TermName2_M, AccF2 ++ TermName2_F}
                        end,
                        {AccM_2, AccF_2} = lists:foldl(F2, {[], []}, SubList2),

                        Acc ++ ClassH ++ AccM_2 ++ Funs_H2 ++ AccF_2 ++ Funs_T2 ++ ClassT
                end;
            "0" ->

                %% 处理type为0客户端发给服务器的消息

                Seri_module = "\n            Proto.Instance.Push(VUInt8.Instance.Encode(module));",
                Seri_proto = "\n            Proto.Instance.Push(VUInt8.Instance.Encode(proto));\n",

                Funs_H1 = "\n\n        public byte[] serialize()\n        {\n            Proto.Instance.Reset();",
                Funs_T1 = "\n            return Proto.Instance.Result();\n        }",

                case get_xmlElementList(E#xmlElement.content, []) of
                    [] ->
                        Acc ++ ClassH ++ Funs_H1 ++ Seri_module ++ Seri_proto ++ Funs_T1 ++ ClassT;
                    SubList ->
                        F1 = fun(E1, {AccM1, AccF1}) ->
                            TermName1 = get_xml_attribute_value(name, E1#xmlElement.attributes),
                            {TermName1_M, TermName1_F} = case E1#xmlElement.name of
                                loop -> %% 列表
                                    case get_xmlElementList(E1#xmlElement.content, []) of
                                        [] ->
                                            {[], []};
                                        LopCon ->
                                            LopH = "\n        public class " ++ TermName1 ++ "\n        {",
                                            LopFH = "\n\n            public void serialize()\n            {",
                                            {LopH_Acc, LopFH_Acc} = lists:foldl(FLop, {LopH, LopFH}, LopCon),
                                            {"\n" ++ LopH_Acc ++ LopFH_Acc ++ "\n            }\n        }\n", []}
                                    end;
                                value -> %% 基本数据结构
                                    Descr = erlang:binary_to_list(unicode:characters_to_binary(get_xml_attribute_value(desc, E1#xmlElement.attributes)))++" ",
                                    case get_xml_attribute_value(type, E1#xmlElement.attributes) of
                                        "uint8" ->
                                            {"\n        public Byte " ++ TermName1 ++ "; // " ++ Descr,
                                             "\n            Proto.Instance.Push(VUInt8.Instance.Encode(" ++ TermName1 ++ "));"};
                                        "uint16" ->
                                            {"\n        public UInt16 " ++ TermName1 ++ "; // " ++ Descr,
                                             "\n            Proto.Instance.Push(VUInt16.Instance.Encode(" ++ TermName1 ++ "));"};
                                        "uint32" ->
                                            {"\n        public UInt32 " ++ TermName1 ++ "; // " ++ Descr,
                                             "\n            Proto.Instance.Push(VUInt32.Instance.Encode(" ++ TermName1 ++ "));"};
                                        "uint64" ->
                                            {"\n        public UInt64 " ++ TermName1 ++ "; // " ++ Descr,
                                             "\n            Proto.Instance.Push(VUInt64.Instance.Encode(" ++ TermName1 ++ "));"};
                                        "string" ->
                                            {"\n        public String " ++ TermName1 ++ "; // " ++ Descr,
                                             "\n            Proto.Instance.Push(VString.Instance.Encode(" ++ TermName1 ++ "));"};
                                        "bytes" ->
                                            {"\n        public Byte[] " ++ TermName1 ++ "; // " ++ Descr,
                                             "\n            Proto.Instance.Push(VBytes.Instance.Encode(" ++ TermName1 ++ "));"};
                                        "loop" ->
                                            LopType = get_xml_attribute_value(looptype, E1#xmlElement.attributes) ++ "[] ",

                                            %% 序列化数组
                                            LopSer = "\n\n            Proto.Instance.Push(VUInt16.Instance.Encode("++TermName1++".Length));"
                                            ++ "\n            for (int i = 0; i < " ++ TermName1 ++ ".Length; i++)\n            {"
                                            ++ "\n                " ++ TermName1 ++ "[i].serialize();\n            }",

                                            {"\n        public " ++ LopType ++ "[] " ++ TermName1 ++ ";", LopSer};
                                        Other ->
                                            io:format("unkown_type~n"),
                                            throw({unkown_type, Other})
                                    end
                            end,
                            {AccM1 ++ TermName1_M, AccF1 ++ TermName1_F}
                        end,
                        {AccM_1, AccF_1} = lists:foldl(F1, {[], []}, SubList),

                        Acc ++ ClassH ++ AccM_1 ++ Funs_H1 ++ Seri_module ++ Seri_proto ++ AccF_1 ++ Funs_T1 ++ ClassT
                end;
            Other ->
                io:format("unkown_type~n"),
                throw({unkown_type, Other})
        end
    end,

    Src = lists:foldl(F0, HeadSrc, ProtoList),
    ok = file:write_file("../../../u3d/UN/Assets/Code/MsgModule/proto/" ++ ErlName ++ ".cs", Src ++ "\n}"),
    make_proto(L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 功能函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
