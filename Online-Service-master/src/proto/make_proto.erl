%% -*- coding: latin-1 -*-
%%%-------------------------------------------------------------------
%%% @author wulei
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2014 下午7:34
%%%-------------------------------------------------------------------
-module(make_proto).
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



%% XML Element
%% content = [#xmlElement()|#xmlText()|#xmlPI()|#xmlComment()|#xmlDecl()]
%% -record(xmlElement,{
%%     name,			% atom()
%%     expanded_name = [],	% string() | {URI,Local} | {"xmlns",Local}
%%     nsinfo = [],	        % {Prefix, Local} | []
%%     namespace=#xmlNamespace{},
%%     parents = [],		% [{atom(),integer()}]
%%     pos,			% integer()
%%     attributes = [],	% [#xmlAttribute()]
%%     content = [],
%%     language = "",	% string()
%%     xmlbase="",           % string() XML Base path, for relative URI:s
%%     elementdef=undeclared % atom(), one of [undeclared | prolog | external | element]
%% }).

%% Attribute
%% -record(xmlAttribute,{
%%     name,		   % atom()
%%     expanded_name=[],% atom() | {string(),atom()}
%%     nsinfo = [],	   % {Prefix, Local} | []
%%     namespace = [],  % inherits the element's namespace
%%     parents = [],	   % [{atom(),integer()}]
%%     pos,		   % integer()
%%     language = [],   % inherits the element's language
%%     value,	   % IOlist() | atom() | integer()
%%     normalized       % atom() one of (true | false)
%% }).

%% <module mod_name="mod_player" modid="1">
%%  <proto protoid="1" protoname="mod_player_login" type="0">
%%      <loop name="list">
%%          <value type="uint32" name="id" desc="角色id"/>
%%          <value type="uint32" name="time" desc="角色激活时间戳"/>
%%      </loop>
%%      <value type="uint32" name="id" desc="玩家id"/>
%%      <value type="uint32" name="time" desc="时间戳"/>
%%      <value type="loop" name="list" desc="激活的角色列表"/>
%%  </proto>
%% </module>

%% 解析module节点
%% 要生成两个根据协议解析 构造数据的脚本文件 ProtoFileName.h 定义数据结构 ProtoFileName.erl 定义数据解析以及构造脚本
%% 网关根据id知道调用哪个脚本来解析数据的文件， 最后
%% proto.erl脚本处理网关协议  根据客户端2byte的协议好解析成{modid,protoid}
%% 根据modid可以获得协议处理脚本proto_xxx.erl以及对应的逻辑处理脚本mod_xxx.erl
%% proto_xxx.erl中会根据具体的协议id来处理，最终cast {client_request, ModName, Data} 给player
%% Xml#xmlElement.attributes 是一个#xmlAttribute的列表 可以取得对应的每一个属性
%% 例如上面我们能 lists:keyfind(mod_name, #xmlAttribute.name, Xml#xmlElement.attributes) 找到对应的属性，然后 .value取出那个值
%% Xml#xmlElement.content 包含了所有子节点信息，循环处理  ，生成协议时 loop的先存储起来，在处理后面的value的时候会用到
%% Content是一个[#xmlText{}, #xmlElement{},...]这样的列表，提出所有的#xmlElement
-define(L2A(A), list_to_atom(A)).
-define(L2I(A), list_to_integer(A)).
-define(P(F,A),io:format(F,A)).

handle_error_xml(#xmlElement{content = Content}) ->
    ElementList = get_xmlElementList(Content, []),
    HeadSrc =
        "%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 根据error.xml生成
%%%
%%% 请勿手动修改
%%%---------------------------------------------

",
    make_error_hrl(HeadSrc, ElementList),
    ok.

make_error_hrl(Src, []) ->
    ok = file:write_file("error.hrl", Src),
    ok;
make_error_hrl(Src, [H|L]) ->
    Id = get_xml_attribute_value(id, H#xmlElement.attributes),
    Desc = erlang:binary_to_list(unicode:characters_to_binary(get_xml_attribute_value(desc, H#xmlElement.attributes))), % 文件中读的需要处理
    NewSrc = Src ++ "%% " ++ Desc ++ "\n-define(ERROR_" ++ Id ++ ", "++ Id ++ ").\n",
    make_error_hrl(NewSrc, L).


handle(#xmlElement{content = Content}) ->
    ElementList = get_xmlElementList(Content, []),
    make_proto_erl(ElementList),
    make_hrl(ElementList),
    make_erl(ElementList),
    ok.

make_proto_erl(L) ->
    Proto_Head =
"%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 根据协议ｘｍｌ自动生成
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(proto).
-compile(export_all).

",
    % 获取所有涉及到的proto_xxx
    HrlList = [get_xml_attribute_value(erlname, One#xmlElement.attributes) || One <- L ],
    Src = lists:foldl(
        fun(One, Acc) ->
            Acc ++ "-include( \"" ++ One ++ ".hrl\").\n"
        end,
        Proto_Head,
        HrlList
    ),
    Src1 = make_hand(L, Src ++ "\n\n"),
    Src2 = make_pack(L, Src1),
    ok = file:write_file("proto.erl", Src2).

make_erl([]) ->
    ok;
make_erl([H|L]) ->
    _Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
    ModName = get_xml_attribute_value(modname, H#xmlElement.attributes),
    ErlName = get_xml_attribute_value(erlname, H#xmlElement.attributes),
    ProtoList = get_xmlElementList(H#xmlElement.content,[]),
    HeadSrc =
"%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块"++ ModName ++"的协议定义
%%%
%%% 请勿手动修改
%%%---------------------------------------------
-module(" ++ ErlName ++").
-compile(export_all).

%%% ------------------
%%% 协议解析
%%% ------------------
",
    % 先导出type为0的解析客户端数据的函数
    F0 = fun(E, Acc) ->
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "1" ->
                Acc;
            "0" ->
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
                case get_xmlElementList(E#xmlElement.content, []) of
                    [] ->
                        Acc ++ ProtoName ++ "(<<>>) -> \n    "
                            ++ "{ok, {"++ ProtoName ++ "}}.\n";
                    SubList ->
                        % 拿出所有loop 并生成对应loop解析函数
                        Fun1 = fun(EFun1, AccFun1) ->
                            case EFun1#xmlElement.name of
                                loop ->
                                    [EFun1|AccFun1];
                                _ ->
                                    AccFun1
                            end
                        end,
                        LoopList = lists:foldl(Fun1, [], SubList),
                        % 生成loop解析函数
                        Src0_0 = create_parse_loop_fun("", LoopList),
                        if
                            Src0_0 == "" ->
                                Src0_1 = "\n" ++ ProtoName ++ "(<<",
                                F1 = fun(E1, {Acc1, TypeL}) ->
                                    if
                                        E1#xmlElement.name == loop ->
                                            {Acc1, TypeL};
                                        true ->
                                            TermName1 = first_up(get_xml_attribute_value(name, E1#xmlElement.attributes)),
                                            case get_xml_attribute_value(type, E1#xmlElement.attributes) of
                                                "uint8" ->
                                                    % TermName 第一个转为大写，做变量
                                                    {Acc1 ++ TermName1 ++":8,", [TermName1|TypeL]};
                                                "uint16" ->
                                                    {Acc1 ++ TermName1 ++":16,", [TermName1|TypeL]};
                                                "uint32" ->
                                                    {Acc1 ++ TermName1 ++":32,", [TermName1|TypeL]};
                                                "uint64" ->
                                                    {Acc1 ++ TermName1 ++":64,", [TermName1|TypeL]};
                                                "int8" ->
                                                    % TermName 第一个转为大写，做变量
                                                    {Acc1 ++ TermName1 ++":8/signed,", [TermName1|TypeL]};
                                                "int16" ->
                                                    {Acc1 ++ TermName1 ++":16/signed,", [TermName1|TypeL]};
                                                "int32" ->
                                                    {Acc1 ++ TermName1 ++":32/signed,", [TermName1|TypeL]};
                                                "int64" ->
                                                    {Acc1 ++ TermName1 ++":64/signed,", [TermName1|TypeL]};
                                                "string" ->
                                                    {Acc1 ++ TermName1 ++"Len:16," ++ TermName1 ++ ":" ++ TermName1 ++ "Len"
                                                        ++ "/binary,", [TermName1|TypeL]};
                                                "bytes" ->
                                                    {Acc1 ++ TermName1 ++"Len:16," ++ TermName1 ++ ":" ++ TermName1 ++ "Len"
                                                        ++ "/binary,", [TermName1|TypeL]};
                                                Other ->
                                                    io:format("unkown_typeunkown_type~n"),
                                                    throw({unkown_type, Other})
                                            end
                                    end
                                end,
                                {Src0_2, TypeL1} = lists:foldl(F1, {Src0_1, []}, SubList),
                                Src0_3 = drop_do(Src0_2) ++ ">>) ->\n    "
                                    ++ "{ok, {" ++ ProtoName ++ "," ,
                                TL = lists:reverse(TypeL1),
                                F2 = fun(E2, Acc2) ->
                                    Acc2 ++ E2 ++ ","
                                end,
                                Src0_4 = lists:foldl(F2, Src0_3, TL),
                                Src0_5 = drop_do(Src0_4) ++ "}}.\n",
                                Acc ++ Src0_5;
                            true ->
                                Src0_1 = Src0_0 ++ ProtoName ++ "(__B) ->\n",
                                F1 = fun(E1, {Acc1, Acc2, Acc3}) ->
                                    if
                                        E1#xmlElement.name == loop ->
                                            {Acc1, Acc2, Acc3};
                                        true ->
                                            TermName1 = first_up(get_xml_attribute_value(name, E1#xmlElement.attributes)),
                                            case get_xml_attribute_value(type, E1#xmlElement.attributes) of
                                                "uint8" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":8, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "uint16" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":16, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "uint32" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":32, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "uint64" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":64, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "int8" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":8/signed, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "int16" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":16/signed, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "int32" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":32/signed, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "int64" ->
                                                    {Acc1 ++ "    <<" ++ TermName1 ++ ":64/signed, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc2 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "string" ->
                                                    {Acc1 ++ "    <<__" ++ TermName1 ++ "Len:16, " ++ TermName1 ++ ":__" ++ TermName1 ++ "Len/binary, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "bytes" ->
                                                    {Acc1 ++ "    <<__" ++ TermName1 ++ "Len:16, " ++ TermName1 ++ ":__" ++ TermName1 ++ "Len/binary, __" ++ TermName1 ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                "loop" ->
                                                    LoopTypeF1 = get_xml_attribute_value(looptype, E1#xmlElement.attributes),
                                                    {Acc1 ++ "    {" ++ TermName1 ++", __" ++ TermName1 ++ "Binary} = " ++ LoopTypeF1 ++ "(" ++ Acc2 ++ "),\n", "__" ++ TermName1 ++ "Binary", Acc3 ++ TermName1 ++ ","};
                                                Other ->
                                                    io:format("unkown_typeunkown_type~n"),
                                                    throw({unkown_type, Other,TermName1})
                                            end
                                    end
                                end,
                                {Src0_2, _, ParamList} = lists:foldl(F1, {Src0_1, "__B", ""}, SubList),
                                Src0_3 = Src0_2 ++ "    {ok, {" ++ ProtoName ++ "," ++ drop_do(ParamList) ++ "}}.\n",
                                Acc ++ Src0_3
                        end
                end;
            Other ->
                io:format("unkown_type~n"),
                throw({unkown_type, Other})
        end
    end,
    Src1 = lists:foldl(F0, HeadSrc, ProtoList),
    Src2 = Src1 ++
"
%%% ------------------
%%% 服务器协议打包
%%% ------------------
",
    % 导出type为"1"的 返回给客户端的协议pack函数
    % 我们需要传入proto:pack(M,F,Tuple) 这个tuple就是一个F的记录
    % 这个记录中可能会存在loop  即列表形式，那么当有元素是loop  我们就构造一个 protoname_loopname 的函数处理
%%  <proto protoid="1" protoname="send_goods" type="1">
%%     <loop name="artifactattribute">
%%          <value type="uint8" name="attributetype" desc="属性类型"/>
%%          <value type="uint32" name="lv" desc="神器等级"/>
%%          <value type="uint32" name="exp" desc="神器当前经验"/>
%%     </loop>
%%     <loop name="stone">
%%          <value type="uint8" name="stonetype" desc="宝石类型"/>
%%          <value type="uint8" name="lv" desc="宝石等级"/>
%%     </loop>
%%     <loop name="goodslist">
%%          <value type="uint64" name="goodsid" desc="物品唯一id"/>
%%          <value type="uint32" name="goodstypeid" desc="物品模板id"/>
%%          <value type="uint32" name="num" desc="物品数量"/>
%%          <value type="unit8" name="strenlv" desc="强化等级"/>
%%          <value type="uint8" name="canstone" desc="物品孔数"/>
%%          <value type="loop" name="artifactattribute" desc="神器属性"/>
%%          <value type="loop" name="stone" desc="宝石镶嵌"/>
%%     </loop>
%%     <value type="loop" name="goodslist" desc="物品列表"/>
%%  </proto>
    % 导出形式为
    %
    % send_goods({goodslist, Goodslist}) ->
    %     {ok,[send_goods_goodslist(Goodslist)]}.
    % send_goods_goodslist(L) ->
    %     NL = [[<<Goodsid:64>>,Goodstypeid:32,Num:32,Strenlv:8,Canstone:8>>,send_goods_artifactattribute(Artifactattribute),send_goods_stone(Stone)]
    %     || {goodslist,Goodsid,Goodstypeid,Num,Strenlv,Canstone,Artifactattribute,Stone} <- L],
    %     Len = length(L),
    %     [<<Len:16>>|NL].
    % send_goods_artifactattribute(L) ->
    %     NL = [[<<Attributetype:8>>,<<Lv:32>>,<<Exp:32>>]
    %     || {artifactattribute,Attributetype,Lv,Exp} <- L],
    %     Len = length(L),
    %     [<<Len:16>>|NL].
    % send_goods_stone(L) ->
    %     NL = [[<<Stonetype:8>>,<<Lv:8>>]
    %     || {stone,Stonetype,Lv} <- L],
    %     Len = length(L),
    %     [<<Len:16>>|NL].
    %
    F3 = fun(E3, Acc3) ->
        case get_xml_attribute_value(type, E3#xmlElement.attributes) of
            "0" ->
                Acc3;
            "1" ->
                ProtoName = get_xml_attribute_value(protoname, E3#xmlElement.attributes),
                case get_xmlElementList(E3#xmlElement.content, []) of
                    [] ->
                        Acc3 ++ ProtoName ++ "({" ++ ProtoName ++ "}) -> \n    "
                            ++ "{ok, [<<>>]}.\n\n";
                    SubList ->
                        % uint8 uint16 uint32 uint64 string
                        % 先导出该协议中的loop的元素
                        F4 = fun(E4, Acc4) ->
                            case E4#xmlElement.name of
                                loop ->
                                    LoopName4 = get_xml_attribute_value(name, E4#xmlElement.attributes),
                                    LoopFunName4 = ProtoName ++ "_" ++ LoopName4,
                                    Src4_1 = Acc4 ++ LoopFunName4 ++"(L) ->\n    ",
                                    % 导出此loop节点中所有
                                    case get_xmlElementList(E4#xmlElement.content, []) of
                                        [] ->
                                            throw({cannot_nil_loop,LoopName4});
                                        L4_1 ->
                                            Src4_2 = Src4_1 ++ "NL = [[",
                                            F5 = fun(E5, {Acc5, Name5L}) ->
                                                Name5_1 = get_xml_attribute_value(name, E5#xmlElement.attributes),
                                                Name5 = first_up(Name5_1),

                                                case get_xml_attribute_value(type, E5#xmlElement.attributes) of
                                                    "uint8" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":8>>,", [Name5|Name5L]};
                                                    "uint16" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":16>>,", [Name5|Name5L]};
                                                    "uint32" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":32>>,", [Name5|Name5L]};
                                                    "uint64" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":64>>,", [Name5|Name5L]};
                                                    "int8" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":8/signed>>,", [Name5|Name5L]};
                                                    "int16" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":16/signed>>,", [Name5|Name5L]};
                                                    "int32" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":32/signed>>,", [Name5|Name5L]};
                                                    "int64" ->
                                                        {Acc5 ++ "<<" ++ Name5 ++ ":64/signed>>,", [Name5|Name5L]};
                                                    "string" ->
                                                        {Acc5 ++ "pt:packstring(" ++ Name5 ++ "),", [Name5|Name5L]};
                                                    "bytes" ->
                                                        {Acc5 ++ "pt:packstring(" ++ Name5 ++ "),", [Name5|Name5L]};
                                                    "loop" ->
                                                        LoopType5 = get_xml_attribute_value(looptype, E5#xmlElement.attributes),
                                                        LoopFunName5 = ProtoName ++ "_" ++ LoopType5,
                                                        {Acc5 ++ LoopFunName5 ++ "(" ++ Name5 ++ "),", [Name5|Name5L]};
                                                    Other ->
                                                        throw({unkown_type,Other})
                                                end
                                            end,
                                            {Src4_3, Name5L1} = lists:foldl(F5, {Src4_2, []}, L4_1),
                                            Name5L2 = lists:reverse(Name5L1),
                                            Src4_4 = drop_do(Src4_3) ++ "]\n    ",
                                            Src4_5 = Src4_4 ++ "|| {" ++ LoopName4 ++ ",",
                                            F6 = fun(E6, Acc6) ->
                                                Acc6 ++ E6 ++ ","
                                            end,
                                            Src4_6 = lists:foldl(F6, Src4_5, Name5L2),
                                            Src4_7 = drop_do(Src4_6) ++ "} <- L],\n    ",
                                            Src4_8 = Src4_7 ++ "Len = length(L),\n    ",
                                            Src4_8 ++ "[<<Len:16>>|NL].\n"
                                    end;
                                _ ->
                                    Acc4
                            end
                        end,
                        Src3_1 = lists:foldl(F4, Acc3, SubList),
                        Src3_2 = Src3_1 ++ ProtoName ++ "({" ++ ProtoName ++ ",",
                        % 将非loop的作为参数写入
                        F6 = fun(E6,Acc6) ->
                            Name6_1 = get_xml_attribute_value(name,E6#xmlElement.attributes),
                            Name6 = first_up(Name6_1),
                            case E6#xmlElement.name of
                                value ->
                                    Acc6 ++ Name6 ++ ",";
                                _ ->
                                    Acc6
                            end
                        end,
                        Src3_3 = lists:foldl(F6, Src3_2, SubList),
                        Src3_4 = drop_do(Src3_3) ++ "}) ->\n    ",
                        Src3_5 = Src3_4 ++ "{ok, [",
                        % 将对应的value按顺序以及相应格式写入
                        F7 = fun(E7, Acc7) ->
                            case E7#xmlElement.name of
                                value ->
                                    Type7 = get_xml_attribute_value(type, E7#xmlElement.attributes),
                                    Name7_1 = get_xml_attribute_value(name,E7#xmlElement.attributes),
                                    Name7 = first_up(Name7_1),
                                    case Type7 of
                                        "uint8" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":8>>,";
                                        "uint16" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":16>>,";
                                        "uint32" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":32>>,";
                                        "uint64" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":64>>,";
                                        "int8" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":8/signed>>,";
                                        "int16" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":16/signed>>,";
                                        "int32" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":32/signed>>,";
                                        "int64" ->
                                            Acc7 ++ "<<" ++ Name7 ++ ":64/signed>>,";
                                        "string" ->
                                            Acc7 ++ "pt:packstring(" ++ Name7 ++ "),";
                                        "bytes" ->
                                            Acc7 ++ "pt:packstring(" ++ Name7 ++ "),";
                                        "loop" ->
                                            LoopType7 = get_xml_attribute_value(looptype, E7#xmlElement.attributes),
                                            Acc7 ++ ProtoName ++ "_" ++ LoopType7 ++ "(" ++ Name7 ++ "),";
                                        Other7 ->
                                            throw({unkown_type,Other7})
                                    end;
                                _ ->
                                    Acc7
                            end
                        end,
                        Src3_6 = lists:foldl(F7, Src3_5, SubList),
                        drop_do(Src3_6) ++ "]}.\n\n\n"
                end;
            Other ->
                io:format("unkown_type~n"),
                throw({unkown_type, Other})
        end
    end,
    Src3 = lists:foldl(F3, Src2, ProtoList),
    ok = file:write_file(ErlName ++ ".erl", Src3),
    make_erl(L).

make_hrl([]) ->
    ok;
make_hrl([H|L]) ->
%%     Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
%%     ModName = get_xml_attribute_value(modname, H#xmlElement.attributes),
    ErlName = get_xml_attribute_value(erlname, H#xmlElement.attributes),
    ProtoList = get_xmlElementList(H#xmlElement.content,[]),
    HeadSrc =
"%%%---------------------------------------------
%%% 文件自动生成
%%%
%%% 模块"++ ErlName ++"的相关记录
%%%
%%% 请勿手动修改
%%%---------------------------------------------

",
    F = fun(E, Acc) ->
        RecordName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
        case get_xmlElementList(E#xmlElement.content,[]) of
            [] ->
                Acc ++ "-record(" ++ RecordName ++", {}).\n\n";
            Sub_List ->
                F1 = fun(E1, Acc1) ->
                    % 这个record将name不是loop的作为记录的元素
                    case E1#xmlElement.name of
                        loop ->
                            Acc1;
                        value ->
                            TermName = get_xml_attribute_value(name, E1#xmlElement.attributes),
                            Acc1 ++ TermName ++ ",";
                        Other ->
                            throw({unkown_proto_tpye,Other})
                    end
                end,
                Src_1 = "-record(" ++ RecordName ++", {",
                Src_2 = lists:foldl(F1, Src_1, Sub_List),
                Src_3 = drop_do(Src_2),
                Src_4 = Src_3 ++ "}).\n",
                % 将这个节点里的loop也申明为记录，就放在该记录的下方
                F2 = fun(E2, Acc2) ->
                    case E2#xmlElement.name of
                        value ->
                            Acc2;
                        loop ->
                            TermName = get_xml_attribute_value(name, E2#xmlElement.attributes),
                            case get_xmlElementList(E2#xmlElement.content, []) of
                                [] ->
                                    Src_5 = "-record(" ++ TermName ++", {}).\n\n";
                                LoopList ->
                                    F3 = fun(E3, Acc3) ->
                                        LoopTermName = get_xml_attribute_value(name, E3#xmlElement.attributes),
                                        Acc3 ++ LoopTermName ++ ","
                                    end,
                                    Src_5 = lists:foldl(F3, "-record(" ++ TermName ++", {", LoopList)
                            end,
                            Src_6 = drop_do(Src_5),
                            Src_7 = Src_6 ++ "}).\n",
                            Acc2 ++ Src_7;
                        Other ->
                            throw({unkown_proto_tpye,Other})
                    end
                end,
                Acc ++ lists:foldl(F2, Src_4, Sub_List) ++ "\n"
        end
    end,
    H_SRC = lists:foldl(F, HeadSrc, ProtoList),
    ok = file:write_file(ErlName ++ ".hrl", H_SRC),
    make_hrl(L).

make_hand([], SrcL) ->
    SrcL ++ "handle(<<ModId:8, ProtoId:8, _Binary/binary>>) ->\n    "
        ++ "throw({receive_unkown_cmd, ModId, ProtoId}).\n\n\n";
make_hand([H|L], SrcL) ->
    Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
    ErlName = get_xml_attribute_value(erlname, H#xmlElement.attributes),
    ModName = get_xml_attribute_value(modname, H#xmlElement.attributes),
    ProtoList = get_xmlElementList(H#xmlElement.content, []),
    F = fun(E, Acc) ->
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "0" ->
                % 客户端的请求在这里弄成 一般client的协议号是2byte的一个int N,那么N bsr 8 -> ModId, N rem 256 -> ProtoId
                % 这里可以考虑直接将协议号先匹配出来 <<CMD:16/bits, Binary/binary>> 然后函数里面直接模式匹配就搞定
                % handle(ModId, ProtoId, Binary)->
                %   {ok, Tuple} = proto_xx:protoname(Binary),
                %   {client_request, ModName, Tuple}.
                % proto_xx.erl 也要自动生成 proto_xx:protoname 函数应该返回 {protoname,data}
                % 在proto_xx.h中生成protoname的记录，那么逻辑处理中用record来操作就方便多了
                % 然后将这个返回值交给player进程， player进程会调用ModName:handle(Tuple)
                ProtoId = get_xml_attribute_value(protoid, E#xmlElement.attributes),
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),
                Acc ++ "handle(<<" ++ Modid ++":8, " ++ ProtoId ++ ":8, Binary/binary>>) ->\n    "
                    ++ "{ok, Tuple} = "++ ErlName ++":" ++ ProtoName ++ "(Binary),\n    "
                    ++ "{client_request, " ++ ModName ++ ", Tuple};\n";
            _ ->    % 服务器返回的请求在下面处理
                Acc
        end
    end,
    New_Src1 = lists:foldl(F, SrcL, ProtoList),
    make_hand(L, New_Src1).


make_pack([], SrcL) ->
    SrcL ++ "pack(Tuple) ->\n    "
        ++ "throw({pack_unkown_msg, Tuple}).\n\n\n";
make_pack([H|L], SrcL) ->
    Modid = get_xml_attribute_value(modid, H#xmlElement.attributes),
    ErlName = get_xml_attribute_value(erlname, H#xmlElement.attributes),
    _ModName = get_xml_attribute_value(modname, H#xmlElement.attributes),
    ProtoList = get_xmlElementList(H#xmlElement.content,[]),
    F = fun(E, Acc) ->
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "1" ->  % 服务器返回
                % 生成打包数据脚本
                % proto_xx:protoname(#protoname{}) 这个函数会将上层传入的数据打包生成Iolist
                % 完成从 modname protoname到协议id的转换
                % 如果是用的{packet, 0} 那么自己额外加4字节的包长吧
                ProtoId = get_xml_attribute_value(protoid, E#xmlElement.attributes),
                ProtoName = get_xml_attribute_value(protoname, E#xmlElement.attributes),

                %% new  不主动加头长了   以后调用的时候这个pack就不用调用了  这里这么写只是为兼容  有时间再重新规划下
                Acc ++ "pack(#" ++ ProtoName ++ "{} = Tuple) ->\n    "
                    ++ "{ok, IoList} = "++ ErlName ++":" ++ ProtoName ++ "(Tuple),\n    "
                    ++ "[<<" ++ Modid ++ ":8, "++ ProtoId ++ ":8>>" ++ "|IoList];\n";
%%                 Acc ++ "pack(" ++ ErlName ++", " ++ ProtoName ++ ", Tuple) ->\n    "
%%                     ++ "{ok, IoList} = "++ ErlName ++":" ++ ProtoName ++ "(Tuple),\n    "
%%                     ++ "Len = iolist_size(IoList) + 6,\n    "
%%                     ++ "[<<Len:32, " ++ Modid ++ ":8, "++ ProtoId ++ ":8>>" ++ "|IoList];\n";
            _ ->
                Acc
        end
    end,
    New_Src1 = lists:foldl(F, SrcL, ProtoList),
    make_pack(L, New_Src1).

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

%% 如果结尾是",\n" 去掉
drop2(L) ->
    Num = erlang:length(L),
    if
        Num > 2 ->
            {L1, CheckL} = lists:split(Num - 2, L),
            if
                CheckL == ",\n" ->
                    L1;
                true ->
                    L
            end;
        true ->
            L
    end.

create_parse_loop_fun(Src, []) ->
    Src ;
create_parse_loop_fun(Src, [H|L]) ->
    LoopFunName = get_xml_attribute_value(name, H#xmlElement.attributes),
    %% 注意这里没有反转最后的列表，所以顺序是不在考虑
    Src1 = Src ++ "\n" ++ LoopFunName ++ "(<<__Len:16, __B/binary>>) ->\n"
        ++ "    " ++ LoopFunName ++ "(__Len, __B, []).\n"
        ++ LoopFunName ++ "(0, __B, __L) ->\n"
        ++ "    {__L, __B};\n"
        ++ LoopFunName ++ "(__Len, __B, __L) ->\n",
    F = fun(E, {Acc, Acc1, Acc2}) ->
        TermNameF = first_up(get_xml_attribute_value(name, E#xmlElement.attributes)),
        case get_xml_attribute_value(type, E#xmlElement.attributes) of
            "uint8" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":8, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "uint16" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":16, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "uint32" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":32, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "uint64" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":64, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "int8" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":8/signed, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "int16" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":16/signed, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "int32" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":32/signed, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "int64" ->
                {Acc ++ "    <<" ++ TermNameF ++ ":64/signed, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "string" ->
                {Acc ++ "    <<__" ++ TermNameF ++ "Len:16, " ++ TermNameF ++ ":__" ++ TermNameF ++ "Len/binary, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "bytes" ->
                {Acc ++ "    <<__" ++ TermNameF ++ "Len:16, " ++ TermNameF ++ ":__" ++ TermNameF ++ "Len/binary, __" ++ TermNameF ++ "Binary/binary>> = " ++ Acc1 ++ ",\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            "loop" ->
                LoopTypeF = get_xml_attribute_value(looptype, E#xmlElement.attributes),
                {Acc ++ "{" ++ TermNameF ++", __" ++ TermNameF ++ "Binary} = " ++ LoopTypeF ++ "(" ++ Acc1 ++ "),\n", "__" ++ TermNameF ++ "Binary", Acc2 ++ TermNameF ++ ","};
            O ->
                erlang:throw({unkown, O})
        end
    end,
    {Src2, LastBinary, ParamList} = lists:foldl(F, {Src1, "__B", ""}, get_xmlElementList(H#xmlElement.content,[])),
    Src3 = Src2 ++ "    " ++ LoopFunName ++ "(__Len - 1, " ++ LastBinary ++ ", [{" ++ LoopFunName ++ "," ++ drop_do(ParamList) ++ "}|__L]).\n",
    create_parse_loop_fun(Src3, L).