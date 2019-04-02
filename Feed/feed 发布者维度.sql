date=`date -d "20180706" +%Y%m%d`
date1=`date -d "'$date' +1 day" +%Y%m%d`
date7=`date -d "'$date' +7 day" +%Y%m%d`
hive -e

select type
      ,level
      ,client
      ,citylevel
      ,feed_type
      ,base_uv
      ,base_pv
      ,changsha_uv
      ,changsha_pv
      ,beijing_uv
      ,beijing_pv
      ,beijing_rec_uv
      ,beijing_rec_pv
      ,pub_uv
      ,pub_pv
      ,next_day
      ,next_week
from

select b.publisher_type as type
      ,b.level as level 
      ,b.client as client
      ,b.citylevel as citylevel
      ,c.feed_type as feed_type
      ,count(distinct if(a.check_type = 'base',a.actor_id,null)) as base_uv
      ,sum(if(a.check_type = 'base',a.check_pv,0)) as base_pv
      ,count(distinct if(a.check_type = 'changsha',a.actor_id,null)) as changsha_uv
      ,sum(if(a.check_type = 'changsha',a.check_pv,0)) as changsha_pv
      ,count(distinct if(a.check_type = 'beijing',a.actor_id,null)) as beijing_uv
      ,sum(if(a.check_type = 'beijing',a.check_pv,0)) as beijing_pv
      ,count(distinct if(a.check_type = 'beijing_rec',a.actor_id,null)) as beijing_rec_uv
      ,sum(if(a.check_type = 'beijing_rec',a.check_pv,0)) as beijing_rec_pv
      ,count(distinct c.actor_id) as pub_uv
      ,count(distinct c.entity_id) as pub_pv
      ,count(distinct if(next = 'day',d.actor_id,null)) as next_day
      ,count(distinct if(next = 'week',d.actor_id,null)) as next_week
from

(
select actor_id
      ,entity_id
      ,case when acl_type=3 then 'base'
            when acl_type=7 then 'changsha'
            when acl_type=15 then 'beijing'
            when acl_type=31 then 'beijing_rec'
       end check_type
      ,count(1) as check_pv
from 
hds.ns_user__feed__logic__update
where ymd='$date' and acl_type in (3,7,15,31)
group by actor_id
      ,entity_id
      ,case when acl_type=3 then 'base'
            when acl_type=7 then 'changsha'
            when acl_type=15 then 'beijing'
            when acl_type=31 then 'beijing_rec'
       end
)a

right join
(
select actor_id
      ,entity_id 
      ,feed_type
from 
hds.ns_user__feed__logic__publish
where ymd ='$date'
group by actor_id
      ,entity_id 
      ,feed_type
)c
on a.actor_id = c.actor_id and a.entity_id = c.entity_id 

inner join
(
select uid
      ,publisher_type
      ,level
      ,client
      ,citylevel
from stg.user_info
where ymd='$date' 
)b
on c.actor_id = b.uid

left join
(
select actor_id
      ,case when ymd = '$date1' then 'day'
            when ymd between '$date1' and '$date7' then 'week'
            end as next
from 
hds.ns_user__feed__logic__publish
group by actor_id
      ,case when ymd = '$date1' then 'day'
            when ymd between '$date1' and '$date7' then 'week'
            end
)d
on c.actor_id = d.actor_id

group by b.publisher_type
      ,b.level
      ,b.client
      ,b.citylevel
      ,c.feed_type

union all

select 'all' as type
      ,'all' as level
      ,'all' as client
      ,'all' as citylevel
      ,'all' as feed_type
      ,count(distinct if(q.check_type = 'base',q.actor_id,null)) as base_uv
      ,sum(if(q.check_type = 'base',q.check_pv,0)) as base_pv
      ,count(distinct if(q.check_type = 'changsha',q.actor_id,null)) as changsha_uv
      ,sum(if(q.check_type = 'changsha',q.check_pv,0)) as changsha_pv
      ,count(distinct if(a.check_type = 'beijing',a.actor_id,null)) as beijing_uv
      ,sum(if(q.check_type = 'beijing',q.check_pv,0)) as beijing_pv
      ,count(distinct if(q.check_type = 'beijing_rec',q.actor_id,null)) as beijing_rec_uv
      ,sum(if(q.check_type = 'beijing_rec',q.check_pv,0)) as beijing_rec_pv
      ,count(distinct w.actor_id) as pub_uv
      ,count(distinct w.entity_id) as pub_pv
      ,count(distinct if(next = 'day',t.actor_id,null)) as next_day
      ,count(distinct if(next = 'week',t.actor_id,null)) as next_week
from
(
select actor_id
      ,entity_id
      ,case when acl_type=3 then 'base'
            when acl_type=7 then 'changsha'
            when acl_type=15 then 'beijing'
            when acl_type=31 then 'beijing_rec'
       end check_type
      ,count(1) as check_pv
from 
hds.ns_user__feed__logic__update
where ymd='$date' and acl_type in (3,7,15,31)
group by actor_id
      ,entity_id
      ,case when acl_type=3 then 'base'
            when acl_type=7 then 'changsha'
            when acl_type=15 then 'beijing'
            when acl_type=31 then 'beijing_rec'
       end
)q

right join
(
select actor_id
      ,entity_id 
      ,feed_type
from 
hds.ns_user__feed__logic__publish
where ymd ='$date'
group by actor_id
      ,entity_id 
      ,feed_type
)w
on q.actor_id = w.actor_id and q.entity_id = w.entity_id 

inner join
(
select uid
      ,publisher_type
      ,level
      ,client
      ,citylevel
from stg.user_info
where ymd='$date' 
)r
on w.actor_id = r.uid

left join
(
select actor_id
      ,case when ymd = '$date1' then 'day'
            when ymd between '$date1' and '$date7' then 'week'
            end as next
from 
hds.ns_user__feed__logic__publish
group by actor_id
      ,case when ymd = '$date1' then 'day'
            when ymd between '$date1' and '$date7' then 'week'
            end
)t
on w.actor_id = t.actor_id

group by b.publisher_type
      ,b.level
      ,b.client
      ,b.citylevel
      ,c.feed_type


