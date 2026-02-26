
CREATE TABLE retail_sales
(		
		transactions_id INT PRIMARY KEY,
		sale_date DATE, 
		sale_time	TIME,
		customer_id	INT,
		gender	VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs	FLOAT,
		total_sale FLOAT

)
-- Data Cleaning
select * from retail_sales
where transactions_id is null or 
sale_date is null or
sale_time is null or 
gender is null or
category is null or
quantity is null or
cogs is null or 
total_sale is null

DELETE FROM retail_sales
where transactions_id is null or 
sale_date is null or
sale_time is null or 
gender is null or
category is null or
quantity is null or
cogs is null or 
total_sale is null

select * from retail_sales

--Data Exploaration
-- How many sales we have?
select count(*) as total_sales from retail_sales

--Data Analysis and Business key problem and answers
--Write a sql query to retrive all columns for sales made on '2022 -11-05'
select * from retail_sales 
where sale_date = '2022-11-05';

--Write a sql qurey to retrieve all transactions where the category is clothing
-- and the quantity sold is more than 10 in the month of nov 2022

select * from retail_sales 
where category = 'Clothing' 
and 
to_char(sale_date, 'YYY-MM') = '2022-11'
and
quantity =3 ;

select *
from retail_sales
where category = 'Clothing'
and sale_date >= DATE '2022-11-01'
and sale_date < DATE '2022-12-01'
and quantity = 3;

--Calculate the total sales (toal_sale) for each category 
select category,  
		sum(total_sale) as total_sales,
		count(*) as total_orders
from retail_sales
group by category
--find the average age of customers who purchased items from the 'Beauty' category
select 
	customer_id, 
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'
group by customer_id

--find all transactions where the total_sale is greater than 1000
select *
from retail_sales
where total_sale > 1000;

--find the total number of transactions (transaction_id) made by each gender in each category
select category, 
		gender,
		count(transactions_id) as total_no_transactions
from retail_sales
group by category, gender
order by category;

--calculate the average sales for each month . find out the best selling month in each year.
select * from 

(
	select 
		EXTRACT(year from sale_date ) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sales,
		rank() over(partition by EXTRACT(year from sale_date ) order by avg(total_sale) desc) as rnk

	from retail_sales
	group by 1,2
) as t1 
where rnk = 1

--find the top 5 customers based on the highest total sales

select 
	customer_id, 
	sum(total_sale) as highest_total_sales
from retail_sales
group by customer_id
order by highest_total_sales desc
limit 5;

--find the number of unique customers who purchased items from each category?
select 
	category,
	count(distinct customer_id) as unique_customer
from retail_sales
group by category

--create each shift and number of orders (example morning <=12 ), afternoon between 12 & 17, Evening >17)
with hourly_sale as
(
select *,
	CASE 
		WHEN extract(hour from sale_time)  < 12 then 'Morning'
		WHEN extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales
)
select 	shift,
	count(*) as total_orders
from hourly_sale
group by shift 



