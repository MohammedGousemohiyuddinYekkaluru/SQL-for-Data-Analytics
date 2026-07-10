/*
Pivoting w/ Statistical Functions
MIN, MAX, AVG
*/

SELECT
	p.categoryname,
	AVG(CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS avg_netrevenue_2022,
	AVG(CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS avg_netrevenue_2023,
	MIN(CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS min_netrevenue_2022,
	MIN(CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS min_netrevenue_2023,
	MAX(CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS max_netrevenue_2022,
	MAX(CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS max_netrevenue_2023
FROM sales s
LEFT JOIN product p ON p.productkey = s.productkey
GROUP BY p.categoryname 
ORDER BY p.categoryname;

/*
Pivoting w/ the Median
PERCENTILE_CONT(0.5)
*/

SELECT
	p.categoryname,
	PERCENTILE_CONT(.50) WITHIN GROUP (ORDER BY CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS medianSales_2022,
	PERCENTILE_CONT(.50) WITHIN GROUP (ORDER BY CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN (s.netprice * s.quantity * s.exchangerate) END) AS medianSales_2023
FROM sales s
LEFT JOIN product p ON p.productkey = s.productkey
GROUP BY p.categoryname 
ORDER BY p.categoryname;