-- Write a query that displays the order ID, account ID, and total dollar amount for all the orders, 
-- sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
select id, account_id, total_amt_usd
from orders
group by 1,2
order by 1,3 desc ;

-- Now write a query that again displays order ID, account ID, and total dollar amount for each order,
-- but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).
select id, account_id, total_amt_usd
from orders
group by 1,2
order by 3 desc, 1;

-- Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
-- Be sure to include the primary_poc, time of the event, and the channel for each event. 
-- Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
select a.primary_poc, we.occurred_at, we.channel, a.name
from accounts as a
inner join web_events as we
on a.id = we.account_id
where a.name like 'Walmart';


-- Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: 
-- the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
select r.name as "region", 
	   sr.name as sales_rep_name,
	   a.name as "account_name"
from regions as r
inner join sales_reps as sr
on sr.region_id =  r.id
inner join accounts as a
on a.sales_rep_id = sr.id
order by 3;


-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- Your final table should have 3 columns: region name, account name, and unit price.
-- A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
select r.name as "region_name", a.name as "account_name", o.total_amt_usd/(o.total+0.01) as "unit_price"
from sales_reps as sr
inner join regions as r
on r.id = sr.region_id
inner join accounts as a
on a.sales_rep_id = sr.id
inner join orders as o
on a.id = o.account_id
order by 3 asc


-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
-- This should give a dollar amount for each order in the table.
select (standard_amt_usd + gloss_amt_usd) as "total_standard_gloss"
from orders;


-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
select a.name, o.occurred_at
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1,2
order by 2 asc
limit 1;


-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
select a.name, sum(total_amt_usd) as "total_sales_usd"
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
-- Your query should return only three values - the date, channel, and account name.
select a.name, we.occurred_at, we.channel
from accounts as a
inner join web_events as we
on a.id = we.account_id
order by 2 desc
limit 1;


-- For each account, determine the average amount of each type of paper they purchased across their orders. 
-- Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
select a.name as "account_name",
	   avg(o.standard_qty) as "average_standard",
	   avg(o.gloss_qty) as "average_gloss",
	   avg(o.poster_qty) as "average_poster"
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1;


	   
-- For each account, determine the average amount spent per order on each paper type. 
-- Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
select a.name, 
	   avg(o.standard_amt_usd) as "average_standard_usd",
	   avg(o.gloss_amt_usd) as "average_gloss_usd",
	   avg(o.poster_amt_usd) as "average_poster_usd"
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1


-- Determine the number of times a particular channel was used in the web_events table for each sales rep. 
-- Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
-- Order your table with the highest number of occurrences first.
select sr.name, we.channel, count(*) as "number_occurrences"
from accounts as a
inner join web_events as we
on a.id = we.account_id
inner join sales_reps as sr
on sr.id = a.sales_rep_id
group by 1,2
order by 3 desc;


-- Determine the number of times a particular channel was used in the web_events table for each region. 
-- Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
select r.name, we.channel, count(*) as "number_occurrences"
from sales_reps as sr 
inner join regions as r
on r.id = sr.region_id
inner join accounts as a
on a.sales_rep_id = sr.id
inner join web_events as we
on we.account_id = a.id
group by 1,2
order by 3 desc;


-- How many of the sales reps have more than 5 accounts that they manage?
select sr.id, sr.name, count(*) as "count"
from sales_reps as sr
inner join accounts as a
on a.sales_rep_id = sr.id
group by 1,2 
having count(*) > 5


-- How many accounts have more than 20 orders?
select a.name, count(*) as "orders"
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1
having count(*) > 20
order by count(*) desc;


-- Which account has the most orders?
select a.id, a.name, count(*) as "orders"
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1,2
order by 3 desc
limit 1;


-- How many accounts spent more than 30,000 usd total across all orders?
select a.name, sum(o.total_amt_usd) as "total_spent_usd"
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1
having sum(o.total_amt_usd) > 30000 


-- How many accounts spent less than 1,000 usd total across all orders?
select a.name, sum(o.total_amt_usd) as "total_spent_usd"
from accounts as a
inner join orders as o
on a.id = o.account_id
group by 1
having sum(o.total_amt_usd) < 1000
order by 2


