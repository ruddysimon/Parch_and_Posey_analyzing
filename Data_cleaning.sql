-- In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using.
-- Provide how many of each website type exist in the accounts table.
select right(website, 3) as "Domain_name", count(*)
from accounts
group by 1



-- There is much debate about how much the name (or even the first letter of a company name) matters. 
-- Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
select right(name, 1) as "first_letter_company_name", count(*)
from accounts 
group by 1
order by 2 desc



-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
select vowels_cnt, non_vowels_cnt
from (select sum(vowels) as "vowels_cnt", sum(non_vowels) as "non_vowels_cnt", count(*) as "total_cnt"
	 from (select name,
		   case when left(lower(name),1) IN ('a', 'e', 'i', 'o', 'u') then 1 else 0 end as "vowels",
		   case when left(lower(name),1) NOT IN ('a', 'e', 'i', 'o', 'u') then 1 else 0 end as "non_vowels",
	  	   count(*)
	  	   
	from accounts
	group by 1) as s1) s2 


-- Suppose the company wants to assess the performance of all the sales representatives. Each sales representative is assigned to work in a particular region. 
-- To make it easier to understand for the HR team, display the concatenated sales_reps.id, ‘_’ (underscore), and region.name as EMP_ID_REGION for each sales representative.
select sr.name ,concat(sr.id, '_', r.name) as "EMP_ID_REGION"
from sales_reps as sr
inner join regions as r
on r.id = sr.region_id


-- From the accounts table, display the name of the client, the coordinate as concatenated (latitude, longitude), 
-- email id of the primary point of contact as <first letter of the primary_poc><last letter of the primary_poc>@<extracted name and domain from the website>
select name, concat(lat,',',long) as "coordinate", concat(left(primary_poc,1), right(primary_poc,1),'@', right(website,3)) as "email"
from accounts


-- From the web_events table, display the concatenated value of account_id, '_' , channel, '_', count of web events of the particular channel.
with t1 as(
select channel, account_id,  count(*) as "web_events_cnt"
from web_events
group by 1,2
order by 3 desc)
select concat(t1.account_id, '_', t1.channel, '_', t1.web_events_cnt) as "concatenated_value"
from t1;


-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
select left(primary_poc, strpos(primary_poc,' ')-1) as "first_name",
	   right(primary_poc, length(primary_poc) - strpos(primary_poc,' ')) as "last_name",
	   primary_poc
from accounts



-- Each company in the accounts table wants to create an email address for each primary_poc. 
-- The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
select primary_poc, concat(left(primary_poc, strpos(primary_poc,' ')-1), '.', right(primary_poc, length(primary_poc) - strpos(primary_poc,' ')), '@', name, '.com') as "email_address"
from accounts

-- solution with subquery
WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;



-- You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. 
-- See if you can create an email address that will work by removing all of the spaces in the account name. 
select primary_poc, concat(left(primary_poc, strpos(primary_poc,' ')-1), '.', right(primary_poc, length(primary_poc) - strpos(primary_poc,' ')), '@', replace(name,' ',''), '.com') as "email_address"
from accounts



-- We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), 
-- then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), 
-- the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.
with t1 as(
select name,
	   primary_poc,
	   left(primary_poc, strpos(primary_poc, ' ')-1) as "first_name",
	   right(primary_poc, length(primary_poc) - strpos(primary_poc, ' ')) as "last_name"
from accounts
)
select concat(lower(right(first_name, 1)), lower(left(first_name,1)), lower(right(last_name,1)), lower(left(last_name,1)), length(first_name), length(last_name), upper(replace(name,' ',''))) as "Password"
from t1




-- Run the query below to see the missing values
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
	   COALESCE(o.account_id,a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


select *
from accounts as a
left join orders as o 
on a.id = o.account_id
where o.total is null;
-- The query above makes a "left join" of tables - accounts and orders, based on join condition a.id = o.account_id. The result of the join will necessarily contain all rows of the accounts table, even if there is no matching row in the orders table.

-- There is a row in the accounts table with the id = 1731 and name = 'Goldman Sachs Group' that does not have a matching row in the orders table. Therefore, the query above will return a row having NULL in each column from the orders table.

-- You will notice that the id column is also blank. One might think that the null value is due to the ambiguous id column as it is present in both the tables. But, even if we use a fully qualified column name a.id, it will not give us the 1731 value.


-- Using coalesce to fill in the account.id column with account.id for the null value.
select coalesce(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
from accounts a
left join orders o
on a.id = o.account_id
where o.total is null



-- Using coalesce to fill in the orders.id column with account.id for the null value.
select coalesce(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
	   coalesce(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
from accounts a
left join orders o
on a.id = o.account_id
where o.total is NULL;


-- Using coalesce to fill in the qty and usd column with 0.
select coalesce(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
	   coalesce(o.account_id, a.id) account_id, o.occurred_at, coalesce(o.standard_qty,0) as "standard_qty", coalesce(o.gloss_qty,0) as "gloss_qty", 
	   coalesce(o.poster_qty,0) "poster_qty", coalesce(o.total,0) as "total", coalesce(o.standard_amt_usd,0) as "standard_amt_usd",
	   coalesce(o.gloss_amt_usd,0) as "gloss_amt_usd", coalesce(o.poster_amt_usd,0) as "poster_amt_usd", coalesce(o.total_amt_usd,0) as "total_amt_usd"
from accounts a
left join orders o
on a.id = o.account_id
where o.total is NULL;


SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;


select coalesce(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
	   coalesce(o.account_id, a.id) account_id, o.occurred_at, coalesce(o.standard_qty,0) as "standard_qty", coalesce(o.gloss_qty,0) as "gloss_qty", 
	   coalesce(o.poster_qty,0) "poster_qty", coalesce(o.total,0) as "total", coalesce(o.standard_amt_usd,0) as "standard_amt_usd",
	   coalesce(o.gloss_amt_usd,0) as "gloss_amt_usd", coalesce(o.poster_amt_usd,0) as "poster_amt_usd", coalesce(o.total_amt_usd,0) as "total_amt_usd"
from accounts a
left join orders o
on a.id = o.account_id


