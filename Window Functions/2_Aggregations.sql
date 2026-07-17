/*
Cohort Analysis w/ COUNT()
- Unique customers per year by cohort.
*/

WITH yearly_cohort AS (
	SELECT DISTINCT
		customerkey,
		EXTRACT(YEAR FROM (MIN(orderdate) OVER(PARTITION BY customerkey))) AS cohort_year,
		EXTRACT(YEAR FROM orderdate) AS purchase_year
	FROM sales
)

SELECT DISTINCT
	cohort_year,
	purchase_year,
	COUNT(customerkey) OVER(PARTITION BY cohort_year, purchase_year) AS num_customers
FROM yearly_cohort
ORDER BY
	cohort_year,
	purchase_year;

/*
Window Functions w/ GROUP BY()
- Window functions run after group by
- its best practice not to use group by with window functions use CTEs instead
*/

WITH customer_orders AS (
	SELECT
		customerkey,
		(netprice * quantity * exchangerate) AS order_value,
		COUNT(*) OVER(PARTITION BY customerkey) AS total_orders
	FROM sales
)

SELECT
	customerkey,
	total_orders,
	AVG(order_value) AS avg_net_revenue
FROM customer_orders
GROUP BY
	customerkey,
	total_orders;

/*
Cohort Analysis w/ AVG()
- customer Life time value(LTV)
*/

WITH yearly_cohort AS (
	SELECT
		customerkey,
		EXTRACT(YEAR FROM MIN(orderdate)) AS cohort_year,
		SUM(netprice * quantity * exchangerate) AS customer_ltv
	FROM 
		sales
	GROUP BY
		customerkey
)

SELECT
	*,
	AVG(customer_ltv) OVER(PARTITION BY cohort_year) AS avg_cohort_ltv
FROM 
	yearly_cohort
ORDER BY
	cohort_year,
	customerkey;

/*
Filtering w/ WHERE
- Cohort Year Analysis > 2020
*/

/*
Filtering Before window function
*/

SELECT
	customerkey,
	EXTRACT(YEAR FROM MIN(orderdate) OVER(PARTITION BY customerkey)) AS cohort_year
FROM sales
WHERE orderdate >= '2020-01-01'
ORDER BY customerkey;

/*
Filtering After window function
*/
WITH cohort AS (
	SELECT
		customerkey,
		EXTRACT(YEAR FROM MIN(orderdate) OVER(PARTITION BY customerkey)) AS cohort_year
	FROM sales
)

SELECT *
FROM cohort
WHERE cohort_year >= '2020';