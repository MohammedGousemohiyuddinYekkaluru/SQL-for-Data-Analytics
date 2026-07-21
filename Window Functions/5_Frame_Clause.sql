/*
FRAME CLAUSE
*/

/*
ROWS & CURRENT ROW
- 2023 MONTHLY REVENUE
*/

WITH monthly_sales AS (
	SELECT
		TO_CHAR(orderdate, 'YYYY-MM') AS month,
		SUM(netprice * quantity * exchangerate) AS monthly_revenue
	FROM sales
	WHERE EXTRACT(YEAR FROM orderdate) = 2023
	GROUP BY month
	ORDER BY month
)

SELECT
	month,
	monthly_revenue,
	AVG(monthly_revenue) OVER(
		ORDER BY month
		ROWS BETWEEN CURRENT ROW AND CURRENT ROW
	) AS net_revenue_current
FROM monthly_sales;

/*
N PRECEDING & N FOLLOWING
- 2023 monthly net revenue 
*/

WITH monthly_sales AS (
	SELECT
		TO_CHAR(orderdate, 'YYYY-MM') AS month,
		SUM(netprice * quantity * exchangerate) AS monthly_revenue
	FROM sales
	WHERE EXTRACT(YEAR FROM orderdate) = 2023
	GROUP BY month
	ORDER BY month
)

SELECT
	month,
	monthly_revenue,
	AVG(monthly_revenue) OVER(
		ORDER BY month
		ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	) AS avg_net_revenue_3months
FROM monthly_sales;

/*
UNBOUNDED PRECEDING/ FOLLOWING
*/

WITH monthly_sales AS (
	SELECT
		TO_CHAR(orderdate, 'YYYY-MM') AS month,
		SUM(netprice * quantity * exchangerate) AS monthly_revenue
	FROM sales
	WHERE EXTRACT(YEAR FROM orderdate) = 2023
	GROUP BY month
	ORDER BY month
)

SELECT
	month,
	monthly_revenue,
	AVG(monthly_revenue) OVER(
		ORDER BY month
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS avg_net_revenue,
	AVG(monthly_revenue) OVER(
		ORDER BY month
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS avg_net_revenue
FROM monthly_sales;