/*
ORDER BY in Window Functions
- Running Order Count & Running Avg. Revenue
*/

SELECT
	customerkey,
	orderdate,
	(quantity * netprice * exchangerate) AS net_revenue,
	COUNT(*) OVER (
		PARTITION BY customerkey
		ORDER BY orderdate
	) AS running_order_count,
	AVG(quantity * netprice * exchangerate) OVER (
		PARTITION BY customerkey
		ORDER BY orderdate
	) AS running_avg_revenue
FROM sales;

/*
Difference B/W
- ROW_NUM(), RANK() & DENSE_RANK
*/

SELECT
	customerkey,
	COUNT(*) AS total_orders,
	ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS total_orders_row_num,
	RANK() OVER(ORDER BY COUNT(*) DESC) AS total_orders_rank,
	DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS total_orders_dense_rank
FROM sales
GROUP BY customerkey
LIMIT 10;
