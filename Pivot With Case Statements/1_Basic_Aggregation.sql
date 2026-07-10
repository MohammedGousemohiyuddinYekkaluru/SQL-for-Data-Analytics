/*
Total customers per day in 2023
*/

/*
Count of all customers per day
*/

SELECT
	orderdate,
	COUNT(customerkey) AS total_customers
FROM sales
GROUP BY orderdate
ORDER BY orderdate;

/*
Count of all unique customers per day in the year 2023
*/

SELECT
	orderdate,
	COUNT(DISTINCT customerkey) AS total_customers
FROM sales
WHERE orderdate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY orderdate
ORDER BY orderdate;

/*
Pivot with COUNT()
Daily customers by region
*/

SELECT
	s.orderdate,
	COUNT(DISTINCT CASE WHEN c.continent = 'Europe' THEN s.customerkey END) AS eu_customers,
	COUNT(DISTINCT CASE WHEN c.continent = 'North America' THEN s.customerkey END) AS na_customers,
	COUNT(DISTINCT CASE WHEN c.continent = 'Australia' THEN s.customerkey END) AS au_customers
FROM sales s
LEFT JOIN customer c ON c.customerkey = s.customerkey
WHERE s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY s.orderdate
ORDER BY s.orderdate;

/*
Pivot with SUM()
Net Revenue by category in 2022 & 2023
*/

SELECT
	p.categoryname,
	SUM(CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS netrevenue_2022,
	SUM(CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS netrevenue_2023
FROM sales s
LEFT JOIN product p ON p.productkey = s.productkey
GROUP BY p.categoryname 
ORDER BY p.categoryname;


 


