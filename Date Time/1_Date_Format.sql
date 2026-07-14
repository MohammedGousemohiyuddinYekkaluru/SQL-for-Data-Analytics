/*
DATE_TRUNC()
*/

SELECT
	DATE_TRUNC('MONTH', orderdate)::DATE AS order_month,
	SUM(quantity * netprice * exchangerate) AS net_revenue,
	COUNT(DISTINCT customerkey) AS total_unique_customers
FROM sales
GROUP BY order_month;

/*
TO_CHAR()
*/

SELECT
	orderdate,
	TO_CHAR(orderdate, 'YYYY')
FROM sales
ORDER BY RANDOM()
LIMIT 10;

/**/

SELECT
	TO_CHAR(orderdate, 'YYYY-MM') AS order_month,
	SUM(quantity * netprice * exchangerate) AS net_revenue,
	COUNT(DISTINCT customerkey) AS total_unique_customers
FROM sales
GROUP BY order_month;