%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 一月 2016 15:47
%%%-------------------------------------------------------------------
-author("Administrator").
-ifndef(SERVER_HRL).
-define(SERVER_HRL, true).
-include("server_s2s_msg.hrl").
-include("server_db.hrl").
-include("server_common.hrl").
-include("server_achievement.hrl").

%% tcp_client_gc_gateway_to_wc的消息处理子进程
-define(TCP_CLIENT_GC_GATEWAY_TO_WC_WORKERSUP, "sup1").
-define(TCP_CLIENT_GC_GATEWAY_TO_WC_WORKERNUM, 600).
%% tcp_client_tpc_gateway_to_service的消息处理子进程
-define(TCP_CLIENT_TPC_GATEWAY_TO_SERVICE_WORKERSUP, "sup2").
-define(TCP_CLIENT_TPC_GATEWAY_TO_SERVICE_WORKERNUM, 600).
%% tcp_server_tpc_gateway的消息处理子进程
-define(TCP_SERVER_TPC_GATEWAY_WORKERSUP, "sup3").
-define(TCP_SERVER_TPC_GATEWAY_WORKERNUM, 600).
%% tcp_server_wc_gateway 的消息处理子进程
-define(TCP_SERVER_WC_GATEWAY_WORKERSUP, "sup4").
-define(TCP_SERVER_WC_GATEWAY_WORKERNUM, 1000).
%% wc 网关消息面向游戏服的代理
-define(WC_GATEWAY_AGENT, "sup5").
-define(WC_GATEWAY_AGENT_NUM, 300).

%1 视野范围 500
%2 参与范围 500
%3 侦查范围 500
-define(KEN_ZONE ,500).
-define(TAKE_PART_IN,500).
-define(SPY_ON, 500).

%% slicing节点 切分处理进程数量
-define(WC_SLICING_PLAYER_MGR_NUM, 500).
-define(WC_SLICING_HASH_VALUE, 100).
-define(WC_SLICING_PLAYER_ETS, wc_slicing_player_ets).
-record(wc_slicing_player, {
  player_id,
  pid
}).

%%%% ets
%% 存储的处理过的可连接的网关信息
-define(GC_ENABLE_GATEWAY_LIST, gc_enable_gateway_list).

%% app上存储的 网关信息
-define(SERVER_GATEWAY_INFO, server_gateway_info).
-record(server_gateway_info, {
  node,
  internal_ip,
  external_ip,
  port,
  max_connections,
  connections
}).

%% 存储server之间的连接信息
-define(SERVER_CONNECTION_INFO, server_connection_info).
-record(server_connection_info, {
  key,
  socket
}).

%% gc 上存储的用户连接信息ets
-define(GC_PLAYER_INFO_ETS, gc_player_info_ets).
-record(gc_player_info_ets, {
  player_id,
  pwd,
  status, % 连接状态
  pid,
  socket
}).
-define(PLAYER_REGISTER_STATUS, 0).
-define(PLAYER_LOGIN_STATUS, 1).
-define(PLAYER_LOGINED_STATUS, 2).

%% wc 网关上用户连接信息
-define(WC_GATEWAY_PLAYER, wc_gateway_playrt).
-record(wc_gateway_player, {
  player_id,
  pid,
  gc_node
}).

%% 地图区域表
-define(WC_ZONE_INFO, wc_zone_info).
-record(wc_zone_info, {
  zone, % 区域 [{x1 div Num, y1 div Num}, {x2 div Num, y2 div Num}] 都是正方形的区域划分 左下角的坐标与右上角坐标 经过转换后组成一个区域   最终判断用户是否在区域内   Xmin =< PlayerX div Num =< Xmax  andalso Ymin =< PlayerY div Num =< Ymax
  node,
  parent_node
}).

%% 同屏索引表
-define(WC_SAME_SCREEN, wc_same_screen).
-record(wc_same_screen, {
  zone,
  player_id,
  agent,
  gc_node,
  pid
}).

%% 同屏的用户数据表
-define(WC_SAME_SCREEN_PLAYER, wc_same_screen_player).
-record(wc_same_screen_player, {
  player_id,
  nick_name,
  x,
  y,
  sign,
  lv,
  exp,
  coin,
  mileage,
  city_id,
  city_name,
  addr,
  online_flag = 0,
  agent,
  gc_node,
  pid
}).

