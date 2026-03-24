
USE retail_store;

create table retial_sales
(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
)

-- Calculating total records

SELECT COUNT(*) as total_rec 
	FROM retial_sales;

-- Searching for any null values in the data 

SELECT * FROM retial_sales
WHERE 
	transactions_id IS NULL
    or
    sale_date IS NULL
    or
    sale_time IS NULL
    or
    customer_id IS NULL
    or 
    gender IS NULL
    or
    age IS NULL
    or
    category IS NULL
    or
    quantiy IS NULL
    or
    price_per_unit IS NULL
    or
    cogs IS NULL
    or
    total_sale IS NULL;

-- Deleting the null record

DELETE FROM retial_sales
WHERE 
	transactions_id IS NULL
    or
    sale_date IS NULL
    or
    sale_time IS NULL
    or
    customer_id IS NULL
    or 
    gender IS NULL
    or
    age IS NULL
    or
    category IS NULL
    or
    quantiy IS NULL
    or
    price_per_unit IS NULL
    or
    cogs IS NULL
    or
    total_sale IS NULL;

-- DATA EXPLORATION

-- Q1. How many customer we have?

SELECT count(distinct(customer_id)) as total_cust FROM retial_sales;

-- Q2. How many sales do we have?

select count(*) as num_tot_sale FROM retial_sales;

-- Q3. How much is our total sale?

SELECT sum(total_sale) as total_sales from retial_sales;

-- Q4. How many categories do we have?

SELECT distinct category as categories FROM retial_sales;

-- Key Problems and Answers

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retial_sales 
WHERE 
	sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

-- SOLUTION 1
SELECT * FROM retial_sales
WHERE
	category = 'Clothing'
    AND
    quantiy >= 4
    AND
    sale_date like '2022-11-%';

-- SOLUTION 2
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retial_sales
GROUP BY 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT ROUND(AVG(age), 2) as avg_age
FROM retial_sales
WHERE category = 'Beauty'; 

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retial_sales
WHERE total_sale >= 1000
ORDER BY transactions_id;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
	SUM(transactions_id) as total_trans,
	gender,
    category
FROM retial_sales
group by gender, category
order by gender;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT *
FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank_in_year
    FROM (
        SELECT 
            YEAR(sale_date) AS year,
            MONTH(sale_date) AS month,
            ROUND(AVG(total_sale), 2) AS avg_sale
        FROM retial_sales
        GROUP BY YEAR(sale_date), MONTH(sale_date)
    ) t
) r
WHERE rank_in_year = 1;

-- **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT 
	customer_id,
    SUM(total_sale) as sum_sale
FROM retial_sales
GROUP BY customer_id
ORDER BY sum_sale DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT * FROM retial_sales;

SELECT 
	COUNT(DISTINCT customer_id) as unq_cust,
    category
FROM retial_sales
GROUP BY category
ORDER BY unq_cust;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale AS
	(
	SELECT
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < '12' THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN '12' AND '17' THEN 'Afternoon'
			ELSE 'Evening'
		END as shifts
	FROM retial_sales
    )
SELECT 
	count(*) as total_orders,
    shifts
FROM hourly_sale
GROUP BY shifts;