-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
-- Do you notice any trends in the yearly sales totals?
select date_part('year', occurred_at) as  "year_date",
	   sum(total_amt_usd)
from orders
group by 1
order by 2;


-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
select date_part('month', occurred_at) as "month_date",
	   sum(total_amt_usd) 
from orders
group by 1
order by 2;


-- Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
select date_part('year', occurred_at) as "year_date",
	   count(*) "number_of_orders"
from orders
group by 1
order by 2;


-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
select date_trunc('month', o.occurred_at) as "date",
	   a.name,
	   sum(o.gloss_amt_usd) as "total_gloss_usd"
from accounts as a
inner join orders as o
on a.id = o.account_id
where a.name like 'Walmart'
group by 1,2
order by 3 desc
limit 1;


-- Write a query to display for each order, the account ID, total amount of the order, 
-- and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000
select id, total_amt_usd, 
	   case when total_amt_usd < 3000 then 'Small' else 'Large' end as "Level_of_order"
from orders


-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
-- The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
select  a.name, o.total, 
	    case when o.total < 1000 then 'Less than 1000'
		     when o.total between 1000 and 2000 then 'Between 1000 and 2000'
			 when o.total > 2000 then 'At Least 2000' end as "Categories"
from orders as o
inner join accounts as a
on a.id = o.account_id
group by 1,2


-- We would like to understand 3 different branches of customers based on the amount associated with their purchases. 
-- The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
-- The second branch is between 200,000 and 100,000 usd. 
-- The lowest branch is anyone under 100,000 usd. Provide a table that includes the level associated with each account. 
-- You should provide the account name, the total sales of all orders for the customer, and the level. 
-- Order with the top spending customers listed first.
select sr.name as "sales_rep_name", 
	   count(*) as "total_number_orders", 
	   sum(o.total_amt_usd) as "total_sales",
	   case when sum(o.total_amt_usd) > 750000 or count(*) > 200 then 'Top'
	        when sum(o.total_amt_usd) > 500000 or count(*) > 150 then 'Middle' else 'Low' end as "Performing_sale"
from accounts as a
inner join orders as o
on a.id = o.account_id
inner join sales_reps as sr
on sr.id = a.sales_rep_id
group by 1
order by 3 desc


-- What is the top channel used by each account to market products? And how often was the channel used?
select s3.id, s3.name, s3.channel, s3.count
from (select a.id, a.name, we.channel, count(*) as "count"
	from accounts as a
	inner join web_events as we
	on a.id = we.account_id
	group by 1,2,3
	order by 2 desc) as s3
	
	join
	
(select s1.id, s1.name, max(s1.count) as "max_count"
from
	(select a.id, a.name, we.channel, count(*) as "count"
	from accounts as a
	inner join web_events as we
	on a.id = we.account_id
	group by 1,2,3
	order by 2 desc) as s1
group by 1,2) as s2
on s2.id = s3.id and s2.max_count = s3.count
order by s3.name


-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
select s3.rep_name, s3.region_name, s3.sum_total_usd
from    (select sr.name as "rep_name", r.name as "region_name", sum(o.total_amt_usd) as "sum_total_usd"
		from accounts as a
		inner join sales_reps as sr
		on a.sales_rep_id = sr.id
		inner join orders as o
		on a.id = o.account_id
		inner join regions as r
		on r.id = sr.region_id
		group by 1,2
		order by 3 desc) as s3
		
		join
		
(select region_name, max(sum_total_usd) as "max_amt_usd"
from   (select sr.name as "rep_name", r.name as "region_name", sum(o.total_amt_usd) as "sum_total_usd"
		from accounts as a
		inner join sales_reps as sr
		on a.sales_rep_id = sr.id
		inner join orders as o
		on a.id = o.account_id
		inner join regions as r
		on r.id = sr.region_id
		group by 1,2
		order by 3 desc) as s1
group by 1) as s2
on s2.region_name = s3.region_name and s2.max_amt_usd = s3.sum_total_usd
order by s3.region_name