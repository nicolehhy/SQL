###### 发送侧---总表#####


for i in {0..16}
do
date=`date -d "20180729 +$i day" +%Y%m%d`
hive -e"


SELECT '$date'
       ,new_client
       ,new_strategy
       ,new_texttype
        ,count(distinct z.uid) send_uv
        ,count(distinct z.id) send_pv
FROM 

(
SELECT  ARRAY('ALL',b.client) client
        ,ARRAY('ALL',a.texttype) texttype
        ,ARRAY('ALL',a.strategy) strategy
        ,a.id as uid 
        ,a.pushid as id
FROM
(
SELECT  id
        ,pushid
        ,CASE WHEN notify = '1' and pushtype = '1' THEN 'none'
              WHEN notify = '1' and pushtype = '3'  THEN 'xiaomi'
              WHEN notify = '1' and pushtype = '8' THEN 'huawei'
              WHEN notify = '1' and pushtype = '9' THEN 'oppo' 
              WHEN notify = '0' THEN 'trans' 
              else 'other'
              END AS texttype
        ,CASE WHEN lower(aggtype) like '%groupdvalue%' then 'GroupDVALUE'
                WHEN lower(aggtype) like '%groupdrfm%' then 'GroupDRFM'
                WHEN lower(aggtype) like '%groupa%' then 'GroupA'
                WHEN lower(aggtype) like '%groupb%' then 'GroupB'
                WHEN lower(aggtype) like '%groupc%' then 'GroupC'
                WHEN lower(aggtype) like '%groupd%' then 'GroupD'
                WHEN lower(aggtype) like '%groupe%' then 'GroupE'
                WHEN lower(aggtype) like '%groupf%' then 'GroupF'
                WHEN lower(aggtype) like '%groupg%' then 'GroupG'
                WHEN lower(aggtype) like '%grouph%' then 'GroupH'
                WHEN lower(aggtype) like '%groupi%' then 'GroupI'
                WHEN lower(aggtype) like '%groupj%' then 'GroupJ'
                WHEN lower(aggtype) like '%groupk%' then 'GroupK'
                WHEN lower(aggtype) like '%groupl%' then 'GroupL'
                WHEN lower(aggtype) like '%groupm%' then 'GroupM' else 'other'
                END AS strategy 
FROM
hds.view_ns_push__backend__online__business
WHERE  ymd = '$date' 
        AND (lower(pushid) LIKE '%groupa%' OR lower(pushid) LIKE '%groupb%' OR lower(pushid) LIKE '%groupc%'
            or lower(pushid) LIKE '%groupd%' OR lower(pushid) LIKE '%groupe%'
              OR lower(pushid) LIKE '%groupdvalue%' OR lower(pushid) LIKE '%groupdrfm%'
              or lower(pushid) LIKE '%groupf%' OR lower(pushid) LIKE '%groupg%' OR
              lower(pushid) LIKE '%grouph%' OR lower(pushid) LIKE '%groupi%' OR
              lower(pushid) LIKE '%groupj%' OR lower(pushid) LIKE '%groupk%'
              OR lower(pushid) LIKE '%groupl%' OR lower(pushid) LIKE '%groupm%' )
        AND code = '0'
GROUP BY  id
        ,pushid
        ,CASE WHEN notify = '1' and pushtype = '1' THEN 'none'
              WHEN notify = '1' and pushtype = '3'  THEN 'xiaomi'
              WHEN notify = '1' and pushtype = '8' THEN 'huawei'
              WHEN notify = '1' and pushtype = '9' THEN 'oppo' 
              WHEN notify = '0' THEN 'trans' 
              else 'other'  END
        ,CASE WHEN lower(aggtype) like '%groupdvalue%' then 'GroupDVALUE'
                WHEN lower(aggtype) like '%groupdrfm%' then 'GroupDRFM'
                WHEN lower(aggtype) like '%groupa%' then 'GroupA'
                WHEN lower(aggtype) like '%groupb%' then 'GroupB'
                WHEN lower(aggtype) like '%groupc%' then 'GroupC'
                WHEN lower(aggtype) like '%groupd%' then 'GroupD'
                WHEN lower(aggtype) like '%groupe%' then 'GroupE'
                WHEN lower(aggtype) like '%groupf%' then 'GroupF'
                WHEN lower(aggtype) like '%groupg%' then 'GroupG'
                WHEN lower(aggtype) like '%grouph%' then 'GroupH'
                WHEN lower(aggtype) like '%groupi%' then 'GroupI'
                WHEN lower(aggtype) like '%groupj%' then 'GroupJ'
                WHEN lower(aggtype) like '%groupk%' then 'GroupK'
                WHEN lower(aggtype) like '%groupl%' then 'GroupL'
                WHEN lower(aggtype) like '%groupm%' then 'GroupM' else 'other'
                END
)a

INNER JOIN

(SELECT uid
        ,CASE  WHEN (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%ios%')
                    OR (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%android%'
                    and (lower(binfo_ua_last) like '%iphone%' or lower(binfo_ua_last) like '%ipad%')) THEN 'fake_ios'
              WHEN lower(binfo_cv_last) LIKE '%iphone%' or lower(binfo_cv_last) LIKE '%ipad%' THEN 'ios'
              WHEN lower(binfo_cv_last) LIKE '%android' THEN 'android' 
              else 'other'
              END AS client
FROM hdw.ul_binfo_login

WHERE ymd = '20180814' 

GROUP BY uid
        ,CASE  WHEN (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%ios%')
                    OR (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%android%'
                    and (lower(binfo_ua_last) like '%iphone%' or lower(binfo_ua_last) like '%ipad%')) THEN 'fake_ios'
              WHEN lower(binfo_cv_last) LIKE '%iphone%' or lower(binfo_cv_last) LIKE '%ipad%' THEN 'ios'
              WHEN lower(binfo_cv_last) LIKE '%android' THEN 'android' 
              else 'other'
              END
) b

ON a.id = b.uid
)z

LATERAL VIEW EXPLODE(z.client) r AS new_client
    LATERAL VIEW EXPLODE(z.strategy) s AS new_strategy
    LATERAL VIEW EXPLODE(z.texttype) o AS new_texttype


GROUP BY new_client
       ,new_strategy
       ,new_texttype


;">> push_all_send.txt
done
sed -i '/^WARN.*/d' push_all_send.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/xiangyang/push_all_send.txt' INTO TABLE db_inke_pm_strategy.push_all_send CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"





#### 建表(已建) #####

create table push_all_send( 
ymd varchar(15),
client varchar(15),
strategy varchar(20),
texttype varchar(15),
send_uv bigint,
send_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 
