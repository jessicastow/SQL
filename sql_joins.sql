-- Udacity
-- Lesson 2: SQL Joins

-- Your first JOIN
SELECT orders.* -- table.column (from orders table choose all columns)
FROM orders -- orders table
JOIN accounts -- table #2
ON orders.account_id = accounts.id; -- what variables to merge on
-- ON holds the two columns that get linked across the two tables

/* Try pulling all the data from the accounts table, and all the data
from the orders table. */
SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- OR (alternative answer gives same results)
SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

/* Try pulling standard_qty, gloss_qty, and poster_qty from the orders table,
and the website and the primary_poc from the accounts table. */
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_amt_usd, accounts.website, accounts.primary_poc
FROM accounts
JOIN orders
ON accounts.id = orders.account_id; -- link PK to FK


/* Pull all the data from all the joined tables */
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;

-- Alias

--Alias for table name
SELECT o.*, a.*
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id;

-- Alias for table name (leaving out the 'AS')
SELECT o.*, a.*
FROM accounts a
JOIN orders o
ON a.id = o.account_id;

-- Alias for column name
SELECT t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

/* Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of the
event, and the channel for each event. Additionally, you might choose to add
a fourth column to assure only Walmart events were chosen. */
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

/* Provide a table that provides the region for each sales_rep along with
their associated accounts. Your final table should include three columns:
the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name. */
SELECT r.name AS region_name, s.name AS rep_name, a.name AS account_name
FROM accounts AS a
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
JOIN region AS r
ON s.region_id = r.id
ORDER BY a.name ASC;

/* Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order.
Your final table should have 3 columns: region name, account name, and unit price.
A few accounts have 0 for total, so I divided by (total + 0.01)
to assure not dividing by zero. */
SELECT r.name AS region_name,
        a.name AS account_name,
        o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
JOIN sales_reps as s
ON a.sales_rep_id = s.id
JOIN region AS r
ON s.region_id = r.id;

-- INNER JOIN
-- join the intersection between two tables

-- OUTER JOINS
-- 3 types ....

-- 1) LEFT join
-- table on FROM statement is LEFT table,
-- table on JOIN statement is RIGHT table
-- will include all rows from left table and the overlapping rows in right table
SELECT
FROM left_table
LEFT JOIN right_table

-- OR (this means the same as above)
SELECT
FROM left_table
LEFT OUTER JOIN right_table

-- 2) RIGHT join

-- OR
RIGHT OUTER JOIN -- means the same as RIGHT JOIN
-- although generally we only use left joins

-- 3) FULL OUTER join
-- these are very rare
FULL OUTER JOIN -- same as OUTER JOIN


/* Provide a table that provides the region for each sales_rep along with
their associated accounts. This time only for the Midwest region.
Your final table should include three columns: the region name,
the sales rep name, and the account name. Sort the accounts
alphabetically (A-Z) according to account name. */
SELECT r.name AS region_name, s.name AS sales_rep_name, a.name AS account_name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY account_name;

/* Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a
first name starting with S and in the Midwest region.
Your final table should include three columns: the region name,
the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name. */
SELECT r.name AS region_name, s.name AS sales_rep_name, a.name AS account_name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY account_name;


/* Provide a table that provides the region for each sales_rep along with their
 associated accounts. This time only for accounts where the sales rep has a
 last name starting with K and in the Midwest region.
 Your final table should include three columns: the region name,
 the sales rep name, and the account name.
 Sort the accounts alphabetically (A-Z) according to account name. */
 SELECT r.name AS region_name, s.name AS sales_rep_name, a.name AS account_name
 FROM region AS r
 JOIN sales_reps AS s
 ON r.id = s.region_id
 JOIN accounts AS a
 ON s.id = a.sales_rep_id
 WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
 ORDER BY account_name;

 /* Provide the name for each region for every order, as well as the account
 name and the unit price they paid (total_amt_usd/total) for the order.
 However, you should only provide the results if the standard order quantity
 exceeds 100. Your final table should have 3 columns:
 region name, account name, and unit price.
 In order to avoid a division by zero error, adding .01 to the
 denominator here is helpful total_amt_usd/(total+0.01). */
SELECT r.name AS region_name, a.name AS account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
WHERE o.standard_qty > 100;

/* Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity
exceeds 100 and the poster order quantity exceeds 50.
Your final table should have 3 columns: region name, account name, and unit price.
Sort for the smallest unit price first. In order to avoid a division by
zero error, adding .01 to the denominator here is helpful
(total_amt_usd/(total+0.01). */
 SELECT r.name AS region_name, a.name AS account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
 FROM region AS r
 JOIN sales_reps AS s
 ON r.id = s.region_id
 JOIN accounts AS a
 ON s.id = a.sales_rep_id
 JOIN orders AS o
 ON a.id = o.account_id
 WHERE o.standard_qty > 100 AND o.poster_qty > 50
 ORDER BY unit_price;

/* Provide the name for each region for every order, as well as the account
name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity
exceeds 100 and the poster order quantity exceeds 50.
Your final table should have 3 columns: region name, account name,
and unit price. Sort for the largest unit price first.
In order to avoid a division by zero error, adding .01
to the denominator here is helpful (total_amt_usd/(total+0.01). */
SELECT r.name AS region_name, a.name AS account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

/* What are the different channels used by account id 1001?
Your final table should have only 2 columns: account name and the different
channels. You can try SELECT DISTINCT to narrow down the results to
only the unique values. */

-- SELECT DISTINCT gives only unique values
SELECT DISTINCT a.name AS account_name, w.channel AS channel
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE a.id = '1001';

/* Find all the orders that occurred in 2015.
Your final table should have 4 columns: occurred_at, account name,
order total, and order total_amt_usd. */
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;


-- OTHER TYPES OF Joins

-- https://www.w3schools.com/sql/sql_union.asp (UNION and UNION ALL)
-- http://www.w3resource.com/sql/joins/cross-join.php (CROSS JOIN)
-- https://www.w3schools.com/sql/sql_join_self.asp (SELF JOIN)
