

-- Revenue Growth

-- 1. What is the year-over-year (YoY) revenue growth rate?
WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM order_date)::INT AS year,
        SUM(sales_amount) AS revenue
    FROM fact_sales
    WHERE EXTRACT(YEAR FROM order_date)::INT  IN (2020,2021,2022)
    GROUP BY 1
)
SELECT
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) AS previous_year_revenue,
    ROUND(
        (
            revenue
            - LAG(revenue) OVER (ORDER BY year)
        )
        * 100.0
        / LAG(revenue) OVER (ORDER BY year),
        2
    ) AS yoy_growth_rate
FROM yearly_revenue
ORDER BY year;


-- 2. Which markets contribute the most revenue?
SELECT
	dst.sales_territory_region ,
	round(sum(t.sales_amount), 2) AS total_revenue, 
	round(sum(t.sales_amount - t.order_quantity * t.product_standard_cost),2)  AS profit
FROM
	fact_sales t
JOIN dim_sales_territory dst
		USING (sales_territory_key)
GROUP BY
	dst.sales_territory_region
ORDER BY
	total_revenue DESC


-- 3. Is there any seasonal pattern in sales performance?
WITH revenue_1 AS (
SELECT
	EXTRACT(MONTH FROM order_date)::INT AS MONTH,
	SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2020 THEN sales_amount ELSE 0 END) AS revenue_2020,
	SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2021 THEN sales_amount ELSE 0 END) AS revenue_2021,
	SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN sales_amount ELSE 0 END) AS revenue_2022
FROM
	fact_sales
GROUP BY
	1)
	
,revenue_2 AS (
SELECT
	MONTH,
	revenue_2020,
	sum(revenue_2020) OVER() AS total_2020,
	revenue_2021,
	sum(revenue_2021) OVER() AS total_2021,
	revenue_2022,
	sum(revenue_2022) OVER() AS total_2022
FROM
	revenue_1)
SELECT
	MONTH,
	round(revenue_2020 / total_2020 * 100 , 2) || '%' AS sharing_2020,
	round(revenue_2021 / total_2021 * 100 , 2) || '%' AS sharing_2021,
	round(revenue_2022 / total_2022 * 100 , 2) || '%' AS sharing_2022
FROM
	revenue_2 
	
-- Product Profitability	
-- 1. Which product categories generate the most revenue?
SELECT
	dp.category,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
LEFT JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.category
ORDER BY
	revenue DESC
LIMIT 5;
-- 2. Which categories contribute the most profit?

	
SELECT
	dp.category,
	sum(t.sales_amount) AS revenue
,
	sum(t.sales_amount - t.order_quantity * t.product_standard_cost ) AS profit
FROM
	fact_sales t
LEFT JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.category
ORDER BY
	revenue DESC
LIMIT 5;

-- 3. Is revenue concentrated in a small number of products?

SELECT
	dp.product_name,
	sum(t.sales_amount) AS revenue,
	count(*) AS quantity
FROM
	fact_sales t
LEFT JOIN dim_product dp
		USING(product_key)
GROUP BY
	dp.product_name
ORDER BY
	revenue DESC
LIMIT 10; 

-- Customer Behavior
-- 1. How often do customers return to purchase?
WITH customer_purchase AS (
    SELECT
        customer_key,
        COUNT(DISTINCT order_key) AS purchase_count
    FROM fact_sales
    GROUP BY customer_key
)

SELECT
    purchase_count,
    COUNT(*) AS number_of_customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM customer_purchase
GROUP BY purchase_count
ORDER BY purchase_count;


-- 2. Which age group generates the highest revenue?
SELECT
	dc.age_group,
	sum(t.sales_amount) AS Revenue
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
GROUP BY
	dc.age_group; 


-- 3. Who are the Top 10 customers by revenue?
SELECT
	dc.customer_key ,
	dc.customer_name ,
	sum(t.sales_amount) AS Total_Revenue
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
GROUP BY
	dc.customer_key
ORDER BY
	total_revenue DESC
LIMIT 10
	
-- 
-- 1. How does each sales territory perform?
-- Q1. How does each sales territory perform?

WITH territory_performance AS (
    SELECT
        st.sales_territory_region,
        COUNT(DISTINCT f.customer_key) AS customers,
        SUM(f.sales_amount) AS revenue,
        SUM(f.sales_amount - f.order_quantity * f.product_standard_cost) AS profit
    FROM fact_sales f
    JOIN dim_sales_territory st
        USING (sales_territory_key)
    GROUP BY st.sales_territory_region
)

