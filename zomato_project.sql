use Zomato_Analysis

--Zomato Data analysis using sql

drop table if exists orders
drop table if exists customers
drop table if exists restaurants
drop table if exists riders
drop table if exists deliveries

create table customers(
                       customer_id int primary key,
					   customer_name varchar(30),
					   reg_date date
					   )



create table restaurants(
                       restaurant_id int primary key,
					   restaurant_name varchar(50),
					   city varchar(20),
					   opening_hours varchar(50)
					   )


create table orders(
                       order_id int primary key,
					   customer_id int ,--this is coming from cust_table
					   restaurant_id int ,--this is coming from rest_table
					   order_item varchar(50),
					   order_date date,
					   order_time time,
					   order_status varchar(20),
					   total_amount float
					   )

--adding FK constraints

alter table orders
add constraint fk_customers
foreign key(customer_id)
references customers(customer_id)

alter table orders
add constraint fk_restaurant
foreign key(restaurant_id)
references restaurants(restaurant_id)


create table riders(
                      rider_id int primary key,
					  rider_name varchar(50),
					  sign_up date
					)



create table deliveries(
						  delivery_id int primary key,
						  order_id int,--thi is coming from orders table
						  delivery_status varchar(20),
						  delivery_time time,
						  rider_id int--this is coming from riders table
						  constraint fk_orders foreign key(order_id) references orders(order_id),
						  constraint fk_riders foreign key(rider_id) references riders(rider_id)
					    )


/*
alter table deliveries
add constraint fk_orders
foreign key(order_id)
references orders(order_id)

alter table deliveries
add constraint fk_riders
foreign key(rider_id)
references riders(rider_id)

drop table customers

*/


--Inserting data from csv files

BULK INSERT customers
FROM 'C:\Users\santh\OneDrive\Desktop\Zomato_sql\datasets-20241220T055446Z-001\datasets\customers.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Comma as field delimiter
    ROWTERMINATOR = '\n',  -- Newline as row delimiter
    FIRSTROW = 2           -- Skip the header row
);

BULK INSERT restaurants
FROM 'C:\Users\santh\OneDrive\Desktop\Zomato_sql\datasets-20241220T055446Z-001\datasets\restaurants.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Comma as field delimiter
    ROWTERMINATOR = '\n',  -- Newline as row delimiter
    FIRSTROW = 2           -- Skip the header row
);

BULK INSERT orders
FROM 'C:\Users\santh\OneDrive\Desktop\Zomato_sql\datasets-20241220T055446Z-001\datasets\orders.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Comma as field delimiter
    ROWTERMINATOR = '\n',  -- Newline as row delimiter
    FIRSTROW = 2           -- Skip the header row
);


BULK INSERT riders
FROM 'C:\Users\santh\OneDrive\Desktop\Zomato_sql\datasets-20241220T055446Z-001\datasets\riders.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Comma as field delimiter
    ROWTERMINATOR = '\n',  -- Newline as row delimiter
    FIRSTROW = 2           -- Skip the header row
);


BULK INSERT deliveries
FROM 'C:\Users\santh\OneDrive\Desktop\Zomato_sql\datasets-20241220T055446Z-001\datasets\deliveries.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Comma as field delimiter
    ROWTERMINATOR = '\n',  -- Newline as row delimiter
    FIRSTROW = 2, -- Skip the header row
	keepnulls
);




select* from customers
select* from restaurants
select* from orders
select* from riders
select* from deliveries


--Handling null values

select count(*)
from customers
where customer_name is null
       or
	  reg_date is null



select count(*)
from restaurants
where restaurant_name is null
       or
	  city is null
	  or
	  opening_hours is null


select count(*)
from orders
where
	  order_item is null
	  or
	  order_date is null
	  or
	  order_time is null
	  or
	  order_status is null
	  or
	  total_amount is null

--Advanced Business Problems

--Q1. Top 5 Most Frequently Ordered Dishes
--Write a query to find the top 5 most frequently ordered dishes by the customer "Arjun Mehta" in the last 2 year.


select top 5 order_item,count(order_item) as No_of_times_ordered,DENSE_RANK() over(order by count(*) desc) as rank
			from orders o
			join customers c on c.customer_id= o.customer_id
			where c.customer_name='Arjun Mehta'
				  and
				  o.order_date >=dateadd(year,-2,getdate())	  
			group by order_item



--Q2. Popular Time Slots
--Identify the time slots during which the most orders are placed, based on 2-hour intervals.