-define(WC_WORLD_NORMAL_EVENT_ETS, wc_world_normal_event_ets).  % 缓存在wc_event节点的事件表 主要是为了存世界性的列表
-define(WC_WORLD_NOT_NORMAL_EVENT_ETS, wc_world_not_normal_event_ets).
-define(WC_FRATURE_FILM_EVENT_ETS, wc_feature_film_event_ets).  % 缓存在wc_event节点的剧情类事件表
%% wc_game节点event列表
-define(WC_GAME_WORLD_NORMAL_EVENT, wc_game_world_normal_event).  % 世界性的日常事件列表
-define(WC_GAME_WORLD_NOT_NORMAL_EVENT, wc_game_world_not_normal_event). % 世界性的日常事件列表
-define(WC_GAME_FRATURE_FILM_EVENT, wc_game_feature_film_event_ets).  % 剧情类的列表
-define(WC_GAME_EVENT_MAP_ETS,wc_event_map_ets).%缓存在wc_event节点上的个人视野范围内事件 地图信息
-define(WC_GAME_GLOBAL_EVENT_ETS,wc_global_event_ets).%缓存在wc_event节点上的地图局部事件
-record(wc_event_index,{
  id
}).

-define(WC_GAME_ZONE_EVENT1, wc_game_zone_event1).  % wc_game节点event同屏表1
-define(WC_GAME_ZONE_EVENT2, wc_game_zone_event2).  % wc_game节点event同屏表2
-define(WC_GAME_ZONE_EVENT3, wc_game_zone_event3).  % wc_game节点event同屏表3
-define(WC_GAME_ZONE_EVENT4, wc_game_zone_event4).  % wc_game节点event同屏表4
-record(wc_game_zone_event, {
  zone,
  id
}).
%% -define(WC_GAME_EVENT, wc_game_event).  % 局部事件缓存ets
%% -record(wc_game_event, {
%%   id,
%%   type,
%%   x,
%%   y,
%%   area,
%%   start_time,
%%   end_time,
%%   join_time = 0,
%%   continued_time,
%%   participate_num,
%%   conditions,
%%   award,
%%   name,
%%   description,
%%   award1,
%%   pid = 0,  % event 对应pid
%%   param= [], % 一些事件过程变量，比如当前参加事件的用户信息等
%%   score= [], % 小游戏积分最大值
%%   title_id = 0,
%%   zone_type = 1 ,
%%   state =0, % 剧情事件（0，未完成。1，已完成） 集体事件的循环事件（0,非占领2,争夺，3,已占领）
%%   camp =0, % 集体事件的循环事件，已占领事件的阵营id
%%   limit_player_max_num = -1000,%
%%   limit_event_max_times = -1000,
%%   limit_player_also_num = -1000,%
%%   limit_event_also_times = -1000
%% }).

-define(WC_EVENT_MAP, wc_event_map).  % 个人局部事件缓存地图格子上事件ets
-record(wc_event_map, {
  zone,
  eventList
}).

