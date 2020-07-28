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
