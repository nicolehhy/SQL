/apps/hive/bin/hive -e "
set mapreduce.reduce.memory.mb = 8192;
set mapreduce.map.memory.mb = 8192;
set hive.exec.dynamic.partition.mode=nonstrict; 
set hive.exec.dynamic.partition=true;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.dynamic.partitions.pernode=100000;


insert overwrite table ana.active_uid_front_week_all partition(ymd,week)
SELECT distinct cc,
       cv,
       client,
       uid,
       ymd,
concat(year(concat(substr(t1.ymd,1,4),'-',substr(t1.ymd,5,2),'-',substr(t1.ymd,7,2),'')),
weekofyear(concat(substr(t1.ymd,1,4),'-',substr(t1.ymd,5,2),'-',substr(t1.ymd,7,2),''))) as week
FROM
  (SELECT  cc,
                   cv,
                   client,
                   uid,ymd
   FROM hds.newapplog_basic_heartbeat
   WHERE ymd>=20180701  
   UNION ALL SELECT  cc,
                             cv,
                             client,
                             uid,ymd
   FROM hds.newapplog_basic_startup
   WHERE ymd>=20180701  
   UNION ALL SELECT  cc,
                             cv,
                             client,
                             uid,ymd
   FROM hdw.u_user_new
   WHERE ymd>=20180701  
UNION ALL
select cc, cv, 'ios' as client,uid,ymd from hds.service_info_view
where ymd >=20180701   and split(cv,'_')[1] = 'Iphone' and split(split(cv,'IK')[1],'_')[0] < '4.1.2'
union all 
select cc, cv, 'Android' as client,uid,ymd from hds.service_info_view
where ymd >=20180701   and split(cv,'_')[1] = 'Android' and split(split(cv,'IK')[1],'_')[0] < '4.1.1'
            ) t1



"
