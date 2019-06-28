### This part shows the customer behavior in different client( 'Andriod' and 'ios')

### The syntax below involves 'partion' and here is a simple example how to create a partioning-date table. When we partion date 
### into every year, we can select the data more efficiently. 
# example for how to partiton the table based on time
CREATE TABLE part_date3
    ->      (  c1 int default NULL,
    ->  c2 varchar(30) default NULL,
    ->  c3 date default NULL) engine=myisam
    ->      partition by range (to_days(c3))
    -> (PARTITION p0 VALUES LESS THAN (to_days('1995-01-01')),
    -> PARTITION p1 VALUES LESS THAN (to_days('1996-01-01')) ,
    -> PARTITION p2 VALUES LESS THAN (to_days('1997-01-01')) ,
    -> PARTITION p3 VALUES LESS THAN (to_days('1998-01-01')) ,
    -> PARTITION p4 VALUES LESS THAN (to_days('1999-01-01')) ,
    -> PARTITION p5 VALUES LESS THAN (to_days('2000-01-01')) ,
    -> PARTITION p6 VALUES LESS THAN (to_days('2001-01-01')) ,
    -> PARTITION p7 VALUES LESS THAN (to_days('2002-01-01')) ,
    -> PARTITION p8 VALUES LESS THAN (to_days('2003-01-01')) ,
    -> PARTITION p9 VALUES LESS THAN (to_days('2004-01-01')) ,
    -> PARTITION p10 VALUES LESS THAN (to_days('2010-01-01')),
    -> PARTITION p11 VALUES LESS THAN MAXVALUE );
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
############################################## 
## Here is the code I used for this project ## 
############################################## 

### Set The Environment in HIVE ###
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
