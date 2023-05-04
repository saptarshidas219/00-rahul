CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 
INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

select s.userid,sum(p.price) as Total
from
sales as s
inner join
product as p
on
s.product_id=p.product_id
group by s.userid
order by Total desc

select userid,count(DISTINCT created_date) as Visits
from
sales
group by userid
select * from sales

select * from 
(select *, rank() over(partition by userid order by created_date) as Ranking
from sales) as t 
where 
t.ranking = 1

select userid,count(product_id)as counting from sales
where
product_id =(select product_id
from
sales
group by product_id
order by count(product_id) desc
limit 1)
group by userid


with mycte as (select userid,product_id,count(product_id) as cnt
from sales
group by 
userid,product_id)
select *, rank() over(partition by userid order by cnt desc) as rnk 
from mycte
order by rnk

select * from sales
select * from goldusers_signup

select c.*,rank() over (partition by userid order by created_date) rnk from
(select s.userid,s.product_id,s.created_date
from
sales as s
inner join
goldusers_signup as g
on 
s.userid=g.userid
where 
s.created_date > g.gold_signup_date
order by s.userid) as c
 


with cte as(select s.userid,s.product_id,s.created_date,g.gold_signup_date
from
sales as s
inner join
goldusers_signup as g
on 
s.userid=g.userid
where 
s.created_date < g.gold_signup_date
order by s.userid),
with cte2 as(select *,rank() over (partition by userid order by created_date desc) as ranking
from cte)
select * from cte
where 
cte.ranking=1
select * from sales
select * from product
select * from goldusers_signup


select s.userid,p.product_name,count(s.product_id) as cnt,sum(p.price) as Total_Price
from
sales as s
inner join 
product as p
on
s.product_id=p.product_id
group by
s.userid,p.product_name

select userid,count(created_date),sum(price) 
from
(with t1 as (select s.userid, s.product_id,s.created_date,g.gold_signup_date
from
sales as s
inner join
goldusers_signup as g
on
s.userid=g.userid
where
s.created_date<g.gold_signup_date)
select t1.*,product_name,price
from
t1
inner join
product as p
on
t1.product_id=p.product_id) e
group by userid


select * from sales
select * from product

select e.*, mnt/zomato as Total_points from 
(select d.*,case when product_id=1 then 5 when product_id=2 
then 2 when product_id=3 
then 5 else 0 end as zomato from
(select c.userid,c.product_id,sum(c.price) as mnt
from
(select s.*,p.price
from
sales as s
inner join
product as p
on
s.product_id = p.product_id)as c
group by c.userid,c.product_id) as d)as e
order by Total_points desc

select * from goldusers_signup


select r.*,r.price *.5 as Zomato_Point
from
(select p.*,price from
(select c.*,g.gold_signup_date
from
sales as c
inner join
goldusers_signup as g
on
c.userid=g.userid
where
c.created_date>=g.gold_signup_date
and
c.created_date<=g.gold_signup_date +365
) as p
inner join
product as q
on
p.product_id=q.product_id) as r












