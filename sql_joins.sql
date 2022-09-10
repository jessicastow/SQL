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

/* Provide a table that provides the region for each sales_rep along
with their associated accounts. Your final table should include three columns:
the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name. */
