# 发送---只有策略维度


date=`date -d "yesterday" +%Y%m%d`
for i in {0..16}
do 
date=`date -d "20180729 +$i day" +%Y%m%d`
hive -e"


SELECT  '$date'
        ,a.strategy as strategy
        ,count(distinct a.id) as send_uv
        ,count(distinct a.pushid) as send_pv
FROM
(
SELECT   id
        ,pushid
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
        WHERE  ymd = '$date' AND code = '0'
                AND (lower(pushid) LIKE '%groupa%' OR lower(pushid) LIKE '%groupb%' OR lower(pushid) LIKE '%groupc%'
            or lower(pushid) LIKE '%groupd%' OR lower(pushid) LIKE '%groupe%'
              OR lower(pushid) LIKE '%groupdvalue%' OR lower(pushid) LIKE '%groupdrfm%'
              or lower(pushid) LIKE '%groupf%' OR lower(pushid) LIKE '%groupg%' OR
              lower(pushid) LIKE '%grouph%' OR lower(pushid) LIKE '%groupi%' OR
              lower(pushid) LIKE '%groupj%' OR lower(pushid) LIKE '%groupk%'
              OR lower(pushid) LIKE '%groupl%' OR lower(pushid) LIKE '%groupm%' )
                
        GROUP BY  id
                ,pushid
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
GROUP BY a.strategy

;" >> /home/huanghongyu/push/push_send_strategy.txt
done
sed -i '/^WARN.*/d' /home/huanghongyu/push/push_send_strategy.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/push/push_send_strategy.txt' INTO TABLE db_inke_pm_strategy.push_send_strategy CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"





create table push_send_strategy( 
ymd varchar(15),
strategy varchar(20),
send_uv bigint,
send_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 




# 到达----只有策略
# 


date=`date -d "yesterday" +%Y%m%d`
for i in {0..16}
do 
date=`date -d "20180729 +$i day" +%Y%m%d`
hive -e"

SELECT  '$date'
        ,b.strategy as strategy
        ,count(distinct b.md_userid) as arrive_uv
        ,count(distinct b.info_task_id) as arrive_pv
FROM

(
SELECT md_userid
        ,info_task_id
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
GROUP BY  b.strategy

;">>/home/huanghongyu/push/push_arrive_strategy.txt
done
sed -i '/^WARN.*/d' /home/huanghongyu/push/push_arrive_strategy.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/push/push_arrive_strategy.txt' INTO TABLE db_inke_pm_strategy.push_arrive_strategy CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"



create table push_arrive_strategy( 
ymd varchar(15),
strategy varchar(20),
arrive_uv bigint,
arrive_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 


### 点击 ----只有策略

date=`date -d "yesterday" +%Y%m%d`
for i in {0..16}
do 
date=`date -d "20180729 +$i day" +%Y%m%d`
hive -e"

SELECT '$date',c.strategy as strategy
       ,count(distinct c.md_userid) as click_uv
       ,count(distinct c.info_task_id) as click_pv
FROM

(
SELECT md_userid
        ,info_task_id
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

)c

GROUP BY c.strategy

;">>/home/huanghongyu/push/push_click_strategy.txt
done
sed -i '/^WARN.*/d' /home/huanghongyu/push/push_click_strategy.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/push/push_click_strategy.txt' INTO TABLE db_inke_pm_strategy.push_click_strategy CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"



create table push_click_strategy( 
ymd varchar(15),
strategy varchar(20),
click_uv bigint,
click_pv bigint
)engine = innodb DEFAULT CHARSET=utf8; 
