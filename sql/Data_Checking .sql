-- 1. Kiểm tra số lượng bản ghi. 
SELECT COUNT(*) FROM dim_customer; 
-- Expected: 18484

SELECT COUNT(*) FROM dim_product;
-- Expected: 395

SELECT COUNT(*) FROM dim_geography;
-- Expected: 655

SELECT COUNT(*) FROM dim_sales_territory;
-- Expected: 10

SELECT COUNT(*) FROM dim_date;
-- Expected: 6939

SELECT COUNT(*) FROM fact_sales;
-- Expected: 60398

-- 2. Kiểm tra Primary Key

SELECT
	sales_territory_key,
	COUNT(*)
FROM
	dim_sales_territory
GROUP BY
	sales_territory_key
HAVING
	COUNT(*) > 1;
-----------------
SELECT
	customer_key,
	COUNT(*)
FROM
	dim_customer
GROUP BY
	customer_key
HAVING
	COUNT(*) > 1;
-----------------
SELECT
	date_key,
	COUNT(*)
FROM
	dim_date
GROUP BY
	date_key
HAVING
	COUNT(*) > 1;
-----------------
SELECT
	product_key,
	COUNT(*)
FROM
	dim_product
GROUP BY
	product_key
HAVING
	COUNT(*) > 1;
-----------------
SELECT
	geography_key,
	COUNT(*)
FROM
	dim_geography
GROUP BY
	geography_key
HAVING
	COUNT(*) > 1;

-- 3. Kiểm tra giá trị NULL
SELECT
	*
FROM
	fact_sales
WHERE
	product_key IS NULL
	OR customer_key IS NULL
	OR sales_territory_key IS NULL
	OR sales_territory_key IS NULL
	OR order_date_key IS NULL;

-- 4. Kiểm tra Feature Engineering
SELECT
	age_group,
	COUNT(*)
FROM
	dim_customer
GROUP BY
	age_group;
-----------------
SELECT
	DISTINCT MONTH
FROM
	dim_date
ORDER BY
	MONTH;
-----------------
SELECT
	DISTINCT quarter
FROM
	dim_date;
-- 4. Kiểm tra toàn vẹn dữ liệu toàn bộ
SELECT
	count(*)
FROM
	fact_sales f
JOIN dim_product p
    ON
	f.product_key = p.product_key
JOIN dim_customer c
    ON
	f.customer_key = c.customer_key
JOIN dim_sales_territory s
    ON
	f.sales_territory_key = s.sales_territory_key
JOIN dim_date d
    ON
	f.order_date_key = d.date_key
	
-- Expected: 60398
-- 5. Kiểm tra dữ liệu Measure
SELECT *
FROM fact_sales
WHERE order_quantity <= 0;

SELECT *
FROM fact_sales
WHERE sales_amount < 0;

SELECT *
FROM fact_sales
WHERE product_standard_cost < 0;

-- Expected: 0


