### UGC 关怀政策次周留存率 ####

#for i in {0..28}
#do

#date=`date -d "20180620 +$i day" +%Y%m%d`
#date1=`date -d "$date +1 day" +%Y%m%d`
#date7=`date -d "$date +7 day" +%Y%m%d`

date=`date -d "20180719" +%Y%m%d`
date1=`date -d "$date +1 day" +%Y%m%d`
date7=`date -d "$date +7 day" +%Y%m%d`
hive -e"

select '$date' as ymd,count(b.smid)  as pub_uv, sum(b.pub_pv), count(d.smid)/count(b.smid) from


(select actor_id as smid,count(1) as pub_pv 
from
hds.ns_user__feed__logic__publish
where ymd = '$date'
group by actor_id
)b

left join 

(select distinct actor_id as smid 
from
hds.ns_user__feed__logic__publish
where ymd between '$date1' and '$date7'
)d

on b.smid = d.smid

;"> feed_gl.txt
sed -i '/^WARN.*/d' feed_gl.txt

sed -i '/^WARN.*/d' /home/huanghongyu/feed_publish/feed_republish.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/feed_publish/feed_republish.txt' INTO TABLE db_inke_pm_strategy.feed_republish_rec CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"

done