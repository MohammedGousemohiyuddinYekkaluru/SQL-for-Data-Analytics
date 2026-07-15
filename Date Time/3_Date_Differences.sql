/*
INTERVAL
*/

SELECT INTERVAL '5 months';

/*
last 5 years using INTERVAL
*/

SELECT
	CURRENT_DATE,
	orderdate
FROM sales
WHERE
	orderdate >= CURRENT_DATE - INTERVAL '5 YEARS';

/*
Dynamic Filtering
- ORDERS of last 5 years
- Using INTERVAL
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
	s.orderdate >= CURRENT_DATE - INTERVAL '5 YEARS'  -- last 5 years
GROUP BY 
	s.orderdate, p.categoryname 
ORDER BY 
	s.orderdate, p.categoryname;

/*
AGE() & EXTRACT()
*/

SELECT
	orderdate,
	deliverydate
FROM sales;


SELECT AGE('2026-07-15', '2024-04-10') - INTERVAL '5 DAYS';


/*
Processing time in last 5 years
*/

SELECT
	EXTRACT(YEAR FROM orderdate) AS order_year,
	ROUND(AVG(EXTRACT(DAYS FROM AGE(deliverydate, orderdate))), 2) AS avg_processing_time,
	CAST(SUM(netprice * quantity * exchangerate) AS INTEGER) AS net_revenue
FROM sales
WHERE orderdate >= CURRENT_DATE - INTERVAL '5 YEARS'
GROUP BY order_year
ORDER BY order_year;