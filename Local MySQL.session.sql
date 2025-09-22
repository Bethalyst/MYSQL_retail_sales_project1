--Determine the total number of records in the dataset.-- 
USE sql_project_p1;
SELECT *
FROM retail_sales;
SELECT COUNT(*)
FROM retail_sales;
-- Data Cleaning --
SELECT *
FROM retail_sales
WHERE sale_time IS NULL
    OR sale_date IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
DELETE FROM retail_sales
WHERE sale_time IS NULL
    OR sale_date IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
-- Data exploration--
-- How many sale we have?--
SELECT COUNT(*) AS total_sale
FROM retail_sales;
-- How many  unique customer we have --
SELECT COUNT(DISTINCT customer_id) AS total_Customer
FROM retail_sales;
-- What's all the unique product categories in the dataset --
SELECT COUNT(DISTINCT category) AS category_total
FROM retail_sales;
SELECT DISTINCT category AS category_names
FROM retail_sales;
-- Analysis & Business Key problems & answers--
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the 
--quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND sale_date >= '2022-11-01'
    AND sale_date < '2022-12-01'
    AND quantiy >= 4;
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category,
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 1;
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category,
    gender
ORDER BY 1;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year,
    month,
    avg_sale
FROM (
        SELECT YEAR(sale_date) AS year,
            MONTH(sale_date) AS month,
            ROUND(AVG(total_sale), 2) AS avg_sale,
            RANK() OVER(
                PARTITION BY YEAR(sale_date)
                ORDER BY AVG(total_sale) DESC
            ) AS rnk
        FROM retail_sales
        GROUP BY 1,
            2
    ) as t1
WHERE rnk = 1
ORDER BY year;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT *
FROM retail_sales
ORDER BY total_sale DESC
LIMIT 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT customer_id),
    category
FROM retail_sales
GROUP BY category;
-- Q. 10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternow'
            ELSE 'Eveninig'
        END as shift
    FROM retail_sales
)
SELECT shift,
    COUNT(*) AS total_orders
FROM hourly_sale
group by shift;
---End of Project 01