1. 分logid，分日期

曝光人数	曝光次数  观看人数	 点击次数	观看时长	有效观看时长	覆盖主播人数	 关注数量（uv） 	送礼数	送礼人数  发言数
推荐曝光次数  	推荐覆盖主播人数   覆盖有效开播主播人数	推荐覆盖有效开播人数  有效点击次数  (进入页面人数 进入页面次数) 还没做	 

hds.view_liveroom_msg : 聊天表
hds.view_newapplog_visit: 访问表

select a.ymd, a.logid, a.show_uv, a.show_pv, a.rec_show_uv, a.rec_show_pv, a.anchor_uv, a.rec_anchor_uv, a.valid_anchor_uv, a.valid_rec_anchor_uv,
b.click_pv, b.valid_click_pv, b.duration, b.valid_duration, 
c.follow_pv, d.gift_pv, e.chat_pv, f.dau
from

(select t1.ymd, t1.logid, count(distinct t1.smid) AS show_uv, count(distinct concat(t1.smid, '_', t1.live_id)) AS show_pv,
count(distinct case when t1.token rlike 'rec' then t1.smid) as rec_show_uv,
count(distinct case when t1.token rlike 'rec' then concat(t1.smid, '_', t1/live_id)) as rec_show_pv,
count(distinct t1.live_uid) as anchor_uv,
count(distinct case when t1.token rlike 'rec' then t1.live_uid) as rec_anchor_uv,
count(distinct case when t2.dur_time >= 60 then t2.live_uid) as valid_anchor_uv,
count(distinct case when t2.dur_time >= 60 and t1.token rlike 'rec' then t2.live_uid) as valid_rec_anchor_uv
from

(select ymd, udfsmid(smid) as smid, token, live_id, live_uid,
case when uid%100 in (01,02,03,04,05,06,07,08,09,10) then 'group1'
when uid%100 in (11,12,13,14,15,16,17,18,19,20) then 'group2'
when uid%100 in (21,22,23,24,25,26,27,28,29,30) then 'group3' 
when uid%100 in (31,32,33,34,35,36,37,38,39,40) then 'group4'
when uid%100 in (41,42,43,44,45,46,47,48,49,50) then 'group5'
when uid%100 in (51,52,53,54,55,56,57,58,59,60) then 'group6'
when uid%100 in (61,62,63,64,65,66,67,68,69,70) then 'group7'
when uid%100 in (71,72,73,74,75,76,77,78,79,80) then 'group8'
when uid%100 in (81,82,83,84,85,86,87,88,89,90) then 'group9'
when uid%100 in (91,92,93,94,95,96,97,98,99,00) then 'group10' end as logid
from hds.newapplog_live_show  
where ymd = 20180702 and tab_key in ('FUJINABCD', 'FUJ]NABCD_live', 'FUJINABCD_live', 'FUJINABCD_game', 'nea._live', 'near_live', 'near_mive')
)t1

left join 

(select distinct live_id, live_uid, 
(unix_timestamp(exit_time)-unix_timestamp(enter_time)) as dur_time
from hdw.ev_act_live 
where ymd = 20180702
)t2 on t1.live_id = t2.live_id and t1.live_uid = t2.live_uid

where t1.logid is not null
group by t1.logid, t1.ymd)a

left join 

