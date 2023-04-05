-- Udacity
-- Lesson 3: SQL Aggregations

-- NULL values -----------------------------------------------------------------
-- NULL is NOT equivalent to zero/0
-- NULLs frequently occur when performing a LEFT or RIGHT JOIN
-- NULLs can also occur from simply missing data in our database.

-- to find how many null values exist for poc_primary
SELECT *
FROM demo.accounts
WHERE primary_poc IS NULL;

-- to find how many non-null values exist for poc_primary
SELECT *
FROM demo.accounts
WHERE primary_poc IS NOT NULL;


-- COUNT function --------------------------------------------------------------
-- To count the number of (non-NULL) rows in a table (for orders placed in December 2016)
SELECT COUNT(*) AS order_count
FROM demo.orders
WHERE occurred_at >= '2016-12-01'
AND occurred_at <= '2017-01-01';


-- THESE TWO STATEMENTS BELOW PRODUCE THE SAME OUTPUT
-- BUT THIS IS NOT ALWAYS THE CASE!!!!

-- to find all the rows in the accounts table
SELECT COUNT(*)
FROM accounts;

-- we could have also chosen a column to drop into the aggregation function
SELECT COUNT(accounts.id)
FROM accounts;

-- COUNTING NON-NULLS IN A SPECIFIC COLUMN
-- this returns a count of all the non-nulls in the column
SELECT COUNT(id) AS order_id_count
FROM demo.accounts;

-- SUM function ----------------------------------------------------------------
-- this sums each of the selected columns (we want to see which paper is the most sold)
-- SUM treats NULL as zero
SELECT  SUM(standard_qty) AS standard,
        SUM(gloss_qty) AS gloss,
        SUM(poster_qty) AS poster,
FROM demo.orders;

-- Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) AS total_poster_sales
FROM orders; -- output 723 646

-- Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) AS total_standard_sales
FROM orders; -- output 1 938 346

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) AS total_usd_sales
FROM orders; -- output $23 141 511.83

-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for
-- each order in the orders table. THIS IS NOT AN AGGREGATION Q!!
-- This should give a dollar amount for each order in the table.
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss_usd,
FROM orders;

-- Find the standard_amt_usd per unit of standard_qty paper.
-- Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd)/COUNT(standard_qty) -- 1399.3556915509259259
FROM orders;

-- AVERAGE (AVG) function ------------------------------------------------------
-- AVG returns the MEAN of the data
-- returns mean value for each column
-- AVG ignores NULLS
-- if you don't want to ignore nulls (i.e. nulls = 0) you need to use sum and count functions
-- note that MEDIAN might be a more appropriate measure of spread
SELECT  AVG(standard_qty) AS standard,
        AVG(gloss_qty) AS gloss,
        AVG(poster_qty) AS poster,
FROM demo.orders;

-- MIN and MAX functions -------------------------------------------------------
-- When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) AS earliest_order
FROM orders;

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) AS latest_order
FROM orders;

-- Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at DESC;
LIMIT 1;

-- Find the mean (AVERAGE) amount spent per order on each paper type,
-- as well as the mean amount of each paper type purchased per order.
-- Your final answer should have 6 values - one for each paper type for the
-- average number of sales, as well as the average amount.

SELECT AVG(standard_amt_usd) AS standard_usd,
      AVG(standard_qty) AS standard_amount,
      AVG(gloss_amt_usd) AS glossy_usd,
      AVG(gloss_qty) AS glossy_amount,
      AVG(poster_amt_usd) AS poster_usd,
      AVG(poster_qty) AS poster_amount
FROM orders;

-- Via the video, you might be interested in how to calculate the MEDIAN.
-- Though this is more advanced than what we have covered so far try finding
-- what is the MEDIAN total_usd spent on all orders?
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

-- Since there are 6912 orders - we want the average of the 3457 and 3456 order
-- amounts when ordered. This is the average of 2483.16 and 2482.55.
-- This gives the median of 2482.855. This obviously isn't an ideal way to compute.
-- If we obtain new orders, we would have to change the limit.
-- SQL didn't even calculate the median for us.
-- The above used a SUBQUERY, but you could use any method to find the two
-- necessary values, and then you just need the average of them.

--- GROUP BY function ----------------------------------------------------------

