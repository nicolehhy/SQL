# 回溯多天数据 #
for i in {0..7}
do
date=`date -d "20180707 +$i day" +%Y%m%d`
date1=`date -d "$date -7 day" +%Y%m%d`
date2=`date -d "$date1 -1 day" +%Y%m%d`
date3=`date -d "$date1 -30 day" +%Y%m%d`
date4=`date -d "$date1 -7 day" +%Y%m%d`
date5=`date -d "$date1 +7 day" +%Y%m%d`
date6=`date -d "$date1 +1 day" +%Y%m%d`


hive -e "select ta.obj_uid,show_count,gender,nvl(cnt_before,0),nvl(time_before,0),
nvl(cnt_after,0),nvl(time_after,0),
case when te.uid is null then 'no'
else 'yes' end as isnew 
from

(
select a.obj_uid,show_count from 
(select obj_uid,count (distinct token) AS show_count 
from hds.newapplog_rec_card_show 
where ymd=$date1 and  token like '%rec_7_6%' and 
token rlike 'ja0|ja1' 
group by obj_uid)a 
left join
(select distinct obj_uid
from hds.newapplog_rec_card_show 
where ymd between $date3 and $date2 
and token like '%rec_7_6%' and token rlike 'ja0|ja1|ja2')b
on a.obj_uid=b.obj_uid 
where b.obj_uid is null
)ta 

left join
(select uid,gender from hdw.u_user_certification where ymd=$date2
and gender is not null)tb
on ta.obj_uid=tb.uid

left join
(select uid,nvl(count(distinct case when(duration>60) then ymd end),0) AS cnt_before,
nvl(sum(duration),0) AS time_before
from hdw.ev_act_live
where ymd between $date4 and $date2
group by uid
)tc
on tc.uid=ta.obj_uid

left join
(select uid,nvl(count(distinct case when(duration>60) then ymd end),0) AS cnt_after,
nvl(sum(duration),0) AS time_after
from hdw.ev_act_live
where ymd between $date6 and $date5
group by uid
)td
on td.uid=ta.obj_uid

left join
(
select uid from hdw.u_live_user_new
where ymd between $date4 and $date2
)te
on te.uid=ta.obj_uid

;" > 0703.txt

done



