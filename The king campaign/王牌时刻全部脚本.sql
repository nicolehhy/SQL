
【 PPPPPPPPPPPPPPPS： 应用此代码时，需依据需求，更改时间范围、主播UID，直播间ID 】

王牌时刻的数据

【  1.主播侧  】

一、送礼数
SELECT live_uid as uid
        ,sum(gold) as gold
        FROM
        hdw.ev_fs_send_gift
        WHERE ymd = '20180809' 
            AND trans_time between '2018-08-09 20:26:00.0' and '2018-08-09 21:30:00.0'
            AND live_uid in (45034059,2906315,12104503,6569049,3439877,327688,111)
GROUP BY live_uid

二、新增关注数
select a.uid, count(a.follow_uid)
FROM
(
select follow_uid,uid from hds.user_relation_follows
                            WHERE time between '2018-08-09 20:00:00.0' and '2018-08-09 21:30:00.0'
                            AND uid in (45034059,2906315,12104503,6569049,3439877,327688,111)
                            GROUP BY follow_uid,uid)a
GROUP BY a.uid



【  2. 非主播粉丝的总体数据  】

（****** 单用 hdw.ev_act_live 表得到的数据
① 聊天PV，UV、送礼

select chat_pv,chat_uv,gift_uv,income from hdw.ev_act_live
where start_time between '2018-08-09 20:00:00.0' and '2018-08-09 21:30:00.0'
      and uid = 111）——————》 直播断开则有好几次记录，但是要计算非主播粉丝的数据时不可用


一、曝光
SELECT count(z.uid), count(distinct z.uid) from
(
SELECT b.uid as uid from 

(SELECT uid
        FROM hdw.ev_act_card_show 
        WHERE ymd = 20180809 and obj_uid = 111)b 
left JOIN 
(
select follow_uid,uid from hds.user_relation_follows
                            WHERE time < '2018-08-09 20:00:00.0' 
                            AND uid in (45034059,2906315,12104503,6569049,3439877,327688,111)
                            GROUP BY follow_uid,uid)a
ON b.uid = a.follow_uid

WHERE a.follow_uid is null
)z



二、观看

SELECT count(a.uid),sum(a.view_pv),sum(a.alltime),sum(a.1time),sum(a.5time),sum(a.10time)
FROM
(
SELECT  uid
        ,count(1) view_pv
        ,SUM(unix_timestamp(exit_time)-unix_timestamp(enter_time)) as alltime
        ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >60,1,0) as 1time
        ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >300,1,0) as 5time
        ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >600,1,0) as 10time
        FROM
        hdw.ev_act_view
        WHERE ymd = 20180809
                AND live_uid = 111
                AND unix_timestamp(exit_time)-unix_timestamp(enter_time) >0 and unix_timestamp(exit_time)-unix_timestamp(enter_time) <= 36000
        GROUP BY uid
                 ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >60,1,0) 
                ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >300,1,0) 
                ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >600,1,0)
)a


LEFT JOIN 

(select follow_uid from hds.user_relation_follows
                            WHERE time < '2018-08-09 20:00:00.0' 
                            AND uid in (45034059,2906315,12104503,6569049,3439877,327688,111)
                            GROUP BY follow_uid
                            )z
ON a.uid = z.follow_uid

WHERE z.follow_uid is null

三、送礼

select count(c.uid) 
from
(
SELECT uid
        FROM
        hdw.ev_fs_send_gift
        WHERE trans_time > '2018-08-09 20:00:00.0'
              AND live_id in ('1533817582690751','1533817413353051','1533816762371153','1533815970936366')
GROUP BY uid
)c 

LEFT JOIN 

(
select follow_uid from hds.user_relation_follows
                            WHERE time < '2018-08-09 20:00:00.0' 
                            AND uid in (45034059,2906315,12104503,6569049,3439877,327688)
                            GROUP BY follow_uid                  
)z

ON c.uid = z.follow_uid

WHERE z.follow_uid is null

四、聊天

SELECT count(d.uid),sum(d.chatpv)
FROM
(
SELECT uid
        ,count(uid) as chatpv
       FROM 
       hds.view_liveroom_msg
       WHERE ymd = '20180809' 
       AND liveid in  ('1533817582690751','1533817413353051','1533816762371153','1533815970936366')
       GROUP BY uid
)d


LEFT JOIN 

(
select follow_uid from hds.user_relation_follows
                            WHERE time < '2018-08-09 20:00:00.0' 
                            AND uid in (45034059,2906315,12104503,6569049,3439877,327688)
                            GROUP BY follow_uid       
)z

ON d.uid = z.follow_uid

WHERE z.follow_uid is null


【   3.总体数据   】

一、曝光数
SELECT count(z.uid), count(distinct z.uid) from

(SELECT uid
        FROM hdw.ev_act_card_show 
        WHERE ymd = 20180809 and obj_uid = 111)z

二、观看

SELECT count(a.uid),sum(a.view_pv),sum(a.alltime),sum(a.1time),sum(a.5time),sum(a.10time)
FROM
(
SELECT  uid
        ,count(1) view_pv
        ,SUM(unix_timestamp(exit_time)-unix_timestamp(enter_time)) as alltime
        ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >60,1,0) as 1time
        ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >300,1,0) as 5time
        ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >600,1,0) as 10time
        FROM
        hdw.ev_act_view
        WHERE ymd = 20180809
                AND live_uid = 111
                AND unix_timestamp(exit_time)-unix_timestamp(enter_time) >0 and unix_timestamp(exit_time)-unix_timestamp(enter_time) <= 36000
        GROUP BY uid
                 ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >60,1,0) 
                ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >300,1,0) 
                ,if(unix_timestamp(exit_time)-unix_timestamp(enter_time) >600,1,0)
)a

三、送礼
select count(c.uid)
from
(
SELECT uid
        FROM
        hdw.ev_fs_send_gift
        WHERE trans_time > '2018-08-09 20:00:00.0'
              AND live_id in ('1533817582690751','1533817413353051','1533816762371153','1533815970936366')
              GROUP BY uid
)c 

四、聊天

SELECT count(d.uid),sum(d.chatpv)
FROM
(
SELECT uid
        ,count(uid) as chatpv
       FROM 
       hds.view_liveroom_msg
       WHERE ymd = '20180809' 
       AND liveid in  ('1533817582690751','1533817413353051','1533816762371153','1533815970936366')
       GROUP BY uid
)d