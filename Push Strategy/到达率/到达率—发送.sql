到达率指标（分ua,system,cv,client,texttype)

发送 ##### 



for i in {0..16}
do
date=`date -d "20180729 +$i day" +%Y%m%d`

hive -e"


SELECT  '$date'
        ,new_client 
        ,new_cv
        ,new_ua
        ,new_system
        ,new_texttype
       ,count(distinct z.uid) as push_uv
       ,count(distinct z.id) as push_pv
FROM
(
SELECT  ARRAY('ALL',b.client) client
        ,ARRAY('ALL',b.binfo_cv_last) binfo_cv_last
        ,ARRAY('ALL',b.ua) ua
        ,ARRAY('ALL',b.system) system
        ,ARRAY('ALL',a.texttype) texttype
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
              WHEN notify = '0' THEN 'trans' else 'other'
              END AS texttype
FROM
hds.view_ns_push__backend__online__business
WHERE  ymd = '$date' AND (cv > 'IK5.2.50_Iphone' or cv > 'IK5.2.50_Andriod')
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
              WHEN notify = '0' THEN 'trans' else 'other'
              END
)a

LEFT JOIN

(SELECT uid
        ,CASE WHEN lower(binfo_cv_last) LIKE '%iphone%' or lower(binfo_cv_last) LIKE '%ipad%' THEN 'ios'
              WHEN lower(binfo_cv_last) LIKE '%android' THEN 'android' else 'other'
              END AS client
        ,CASE WHEN (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%ios%')
                    OR (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%android%'
                    and (lower(binfo_ua_last) like '%iphone%' or lower(binfo_ua_last) like '%ipad%')) THEN 'fake_ios'
                when lower(binfo_ua_last) like '%iphone%' then 'iPhone'
                when lower(binfo_ua_last) like '%ipad%' then 'iPad'
                when lower(binfo_ua_last) like '%oppo%' then 'OPPO'
                when lower(binfo_ua_last) like '%vivo%' then 'VIVO'
                when lower(binfo_ua_last) like '%samsung%' then 'samsung'
                when lower(binfo_ua_last) like '%huawei%' then '华为'
                when lower(binfo_ua_last) like '%xiaomi%' then '小米'
                when lower(binfo_ua_last) like '%lenovo%' then '联想'
                when lower(binfo_ua_last) like '%meizu%' then '魅族'
                when lower(binfo_ua_last) like '%zte%' then 'ZTE'
                when lower(binfo_ua_last) like '%htc%' then 'HTC'
                when lower(binfo_ua_last) like '%gionee%' then '金立'
                when lower(binfo_ua_last) like '360%' then '360'
                when lower(binfo_ua_last) like '%lemobile%' then 'LeMobile'  else 'other'
                END AS ua
        ,CASE WHEN (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%ios%')
                    OR (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%android%'
                    and (lower(binfo_ua_last) like '%iphone%' or lower(binfo_ua_last) like '%ipad%')) THEN 'fake_ios'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_8%' then 'ios_8'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_9%' then 'ios_9'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_10%' then 'ios_10'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_11%' then 'ios_11'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_12%' then 'ios_12'
                    WHEN lower(binfo_osversion_last) LIKE '%android%' AND cast(split(binfo_osversion_last,'_')[1] as int) <15 THEN '<android4.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 15 and 19 then 'android4.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 21 and 22 then 'android5.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) =23 then 'android6.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 24 and 25 then 'android7.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 26 and 27 then 'android8.0'
                    else 'other' 
                    END AS system
        ,binfo_cv_last

FROM hdw.ul_binfo_login

WHERE ymd = '20180814' and  (binfo_cv_last > 'IK5.2.50_Iphone' or binfo_cv_last > 'IK5.2.50_Andriod')

GROUP BY uid
        ,CASE WHEN lower(binfo_cv_last) LIKE '%iphone%' or lower(binfo_cv_last) LIKE '%ipad%' THEN 'ios'
              WHEN lower(binfo_cv_last) LIKE '%android' THEN 'android' else 'other'
              END
        ,CASE WHEN (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%ios%')
                    OR (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%android%'
                    and (lower(binfo_ua_last) like '%iphone%' or lower(binfo_ua_last) like '%ipad%')) THEN 'fake_ios'
                when lower(binfo_ua_last) like '%iphone%' then 'iPhone'
                when lower(binfo_ua_last) like '%ipad%' then 'iPad'
                when lower(binfo_ua_last) like '%oppo%' then 'OPPO'
                when lower(binfo_ua_last) like '%vivo%' then 'VIVO'
                when lower(binfo_ua_last) like '%samsung%' then 'samsung'
                when lower(binfo_ua_last) like '%huawei%' then '华为'
                when lower(binfo_ua_last) like '%xiaomi%' then '小米'
                when lower(binfo_ua_last) like '%lenovo%' then '联想'
                when lower(binfo_ua_last) like '%meizu%' then '魅族'
                when lower(binfo_ua_last) like '%zte%' then 'ZTE'
                when lower(binfo_ua_last) like '%htc%' then 'HTC'
                when lower(binfo_ua_last) like '%gionee%' then '金立'
                when lower(binfo_ua_last) like '360%' then '360'
                when lower(binfo_ua_last) like '%lemobile%' then 'LeMobile'  else 'other'
                END
        ,CASE WHEN (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%ios%')
                    OR (lower(binfo_cv_last) LIKE '%android%' and lower(binfo_osversion_last) LIKE '%android%'
                    and (lower(binfo_ua_last) like '%iphone%' or lower(binfo_ua_last) like '%ipad%')) THEN 'fake_ios'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_8%' then 'ios_8'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_9%' then 'ios_9'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_10%' then 'ios_10'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_11%' then 'ios_11'
                    WHEN lower(binfo_osversion_last) LIKE '%ios_12%' then 'ios_12'
                    WHEN lower(binfo_osversion_last) LIKE '%android%' AND cast(split(binfo_osversion_last,'_')[1] as int) <15 THEN '<android4.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 15 and 19 then 'android4.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 21 and 22 then 'android5.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) =23 then 'android6.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 24 and 25 then 'android7.0'
                    WHEN cast(split(binfo_osversion_last,'_')[1] as int) between 26 and 27 then 'android8.0'
                    else 'other' 
                    END 
        ,binfo_cv_last
) b

ON a.id = b.uid

)z

LATERAL VIEW EXPLODE(z.client) r AS new_client
LATERAL VIEW EXPLODE(z.binfo_cv_last) r AS new_cv
LATERAL VIEW EXPLODE(z.ua) r AS new_ua
    LATERAL VIEW EXPLODE(z.system) s AS new_system
    LATERAL VIEW EXPLODE(z.texttype) o AS new_texttype

GROUP BY new_client 
        ,new_cv
        ,new_ua
        ,new_system
        ,new_texttype


;">> /home/yangqin/push/push_arate_send.txt
done
sed -i '/^WARN.*/d' /home/yangqin/push/push_arate_send.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/yangqin/push/push_arate_send.txt' INTO TABLE db_inke_pm_strategy.push_arate_send CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"





###### 建表用 #####
create table push_arate_send( 
ymd varchar(15),
client varchar(15),
cv varchar(20),
ua varchar(20),
system varchar(20),
texttype varchar(15),
send_uv bigint,
send_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 