(select t3.ymd, t3.logid,
count(distinct concat(t3.smid, '_', t3.live_id) as click_pv, 
count(distinct t3.smid) as view_uv,
count(case when t3.dur_time>= 15 then t3.smid end) as valid_click_pv,
sum( t3.dur_time ) as duration,
sum( case when t3.dur_time >= 60 then t3.dur_time end) as valid_duration

from
(
select 
ymd, udfsmid(smid) as smid, live_id,
case when uid%100 in (01,02,03,04,05,06,07,08,09,10) then 'group1'
when uid%100 in (11,12,13,14,15,16,17,18,19,20) then 'group2'
when uid%100 in (21,22,23,24,25,26,27,28,29,30) then 'group3' 
when uid%100 in (31,32,33,34,35,36,37,38,39,40) then 'group4'
when uid%100 in (41,42,43,44,45,46,47,48,49,50) then 'group5'
when uid%100 in (51,52,53,54,55,56,57,58,59,60) then 'group6'
when uid%100 in (61,62,63,64,65,66,67,68,69,70) then 'group7'
when uid%100 in (71,72,73,74,75,76,77,78,79,80) then 'group8'
when uid%100 in (81,82,83,84,85,86,87,88,89,90) then 'group9'
when uid%100 in (91,92,93,94,95,96,97,98,99,00) then 'group10' end as logid,
(unix_timestamp(exit_time)-unix_timestamp(enter_time)) as dur_time
from hdw.ev_act_view_md
where ymd = 20180702 and tab_key in ( 'FUJINABCD_live', 'FUJINABCD_game' , 'FUJINABCD_radio_social')
)t3)b on a.logid = b.logid 

left join

(select t4.logid, count(distinct concat(t5.smid, '_', t5.live_id)) as follow_pv

from

(select distinct ymd, udfsmid(smid) as smid, live_id, uid,
case when uid%100 in (01,02,03,04,05,06,07,08,09,10) then 'group1'
when uid%100 in (11,12,13,14,15,16,17,18,19,20) then 'group2'
when uid%100 in (21,22,23,24,25,26,27,28,29,30) then 'group3' 
when uid%100 in (31,32,33,34,35,36,37,38,39,40) then 'group4'
when uid%100 in (41,42,43,44,45,46,47,48,49,50) then 'group5'
when uid%100 in (51,52,53,54,55,56,57,58,59,60) then 'group6'
when uid%100 in (61,62,63,64,65,66,67,68,69,70) then 'group7'
when uid%100 in (71,72,73,74,75,76,77,78,79,80) then 'group8'
when uid%100 in (81,82,83,84,85,86,87,88,89,90) then 'group9'
when uid%100 in (91,92,93,94,95,96,97,98,99,00) then 'group10' end as logid
from hdw.ev_act_view_md 
where ymd = 20180702 and tab_key in ( 'FUJINABCD_live', 'FUJINABCD_game' , 'FUJINABCD_radio_social'))t4

inner join 

(select ymd, udfsmid(smid) as smid, live_id, uid
from hds.log_base_live_follow_action 
where ymd = 20180702
)t5 on t5.smid = t4.smid and t5.live_id = t4.live_id and t5.uid = t4.uid

group by t4.logid)c on b.logid = c.logid

left join

(select t6.logid, count(distinct concat(t7.smid, '_', t7.live_id)) as gift_pv

from

(select distinct ymd, udfsmid(smid) as smid, live_id, uid,
case when uid%100 in (01,02,03,04,05,06,07,08,09,10) then 'group1'
when uid%100 in (11,12,13,14,15,16,17,18,19,20) then 'group2'
when uid%100 in (21,22,23,24,25,26,27,28,29,30) then 'group3' 
when uid%100 in (31,32,33,34,35,36,37,38,39,40) then 'group4'
when uid%100 in (41,42,43,44,45,46,47,48,49,50) then 'group5'
when uid%100 in (51,52,53,54,55,56,57,58,59,60) then 'group6'
when uid%100 in (61,62,63,64,65,66,67,68,69,70) then 'group7'
when uid%100 in (71,72,73,74,75,76,77,78,79,80) then 'group8'
when uid%100 in (81,82,83,84,85,86,87,88,89,90) then 'group9'
when uid%100 in (91,92,93,94,95,96,97,98,99,00) then 'group10' end as logid
from hdw.ev_act_view_md 
where ymd = 20180702 and tab_key in ( 'FUJINABCD_live', 'FUJINABCD_game' , 'FUJINABCD_radio_social'))t6

inner join 

(select ymd, udfsmid(smid) as smid, live_id, uid
from hds.log_base_live_gift_real_action
where ymd = 20180702
)t7 on t7.smid = t6.smid and t7.live_id = t6.live_id and t7.uid = t6.uid

group by t6.logid)d on c.logid = d.logid

left join 

(select t8.logid, count(distinct concat(t9.smid, '_', t9.live_id)) as chat_pv

from

(select distinct ymd, udfsmid(smid) as smid, live_id, uid,
case when uid%100 in (01,02,03,04,05,06,07,08,09,10) then 'group1'
when uid%100 in (11,12,13,14,15,16,17,18,19,20) then 'group2'
when uid%100 in (21,22,23,24,25,26,27,28,29,30) then 'group3' 
when uid%100 in (31,32,33,34,35,36,37,38,39,40) then 'group4'
when uid%100 in (41,42,43,44,45,46,47,48,49,50) then 'group5'
when uid%100 in (51,52,53,54,55,56,57,58,59,60) then 'group6'
when uid%100 in (61,62,63,64,65,66,67,68,69,70) then 'group7'
when uid%100 in (71,72,73,74,75,76,77,78,79,80) then 'group8'
when uid%100 in (81,82,83,84,85,86,87,88,89,90) then 'group9'
when uid%100 in (91,92,93,94,95,96,97,98,99,00) then 'group10' end as logid
from hdw.ev_act_view_md 
where ymd = 20180702 and tab_key in ( 'FUJINABCD_live', 'FUJINABCD_game' , 'FUJINABCD_radio_social'))t8

inner join

(select ymd, udfsmid(smid) as smid, live_id, uid
from hds.view_liveroom_msg
where ymd = 20180702
)t9 on t8.smid = t9.smid and t8.live_id = t9.live_id and t8.uid = t9.uid)e on d.logid = e.logid












