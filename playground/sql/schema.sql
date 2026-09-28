create table users(id integer primary key,name text not null,created_at timestamp default current_timestamp);
create table posts(id integer primary key,user_id integer references users(id),title text);
