### 点击侧——总表####


date=`date -d "yesterday" +%Y%m%d`

for i in {0..16}
do
date=`date -d "20180729 +$i day" +%Y%m%d`
hive -e

SELECT '$date'
       ,new_client
       ,new_strategy
       ,new_texttype
        ,count(distinct z.uid) click_uv
        ,count(z.id) click_pv
FROM 
(
SELECT  ARRAY('ALL',a.client) client
        ,ARRAY('ALL',a.strategy) strategy
        ,ARRAY('ALL',a.texttype) texttype
        ,a.md_userid as uid 
        ,a.info_task_id as id
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
        ,CASE  WHEN (lower(cv) LIKE '%android%' and lower(cv) LIKE '%ios%')
                    OR (lower(cv) LIKE '%android%' and lower(cv) LIKE '%android%'
                    and (lower(cv) like '%iphone%' or lower(cv) like '%ipad%')) THEN 'fake_ios'
              WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'android' 
              else 'other'       
              END AS client
        ,CASE WHEN lower(info_task_id) like '%groupdvalue%' then 'GroupDVALUE'
                WHEN lower(info_task_id) like '%groupdrfm%' then 'GroupDRFM'
                WHEN lower(info_task_id) like '%groupa%' then 'GroupA'
                WHEN lower(info_task_id) like '%groupb%' then 'GroupB'
                WHEN lower(info_task_id) like '%groupc%' then 'GroupC'
                WHEN lower(info_task_id) like '%groupd%' then 'GroupD'
                WHEN lower(info_task_id) like '%groupe%' then 'GroupE'
                WHEN lower(info_task_id) like '%groupf%' then 'GroupF'
                WHEN lower(info_task_id) like '%groupg%' then 'GroupG'
                WHEN lower(info_task_id) like '%grouph%' then 'GroupH'
                WHEN lower(info_task_id) like '%groupi%' then 'GroupI'
                WHEN lower(info_task_id) like '%groupj%' then 'GroupJ'
                WHEN lower(info_task_id) like '%groupk%' then 'GroupK'
                WHEN lower(info_task_id) like '%groupl%' then 'GroupL'
                WHEN lower(info_task_id) like '%groupm%' then 'GroupM' else 'other'
                END AS strategy  

FROM 
hds.view_newapplog_push_click
WHERE  ymd = '$date' 
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
                WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' THEN 'none' 
                else 'other'
                END 
        ,CASE  WHEN (lower(cv) LIKE '%android%' and lower(cv) LIKE '%ios%')
                    OR (lower(cv) LIKE '%android%' and lower(cv) LIKE '%android%'
                    and (lower(cv) like '%iphone%' or lower(cv) like '%ipad%')) THEN 'fake_ios'
              WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'android' 
              else 'other'       
              END
        ,CASE WHEN lower(info_task_id) like '%groupdvalue%' then 'GroupDVALUE'
                WHEN lower(info_task_id) like '%groupdrfm%' then 'GroupDRFM'
                WHEN lower(info_task_id) like '%groupa%' then 'GroupA'
                WHEN lower(info_task_id) like '%groupb%' then 'GroupB'
                WHEN lower(info_task_id) like '%groupc%' then 'GroupC'
                WHEN lower(info_task_id) like '%groupd%' then 'GroupD'
                WHEN lower(info_task_id) like '%groupe%' then 'GroupE'
                WHEN lower(info_task_id) like '%groupf%' then 'GroupF'
                WHEN lower(info_task_id) like '%groupg%' then 'GroupG'
                WHEN lower(info_task_id) like '%grouph%' then 'GroupH'
                WHEN lower(info_task_id) like '%groupi%' then 'GroupI'
                WHEN lower(info_task_id) like '%groupj%' then 'GroupJ'
                WHEN lower(info_task_id) like '%groupk%' then 'GroupK'
                WHEN lower(info_task_id) like '%groupl%' then 'GroupL'
                WHEN lower(info_task_id) like '%groupm%' then 'GroupM' else 'other'
                END
)a 
)z

LATERAL VIEW EXPLODE(z.client) r AS new_client
    LATERAL VIEW EXPLODE(z.strategy) s AS new_strategy
    LATERAL VIEW EXPLODE(z.texttype) o AS new_texttype

GROUP BY new_client
       ,new_strategy
       ,new_texttype

;">> /home/huanghongyu/push/push_all_click.txt
done
sed -i '/^WARN.*/d' /home/huanghongyu/push/push_all_click.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/push/push_all_click.txt' INTO TABLE db_inke_pm_strategy.push_all_click CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"


#### 建表 #####

create table push_all_click( 
ymd varchar(15),
client varchar(15),
strategy varchar(20),
texttype varchar(15),
click_uv bigint,
click_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 