
到达

 ##### PUSH 到达 #####
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
       ,count(distinct y.uid) as arrive_uv
       ,count(distinct y.id) as arrive_pv
FROM
(
SELECT  ARRAY('ALL',m.client) client
        ,ARRAY('ALL',m.cv) cv
        ,ARRAY('ALL',m.ua) ua
        ,ARRAY('ALL',m.system) system
        ,ARRAY('ALL',m.texttype) texttype
        ,m.md_userid as uid 
        ,m.info_task_id as id

FROM
(
SELECT md_userid
        ,info_task_id
        ,CASE WHEN get_json_object(md_einfo,'$.source') IN ('2','3','5','6') THEN 'trans'
                WHEN get_json_object(md_einfo,'$.source') = '1' THEN 'none'   else 'other'              
                END AS texttype
        ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'android' else 'other'
              END AS client
        ,CASE WHEN (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%ios%')
                    OR (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%android%'
                    and (lower(ua) like '%iphone%' or lower(ua) like '%ipad%')) THEN 'fake_ios'
                when lower(ua) like '%iphone%' then 'iPhone'
                when lower(ua) like '%ipad%' then 'iPad'
                when lower(ua) like '%oppo%' then 'OPPO'
                when lower(ua) like '%vivo%' then 'VIVO'
                when lower(ua) like '%samsung%' then 'samsung'
                when lower(ua) like '%huawei%' then '华为'
                when lower(ua) like '%xiaomi%' then '小米'
                when lower(ua) like '%lenovo%' then '联想'
                when lower(ua) like '%meizu%' then '魅族'
                when lower(ua) like '%zte%' then 'ZTE'
                when lower(ua) like '%htc%' then 'HTC'
                when lower(ua) like '%gionee%' then '金立'
                when lower(ua) like '360%' then '360'
                when lower(ua) like '%lemobile%' then 'LeMobile' else 'other'
                END AS ua
        ,CASE WHEN (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%ios%')
                    OR (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%android%'
                    and (lower(ua) like '%iphone%' or lower(ua) like '%ipad%')) THEN 'fake_ios'
                    WHEN lower(osversion) LIKE '%ios_8%' then 'ios_8'
                    WHEN lower(osversion) LIKE '%ios_9%' then 'ios_9'
                    WHEN lower(osversion) LIKE '%ios_10%' then 'ios_10'
                    WHEN lower(osversion) LIKE '%ios_11%' then 'ios_11'
                    WHEN lower(osversion) LIKE '%ios_12%' then 'ios_12'
                    WHEN lower(osversion) LIKE '%android%' AND cast(split(osversion,'_')[1] as int) <15 THEN '<android4.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 15 and 19 then 'android4.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 21 and 22 then 'android5.0'
                    WHEN cast(split(osversion,'_')[1] as int) =23 then 'android6.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 24 and 25 then 'android7.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 26 and 27 then 'android8.0'
                    else 'other' 
                    END AS system
        ,cv 
FROM 
hds.view_newapplog_push_arrive
WHERE ymd = '$date'
        and 
        (cv > 'IK5.2.50_Iphone' 
        or cv > 'IK5.2.50_Andriod')
        and (lower(info_task_id) LIKE '%groupa%' OR lower(info_task_id) LIKE '%groupb%' OR lower(info_task_id) LIKE '%groupc%'
            or lower(info_task_id) LIKE '%groupd%' OR lower(info_task_id) LIKE '%groupe%'
              OR lower(info_task_id) LIKE '%groupdvalue%' OR lower(info_task_id) LIKE '%groupdrfm%'
              or lower(info_task_id) LIKE '%groupf%' OR lower(info_task_id) LIKE '%groupg%' OR
              lower(info_task_id) LIKE '%grouph%' OR lower(info_task_id) LIKE '%groupi%' OR
              lower(info_task_id) LIKE '%groupj%' OR lower(info_task_id) LIKE '%groupk%'
              OR lower(info_task_id) LIKE '%groupl%' OR lower(info_task_id) LIKE '%groupm%' )
GROUP BY md_userid
        ,info_task_id
        ,CASE WHEN get_json_object(md_einfo,'$.source') IN ('2','3','5','6') THEN 'trans'
                WHEN get_json_object(md_einfo,'$.source') = '1' THEN 'none'   else 'other'              
                END
        ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'android' else 'other'
              END 
        ,CASE WHEN (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%ios%')
                    OR (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%android%'
                    and (lower(ua) like '%iphone%' or lower(ua) like '%ipad%')) THEN 'fake_ios'
                when lower(ua) like '%iphone%' then 'iPhone'
                when lower(ua) like '%ipad%' then 'iPad'
                when lower(ua) like '%oppo%' then 'OPPO'
                when lower(ua) like '%vivo%' then 'VIVO'
                when lower(ua) like '%samsung%' then 'samsung'
                when lower(ua) like '%huawei%' then '华为'
                when lower(ua) like '%xiaomi%' then '小米'
                when lower(ua) like '%lenovo%' then '联想'
                when lower(ua) like '%meizu%' then '魅族'
                when lower(ua) like '%zte%' then 'ZTE'
                when lower(ua) like '%htc%' then 'HTC'
                when lower(ua) like '%gionee%' then '金立'
                when lower(ua) like '360%' then '360'
                when lower(ua) like '%lemobile%' then 'LeMobile' else 'other'
                END 
        ,CASE WHEN (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%ios%')
                    OR (lower(cv) LIKE '%android%' and lower(osversion) LIKE '%android%'
                    and (lower(ua) like '%iphone%' or lower(ua) like '%ipad%')) THEN 'fake_ios'
                    WHEN lower(osversion) LIKE '%ios_8%' then 'ios_8'
                    WHEN lower(osversion) LIKE '%ios_9%' then 'ios_9'
                    WHEN lower(osversion) LIKE '%ios_10%' then 'ios_10'
                    WHEN lower(osversion) LIKE '%ios_11%' then 'ios_11'
                    WHEN lower(osversion) LIKE '%ios_12%' then 'ios_12'
                    WHEN lower(osversion) LIKE '%android%' AND cast(split(osversion,'_')[1] as int) <15 THEN '<android4.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 15 and 19 then 'android4.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 21 and 22 then 'android5.0'
                    WHEN cast(split(osversion,'_')[1] as int) =23 then 'android6.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 24 and 25 then 'android7.0'
                    WHEN cast(split(osversion,'_')[1] as int) between 26 and 27 then 'android8.0'
                    else 'other' 
                    END
        ,cv 

UNION ALL

SELECT z.md_userid as md_userid
        ,z.info_task_id as info_task_id
        ,z.texttype as texttype
        ,z.client as client
        ,b.ua as ua
        ,b.system as system
        ,z.cv as cv 
FROM
(
SELECT  uid as md_userid
        ,pushid as info_task_id
        ,CASE WHEN status= 0 AND pushtype ='3' THEN 'xiaomi'
                WHEN status= 0 AND pushtype ='8' THEN 'huawei'
                WHEN status= 0 AND pushtype ='9' THEN 'oppo' else 'other'
                END AS texttype
        ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'andriod' else 'other'
              END AS client
        ,cv 

FROM 
hds.view_ns_push__receipt__online__receipt
WHERE ymd = '$date' 
        and 
        (cv > 'IK5.2.50_Iphone' 
        or cv > 'IK5.2.50_Andriod')
        AND (lower(aggtype) LIKE '%groupa%' OR lower(aggtype) LIKE '%groupb%' OR lower(aggtype) LIKE '%groupc%'
            or lower(aggtype) LIKE '%groupd%' OR lower(aggtype) LIKE '%groupe%'
              OR lower(aggtype) LIKE '%groupdvalue%' OR lower(aggtype) LIKE '%groupdrfm%'
              or lower(aggtype) LIKE '%groupf%' OR lower(aggtype) LIKE '%groupg%' OR
              lower(aggtype) LIKE '%grouph%' OR lower(aggtype) LIKE '%groupi%' OR
              lower(aggtype) LIKE '%groupj%' OR lower(aggtype) LIKE '%groupk%'
              OR lower(aggtype) LIKE '%groupl%' OR lower(aggtype) LIKE '%groupm%' )
GROUP BY uid       
        ,pushid
        ,CASE WHEN status= 0 AND pushtype ='3' THEN 'xiaomi'
                WHEN status= 0 AND pushtype ='8' THEN 'huawei'
                WHEN status= 0 AND pushtype ='9' THEN 'oppo' else 'other'
                END
        ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'andriod' else 'other'
              END  
        ,cv 
)z

LEFT JOIN

(SELECT uid
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
                when lower(binfo_ua_last) like '%lemobile%' then 'LeMobile' else 'other'
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

FROM hdw.ul_binfo_login

WHERE ymd = '20180814' and  (binfo_cv_last > 'IK5.2.50_Iphone' or binfo_cv_last > 'IK5.2.50_Andriod')

GROUP BY uid
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
                when lower(binfo_ua_last) like '%lemobile%' then 'LeMobile' else 'other'
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

) b
ON z.md_userid = b.uid

)m 
)y
LATERAL VIEW EXPLODE(y.client) r AS new_client
LATERAL VIEW EXPLODE(y.cv) r AS new_cv
LATERAL VIEW EXPLODE(y.ua) r AS new_ua
    LATERAL VIEW EXPLODE(y.system) s AS new_system
    LATERAL VIEW EXPLODE(y.texttype) o AS new_texttype

GROUP BY new_client 
        ,new_cv
        ,new_ua
        ,new_system
        ,new_texttype


;">>/home/yangqin/push/push_arate_arrive.txt
done
sed -i '/^WARN.*/d' /home/yangqin/push/push_arate_arrive.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/yangqin/push/push_arate_arrive.txt' INTO TABLE db_inke_pm_strategy.push_arate_arrive CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"







#### 建表 #####


create table push_arate_arrive( 
ymd varchar(15),
client varchar(15),
cv varchar(20),
ua varchar(20),
system varchar(20),
texttype varchar(15),
arrive_uv bigint,
arrive_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 