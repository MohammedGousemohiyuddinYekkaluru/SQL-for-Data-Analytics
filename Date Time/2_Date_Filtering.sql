/*
DATE_PART()
*/

SELECT
	orderdate,
	DATE_PART('YEAR', orderdate) AS order_year,
	DATE_PART('MONTH', orderdate) AS order_month,
	DATE_PART('DAY', orderdate) AS order_day
FROM sales
ORDER BY RANDOM()
LIMIT 10;

/*
EXTRACT
*/

SELECT
	orderdate,
	EXTRACT(YEAR FROM orderdate) AS order_year,
	EXTRACT(MONTH FROM orderdate) AS order_month,
	EXTRACT(DAY FROM orderdate) AS order_day
FROM sales
ORDER BY RANDOM()
LIMIT 10;

/*
Net_Revenue
*/

SELECT
	EXTRACT(YEAR FROM orderdate) AS order_year,
	EXTRACT(MONTH FROM orderdate) AS order_month,
	SUM(netprice * quantity * exchangerate) AS net_revenue
FROM sales
GROUP BY
	order_year, order_month
ORDER BY
	order_year, order_month;

/*
CURRENT_DATE & NOW()
*/

SELECT CURRENT_DATE;

SELECT NOW();

/*
Dynamic Filtering
- ORDERS of last 5 years
*/

SELECT
	s.orderdate,
	p.categoryname,
	SUM(s.netprice * s.quantity * s.exchangerate) AS net_revenue
FROM 
	sales s
LEFT JOIN 
	product p ON s.productkey = p.productkey
WHERE
	EXTRACT(YEAR FROM orderdate) >= EXTRACT(YEAR FROM CURRENT_DATE) -5
GROUP BY 
	s.orderdate, p.categoryname 
ORDER BY 
	s.orderdate, p.categoryname;