select 
	   case
	      when datepart(hour,order_time) between 0 and 1 then '00:00-02:00'
		  when datepart(hour,order_time) between 2 and 3 then '02:00-04:00'
		  when datepart(hour,order_time) between 4 and 5 then '04:00-06:00'
		  when datepart(hour,order_time) between 6 and 7 then '06:00-08:00'
		  when datepart(hour,order_time) between 8 and 9 then '08:00-10:00'
		  when datepart(hour,order_time) between 10 and 11 then '10:00-12:00'
		  when datepart(hour,order_time) between 12 and 13 then '12:00-14:00'
		  when datepart(hour,order_time) between 14 and 15 then '14:00-16:00'
		  when datepart(hour,order_time) between  16 and 17 then '16:00-18:00'
		  when datepart(hour,order_time) between 18 and 19 then '18:00-20:00'
		  when datepart(hour,order_time) between 20 and 21 then '20:00-22:00'
		  when datepart(hour,order_time) between 22 and 23 then '22:00-00:00'
	   end as time_slot,
	   count(order_id) as order_count
from orders
group by 
       case
	      when datepart(hour,order_time) between 0 and 1 then '00:00-02:00'
		  when datepart(hour,order_time) between 2 and 3 then '02:00-04:00'
		  when datepart(hour,order_time) between 4 and 5 then '04:00-06:00'
		  when datepart(hour,order_time) between 6 and 7 then '06:00-08:00'
		  when datepart(hour,order_time) between 8 and 9 then '08:00-10:00'
		  when datepart(hour,order_time) between 10 and 11 then '10:00-12:00'
		  when datepart(hour,order_time) between 12 and 13 then '12:00-14:00'
		  when datepart(hour,order_time) between 14 and 15 then '14:00-16:00'
		  when datepart(hour,order_time) between  16 and 17 then '16:00-18:00'
		  when datepart(hour,order_time) between 18 and 19 then '18:00-20:00'
		  when datepart(hour,order_time) between 20 and 21 then '20:00-22:00'
		  when datepart(hour,order_time) between 22 and 23 then '22:00-00:00'
	   end
order by order_count desc 

--Other approach using floor 


select
       floor(datepart(hour,order_time)/2)*2 as start_time,
	   floor(datepart(hour,order_time)/2)*2 +2 as end_time,
	   count(*) as total_orders
from orders
group by floor(datepart(hour,order_time)/2)*2 ,floor(datepart(hour,order_time)/2)*2 +2
order by count(*) desc




--Q3. Order Value Analysis

--Find the average order value (AOV) per customer who has placed more than 750 orders.
--Return: customer_name, aov (average order value).


select c.customer_name,
       --o.customer_id,
	   AVG(o.total_amount) as avg_order_value,
	   count(o.order_id) as total_orders
from orders o
join customers c on c.customer_id=o.customer_id		
group by c.customer_name
having count(o.order_id)>750



--Q4. High-Value Customers
--List the customers who have spent more than 100K in total on food orders.
--Return: customer_name, customer_id.

select c.customer_name,
	   sum(o.total_amount) as total_spent
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_name
having sum(o.total_amount)>100000

select * from customers
select * from orders
select*from restaurants

select * 
from orders o
right join customers c on c.customer_id=o.customer_id
order by order_id DESC



--Q5. Orders Without Delivery
--Write a query to find orders that were placed but not delivered.
--Return: restaurant_name, city, and the number of not delivered orders.

select r.restaurant_name,count(o.order_status) as orders_not_delivered
from orders o
join restaurants r on r.restaurant_id=o.restaurant_id
group by o.order_status,r.restaurant_name
having o.order_status='Not Fulfilled'
order by count(o.order_status) desc



--Q6. Restaurant Revenue Ranking

--Rank restaurants by their total revenue from the last year.
--Return: restaurant_name, total_revenue, and their rank within their city.

with ranking_table
as
(
		select r.city,
			   r.restaurant_name,
			   sum(o.total_amount) as total_revenue,
			   RANK() over(partition by r.city order by sum(o.total_amount) desc) as rank
		from orders o
		join restaurants r on r.restaurant_id=o.restaurant_id
		group by r.restaurant_name,r.city
)
select *
from ranking_table
where rank=1

--Q7. Most Popular Dish by City
--Identify the most popular dish in each city based on the number of orders.

with ordered_times
as
(
		select r.city,
			   o.order_item,
			   count(o.order_item) as ordered_times,
			   rank() over(partition by r.city order by count(o.order_item)desc) as rank
		from orders o
		join restaurants r on r.restaurant_id=o.restaurant_id
		group by r.city,o.order_item
)

