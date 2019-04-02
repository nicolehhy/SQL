#### PUSH 核心指标 ####
hive -e"
SELECT P.client
        ,P.texttype
        ,P.ua
        ,P.app
        ,P.strategy
        ,P.system
        ,sum(P.push_uv) as pushuv
        ,sum(P.push_pv) as pushpv 
        ,sum(P.arrive_uv) as arriveuv 
        ,sum(P.arrive_pv) as arrivepv 
        ,sum(P.click_uv) as clickuv 
        ,sum(P.click_pv) as clickpv 
FROM
(
SELECT b.client as client
       ,'none' as  texttype
       ,a.ua as ua
       ,a.cv as app
       ,a.strategy as strategy
       ,b.system as system
       ,count(distinct a.id) as push_uv
       ,count(distinct a.pushid) as push_pv
       ,count(distinct c.md_userid) as arrive_uv
       ,count(distinct c.info_task_id) as arrive_pv
       ,count(distinct d.md_userid) as click_uv
       ,count(distinct d.info_task_id) as click_pv
FROM
(
SELECT distinct id
        ,pushid
        ,CASE WHEN lower(brand) LIKE '%iphone%' then 'iPhone'
                WHEN lower(brand) LIKE '%ipad%' then 'iPad'
                END AS ua
        ,cv
        ,CASE WHEN lower(aggtype) like'%groupa%' then 'GroupA'
        		WHEN lower(aggtype) like'%groupb%' then 'GroupB'
        		WHEN lower(aggtype) like'%groupc%' then 'GroupC'
                WHEN lower(aggtype) like'%groupd%' then 'GroupD'
        		WHEN lower(aggtype) like'%groupdvalue%' then 'GroupDVALUE'
                WHEN lower(aggtype) like'%groupdrfm%' then 'GroupDRFM'
                WHEN lower(aggtype) like'%groupe%' then 'GroupE'
                WHEN lower(aggtype) like'%groupf%' then 'GroupF'
                WHEN lower(aggtype) like'%groupg%' then 'GroupG'
                WHEN lower(aggtype) like'%grouph%' then 'GroupH'
                WHEN lower(aggtype) like'%groupi%' then 'GroupI'
                WHEN lower(aggtype) like'%groupj%' then 'GroupJ'
                WHEN lower(aggtype) like'%groupk%' then 'GroupK'
                WHEN lower(aggtype) like'%groupl%' then 'GroupL'
                WHEN lower(aggtype) like'%groupm%' then 'GroupM'
                END AS strategy 
FROM
hds.view_ns_push__backend__online__business
WHERE cv > 'IK5.0.0_Iphone'
        and pushtype ='1'
        and notify = '1'
        and ymd = 20180801
)a

INNER JOIN
(
SELECT distinct uid
      ,CASE WHEN lower(binfo_cv_last) LIKE '%iphone%' or lower(binfo_cv_last) LIKE '%ipad%' then 'IOS'
            END AS client
      ,CASE WHEN lower(binfo_osversion_last) LIKE '%ios_8%' then 'ios_8'
            WHEN lower(binfo_osversion_last) LIKE '%ios_9%' then 'ios_9'
            WHEN lower(binfo_osversion_last) LIKE '%ios_10%' then 'ios_10'
            WHEN lower(binfo_osversion_last) LIKE '%ios_11%' then 'ios_11'
            WHEN lower(binfo_osversion_last) LIKE '%ios_12%' then 'ios_12'
            END AS system
FROM 
hdw.ul_binfo_login
WHERE 
ymd = 20180801
)b
ON a.id = b.uid

LEFT JOIN
(
SELECT distinct md_userid
        ,info_task_id
FROM 
hds.view_newapplog_push_arrive
WHERE get_json_object(md_einfo,'$.source')='1'
        and ymd = 20180801
)c
ON a.id = c.md_userid

LEFT JOIN
(
SELECT distinct md_userid
        ,info_task_id
FROM
hds.view_newapplog_push_click
WHERE ymd between 20180801 and 20180802
)d 
ON c.md_userid = d.md_userid

GROUP BY b.client
       ,a.ua 
       ,a.cv 
       ,a.strategy 
       ,b.system 


UNION ALL

SELECT f.client as client
       ,e.texttype as  texttype
       ,e.ua as ua
       ,e.cv as app
       ,e.strategy as strategy
       ,f.system as system
       ,count(distinct e.id) as push_uv
       ,count(distinct e.pushid) as push_pv
       ,count(distinct g.md_userid) as arrive_uv
       ,count(distinct g.info_task_id) as arrive_pv
       ,count(distinct h.md_userid) as click_uv
       ,count(distinct h.info_task_id) as click_pv
FROM
(
SELECT distinct id
        ,pushid
        ,CASE WHEN notify = '0' and pushtype != '2' and pushtype != '3' THEN 'trans'
              WHEN notify = '0' and pushtype = '2' and push_switch = '1' or push_switch = '2' THEN 'hyper'
              WHEN notify = '0' and pushtype = '3' and push_switch = '1' or push_switch = '2' THEN 'xiaomi'
              END AS texttype
        ,case when lower(brand) like '%oppo%' then 'OPPO'
                when lower(brand) like '%vivo%' then 'VIVO'
                when lower(brand) like '%samsung%' then 'samsung'
                when lower(brand) like '%huawei%' then '华为'
                when lower(brand) like '%xiaomi%' then '小米'
                when lower(brand) like '%lenovo%' then '联想'
                when lower(brand) like '%meizu%' then '魅族'
                when lower(brand) like '%zte%' then 'ZTE'
                when lower(brand) like '%htc%' then 'HTC'
                when lower(brand) like '%gionee%' then '金立'
                when lower(brand) like '360%' then '360'
                when lower(brand) like '%lemobile%' then 'LeMobile'
                END AS ua
        ,cv
        ,CASE WHEN lower(aggtype) like'%groupa%' then 'GroupA'
        		WHEN lower(aggtype) like'%groupb%' then 'GroupB'
        		WHEN lower(aggtype) like'%groupc%' then 'GroupC'
                WHEN lower(aggtype) like'%groupd%' then 'GroupD'
        		WHEN lower(aggtype) like'%groupdvalue%' then 'GroupDVALUE'
                WHEN lower(aggtype) like'%groupdrfm%' then 'GroupDRFM'
                WHEN lower(aggtype) like'%groupe%' then 'GroupE'
                WHEN lower(aggtype) like'%groupf%' then 'GroupF'
                WHEN lower(aggtype) like'%groupg%' then 'GroupG'
                WHEN lower(aggtype) like'%grouph%' then 'GroupH'
                WHEN lower(aggtype) like'%groupi%' then 'GroupI'
                WHEN lower(aggtype) like'%groupj%' then 'GroupJ'
                WHEN lower(aggtype) like'%groupk%' then 'GroupK'
                WHEN lower(aggtype) like'%groupl%' then 'GroupL'
                WHEN lower(aggtype) like'%groupm%' then 'GroupM'
                END AS strategy  
FROM
hds.view_ns_push__backend__online__business
WHERE cv > 'IK5.0.0_Andriod'
        and ymd = 20180801
)e

INNER JOIN
(
SELECT distinct uid
      ,CASE WHEN lower(binfo_cv_last) LIKE '%android%' THEN 'Andriod'
            END AS client
      ,binfo_osversion_last AS system
FROM 
hdw.ul_binfo_login 
WHERE 
ymd = 20180801 and lower(binfo_osversion_last) LIKE '%android%'
)f
ON e.id = f.uid

LEFT JOIN
(
SELECT  distinct md_userid
        ,info_task_id
FROM 
hds.view_newapplog_push_arrive
WHERE ymd = 20180801
)g
ON e.id = g.md_userid

LEFT JOIN
(
SELECT distinct md_userid
        ,info_task_id
FROM
hds.view_newapplog_push_click
WHERE ymd between 20180801 and 20180802
)h
ON g.md_userid = h.md_userid

GROUP BY f.client
       ,e.texttype 
       ,e.ua 
       ,e.cv 
       ,e.strategy 
       ,f.system 

UNION ALL

SELECT j.client as client
       ,i.texttype as  texttype
       ,i.ua as ua
       ,i.cv as app
       ,i.strategy as strategy
       ,j.system as system
       ,count(distinct i.id) as push_uv
       ,count(distinct i.pushid) as push_pv
       ,count(distinct k.uid) as arrive_uv
       ,count(distinct k.pushid) as arrive_pv
       ,count(distinct l.md_userid) as click_uv
       ,count(distinct l.info_task_id) as click_pv
FROM
(
SELECT distinct id
        ,pushid
        ,CASE WHEN notify = '1' and pushtype = '3'  THEN 'noti_xiaomi'
              WHEN notify = '1' and pushtype = '8' THEN 'noti_hw'
              WHEN notify = '1' and pushtype = '9' THEN 'noti_oppo'
              END AS texttype
        ,case when lower(brand) like '%oppo%' then 'OPPO'
                when lower(brand) like '%vivo%' then 'VIVO'
                when lower(brand) like '%samsung%' then 'samsung'
                when lower(brand) like '%huawei%' then '华为'
                when lower(brand) like '%xiaomi%' then '小米'
                when lower(brand) like '%lenovo%' then '联想'
                when lower(brand) like '%meizu%' then '魅族'
                when lower(brand) like '%zte%' then 'ZTE'
                when lower(brand) like '%htc%' then 'HTC'
                when lower(brand) like '%gionee%' then '金立'
                when lower(brand) like '360%' then '360'
                when lower(brand) like '%lemobile%' then 'LeMobile'
                END AS ua
        ,cv
        ,CASE WHEN lower(aggtype) like'%groupa%' then 'GroupA'
        		WHEN lower(aggtype) like'%groupb%' then 'GroupB'
        		WHEN lower(aggtype) like'%groupc%' then 'GroupC'
                WHEN lower(aggtype) like'%groupd%' then 'GroupD'
        		WHEN lower(aggtype) like'%groupdvalue%' then 'GroupDVALUE'
                WHEN lower(aggtype) like'%groupdrfm%' then 'GroupDRFM'
                WHEN lower(aggtype) like'%groupe%' then 'GroupE'
                WHEN lower(aggtype) like'%groupf%' then 'GroupF'
                WHEN lower(aggtype) like'%groupg%' then 'GroupG'
                WHEN lower(aggtype) like'%grouph%' then 'GroupH'
                WHEN lower(aggtype) like'%groupi%' then 'GroupI'
                WHEN lower(aggtype) like'%groupj%' then 'GroupJ'
                WHEN lower(aggtype) like'%groupk%' then 'GroupK'
                WHEN lower(aggtype) like'%groupl%' then 'GroupL'
                WHEN lower(aggtype) like'%groupm%' then 'GroupM'
                END AS strategy 
FROM
hds.view_ns_push__backend__online__business
WHERE cv > 'IK5.0.0_Andriod'
        and ymd = 20180801
)i

INNER JOIN
(
SELECT distinct uid
      ,CASE WHEN lower(binfo_cv_last) LIKE '%android%' THEN 'Andriod'
            END AS client
      ,binfo_osversion_last AS system
FROM 
hdw.ul_binfo_login 
WHERE 
ymd = 20180801 and lower(binfo_osversion_last) LIKE '%android%'
)j
ON i.id = j.uid

LEFT JOIN
(
SELECT  distinct uid
        ,pushid
FROM 
hds.view_ns_push__receipt__online__receipt
WHERE ymd = 20180801
)k
ON i.id = k.uid

LEFT JOIN
(
SELECT distinct md_userid
        ,info_task_id
FROM
hds.view_newapplog_push_click
WHERE ymd between 20180801 and 20180802
)l
ON k.uid = l.md_userid

GROUP BY j.client 
       ,i.texttype 
       ,i.ua 
       ,i.cv 
       ,i.strategy 
       ,j.system 

UNION ALL


SELECT 'all' as client
       ,'all' as  texttype
       ,'all' as ua
       ,'all' as app
       ,'all' as strategy
       ,'all' as system
       ,count(distinct m.id) as push_uv
       ,count(distinct m.pushid) as push_pv
       ,count(distinct n.md_userid) as arrive_uv
       ,count(distinct n.info_task_id) as arrive_pv
       ,count(distinct o.md_userid) as click_uv
       ,count(distinct o.info_task_id) as click_pv
FROM

(
SELECT distinct id
        ,pushid
FROM
hds.view_ns_push__backend__online__business
WHERE cv > 'IK5.0.0_Andriod' and cv > 'IK5.0.0_Iphone'
        and ymd = 20180801
)m

LEFT JOIN
(
SELECT  distinct md_userid
        ,info_task_id
FROM 
hds.view_newapplog_push_arrive
WHERE ymd = 20180801
)n
ON m.id = n.md_userid

LEFT JOIN
(
SELECT distinct md_userid
        ,info_task_id
FROM
hds.view_newapplog_push_click
WHERE ymd between 20180801 and 20180802
)o
ON n.md_userid = o.md_userid
)P

GROUP BY P.client
        ,P.texttype
        ,P.ua
        ,P.app
        ,P.strategy
        ,P.system
;" > attend.txt