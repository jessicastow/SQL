-- Udacity
-- Lesson 4: SQL Subqueries & Temporary tables

/* Subqueries and table expressions
= are methods for being able to write a query that creates a table,
and then write a query that interacts with this newly created table.

https://mode.com/blog/date-trunc-sql-timestamp-function-count-on/

Find the number of events that occur for each day for each channel */

-- DATE_TRUNC
-- use it to round a timestamp to the interval you need.
-- e.g. by day/minute/hour/year/month etc.

-- DATE_TRUNC(‘[interval]’, time_column)
-- The time_column is the database column that contains the timestamp you'd like
-- to round, and [interval] dictates your desired precision level.
-- https://mode.com/blog/date-trunc-sql-timestamp-function-count-on/

-- CREATE A TABLE / SUBQUERY
SELECT DATE_TRUNC('day',occurred_at) AS day,
           channel, COUNT(*) as events
     FROM web_events
     GROUP BY 1,2
     ORDER BY 3 DESC;

-- Select all columns from subquery
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
           channel, COUNT(*) as events
     FROM web_events
     GROUP BY 1,2
     ORDER BY 3 DESC) sub;

-- get the average number of events per day, for each channel
SELECT channel, AVG(events) AS av_event_count
FROM
(SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS events
FROM web_events
GROUP BY day, channel) AS sub -- we don't need order by in subquery
GROUP BY channel
ORDER BY avg_event_count DESC;

-- Subqueries in conditional statements (WHERE)
-- subquery to get the first month (returns 1 value)
SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM demo.orders;

-- now use the subquery
SELECT *
FROM demo.orders
WHERE DATE_TRUNC('month', occurred_at) =
(SELECT MIN(occurred_at) AS min_month
FROM demo.orders)
ORDER BY occurred_at;

SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS earliest_order_month
         FROM orders)
                   ORDER BY occurred_at;
-- Note if our subquery produces >1 value, instead of the WHERE function we can use the IN function

-- Use DATE_TRUNC to pull month level data about the first order ever placed in the orders tables
SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders

-- Use the result of the previous query to find only the orders that took place in the same month
-- and year as the first order, and then pull the average for each type of paper qty in this month
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

SELECT s.name AS sales_rep_name, r.name AS region_name, SUM(o.total_amt_usd) AS total_amt
FROM region AS r
JOIN sales_reps AS s
ON s.region_id = r.id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
GROUP BY sales_rep_name, region_name
ORDER BY total_amt DESC;

-- WITH   statement
-- also known as Common Table Expressions (CTE)
-- same purpose as subqueries but cleaner for future reader to follow the logic

-- example of with statement
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day,
                        channel, COUNT(*) as events
          FROM web_events
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;

-- addtional tables

WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)

SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

-- Provide the name of the sales_rep in each region with the largest amount
-- of total_amt_usd sales.

WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1,2
   ORDER BY 3 DESC),
t2 AS (
   SELECT region_name, MAX(total_amt) total_amt
   FROM t1
   GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

-- For the region with the largest sales total_amt_usd, how many total orders
-- were placed?


-- How many accounts had more total purchases than the account name which has
-- bought the most standard_qty paper throughout their lifetime as a customer?

-- For the customer that spent the most (in total over their lifetime as a
-- customer) total_amt_usd, how many web_events did they have for each channel?


-- What is the lifetime average amount spent in terms of total_amt_usd for the
-- top 10 total spending accounts?


-- What is the lifetime average amount spent in terms of total_amt_usd,
-- including only the companies that spent more per order, on average,
-- than the average of all orders.
