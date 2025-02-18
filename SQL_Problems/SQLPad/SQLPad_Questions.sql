-- 2. Top 3 movie categories by sales

/*
    1. For data safety, only SELECT statements are allowed
    2. Results have been capped at 200 rows
*/

with cte as (
SELECT category, sum(total_sales) as sales
FROM sales_by_film_category
group by category
order by sales desc)
select category from cte limit 3;


-- 3. Top 5 shortest movies

SELECT title
FROM film
order by length asc
LIMIT 5;

-- 5. Monthly revenue
-- Instruction

-- Write a query to return the total movie rental revenue for each month.
-- For Postgres: you can use EXTRACT(MONTH FROM colname) and EXTRACT(YEAR FROM colname) to extract month and year from a timestamp column.
-- For Python/Pandas: you can use pandas DatetimeIndex() to extract Month and Year
-- df['year'] = pd.DatetimeIndex(df['InsertedDate']).year
/*
    1. For data safety, only SELECT statements are allowed
    2. Results have been capped at 200 rows
*/

SELECT year(payment_ts) as year, month(payment_ts) as mon, sum(amount) as rev
FROM payment
group by year(payment_ts), month(payment_ts);

-- 7- Unique customers count by month
-- https://sqlpad.io/questions/7/unique-customers-count-by-month/

-- Instruction
-- Write a query to return the total number of unique customers for each month
-- Use EXTRACT(YEAR from ts_field) and EXTRACT(MONTH from ts_field) to get year and month from a timestamp column.
-- The order of your results doesn't matter.


-- 8. Average customer spend by month
-- easy
-- Instruction

-- Write a query to return the average customer spend by month.
-- Definition: average customer spend: total customer spend divided by the unique number of customers for that month.
-- Use EXTRACT(YEAR from ts_field) and EXTRACT(MONTH from ts_field) to get year and month from a timestamp column.
-- The order of your results doesn't matter.

/*
    1. For data safety, only SELECT statements are allowed
    2. Results have been capped at 200 rows
*/

SELECT year(payment_ts) as year, month(payment_ts) as mon, (sum(amount)/ count(distinct customer_id)) as avg_spend
FROM payment
group by year(payment_ts) , month(payment_ts) ;



with cte as (
SELECT customer_id, sum(amount) as sumamt, payment_ts
FROM payment
group by customer_id, payment_ts
having year(payment_ts) = 2020 and month(payment_ts) ='6')

select min(sumamt) as min, max(sumamt) as max from cte