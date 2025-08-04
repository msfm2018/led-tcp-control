%%%-------------------------------------------------------------------
%%% @author wulei
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十二月 2014 下午5:41
%%%-------------------------------------------------------------------
-module(pt).
-author("wulei").

%% API
-compile(export_all).

%% 打包字符串的函数
packstring(L) when is_list(L) ->
    BL = list_to_binary(L),
    Len = byte_size(BL),
    <<Len:16,BL/binary>>;
packstring(L) when is_binary(L) ->
    Len = byte_size(L),
    <<Len:16,L/binary>>.

%% 这个函数可能不会用了   大部分直接二进制解析了
read_string(Bin) ->
  case Bin of
    <<Len:16, Bin1/binary>> ->
      case Bin1 of
        <<Str:Len/binary-unit:8, Rest/binary>> ->
          {binary_to_list(Str), Rest};
        _R1 ->
          {[],<<>>}
      end;
    _R1 ->
      {[],<<>>}
  end.




