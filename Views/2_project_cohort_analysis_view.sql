/*
Cohort Analysis View
*/

CREATE VIEW cohort_analysis AS
WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
		SUM(s.netprice * s.quantity * s.exchangerate) AS total_net_revenue,
		COUNT(s.orderkey),
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
	FROM sales s
	LEFT JOIN customer c ON c.customerkey = s.customerkey
	GROUP BY
		s.customerkey,
		s.orderdate,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
)
SELECT 
	cr.*,
	MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchase_date,
	EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year
FROM customer_revenue cr;



/**/

SELECT *
FROM cohort_analysis;

/*
Total Revenue per cohort
*/

SELECT
	cohort_year,
	SUM(total_net_revenue) AS total_revenue_per_cohort
FROM 
	cohort_analysis
GROUP BY 
	cohort_year
ORDER BY
	cohort_year DESC;


/*
ALTER or UPDATE views
*/

ALTER VIEW cohort_analysis RENAME COLUMN count TO num_orders;

-- OR

/*
Best Practice
- Drop & create new view
*/

DROP VIEW cohort_analysis;

CREATE OR REPLACE VIEW cohort_analysis AS
WITH customer_revenue AS (
      SELECT s.customerkey,
            s.orderdate,
            sum(s.netprice * s.quantity * s.exchangerate) AS total_net_revenue,
            count(s.orderkey) AS num_orders,
            c.countryfull,
            c.age,
            c.givenname,
            c.surname
        FROM sales s
             LEFT JOIN customer c ON c.customerkey = s.customerkey
       GROUP BY s.customerkey, s.orderdate, c.countryfull, c.age, c.givenname, c.surname
     )
SELECT customerkey,
    orderdate,
    total_net_revenue,
    num_orders,
    countryfull,
    age,
    givenname,
    surname,
    min(orderdate) OVER (PARTITION BY customerkey) AS first_purchase_date,
    EXTRACT(year FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
FROM customer_revenue cr;


/**/

SELECT * FROM cohort_analysis;