select*
from ordered_times
where rank=1


--Q8. Customer Churn
--Find customers who haven’t placed an order in 2024 but did in 2023.


select distinct c.customer_name,o.customer_id
from orders o
join customers c on c.customer_id=o.customer_id
where year(o.order_date)=2023 
            and
	  o.customer_id not in (select distinct customer_id
	                      from orders
						  where year(order_date)=2024)



--Q9. Cancellation Rate Comparison
---Calculate and compare the order cancellation rate for each restaurant between the current year and the previous year


with cancel_ratio_23 as	           
                       (
						select o.restaurant_id,
								count(o.order_id) as total_orders,
								count(case when d.delivery_id is null then 1 end) as not_delivered 	   
						from orders o
						left join deliveries d on d.order_id=o.order_id
						where year(o.order_date)=2023
						group by o.restaurant_id
						),
cancel_ratio_24 as
                    (
				select o.restaurant_id,
						count(o.order_id) as total_orders,
						count(case when d.delivery_id is null then 1 end) as not_delivered 	   
				from orders o
				left join deliveries d on d.order_id=o.order_id
				where year(o.order_date)=2024
				group by o.restaurant_id
                     ),
 
 last_year_date as
                 (select restaurant_id,
				   total_orders,
				   not_delivered,
				   round(cast(not_delivered as numeric)/cast(total_orders as numeric)*100,2) as cancellation_ratio 
			       from cancel_ratio_23),


current_year_date as
					(
					select restaurant_id,
						   total_orders,
						   not_delivered,
						   round(cast(not_delivered as numeric)/cast(total_orders as numeric)*100,2) as cancellation_ratio 
					from cancel_ratio_24
					)


select current_year_date.restaurant_id as rest_id,
       current_year_date.cancellation_ratio cy_ratio,
	   last_year_date.cancellation_ratio as ly_ratio
from current_year_date
join last_year_date
on current_year_date.restaurant_id=last_year_date.restaurant_id

--Q10. Rider Average Delivery Time
--Determine each rider's average delivery time.



select rider_id,
       rider_name,
       avg(deliverytime_mins) as avg
from(select  d.rider_id,
             r.rider_name,
			 case 
				when delivery_time<order_time then
					datediff(minute,cast(order_time as datetime),cast(delivery_time as datetime)+1)
				else
					datediff(minute,cast(order_time as datetime),cast(delivery_time as datetime))
			 end as deliverytime_mins
			 from orders o
			 join deliveries d 
			 on d.order_id=o.order_id
			 join riders r
			 on r.rider_id=d.rider_id
			 where d.delivery_status='delivered'
	) as t1
group by rider_id,rider_name
order by avg(deliverytime_mins)


--Q11. Monthly Restaurant Growth Ratio
--Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining.

with growth_ratio as 
					(
					select o.restaurant_id,
						   format(cast(o.order_date as date),'MM-yy') as month,
						   count(o.order_id) as cur_orders,
						   lag(count(o.order_id),1) over(partition by o.restaurant_id order by format(cast(o.order_date as date),'MM-yy')) as prev_orders

					from orders o
					join deliveries d
					on d.order_id=o.order_id
					where d.delivery_status='delivered'
					group by o.restaurant_id, format(cast(o.order_date as date),'MM-yy')
					)

select *,
       case
	       when prev_orders is null or prev_orders=0 then null
	       else ((cur_orders-prev_orders)*100/prev_orders) 
	   end as growth_ratio
from growth_ratio


--Q12. Customer Segmentation
--Segment customers into 'Gold' or 'Silver' groups based on their total spending compared to the average order value (AOV).
--If a customer's total spending exceeds the AOV, label them as 'Gold'; otherwise, label them as 'Silver'.
--Return: The total number of orders and total revenue for each segment.
--cx total spend
-- avo
-- gold
--silver
--each category and total order and total revenue

select cust_status,
       sum(orders) as total_orders ,
	   sum(revenue) as total_revenue
from 
			  (
				select customer_id,
						sum(total_amount) as revenue,
						count(order_id) as orders,
						case 
							when sum(total_amount)>(select avg(total_amount) from orders) then 'Gold'
							else 'Silver'
	                    end as cust_status
				from orders
				group by customer_id
				) as t1

group by cust_status

   

--Q13. Rider Monthly Earnings
--Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.


