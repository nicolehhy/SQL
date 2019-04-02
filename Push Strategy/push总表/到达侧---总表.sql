###### 到达侧---总表#####

date=`date -d "yesterday" +%Y%m%d`

for i in {0..16}
do 
date=`date -d "20180729 +$i day" +%Y%m%d`
hive -e

SELECT '$date'
       ,new_client
       ,new_strategy
       ,new_texttype
        ,count(distinct z.uid) arrive_uv
        ,count(distinct z.id) arrive_pv
FROM 

(
SELECT  ARRAY('ALL',b.client) client
        ,ARRAY('ALL',b.strategy) as strategy
        ,ARRAY('ALL',b.texttype) as texttype
        ,b.md_userid as uid
        ,b.info_task_id as id
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
hds.view_newapplog_push_arrive
WHERE ymd = '$date'
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
                WHEN get_json_object(md_einfo,'$.source') = '1' THEN 'none'   else 'other' END             
         ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'android' else 'other'    
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

UNION ALL


SELECT  uid as md_userid
        ,pushid as info_task_id
        ,CASE WHEN status= 0 AND pushtype ='3' THEN 'xiaomi'
                WHEN status= 0 AND pushtype ='8' THEN 'huawei'
                WHEN status= 0 AND pushtype ='9' THEN 'oppo' else 'other'
                END AS texttype
        ,CASE WHEN lower(cv) LIKE '%iphone%' or lower(cv) LIKE '%ipad%' then 'ios'
              WHEN lower(cv) LIKE '%android%' THEN 'android' else 'other'                     
              END AS client
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
hds.view_ns_push__receipt__online__receipt
WHERE ymd = '$date' 
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
              WHEN lower(cv) LIKE '%android%' THEN 'android' else 'other'                     
              END
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
)b


)z


LATERAL VIEW EXPLODE(z.client) r AS new_client
    LATERAL VIEW EXPLODE(z.strategy) s AS new_strategy
    LATERAL VIEW EXPLODE(z.texttype) o AS new_texttype


GROUP BY new_client
       ,new_strategy
       ,new_texttype

;">> /home/huanghongyu/push/push_all_arrive.txt

done
sed -i '/^WARN.*/d' /home/huanghongyu/push/push_all_arrive.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/push/push_all_arrive.txt' INTO TABLE db_inke_pm_strategy.push_all_arrive CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"




#### 建表 #####

create table push_all_arrive( 
ymd varchar(15),
client varchar(15),
strategy varchar(20),
texttype varchar(15),
arrive_uv bigint,
arrive_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 