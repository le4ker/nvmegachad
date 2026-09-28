select u.id,u.name,count(p.id) as posts from users u left join posts p on p.user_id=u.id where u.name like 'A%' group by u.id,u.name order by posts desc;
