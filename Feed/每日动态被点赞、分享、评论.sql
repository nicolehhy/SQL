
### 每日动态被点赞、分享、评论 以及 通过动态被关注、被曝光的数据

for i in {0..1}
do
date=`date -d "20180710 +$i day" +%Y%m%d`
date1=`date -d "$date -6 day" +%Y%m%d`
hive -e
select d.publisher_type
      ,d.level
      ,d.client
      ,e.feed_type
      ,count(distinct if(action_type = 'show',feed_uid,null)) as showuv
      ,sum(if(action_type = 'show',action_pv,0)) as showpv
      ,count(distinct case when action_type = 'like' then feed_uid end) as likeuv
      ,sum(if(action_type = 'like',action_pv,0)) as likepv
      ,count(distinct case when action_type = 'comment' then feed_uid end) as commentuv
      ,sum(if(action_type = 'comment',action_pv,0)) as commentpv
      ,count(distinct case when action_type = 'share' then feed_uid end) as shareuv
      ,sum(if(action_type = 'share',action_pv,0)) as sharepv
      ,count(distinct if(action_type = 'follow',feed_uid,null)) as follow_uv
      ,sum(if(action_type = 'follow',action_pv,0)) as followpv
from
      (select feed_uid
       ,feed_id
       ,action_type
       ,action_pv
      from
          (
            select get_json_object(md_einfo,'$.feed_uid') feed_uid
             ,get_json_object(md_einfo,'$.feed_id') feed_id
             ,case when md_eid='feed_new_like_button' then 'like'
                   when md_eid='share_click' and get_json_object(md_einfo,'$.live_type')='feed' then 'share'
                   when md_eid='feed_new_comment' then 'comment'
              end action_type
             ,count(1) action_pv
             from hds.view_newapplog_click
             where ymd=20180722 and md_eid in ('feed_new_like_button','share_click','feed_new_comment')
            group by get_json_object(md_einfo,'$.feed_uid') 
                    ,get_json_object(md_einfo,'$.feed_id') 
                    ,case when md_eid='feed_new_like_button' then 'like'
                          when md_eid='share_click' and get_json_object(md_einfo,'$.live_type')='feed' then 'share'
                          when md_eid='feed_new_comment' then 'comment'
                      end
            union all
      
            select feed_uid
                  ,feed_id
                  ,'show' as action_type
                  ,count(1) as action_pv  
            from hds.newapplog_feed_new_show
            where ymd='$date'
            group by feed_uid
                    ,feed_id
            
            union all

            select c.follow_uid as feed_uid
                  ,c.feed_id as feed_id
                  ,'follow' as action_type
                  ,sum(c.follow_pv) - sum(c.cancel_pv) as action_pv
            from
                (
                  select follow_uid
                        ,uid
                        ,if(action=1,1,0) follow_pv
                        ,if(action=2,1,0) cancel_pv
                        ,obj_id as feed_id
                  from
                  hds.newapplog_follow_user_action
                  where ymd='$date'
                  and obj_type in('feed_list','feed_info')
                  group by follow_uid,uid,if(action=1,1,0)
                          ,if(action=2,1,0) 
                          ,obj_id
                )c
            group by c.follow_uid,c.feed_id
            )a
            where action_type is not null
          )z

    inner join
    (
      select uid
            ,publisher_type
            ,level
            ,client
            ,citylevel
      from stg.user_info
      where ymd='$date' 
    )d
    on z.feed_uid = d.uid

    inner join
    (
      select actor_id
            ,entity_id 
            ,feed_type
      from 
      hds.ns_user__feed__logic__publish
      where ymd  between '$date' and '$date1' 
      group by actor_id
              ,entity_id 
              ,feed_type
    )e

    on z.feed_uid = e.actor_id and z.feed_id = e.entity_id

group by d.publisher_type
        ,d.level
        ,d.client
        ,e.feed_type

;">>/home/huanghongyu/feed_publish/feed_action.txt
#
#sed -i '/^WARN.*/d' /home/huanghongyu/feed_publish/feed_action.txt
mysql -hrm-2ze6406t9hkur76rk.mysql.rds.aliyuncs.com -P3306 -uinke_db_user -p'Nx$X6^soiPi' -e "LOAD DATA LOCAL INFILE '/home/huanghongyu/feed_publish/feed_action.txt' INTO TABLE db_inke_pm_strategy.feed_action CHARACTER SET utf8 fields terminated by '\t' lines terminated by '\n';"

done