
1. 每日过北京或北京推荐动态条数（监控已搭)
## 监控 ##
date=`date -d "yesterday" +%Y%m%d`

hive -e"
select '$date' as ymd, count(time) from hds.ns_user__feed__logic__update
where ymd = $date and acl_type = 15 or acl_type = 31

;"> /home/huanghongyu/feed_publish/feed_publish.txt
sed -i '/^WARN.*/d' /home/huanghongyu/feed_publish/feed_publish.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/feed_publish/feed_publish.txt' INTO TABLE db_inke_pm_strategy.feed_publish_acl_type CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"

# done
### 建表 ###
create table feed_publish_acl_type( 
ymd varchar(15),
publish varchar(10)
)engine = innodb DEFAULT CHARSET=utf8; 





2. 上周上了推荐的主播次周的发布率

for i in {0..2}
do

date=`date -d "20180718 +$i day" +%Y%m%d`

date=`date -d "yesterday -7 day" +%Y%m%d`
date2=`date -d "$date -6 day" +%Y%m%d`
date1=`date -d "$date +1 day" +%Y%m%d`
date7=`date -d "$date +7 day" +%Y%m%d`

hive -e"

select '$date' as ymd,count(b.smid) ,count(d.smid) , count(d.smid)/count(b.smid) from


(select distinct feed_uid as smid from
hds.newapplog_feed_new_show
where tab_key='D8AD8E73B57E391B' and ymd between $date2 and $date
)b

left join 

(select distinct actor_id as smid from
hds.ns_user__feed__logic__publish
where ymd between $date1 and $date7
)d

on b.smid = d.smid

;">/home/huanghongyu/feed_publish/feed_republish.txt
sed -i '/^WARN.*/d' /home/huanghongyu/feed_publish/feed_republish.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/feed_publish/feed_republish.txt' INTO TABLE db_inke_pm_strategy.feed_publish_d CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"

done