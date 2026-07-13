/*
Using AND() & Multiple WHEN() Clauses
*/

/*
Categorize
- "High Value Order" if quantity >= 2 & netprice >= 50
- "Standard Order" otherwise
*/

SELECT
	orderdate,
	quantity,
	netprice,
	CASE
		WHEN quantity >= 2 AND netprice >= 50 THEN 'High Value Order' 
		ELSE 'Standard Order' END AS Order_Type
FROM sales;

/*
Categorize
- "Multiple High Value Items" if quantity >= 2 and netprice >= 100
- "Single High Value Item" if netprice >= 100
- "Multiple Standard Items" if quantity >= 2
- "Single Standard Item" Otherwise
*/

SELECT
	orderdate,
	quantity,
	netprice,
	CASE
		WHEN quantity >= 2 AND netprice >= 100 THEN 'Multiple High Value Items'
		WHEN netprice >= 100 THEN 'Single High Value Item'
		WHEN quantity >= 2 THEN 'Multiple Standard Items'
		ELSE 'Single Standard Item'
	END Order_Type
FROM sales;

/*
Using AND & Multiple Conditions
*/


/*
MEDIAN net_revenue between 2022 & 2023
*/

SELECT
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (quantity * netprice * exchangerate)) AS median
FROM 
	sales
WHERE
	orderdate BETWEEN '2022-01-01' AND '2023-12-31';

/*
low_revenue & high_revenue based on median in 2022 & 2023
*/

SELECT
	p.categoryname AS category,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) < 398
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS low_net_revenue,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) >= 398
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS high_net_revenue
FROM 
	sales s
	LEFT JOIN product p ON s.productkey = p.productkey
GROUP BY
	p.categoryname
ORDER BY
	p.categoryname;


/*Final Query*/

SELECT
	p.categoryname AS category,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) < 398 AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS low_2022_net_revenue,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) >= 398 AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS high_2022_net_revenue,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) < 398 AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS low_2023_net_revenue,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) >= 398 AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS high_2023_net_revenue
FROM 
	sales s
	LEFT JOIN product p ON s.productkey = p.productkey
GROUP BY
	p.categoryname
ORDER BY
	p.categoryname;

/*
Without Hard coding the median value 
*/

WITH median_value AS (
	SELECT
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (quantity * netprice * exchangerate)) AS median
	FROM 
		sales
	WHERE
		orderdate BETWEEN '2022-01-01' AND '2023-12-31'
)

SELECT
	p.categoryname AS category,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) < mv.median AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS low_2022_net_revenue,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) >= mv.median AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS high_2022_net_revenue,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) < mv.median AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS low_2023_net_revenue,
	SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) >= mv.median AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
		THEN (s.quantity * s.netprice * s.exchangerate) END) AS high_2023_net_revenue
FROM 
	sales s
	LEFT JOIN product p ON s.productkey = p.productkey,
	median_value AS mv
GROUP BY
	p.categoryname
ORDER BY
	p.categoryname;
