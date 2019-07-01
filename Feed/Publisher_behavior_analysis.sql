
################
## Background ##
################

This is a analysis need from Operations Department to analyze if the users like the new feature of 'posting feed'. 
Here I needed to focused on the user_level, the content they posted, the pass-rate of their posts, how other users react to their posts
and how often they use these fearture. 

##########
## Code ##
##########

(select uid, case when type = 1 then 'platform'
when type = 2 then 'catch' 
when type = 3 then 'bring'
#when type is not null then 'all' end as publisher_type,
case when level = S then 'S'
when level = A then 'A'
when level = B then 'B'
when level = B- then 'B-'
when level = C then 'C'
when level = D then 'D'
when level = N then 'N'
#when level is not null then 'all' end as publisher_level,
case when client = android then 'android'
when client = ios then 'ios'
whenn client is not null then 'all' end as client,
case when citylevel = 1 then '1'
when citylevel = 2 then '2'
when citylevel = 3 then '2'
when citylevel = 0 then 'other'
#when citylevel is not null then 'all' end as citylevel
from stg.user_info
where ymd = $date
group by uid,publisher_type,publisher_level,client,citylevel)a

# 图文视频
inner join 
(select actor_id, 
case when feed_type=1 then 'word'
when feed_type=2 then 'picture'
when feed_type=3 then 'wor_pic'
when feed_type=4 then 'video'
when feed_type=5 then 'wor_video'
when feed_type is not null then 'all' end as feed_type,
count(actor_id) as pub_pv
from 
hds.ns_user__feed__logic__publish
where ymd=$date
group by actor_id, feed_type)b
on a.uid = b.actor_id
# 审核

left join 
(select actor_id, count(distinct case when acl_type = 3 then actor_id else null end) as baseline_uv,
count(case when acl_type = 3 then actor_id else null end) as baseline,
count(distinct case when acl_type = 7 then actor_id else null end) as changsha_uv,
count(case when acl_type = 7 then actor_id else null end) as changsha_line,
count(distinct case when acl_type = 15 then actor_id else null end) as beijing_uv,
count(case when acl_type = 15 then actor_id else null end) as beijing_line,
count(distinct case when acl_type = 31 then actor_id else null end) as beijing_rec_uv,
count(case when acl_type = 31 then actor_id else null end) as beijing_rec,
(changsha_uv - beijing_rec_uv - beijing_uv) as beijing_fail_uv,
(changsha_line - beijing_line - beijing_rec) as beijing_fail
from
hds.ns_user__feed__logic__update
where ymd=$date
group by actor_id)c
on a.uid = c.actor_id

# 曝光
left join
(select feed_uid, count(distinct feed_id) as feshow_pv from hds.newapplog_feed_new_show
where ymd=$date 
group by feed_uid)d
on c.actor_id = d.fee_uid

# 点赞、评论、分享

left join 
(select md_userid, count(md_userid) as likepv from
hds.view_newapplog_click
where md_eid="feed_new_like_button" and ymd=$date)o
on c.actor_id = o.md_userid

left join
(select md_userid, count(md_userid) as commentpv from
hds.view_newapplog_click
where md_eid="feed_new_comment" and ymd=$date)p
on c.actor_id = p.md_userid

left join
(select md_userid, count(md_userid) as sharepv from
hds.view_newapplog_click
where md_eid="share_click" and get_json_object(md_einfo,'$.live_type')='feed' and ymd=$date)q
on c.actor_id = q.md_userid
# 关注

left join
(select follow_uid, (sum(followpv) - sum(cancelpv)) as follow_pv
from
(select follow_uid,uid, count(distinct case when action = 1 then uid end) as followpv,
count(distinct case when action = 2 then uid end) as cancelpv,
followpv - cancelpv as 
hds.newapplog_follow_user_action
where get_json_object(md_einfo,'$.obj_type') in ('feed_list','feed_info','user_feed','feed')
group by follow_uid,uid
)f
group by follow_uid)r
on c.actor_id = r.follow_uid

# 次日、次周
left join
(select actor_id, count(distinct actor_id) as repub from hds.ns_user__feed__logic__publish
where ymd=$date1 
group by actor_id)s
on c.actor_id = s.actor_id

left join
(select actor_id, count(distinct actor_id) as repub_week from hds.ns_user__feed__logic__publish
where ymd between $date1 and $date7
group by actor_id)t
on c.actor_id = t.actor_id