select d.rider_id,format(cast(o.order_date as date),'yyyy-MM') as month,sum(o.total_amount) as revenue,sum(o.total_amount)*0.08 as riders_earning,r.rider_name
from orders o
join deliveries d
on d.order_id=o.order_id
join riders r
on r.rider_id=d.rider_id
group by d.rider_id,format(cast(o.order_date as date),'yyyy-MM'),r.rider_name
order by d.rider_id,format(cast(o.order_date as date),'yyyy-MM'),r.rider_name



--Q14. Rider Ratings Analysis
--Find the number of 5-star, 4-star, and 3-star ratings each rider has.
--Riders receive ratings based on delivery time:
-- 5-star: Delivered in less than 15 minutes
-- 4-star: Delivered between 15 and 20 minutes
-- 3-star: Delivered after 20 minutes

select rider_id,rating,count(*) as rating_count
from 
(
    select rider_id,
	deliverytime_mins,
	case
	    when deliverytime_mins<15 then '5 Star'
		when deliverytime_mins between 15 and 20 then '4 Star'
		else '3 Star'
	end as rating
	from  
	(
	select o.order_id,
			o.order_time,
			d.delivery_time,
			case 
				when delivery_time<order_time then
					datediff(minute,cast(order_time as datetime),cast(delivery_time as datetime)+1)
				else
					datediff(minute,cast(order_time as datetime),cast(delivery_time as datetime))
			end as deliverytime_mins,
			d.rider_id
	from orders o
	join deliveries d
	on d.order_id=o.order_id
	where delivery_status='Delivered'
	) as t1
) as t2
group by rider_id,rating
order by rider_id,rating_count desc



--Q15. Order Frequency by Day
--Analyze order frequency per day of the week and identify the peak day for each restaurant.
select *
from 
	(
	select r.restaurant_name,
		   --o.order_date,
		   format(cast(o.order_date as date),'dddd') as day,
		   --o.order_id,
		   count(order_id) as total_orders,
		   rank() over(partition by r.restaurant_name order by count(order_id) desc) as rank
       
	from orders o
	join restaurants r
	on o.restaurant_id=r.restaurant_id
	group by r.restaurant_name,format(cast(o.order_date as date),'dddd')
	
	) as t1
where rank=1

--Q16. Customer Lifetime Value (CLV)
--Calculate the total revenue generated by each customer over all their orders.

select c.customer_id,
       c.customer_name,
	   --o.order_item,
	   sum(o.total_amount) as total_revenue
from orders o
join customers c
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
order by sum(o.total_amount) desc

--Q17. Monthly Sales Trends
--Identify sales trends by comparing each month's total sales to the previous month.

select year(order_date) as year,
       month(order_date)as month,
	   sum(total_amount) as current_sales,
	   lag(sum(total_amount),1) over(order by year(order_date), month(order_date)) as previous_month_sales
from orders
group by year(order_date), month(order_date)
order by year(order_date),month(order_date)



--Q18. Rider Efficiency
--Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages.

with new_table
as
(
	select d.rider_id,
		   case 
				when delivery_time<order_time then
					datediff(minute,cast(order_time as datetime),cast(delivery_time as datetime)+1)
				else
					datediff(minute,cast(order_time as datetime),cast(delivery_time as datetime))
		   end as deliverytime_mins
	from orders o
	join deliveries d 
	on d.order_id=o.order_id
	where delivery_status='delivered'
),

riders_time 
as
(
	select rider_id,
		   avg(deliverytime_mins) as avg_delivery_time
	from new_table
	group by rider_id
)

select min(avg_delivery_time) as min_time,
       max(avg_delivery_time) as max_time
from riders_time

--Q19. Order Item Popularity
--Track the popularity of specific order items over time and identify seasonal demand spikes.

select 
      order_item,
	  seasons,
	  count(order_id) as total_orders
from 
	(select *,
	month(order_date) as month,
	case
		when month(order_date) between 3 and 6 then 'spring'
		when month(order_date)>6 and month(order_date)<9 then 'Summer'
		else 'Winter'
	end as seasons
	from orders
	 ) as t1
group by order_item,seasons
order by order_item,count(order_id)



--Q20. City Revenue Ranking
--Rank each city based on the total revenue for the last year (2023).

select r.city,
		   sum(o.total_amount)as total_revenue,
		   rank()over(order by sum(o.total_amount)desc) as rank
		from  orders o
		join restaurants r
		on r.restaurant_id=o.restaurant_id
		where year(o.order_date)=2023
		group by r.city

--end of reports