-- GROUP BY can be used to aggregate data within subsets of the data.
-- For example, grouping for different accounts, different regions, or different sales representatives.
-- Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
-- Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
SELECT  account_id,
        SUM(standard_qty) AS standard,
        SUM(gloss_qty) AS gloss,
        SUM(poster_qty) AS poster,
FROM demo.orders
GROUP BY account_id
ORDER BY account_id;

-- SQL evaluates the aggregations before the LIMIT clause.
-- If you don’t group by any columns, you’ll get a 1-row result—no problem there.
-- If you group by a column with enough unique values that it exceeds the LIMIT number,
-- the aggregates will be calculated, and then some rows will simply be omitted from the results.

-- Which account (by name) placed the earliest order?
-- Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
ORDER BY o.occurred_at ASC
LIMIT 1;

-- Find the total sales in usd for each account.
-- You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name,
      SUM(o.total_amt_usd) AS total_sales
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name;

-- Via what channel did the most recent (latest) web_event occur, which account
-- was associated with this web_event? Your query should return only three values
-- the date, channel, and account name.
SELECT w.occurred_at, w.channel, a.name
FROM accounts AS a
JOIN web_events AS w
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- Find the total number of times each type of channel from the web_events was used.
-- Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel,
      COUNT(channel)
FROM web_events
GROUP BY channel;

-- OR / alternative approach
SELECT channel, COUNT(*)
FROM web_events
GROUP BY channel;

-- Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
ORDER BY occurred_at ASC
LIMIT 1;

-- What was the smallest order placed by each account in terms of total usd.
-- Provide only two columns - the account name and the total usd.
-- Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_usd) AS smallest_order
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

-- Find the number of sales reps in each region.
-- Your final table should have two columns - the region and the number of sales_reps.
-- Order from fewest reps to most reps.
SELECT r.name,
        COUNT(s.name)
FROM sales_reps AS s
JOIN region AS r
ON s.region_id = r.id
GROUP BY r.name;

-- OR / alternative approach
SELECT r.name, COUNT(*) AS num_reps
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

-- Notes
-- The order of column names in your GROUP BY clause doesn’t matter
-- you can substitute numbers for column names in the GROUP BY clause


-- For each account, determine the average amount of each type of paper they
-- purchased across their orders. Your result should have four columns -
-- one for the account name and
-- one for the average quantity purchased for each of the paper types for each account.
SELECT a.name AS account,
	AVG(o.standard_qty) AS avg_std,
	AVG(o.gloss_qty) AS avg_gloss,
    AVG(o.poster_qty) AS avg_poster
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1;

-- For each account, determine the average amount spent per order on each paper type.
-- Your result should have four columns - one for the account name and one
-- for the average amount spent on each paper type.
SELECT a.name AS account,
      AVG(o.standard_amt_usd) AS avg_usd_std,
      AVG(o.gloss_amt_usd) AS avg_usd_gloss,
      AVG(o.poster_amt_usd) AS avg_usd_poster
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1;

-- Determine the number of times a particular channel was used in the web_events
-- table for each sales rep. Your final table should have three columns -
-- the name of the sales rep, the channel, and the number of occurrences.
-- Order your table with the highest number of occurrences first.
SELECT  s.name,
        w.channel,
        count(*) AS num_events
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
GROUP BY 1,2
ORDER BY num_events DESC;

-- Determine the number of times a particular channel was used in the web_events
-- table for each region. Your final table should have three columns -
-- the region name, the channel, and the number of occurrences.
-- Order your table with the highest number of occurrences first.


SELECT r.name, w.channel, COUNT(*) AS num_events
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN web_events AS w
ON w.account_id = a.id
GROUP BY 1,2
ORDER BY num_events DESC;

-- DISTINCT statements ---------------------------------------------------------
-- DISTINCT is always used in SELECT statements, and it provides the unique
-- rows for all columns written in the SELECT statement.
-- Therefore, you only use DISTINCT once in any particular SELECT statement.

SELECT DISTINCT column1, column2, column3
FROM table1;

-- Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT DISTINCT id, name
FROM accounts;

-- Have any sales reps worked on more than one account?
SELECT DISTINCT id, name
FROM sales_reps;

-- HAVING statements -----------------------------------------------------------
-- HAVING is the “clean” way to filter a query that has been aggregated,
-- but this is also commonly done using a subquery.
-- Essentially, any time you want to perform a WHERE on an element of your query
-- that was created by an aggregate, you need to use HAVING instead.
