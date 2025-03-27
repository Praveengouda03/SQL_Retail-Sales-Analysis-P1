

Use Retail_sales_db

--                        CREATE TABLE

drop table IF EXISTS retail_sales
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);



select * from retail_sales_tb

/* 
             Data Exploration & Cleaning
1.Record Count: Determine the total number of records in the dataset.
2.Customer Count: Find out how many unique customers are in the dataset.
3.Category Count: Identify all unique product categories in the dataset.
4.Null Value Check: Check for any null values in the dataset and delete records with missing data.
*/

Select * from retail_sales_tb;

Select count(*) from retail_sales_tb;
select count(Distinct customer_id) from retail_sales_tb;
select Distinct category from retail_sales_tb;

-- Data Cleaning

Select * from retail_sales_tb
where transactions_id is Null or sale_date is null or sale_time is null or customer_id is null or gender is null or age is null or 
category is null or quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

Delete from retail_sales_tb
where  transactions_id is Null or sale_date is null or sale_time is null or customer_id is null or gender is null or age is null or 
category is null or quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

  -- Data Exploration

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales_tb
where sale_date = '2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022(use covert):

Select * from retail_sales_tb
where category='Clothing' and quantiy>=4 and convert(varchar(7),sale_date,120)='2022-11' ;

--3.Write a SQL query to calculate the total sales (total_sale) for each category.:

Select Category,sum(total_sale) as Net_Sale,count(*) as total_order from  retail_sales_tb
group by category;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select category,AVG(age)as average_age from retail_sales_tb
where category='Beauty'
group by category;

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000

select * from retail_sales_tb 
where total_sale >1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender,category,count(*) as no_of_transation from retail_sales_tb
group by gender,category
order by 1;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

Select * from
(
Select 
YEAR(sale_date) as Year,
MONTH(sale_date) as Month,
AVG(total_sale) as avg_sales,
RANK() over(Partition by YEAR(sale_date) Order By AVG(total_sale) Desc) as rank
from retail_sales_tb
group by YEAR(sale_date),MONTH(sale_date)
) as rnk
Where rank=1;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales

--Using TOP  
Select Top 5 customer_id,Sum(Total_sale) as Sales
from retail_sales_tb
group by customer_id
order by Sum(Total_sale) desc

-- Using RANK()
Select * from 
( select 
        customer_id,
        SUM(total_sale) AS total_sales,
		RANK() over(order by Sum(Total_sale) desc) as rank 
  from retail_sales_tb
  group by customer_id) as ranked_salaries
		where rank <= 5; 

--9.Write a SQL query to find the number of unique customers who purchased items from each category.

select 
category,
count(Distinct customer_id)
from retail_sales_tb 
group by category;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


with hourly_sales AS(
Select *,
case
    when datepart(hour,sale_time) < 12 then 'Morning'
	when datepart(hour,sale_time) >= 12 and datepart(hour,sale_time) < 17 then 'Afternoon' 
	else 'Evening'
end as shift
from retail_sales_tb
)
select shift,count(*) as total_order
from hourly_sales
group by shift ;

 -----End Of Project----