SELECT
    sales_territory_region,
    customers,
    ROUND(revenue, 2) AS revenue,
    ROUND(profit, 2) AS profit,
    ROUND(profit / revenue * 100, 2) AS profit_margin,
    ROUND(revenue / SUM(revenue) OVER () * 100, 2) AS revenue_share
FROM territory_performance
ORDER BY revenue DESC;
	
-- 2. Which sales territory has the highest average revenue per customer?
SELECT
    st.sales_territory_region,
    COUNT(DISTINCT f.customer_key) AS customers,
    ROUND(SUM(f.sales_amount), 2) AS revenue,
    ROUND(
        SUM(f.sales_amount) /
        COUNT(DISTINCT f.customer_key),
        2
    ) AS avg_revenue_per_customer
FROM fact_sales f
JOIN dim_sales_territory st
    USING (sales_territory_key)
GROUP BY st.sales_territory_region
ORDER BY avg_revenue_per_customer DESC;


-- 3. Which sales territory has the highest average order value?
SELECT
    st.sales_territory_region,
    COUNT(DISTINCT f.order_key) AS orders,
    ROUND(SUM(f.sales_amount), 2) AS revenue,
    ROUND(
        SUM(f.sales_amount) /
        COUNT(DISTINCT f.order_key),
        2
    ) AS avg_order_value
FROM fact_sales f
JOIN dim_sales_territory st
    USING (sales_territory_key)
GROUP BY st.sales_territory_region
ORDER BY avg_order_value DESC;
	
--- Advanced Analytics Techniques Applied
-- 1. Do 20% of products generate 80% of revenue? (Pareto analysis)
WITH metric AS (
SELECT
	product_key,
	SUM(sales_amount) AS revenue_by_product
FROM
	fact_sales
GROUP BY
	product_key
),
pareto_frame AS (
SELECT
	*,
	SUM(revenue_by_product) OVER() AS total_revenue,
	SUM(revenue_by_product) OVER (
ORDER BY
	revenue_by_product DESC
    ROWS BETWEEN UNBOUNDED PRECEDING
             AND CURRENT ROW
) AS running_total
FROM
	metric
)

SELECT
	COUNT(*) AS products_for_80_percent,
	(
	SELECT
		COUNT(*)
	FROM
		metric) AS total_products,
	ROUND(
        COUNT(*)::NUMERIC /
        (SELECT COUNT(*) FROM metric) * 100,
        2
    ) || '%' AS product_percentage
FROM
	pareto_frame
WHERE
	running_total <= total_revenue * 0.8;

-- 2. Which products have low margins despite strong sales? (Product Portfolio Analysis)

WITH product_kpi AS (
    SELECT
        dp.product_name ,

        -- REVENUE
       round( SUM(sales_amount),2) AS revenue,

        -- COST
       round( SUM(order_quantity * product_standard_cost),2)  AS cost,

        -- PROFIT
        round(SUM(sales_amount - order_quantity * product_standard_cost),2) AS profit,

        -- MARGIN
        round(SUM(sales_amount - order_quantity * product_standard_cost)
        / NULLIF(SUM(sales_amount), 0),2) AS margin

    FROM fact_sales t 
    JOIN dim_product dp
    USING(product_key)
    GROUP BY  dp.product_name 
    
)
, ranked AS (
    SELECT *,
        PERCENT_RANK() OVER (ORDER BY revenue) AS revenue_rank,
        PERCENT_RANK() OVER (ORDER BY margin) AS margin_rank
    FROM product_kpi
)
, segmented AS (
    SELECT *,
        CASE
            WHEN revenue_rank >= 0.7 AND margin_rank >= 0.7 THEN 'STAR'
            WHEN revenue_rank >= 0.7 AND margin_rank < 0.3 THEN 'RISK (High Sales - Low Margin)'
            WHEN revenue_rank < 0.3 AND margin_rank >= 0.7 THEN 'OPPORTUNITY'
            ELSE 'LOW PERFORMER'
        END AS product_segment
    FROM ranked
)
SELECT *
FROM segmented
WHERE product_segment = 'RISK (High Sales - Low Margin)'
ORDER BY revenue DESC;
	
	
	
	
	

	