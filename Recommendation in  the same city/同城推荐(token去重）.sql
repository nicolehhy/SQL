同城推荐（token分类各指标监控）

## mysql 建表
create table tongcheng_rec_token( 
ymd varchar(15),
token varchar(10) not null,
showpv varchar(10),
view_pv int,
view_time int,
eff_view int,
eff_time int
)engine = innodb DEFAULT CHARSET=utf8; 



#### bash 内定时监控脚本

date=`date -d "yesterday" +%Y%m%d`
/apps/hive/bin/hive -e"
add jar hdfs://nameservice1//user/hive/udfs/smidudf.jar;
create temporary function udfsmid as  'com.baidu.hive.udf.UDFUrlParams';

select $date, t1.token, sum(t1.show_pv) as zshowpv,sum(c.view_pv) as zviewpv, sum(c.view_time) as zviewtime, 
sum(b.effview_pv) as effviewtm, sum(b.eff_time) as eff_time
from

(select live_uid,count(distinct concat(udfsmid(smid), '_', live_id)) as show_pv,
case when token rlike 'rec_4_1_1_0' then '4_1_1_0'
when token rlike 'rec_4_1_1_1' then '4_1_1_1'
when token rlike 'rec_4_1_1_3' then '4_1_1_3'
when token rlike 'rec_4_1_1_4' then '4_1_1_4'
when token rlike 'rec_4_1_1_5' then '4_1_1_5'
when token rlike 'rec_4_1_1_6' then '4_1_1_6'
when token rlike 'rec_4_1_1_7' then '4_1_1_7'
when token rlike 'rec_4_1_1_9' then '4_1_1_9'
when token rlike 'rec_4_1_1_10' then '4_1_1_10' end as token
from hds.newapplog_live_show  
where ymd = $date and tab_key in ('FUJINABCD', 'FUJ]NABCD_live', 'FUJINABCD_live', 'FUJINABCD_game', 'nea._live', 'near_live', 'near_mive')
group by live_uid,case when token rlike 'rec_4_1_1_0' then '4_1_1_0'
when token rlike 'rec_4_1_1_1' then '4_1_1_1'
when token rlike 'rec_4_1_1_3' then '4_1_1_3'
when token rlike 'rec_4_1_1_4' then '4_1_1_4'
when token rlike 'rec_4_1_1_5' then '4_1_1_5'
when token rlike 'rec_4_1_1_6' then '4_1_1_6'
when token rlike 'rec_4_1_1_7' then '4_1_1_7'
when token rlike 'rec_4_1_1_9' then '4_1_1_9'
when token rlike 'rec_4_1_1_10' then '4_1_1_10' end)t1

left join
(select 
sum(unix_timestamp(exit_time)-unix_timestamp(enter_time)) as view_time,live_uid,
count(udfsmid(smid)) as view_pv,
case when token rlike 'rec_4_1_1_0' then '4_1_1_0'
when token rlike 'rec_4_1_1_1' then '4_1_1_1'
when token rlike 'rec_4_1_1_3' then '4_1_1_3'
when token rlike 'rec_4_1_1_4' then '4_1_1_4'
when token rlike 'rec_4_1_1_5' then '4_1_1_5'
when token rlike 'rec_4_1_1_6' then '4_1_1_6'
when token rlike 'rec_4_1_1_7' then '4_1_1_7'
when token rlike 'rec_4_1_1_9' then '4_1_1_9'
when token rlike 'rec_4_1_1_10' then '4_1_1_10' end as token 
from hdw.ev_act_view_md
where ymd=$date and unix_timestamp(exit_time)-unix_timestamp(enter_time) >0 and unix_timestamp(exit_time)-unix_timestamp(enter_time) < 36000
and tab_key in ('FUJINABCD', 'FUJINABCD_live', 'FUJINABCD_radio_social')
group by live_uid,
case when token rlike 'rec_4_1_1_0' then '4_1_1_0'
when token rlike 'rec_4_1_1_1' then '4_1_1_1'
when token rlike 'rec_4_1_1_3' then '4_1_1_3'
when token rlike 'rec_4_1_1_4' then '4_1_1_4'
when token rlike 'rec_4_1_1_5' then '4_1_1_5'
when token rlike 'rec_4_1_1_6' then '4_1_1_6'
when token rlike 'rec_4_1_1_7' then '4_1_1_7'
when token rlike 'rec_4_1_1_9' then '4_1_1_9'
when token rlike 'rec_4_1_1_10' then '4_1_1_10' end)c
on t1.live_uid = c.live_uid and t1.token = c.token

left join
(select 
sum(unix_timestamp(exit_time)-unix_timestamp(enter_time)) as eff_time,live_uid,
count(udfsmid(smid)) as effview_pv,
case when token rlike 'rec_4_1_1_0' then '4_1_1_0'
when token rlike 'rec_4_1_1_1' then '4_1_1_1'
when token rlike 'rec_4_1_1_3' then '4_1_1_3'
when token rlike 'rec_4_1_1_4' then '4_1_1_4'
when token rlike 'rec_4_1_1_5' then '4_1_1_5'
when token rlike 'rec_4_1_1_6' then '4_1_1_6'
when token rlike 'rec_4_1_1_7' then '4_1_1_7'
when token rlike 'rec_4_1_1_9' then '4_1_1_9'
when token rlike 'rec_4_1_1_10' then '4_1_1_10' end as token 
from hdw.ev_act_view_md
where ymd=$date and unix_timestamp(exit_time)-unix_timestamp(enter_time) >15 and unix_timestamp(exit_time)-unix_timestamp(enter_time) < 36000
and tab_key in ('FUJINABCD', 'FUJINABCD_live', 'FUJINABCD_radio_social')
group by live_uid,
case when token rlike 'rec_4_1_1_0' then '4_1_1_0'
when token rlike 'rec_4_1_1_1' then '4_1_1_1'
when token rlike 'rec_4_1_1_3' then '4_1_1_3'
when token rlike 'rec_4_1_1_4' then '4_1_1_4'
when token rlike 'rec_4_1_1_5' then '4_1_1_5'
when token rlike 'rec_4_1_1_6' then '4_1_1_6'
when token rlike 'rec_4_1_1_7' then '4_1_1_7'
when token rlike 'rec_4_1_1_9' then '4_1_1_9'
when token rlike 'rec_4_1_1_10' then '4_1_1_10' end)b
on t1.live_uid=b.live_uid and t1.token = b.token
where t1.token is not null
group by t1.token,$date
;" > tongcheng_rec_token.txt          
sed -i '/^WARN.*/d' tongcheng_rec_token.txt 
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/tongcehng_rec_token/tongcheng_rec_token.txt' INTO TABLE db_inke_pm_strategy.tongcheng_rec_token CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"  



### 监控  ###
30 06 * * * sh /home/huanghongyu/tongcheng_rec_token/tongcheng_rec_token.sh 