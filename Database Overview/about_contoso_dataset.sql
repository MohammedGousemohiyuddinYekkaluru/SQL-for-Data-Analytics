/*
Calculate Net Revenue
*/

SELECT
	(netprice * quantity * exchangerate) AS net_revenue
FROM sales;


/*
Recent sales >= 2020
*/

SELECT
	orderdate,
	(netprice * quantity * exchangerate) AS net_revenue
FROM sales
WHERE orderdate >= '2020-01-01';

/*
Add customer info
*/

SELECT
	s.orderdate,
	c.givenname,
	c.surname,
	c.countryfull,
	c.continent,
	(s.netprice * s.quantity * s.exchangerate) AS net_revenue
FROM sales s
LEFT JOIN customer c
ON s.customerkey = c.customerkey
WHERE orderdate >= '2020-01-01';

/*
Add product information
*/

SELECT
	s.orderdate,
	c.givenname,
	c.surname,
	c.countryfull,
	c.continent,
	p.productkey,
	p.productname,
	p.categoryname,
	p.subcategoryname,
	(s.netprice * s.quantity * s.exchangerate) AS net_revenue
FROM sales s
LEFT JOIN customer c
ON s.customerkey = c.customerkey
LEFT JOIN product p
ON p.productkey = s.productkey
WHERE orderdate >= '2020-01-01';

/*
High vs Low value ($1000)
*/

SELECT
	s.orderdate,
	c.givenname,
	c.surname,
	c.countryfull,
	c.continent,
	p.productkey,
	p.productname,
	p.categoryname,
	p.subcategoryname,
	(s.netprice * s.quantity * s.exchangerate) AS net_revenue,
	CASE 
		WHEN (s.netprice * s.quantity * s.exchangerate) > 1000 THEN 'HIGH'
		ELSE 'LOW'
	END high_low
FROM sales s
LEFT JOIN customer c
ON s.customerkey = c.customerkey
LEFT JOIN product p
ON p.productkey = s.productkey
WHERE orderdate >= '2020-01-01';