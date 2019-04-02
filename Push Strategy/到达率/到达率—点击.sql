到达率仪表盘 —— 点击侧 （共5个维度）


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
       ,count(distinct z.uid) as click_uv
       ,count(distinct z.id) as click_pv
FROM
(
SELECT  ARRAY('ALL',a.client) client
        ,ARRAY('ALL',a.cv) cv
        ,ARRAY('ALL',a.ua) ua
        ,ARRAY('ALL',a.system) system
        ,ARRAY('ALL',a.texttype) texttype
        ,a.md_userid as uid 
        ,a.info_task_id id
FROM

(
SELECT md_userid
        ,info_task_id
        ,CASE WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '4' THEN 'oppo'
                WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '3' THEN 'vivo'
                WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '2' THEN 'huawei'
                WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '1' THEN 'xiaomi'
                WHEN get_json_object(md_einfo,'$.is_notify') ='0' THEN 'trans' 
                WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' THEN 'none' 
                else 'other'
                END AS texttype
        ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'andriod' 
              else 'other'
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
                when lower(ua) like '%lemobile%' then 'LeMobile' 
                 else 'other'
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
hds.view_newapplog_push_click
WHERE  ymd = '$date' AND (cv > 'IK5.2.50_Iphone' or cv > 'IK5.2.50_Andriod')
       AND (lower(info_task_id) LIKE '%groupa%' OR lower(info_task_id) LIKE '%groupb%' OR lower(info_task_id) LIKE '%groupc%'
            or lower(info_task_id) LIKE '%groupd%' OR lower(info_task_id) LIKE '%groupe%'
              OR lower(info_task_id) LIKE '%groupdvalue%' OR lower(info_task_id) LIKE '%groupdrfm%'
              or lower(info_task_id) LIKE '%groupf%' OR lower(info_task_id) LIKE '%groupg%' OR
              lower(info_task_id) LIKE '%grouph%' OR lower(info_task_id) LIKE '%groupi%' OR
              lower(info_task_id) LIKE '%groupj%' OR lower(info_task_id) LIKE '%groupk%'
              OR lower(info_task_id) LIKE '%groupl%' OR lower(info_task_id) LIKE '%groupm%' )
GROUP BY md_userid
        ,info_task_id
        ,CASE WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '4' THEN 'oppo'
                WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '3' THEN 'vivo'
                WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '2' THEN 'huawei'
                WHEN get_json_object(md_einfo,'$.is_notify') ='1'AND get_json_object(md_einfo,'$.notify_channel') = '1' THEN 'xiaomi'
                WHEN get_json_object(md_einfo,'$.is_notify') ='0' THEN 'trans' 
                WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' THEN 'none'  else 'other'
                END 
        ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'andriod'  else 'other'
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
                when lower(ua) like '%lemobile%' then 'LeMobile'  else 'other'
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

)a 
)z

LATERAL VIEW EXPLODE(z.client) a AS new_client
    LATERAL VIEW EXPLODE(z.cv) b AS new_cv
    LATERAL VIEW EXPLODE(z.ua) c AS new_ua
    LATERAL VIEW EXPLODE(z.system) d AS new_system
    LATERAL VIEW EXPLODE(z.texttype) e AS new_texttype

GROUP BY new_client 
        ,new_cv
        ,new_ua
        ,new_system
        ,new_texttype

;" >>/home/huanghongyu/push/push_arate_click.txt 
done
sed -i '/^WARN.*/d' push_click.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/push/push_arate_click.txt' INTO TABLE db_inke_pm_strategy.push_arate_click CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"







###### 建表用 #####
create table push_arate_click( 
ymd varchar(15),
client varchar(15),
cv varchar(20),
ua varchar(20),
system varchar(20),
texttype varchar(15),
click_uv bigint,
click_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 