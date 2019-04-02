create table feed_check_pass( 
ymd varchar(15),
level varchar(6),
check_type varchar(10),
feed_pv int
)engine = innodb DEFAULT CHARSET=utf8; 

### 监控数据 审核流程 ####
date=`date -d "20180727" +%Y%m%d`

for i in {0..10}
do

date=`date -d "20180716 +$i day" +%Y%m%d`
hive -e"
select  '$date' as ymd
        ,z.level
        ,case when z.check_type = 3 then 'base'
              when z.check_type = 7 then 'changsha'
              when z.check_type = 15 then 'beijing'
              when z.check_type = 31 then 'bj_rec'
              when z.check_type = 'all' then 'all'
              end as allcheck
        ,z.feedpv
from

(
select  c.level as level
        ,a.acl_type as check_type
        ,sum(a.feedpv) as feedpv 

from

(
SELECT entity_owner_id
                   ,entity_id
                   ,acl_type
                   ,count(1) as feedpv
             FROM hds.ns_user__feed__logic__update
             where ymd ='$date'
                 AND acl_type IN (3,7,15,31)
                 group by entity_owner_id
                   ,entity_id
                   ,acl_type
)a

inner join
(
SELECT uid
          ,level
         FROM stg.user_info
         WHERE ymd='$date'
         group by uid
                    ,level
)c
on a.entity_owner_id = c.uid

group by c.level
        ,a.acl_type 

union all


select  f.level as level
        ,'all' as check_type
        ,count(e.entity_id) as feedpv        
from

(
SELECT actor_id
               ,entity_id
             FROM hds.ns_user__feed__logic__publish
             WHERE ymd='$date'
             group by actor_id
               ,entity_id
)e

inner join

(
SELECT uid
          ,level
         FROM stg.user_info
         WHERE ymd='$date'
         group by uid
                    ,level
)f
on e.actor_id = f.uid
group by f.level 

)z


group by z.level
        ,case when z.check_type = 3 then 'base'
              when z.check_type = 7 then 'changsha'
              when z.check_type = 15 then 'beijing'
              when z.check_type = 31 then 'bj_rec'
              when z.check_type = 'all' then 'all'
              end 
        ,z.feedpv


;">/home/huanghongyu/feed_publish/feed_check.txt

sed -i '/^WARN.*/d' /home/huanghongyu/feed_publish/feed_check.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/feed_publish/feed_check.txt' INTO TABLE db_inke_pm_strategy.feed_check_pass CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"

done