%% -record(wc_game_global_event, {
-define(WC_GAME_EVENT, wc_game_event).  % 局部事件缓存ets
-record(wc_game_event, {
  zone= {0,0},%event的中心点坐标  (个人视野范围内的事件，这个字段才会有用，代表格子的中心点坐标。)
  id,
  type,
  x,
  y,
  area,
  start_time,
  end_time,
  join_time = 0,
  continued_time =0,
  participate_num,
  conditions,
  award,
  name,
  description,
  award1,
  pid =0,  % event 对应pid
  param =[], % 一些事件过程变量，比如当前参加事件的用户信息等
  score= [], % 小游戏积分最大值
  title_id =0,
  zone_type =1,
  grid_cd_time = 0, %格子cd时间 (事件结束时间+一个随机值)
  state =0, % 剧情事件（0，未完成。1，已完成） 集体事件的循环事件（0,非占领2,争夺，3,已占领）
  camp =0, % 集体事件的循环事件，已占领事件的阵营id
  limit_player_max_num = -1000,
  limit_event_max_times = -1000,
  limit_player_also_num = -1000,%
  limit_event_also_times = -1000,
  quest_group = [],
  wave_random_number = 0,
  top_list =[]  %事件前十名的排行榜([{playerid,name,score}])
}).
-define(AUCTION_TEMPLATE_PAGE_ETS, auction_template_page_ets). % 记录{{auction_id, template_id}，update时间戳，[{订单id，价格，数量, 截止时间}}, ...]}
-record(auction_template_page_ets, {
	key,
	time,
	list
}).
-define(AUCTION_RECORD_ETS, auction_record_ets). % 记录所有拍卖记录ets表 {{auction_id, record_id}, record}  record -> #stack_record/#unstack_record
-record(auction_record_ets, {
	key,
	record
}).

%% 注意时序性问题，
%% 因为mod_email会加载离线时的邮件，有可能标示着完成了某事件或者拍卖了某东西，那么此时可能会抛出一些事件让对应模块处理，比如拍卖行中需要去掉拍卖单的缓存，又比如成就系统的变更
-define(MODLIST, [mod_player, mod_goods, mod_event, mod_chat, mod_task, mod_auction, mod_achievement, mod_email]).
-record(player_event, {
  type,
  param
}).
-define(DISPATCH(State, EventType),lib_wc:dispatch(State, #player_event{type = EventType})).
-define(DISPATCH(State, EventType, Param),lib_wc:dispatch(State, #player_event{type = EventType, param = Param})).

%% auction进程启动参数
-record(auction_opts, {
	auction_id,
	price_count_list,
	max_record_id,
	time
}).

%% 用户进程状态变量
-record(player_state, {
  player_id,
  pid,
  x,
  y,
  pwd,
  player_data,
  gc_node,
  status = 0,
  agent_pid
}).

%% event进程状态变量
-record(event_state, {
  event,
  db_flag,
  receiver_list = [],
  node,
	is_closing = false,
  event_borad_node = []
}).

%% 用户接事件发送的变量 给event进程
-record(receive_e, {
  player_id,
  nick_name,
  pid,
  flag = 0, % 默认为0 代表是用户自己亲自参与   1代表宠物参与
  join_time = 0,
  last_award_time = 0,  % 用户自己领取的时间戳或者 宠物列表领取的时间戳([{宠物id， 上一次获取时间戳，上一次随即伤害判定时间戳， 上一次战斗伤害判定时间戳}])
	hurt_info_list = [],  % 宠物受到的累计伤害记录 [{PetGoodsId, 累计伤害值}, {PetGoodsId, 累计伤害值},...]
	die_pet_list = [],		% 死亡宠物列表 [PetGoodsId, PetGoodsId, ...]
	award_list = [],			% 累a计的奖励列表 [{goodsid, num}, ...]
  pet_list = [],
  score_list = []       % 积分记录
}).
%% 用户退出事件 给event进程发送通知
-record(exit_e, {
  player_id,
  pid
}).

%% 跨进程抛事件
-define(S2S_DISPATCH(P, E), P ! {s2s_d, E}).
-define(S2S_DISPATCH(P, E, Param), P ! {s2s_d, E, Param}).

%% 定义事件
-define(EVENT_PLAYER_INIT, 1).                  %% 用户进程初始化
-define(EVENT_PLAYER_ONLINE, 2).                %% 用户置为在线状态
-define(EVENT_PLAYER_OFFLINE, 3).               %% 用户置为下线状态
-define(EVENT_PLAYER_REPLACE, 4).               %% 用户顶人操作
-define(EVENT_PLAYER_CLOSE, 5).                 %% 用户进程退出
-define(EVENT_PLAYER_BROAD_ZONE_MSG, 6).        %% 用户局部广播消息
-define(EVENT_PLAYER_GM_CREATE_GOODS, 7).       %% gm指令给自己创建物品
-define(EVENT_PLAYER_RECEIVE_EVENT_FAILURE, 8). %% 用户接取事件失败
-define(EVENT_PLAYER_RECEIVE_EVENT_OK, 9).      %% 用户接取事件成功
-define(EVENT_PLAYER_EVENT_COMPLETED, 10).      %% 事件完成
-define(EVENT_PLAYER_BE_KICKED, 11).            %% 用户被踢
-define(EVENT_PLAYER_CREATE_GOODS, 12).         %% 创建物品
-define(EVENT_PLAYER_CREATE_PET, 13).           %% 创建宠物
-define(EVENT_PLAYER_EVENT_RETURN_PET, 14).     %% 用户收回驻守在事件处的宠物
-define(EVENT_PLAYER_LOOP_30, 15).              %% 30s一次的tick
-define(EVENT_PLAYER_PRODUCE_EMAIL_TOSELF, 16). %% 产生自己的系统邮件
-define(EVENT_PLAYER_EXIT_GROUP_AREA_EVENT, 17).%% 退出集体区域事件消息
-define(EVENT_PLAYER_MSG_GROUP_AREA_EVENT, 18). %% 集体区域事件收益通知
-define(EVENT_PLAYER_NEW_TABLE_EMAIL, 19).      %% 有新的邮件，需要加载转化为自己邮件
-define(EVENT_PLAYER_BROAD_NODE_MSG, 20).       %% 用户整个节点广播消息
-define(EVENT_PLAYER_BROAD_WORLD_MSG, 21).      %% 用户整个世界广播消息
-define(EVENT_PLAYER_CHAT_TARGET_INFO, 22).     %% 聊天返回target信息
-define(EVENT_PLAYER_CHAT_PERSON_MSG, 23).      %% 发送给target私聊
-define(EVENT_PLAYER_CHAT_ACK_OFFLINE, 24).     %% 返回给用户target已不在线
-define(EVENT_PLAYER_PET_BE_HURT, 25).     			%% 宠物受到伤害
-define(EVENT_PLAYER_EVENT_OVER_WHEN_OFF, 26).	%% 通知用户事件结束 扣除对应消耗的宠物数值
-define(EVENT_PLAYER_AUCTION_PAGE, 27).         %% 通知用户拍卖行页面数据
-define(EVENT_PLAYER_AUCTION_TEMPLATE_PAGE, 28).%% 通知用户拍卖行某道具种类对应的页面数据
-define(EVENT_PLAYER_AUCTION_RECORD_DETAIL, 29).%% 通知用户拍卖行某单号物品详细信息
-define(EVENT_PLAYER_REDUCE_GOODS, 30).         %% 减少道具
-define(EVENT_PLAYER_CHANGE_COIN, 31).          %% 减少钱
-define(EVENT_PLAYER_SELL_TO_AUCTION, 32).      %% 出售某东西的消息
-define(EVENT_PLAYER_AUCTION_CANCEL_RECORD, 33).%% 删除某订单成功返回消息
-define(EVENT_PLAYER_AUCTION_RETURN_UNSTACK,34).%% 拍卖时间到了返回给用户的不可堆叠物品
-define(EVENT_PLAYER_AUCTION_CHANGE_RECORD, 35).%% 从邮件中体现的拍卖单变化
-define(EVENT_PLAYER_ACHIEVEMENT_CHECK, 36).    %% 抛出成就相关
-define(EVENT_PLAYER_CHANGE_ATTRIBUTE, 37).     %% 增加玩家属性
-define(EVENT_PLAYER_UPDATA_FEATURE_ID,38).           %% 更新玩家剧情事件id

%% 定义事件 end
%%%% ets end
-define(packwebmsg(Data), t_client_server:pack_websocket_data(Data)).
-define(MYSQL_POOL, mysql). %
-define(OFFLINE_FLAG, 0).
-define(ONLINE_FLAG, 1).

% 邮件具体内容
-record(player_email, {
  email_id,
  sender_id,
  sender_name,
  type,
  title,
  content,
  goods,
  send_time,
  goods_flag,
  read_flag
}).
% 邮件简讯
-record(email_simple, {
  email_id,
  sender_name,
  type,
  read_flag,
  goods_flag,
  send_time,
  title
}).

%阵营详情
-define(WC_GAME_CAMP_INFO_ETS,wc_game_camp_info_ets).%缓存阵营详情缓存ets
-define(WC_GAME_CAMP_INFO, wc_game_camp_info).  % 阵营详情
-record(wc_game_camp_info, {
  camp_id,
  player_num
}).

%事件的排行榜信息
-define(WC_GAME_EVENT_TOP_ETS,wc_game_event_top_ets).%缓存阵营详情缓存ets
-define(WC_GAME_EVENT_TOP, wc_game_event_top).  % 阵营详情
-record(wc_game_event_top, {
  index,%index = {zonex,zoney,event_id,event_start_time}
  player_id,
  player_name,
  player_score,
  camp = -1
}).


-define(WC_EVENT_SCORE, wc_event_score).  % 个人事件的记录
-record(wc_event_score, {
  index,%index = {zoneX,zoneY,event_id,event_start_time}
  eventid =0,
  eventstarttime =0,
  score =0,
  eventEndTime =0,
  rank = 0,
  camp = -1 % 玩家自己选择的阵营id(-1标示不需要选择阵营，0 标示需要选择阵营 ，其他值则对应相应的阵营)
}).

%事件的阵营信息
-define(WC_EVENT_CAMP_INFO, wc_player_camp_info).  % 事件阵营信息缓存ets
%% -define(WC_EVENT_CAMP_INFO1, wc_player_camp_info1).  % 事件阵营信息缓存ets
%% -define(WC_EVENT_CAMP_INFO2, wc_player_camp_info2).
%% -define(WC_EVENT_CAMP_INFO3, wc_player_camp_info3).
%% -define(WC_EVENT_CAMP_INFO4, wc_player_camp_info4).
-record(wc_player_camp_info, {
  index = {0,0,0,0}, %{zonex,zoney,eventid,eventstarttime}
  eventid =0,
  eventstarttime =0,
  playerid =0, %玩家自己的id
  playername = "",
  camp =0, % 阵营id
  score =0 % 玩家的事件积分
}).

%% 题库表
-define(WC_QUEST_INFO_ETS, wc_quest_info).
-record(wc_quest_info, {
  id,
  describe,
  answer1,
  answer2,
  answer3,
  right_answer,
  next_id
}).

-define(WC_READPACKET_SUM_ETS, wc_readpacket_sum).
-record(wc_readpacket, {
  key,
  part_num, %红包份数
  sum       %红包金额
}).
-endif.