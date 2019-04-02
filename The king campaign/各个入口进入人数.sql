运营方查看直播间各个入口进入人数


主页
SELECT count(distinct uid) from hdw.ev_act_view_md where ymd = 20180809 and live_uid = 111 and  enter like '%otheruc%'
1070
首页热1 1C2076736E3D02B6

SELECT count(distinct uid) from hdw.ev_act_view_md where ymd = 20180809 and live_uid = 111 and enter like '%1C2076736E3D02B6%'
SELECT count(distinct uid) from hdw.ev_act_view_md where ymd = 20180809 and live_uid = 111 and enter like '%1C2076736E3D02B6_null%'
关注
SELECT count(distinct uid) from hdw.ev_act_view_md where ymd = 20180809 and live_uid = 111 and enter like '%GUANZHUA%'

push 
SELECT count(distinct uid) from hdw.ev_act_view_md where ymd = 20180809 and live_uid = 111 and enter like '%push%'

搜索
SELECT count(distinct uid) from hdw.ev_act_view where ymd = 20180809 and live_uid = 111 and user_from like '%search%' 

SELECT count(distinct uid) from hdw.ev_act_view where ymd = 20180809 and live_uid = 111 and user_from like '%srh_result%'

SELECT count(distinct uid) from hdw.ev_act_view_md where ymd = 20180809 and live_uid = 111 and enter like '%srh_result%'
分享
SELECT count(distinct uid) from hdw.ev_act_view where ymd = 20180809 and live_uid = 111 and user_from like '%share%' 



查看总的入口类型
SELECT enter from hdw.ev_act_view_md where ymd = 20180809 and live_uid = 111 group by enter



