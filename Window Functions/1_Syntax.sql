/*
OVER()
*/

SELECT
	customerkey,
	orderkey,
	linenumber,
	(netprice * quantity * exchangerate) AS net_revenue
FROM sales
ORDER BY customerkey
LIMIT 10;

/*
AVG()
*/

SELECT
	AVG(netprice * quantity * exchangerate) AS avg_net_revenue
FROM sales;

/*
AVG net revenue of all orders
*/

SELECT
	customerkey,
	orderkey,
	linenumber,
	(netprice * quantity * exchangerate) AS net_revenue,
	AVG(netprice * quantity * exchangerate) OVER() AS avg_net_revenue_all_orders
FROM sales
ORDER BY customerkey
LIMIT 10;

/*
AVG net revenue of all orders by customers
*/

SELECT
	customerkey,
	orderkey,
	linenumber,
	(netprice * quantity * exchangerate) AS net_revenue,
	AVG(netprice * quantity * exchangerate) OVER() AS avg_net_revenue_all_orders,
	AVG(netprice * quantity * exchangerate) OVER(PARTITION BY customerkey) AS avg_net_revenue_customer 
FROM sales
ORDER BY customerkey
LIMIT 10;

/*
Window Function w/ SUM()
- Grouping by First Orders
*/

SELECT
	orderdate,
	orderkey * 10 + linenumber AS order_line_number,
	(netprice * quantity * exchangerate) AS net_revenue,
	SUM(netprice * quantity * exchangerate) OVER(PARTITION BY orderdate) AS daily_net_revenue,
	(netprice * quantity * exchangerate) * 100 / SUM(netprice * quantity * exchangerate) OVER(PARTITION BY orderdate) AS pct_daily_revenue
FROM sales
ORDER BY
	orderdate,
	pct_daily_revenue DESC
LIMIT 10;


/*
using subquery()
*/

SELECT *,
	net_revenue * 100 / daily_net_revenue AS pct_daily_revenue
FROM (
	SELECT
		orderdate,
		orderkey * 10 + linenumber AS order_line_number,
		(netprice * quantity * exchangerate) AS net_revenue,
		SUM(netprice * quantity * exchangerate) OVER(PARTITION BY orderdate) AS daily_net_revenue
	FROM sales) AS revenue_by_day;

/*
Cohort Analysis w/ MIN()
*/

WITH yearly_cohort AS (
	SELECT DISTINCT
		customerkey,
		EXTRACT(YEAR FROM MIN(orderdate) OVER(PARTITION BY customerkey)) AS cohort_year
	FROM sales
)

SELECT 
	y.cohort_year,
	EXTRACT(YEAR FROM orderdate) AS purchase_year,
	SUM(s.netprice * s.quantity * s.exchangerate) AS net_revenue
FROM 
	sales s
LEFT JOIN 
	yearly_cohort y ON s.customerkey = y.customerkey
GROUP BY
	y.cohort_year,
	purchase_year;