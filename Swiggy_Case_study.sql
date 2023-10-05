CREATE TABLE delivery_partner(
	partner_id	int primary key not null,
	partner_name varchar
)

CREATE TABLE orders(
	order_id int primary key not null,
	user_id	int,
	r_id int ,
	amount int,
	date date,
	partner_id int,
	delivery_time int,
	delivery_rating	int,
	restaurant_rating int
)
	

CREATE TABLE menu(
	menu_id int primary key,
	r_id int,
	f_id int,
	price int
)

CREATE TABLE food(
	f_id int primary key,
	f_name varchar,
	type varchar
)
	
create table users(
	user_id	int primary key,
	name varchar,
	email varchar,
	password varchar
)

create table order_details(
	id int primary key,
	order_id int,
	f_id int
)

create table resturant(
	r_id int,
	r_name varchar,
	cuisine varchar
)



-- And we have imported data from csv files.

select * from delivery_partner
select * from food
select * from menu
select * from order_details
select * from orders
select * from users
select * from resturant
	
	
	
	
-- 1}.Find customer who had never ordered

select * from users
where user_id not in (select user_id from orders)



-- 2}.Find out average price of dish

select f_name as "Dish", round(avg(m.price),2) as "Avg dish price"
from menu m
join food f
on m.f_id = f.f_id
group by f_name	
	
	
	
	
-- 3}.Find top resturent in terms of number of orders in 6th month

select r.r_name, count(*) as "Total_No_of_orders" 
from orders o 
join resturant r
on o.r_id = r.r_id
where extract(month from o.date) = 6
group by r.r_name
order by count(*) desc
limit 1
	
	
	

-- 4}.	Find restaurants with monthly sales > 1000 for any particular month.

select r.r_name as "Resturent_name", sum(o.amount) as "Total_sale"
from orders o 
join resturant r
on r.r_id = o.r_id
where extract(month from o.date) = 7
group by r.r_name
having sum(o.amount) > 1000





-- 5}. Show all orders with order details for a perticular customer

select o.order_id, r.r_name, f.f_name
from orders o
join resturant r
on o.r_id = r.r_id
join order_details od
on od.order_id = o.order_id
join food f
on f.f_id = od.f_id
where o.user_id = (select "user_id" from users where "name" like 'Nitish' )





-- 6}.find resturent with maximun repeated orders

select r_name as "Resturant Name" , count(*) as "Total_counts" 
from (select r_id,user_id, count(*) as "Total_count"
from orders
group by r_id, user_id
having count(*) > 1) a
join resturant r
on  r.r_id = a.r_id
group by r_name
order by count(*) desc
limit 1





-- 7}.Month by Month revenue growth of swiggy


select "Month", ("Revenue" - "Prev") as "Monthly growth" from
(WITH sales as
(	
	select to_char("date", 'month') as "Month" , sum(amount) as "Revenue"
	from orders
	group by "Month"
-- order by month("date")
)
select "Month", "Revenue", lag("Revenue",1) over(order by "Revenue") as "Prev" from"sales") t






-- 8}.Customer name with there favorite food.

with temp as
(Select o.user_id, od.f_id, count(*) as "frequency"
from orders o
join order_details od
on o.order_id = od.order_id
group by o.user_id, od.f_id)

select u.name, f.f_name ,t1.frequency 
from temp t1
join users u
on u.user_id = t1.user_id
join food f
on f.f_id = t1.f_id
where t1.frequency = (select max(frequency) from temp t2
					   where t2.user_id = t1.user_id)



select * from food

-- 9}.which 2 products are order multiple times

select f.f_name , count(*) as "Times_orders"
from orders o
join order_details od
on o.order_id = od.order_id
join food f
on f.f_id = od.f_id
group by f.f_name
order by "Times_orders" desc
limit 2
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

)