/*
FIRST_VALUE(), LAST_VALUE(), LAG(), LEAD()
- Month-over-Month Revenue Growth
*/

/*
Monthly Revenue in 2023
*/

SELECT
	TO_CHAR(orderdate, 'YYYY-MM') AS month,
	SUM(quantity * netprice * exchangerate) AS net_revenue
FROM sales
WHERE orderdate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY month
ORDER BY month;

/*
FIRST_VALUE, LAST_VALUE & NTH_VALUE
*/

WITH monthly_revenue AS (
	SELECT
	TO_CHAR(orderdate, 'YYYY-MM') AS month,
	SUM(quantity * netprice * exchangerate) AS net_revenue
	FROM sales
	WHERE orderdate BETWEEN '2023-01-01' AND '2023-12-31'
	GROUP BY month
	ORDER BY month
)

SELECT 
	*,
	FIRST_VALUE(net_revenue) OVER(ORDER BY month) AS first_month_revenue,
	LAST_VALUE(net_revenue) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_month_revenue,
	NTH_VALUE(net_revenue, 3) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS third_month_revenue
FROM monthly_revenue;

/*
LAG, LEAD
- Month-over-month revenue growth
*/

WITH monthly_revenue AS (
	SELECT
	TO_CHAR(orderdate, 'YYYY-MM') AS month,
	SUM(quantity * netprice * exchangerate) AS net_revenue
	FROM sales
	WHERE orderdate BETWEEN '2023-01-01' AND '2023-12-31'
	GROUP BY month
	ORDER BY month
)

SELECT 
	*,
	LAG(net_revenue) OVER(ORDER BY month) AS previous_month_revenue,
	-- LEAD(net_revenue) OVER(ORDER BY month) AS next_month_revenue
	100 * (net_revenue - LAG(net_revenue) OVER(ORDER BY month)) / LAG(net_revenue) OVER(ORDER BY month) AS monthly_revenue_growth
FROM monthly_revenue;


/*
LTV change from cohort to cohort
*/

WITH yearly_cohort AS (
	SELECT
		customerkey,
		EXTRACT(YEAR FROM (MIN(orderdate))) AS cohort_year,
		SUM(quantity * netprice * exchangerate) AS customer_ltv
	FROM 
		sales
	GROUP BY
		customerkey
), cohort_summary AS (
	SELECT
		cohort_year,
		customerkey,
		customer_ltv,
		AVG(customer_ltv) OVER(PARTITION BY cohort_year) AS avg_cohort_ltv
	FROM
		yearly_cohort
	ORDER BY
		cohort_year,
		customerkey
), cohort_final AS (
	SELECT DISTINCT
		cohort_year,
		avg_cohort_ltv
	FROM 
		cohort_summary
	ORDER BY cohort_year
)

SELECT 
	*,
	LAG(avg_cohort_ltv) OVER(ORDER BY cohort_year) AS previous_cohort_ltv,
	100 * (avg_cohort_ltv - LAG(avg_cohort_ltv) OVER(ORDER BY cohort_year)) / 
	LAG(avg_cohort_ltv) OVER(ORDER BY cohort_year) AS ltv_change
FROM cohort_final;