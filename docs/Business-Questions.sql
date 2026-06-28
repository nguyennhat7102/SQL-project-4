


-- I. Revenue Performance 
-- 1. What is the total revenue generated during the analysis period?
SELECT
	SUM(sales_amount) AS total_revenue
FROM
	fact_sales;

-- 2. How has revenue changed over time?
SELECT
	EXTRACT(YEAR FROM order_date) AS YEAR,
	SUM(sales_amount) AS total_revenue
FROM
	fact_sales
GROUP BY
	EXTRACT(YEAR FROM order_date)
ORDER BY
	total_revenue DESC;


SELECT
	dd.YEAR,
	SUM(T.sales_amount) AS total_revenue
FROM
	fact_sales t
LEFT JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
GROUP BY
	dd."year"
ORDER BY
	total_revenue DESC;
	
	
-- 3. Which year generated the highest revenue?
SELECT
	dd.YEAR,
	SUM(T.sales_amount) AS total_revenue
FROM
	fact_sales t
LEFT JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
GROUP BY
	dd."year"
ORDER BY
	total_revenue DESC
LIMIT 1;

-- 4. Which month generated the highest revenue?
SELECT
	dd.YEAR, dd.month_name ,
	SUM(t.sales_amount) AS total_revenue
FROM
	fact_sales t
LEFT JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
GROUP BY
	dd."year" , dd.month_name 
ORDER BY
	total_revenue DESC
LIMIT 1;


SELECT
	DATE_TRUNC('month', order_date) AS MONTH,
	SUM(sales_amount) AS total_revenue
FROM
	fact_sales
GROUP BY
	1
ORDER BY
	total_revenue DESC;


-- 5. Which month generated the lowest revenue?

SELECT
	dd.YEAR, dd.month_name ,
	SUM(t.sales_amount) AS total_revenue
FROM
	fact_sales t
LEFT JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
GROUP BY
	dd."year" , dd.month_name 
ORDER BY
	total_revenue ASC
LIMIT 1;

-- 6. Is there any seasonal pattern in sales performance?
SELECT
	EXTRACT(MONTH FROM order_date)::INT AS MONTH,
	SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2019 THEN sales_amount ELSE 0 END) AS revenue_2019,
	SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2020 THEN sales_amount ELSE 0 END) AS revenue_2020,
	SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2021 THEN sales_amount ELSE 0 END) AS revenue_2021
FROM
	fact_sales
GROUP BY
	1
ORDER BY
	1;

-- 6. What is the year-over-year (YoY) revenue growth rate?
WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM order_date)::INT AS year,
        SUM(sales_amount) AS revenue
    FROM fact_sales
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
	

-- II. Product Performance
-- 1. Which products generate the highest revenue?
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
	revenue DESC;

-- 2. Which products sell the most units?

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
	quantity DESC;

-- 3. Which products perform poorly in terms of sales?

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
	revenue ASC
LIMIT 5; 

-- 4. What are the Top 10 products by revenue?

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
	
-- 5. What are the Top 10 products by sales volume?

	
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
	quantity DESC
LIMIT 10; 



-- Category Performance
-- 6. Which product category generates the highest revenue and the most units?
SELECT
	dp.category,
	sum(t.sales_amount) AS revenue,
	count(*) AS num
FROM
	fact_sales t
LEFT JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.category
ORDER BY
	revenue DESC
LIMIT 5;
	
-- 7. Which product color is the most popular among customers?
SELECT
	dp.color ,
	count(*) AS num_color
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
WHERE
	(COLOR != 'NA')
GROUP BY
	dp.color
ORDER BY
	num_color DESC;

-- 8. How does revenue vary by product color? 

SELECT
	dp.color ,
	count(*) AS num_color,
	SUM(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
WHERE
	(COLOR != 'NA')
GROUP BY
	dp.color
ORDER BY
	num_color DESC;

-- Group by category and color

SELECT
	dp.category ,
	dp.color , 
	count(*) AS num_color,
	SUM(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)

GROUP BY
	dp.category ,dp.color
ORDER BY
	dp.category , num_color DESC;


-- 9. How do current products compare with outdated products in terms of sales performance?

SELECT
	dd.YEAR,
	dp.status,
	
	SUM(t.sales_amount) AS revenue
FROM
	fact_sales t
LEFT JOIN dim_product dp
		USING (product_key)
LEFT JOIN dim_date dd
ON
	t.order_date_key = dd.date_key
GROUP BY
	dd.YEAR ,
	dp.status
ORDER BY
 	dd.YEAR,	revenue DESC;

-- III. Customer Analysisc
 -- Customer Demographics --
--1. Do male or female customers contribute more revenue?
SELECT
	dc.gender ,
	sum(t.sales_amount) AS total_revenue
FROM
	fact_sales t
LEFT JOIN dim_customer dc
		USING (customer_key)
GROUP BY
	gender

---
SELECT
	dd.YEAR, dc.gender , 
	sum(t.sales_amount) AS total_revenue
FROM
	fact_sales t
LEFT JOIN dim_customer dc
		USING (customer_key)
LEFT JOIN dim_date dd 
ON dd.date_key = t.order_date_key 
GROUP BY
	dd.YEAR, dc.gender	
ORDER BY dd."year" 


-- 2. Which age group generates the highest revenue?

WITH tmp AS (
SELECT
	EXTRACT(YEAR FROM t.order_date ) - EXTRACT(YEAR FROM dc.birth_date ) AS age
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
)
SELECT
    MIN(age),
    MAX(age),
    round(AVG(age),2) AS avg,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY age) AS q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age) AS median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY age) AS q3
FROM tmp;

----------------
WITH tmp AS (
SELECT
	t.customer_key,
	EXTRACT(YEAR FROM t.order_date ) - EXTRACT(YEAR FROM dc.birth_date ) AS age
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
)
SELECT
	CASE
		WHEN age BETWEEN 34 AND 44 THEN '35-44'
		WHEN age BETWEEN 45 AND 54 THEN '45-54'
		WHEN age BETWEEN 55 AND 64 THEN '55-64'
		ELSE '65+'
	END AS group_age,
	sum (t.sales_amount) AS revenue
FROM
	fact_sales t
LEFT JOIN tmp
		USING(customer_key)
GROUP BY
	group_age
ORDER By revenue DESC;
	
-- 3. Do married customers spend more than single customers?
SELECT
	dc.marital_status ,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_customer dc
		USING(customer_key)
GROUP BY
	dc.marital_status;
	
-- Customer Value --
	-- 4. Who are the Top 10 customers by revenue?
SELECT
	dc.customer_name ,
	sum(t.sales_amount) AS total_revenue,
	count(*) AS num_order
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
GROUP BY
	dc.customer_key
ORDER BY
	total_revenue DESC
LIMIT 10;

  -- 5. What is the average revenue per customer?
SELECT
	round (sum(t.sales_amount) / count(DISTINCT t.customer_key ),
	2) AS avg_revenue_each
FROM
	fact_sales t

-- 6. How many customers purchased only one product? 
	SELECT
	count(*) AS number_customers
FROM
	(
	SELECT
		t.customer_key ,
		count(*)
	FROM
		fact_sales t
	GROUP BY
		t.customer_key
	HAVING
		count(*) = 5 );
	
-- 7. What percentage of revenue comes from the top 10% of customers?

WITH customer_revenue AS (
    SELECT
        customer_key,
        SUM(sales_amount) AS revenue
    FROM fact_sales
    GROUP BY customer_key
)
SELECT
    *,
    ROW_NUMBER() OVER (
        ORDER BY revenue DESC
    ) AS ranking
FROM customer_revenue
LIMIT (
    SELECT CEIL(COUNT(*) * 0.1)
    FROM customer_revenue
);
	

-- IV. Geographic Analysis
-- Country Performance -- 
-- 1. Which countries generate the highest revenue?

SELECT
	dg.country_name ,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
LEFT JOIN dim_customer dc
		USING (customer_key)
LEFT JOIN dim_geography dg
		USING (geography_key)
GROUP BY
	dg.country_name
ORDER BY
	revenue DESC;

-- 2. Which countries show the strongest sales growth?
WITH country_year_sales AS (
SELECT
	dg.country_name,
	dd."year" ,
	SUM(sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_date dd 
    ON
	t.order_date_key = dd.date_key
JOIN dim_customer dc
		USING (customer_key)
JOIN dim_geography dg
		USING (geography_key)
GROUP BY
	dg.country_name,
	dd."year"
ORDER BY
	dd."year" ASC
)
SELECT
	country_name,
	YEAR,
	revenue,
	LAG(revenue) OVER (
        PARTITION BY country_name
ORDER BY
	YEAR
    ) AS prev_revenue,
	ROUND(
        (
            revenue - LAG(revenue) OVER (
                PARTITION BY country_name
                ORDER BY YEAR
            )
        ) * 100.0
        /
        NULLIF(
            LAG(revenue) OVER (
                PARTITION BY country_name
                ORDER BY YEAR
            ),
            0
        ),
        2
    ) || '%' AS growth_pct
FROM
	country_year_sales
	
---------- ver 2----------
	
	
WITH country_year_sales AS (
SELECT
	dg.country_name,
	dd."year" ,
	SUM(sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_date dd 
    ON
	t.order_date_key = dd.date_key
JOIN dim_customer dc
		USING (customer_key)
JOIN dim_geography dg
		USING (geography_key)
GROUP BY
	dg.country_name,
	dd."year"
ORDER BY
	dd."year" ASC
), 
growth_cal AS 
(
SELECT
	country_name,
	YEAR,
	revenue,
	LAG(revenue) OVER(PARTITION BY country_name ORDER BY YEAR ASC ) AS pre_year
FROM
	country_year_sales
)
SELECT
	* ,
	round ((revenue - pre_year) * 100 / pre_year ,
	2 )  AS growth_pct
FROM
	growth_cal
WHERE
	pre_year IS NOT NULL
ORDER BY growth_pct DESC

-- 3. Which countries have the largest customer base?

SELECT
	dg.country_name  ,
	count(DISTINCT t.customer_key ) AS num_customer
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
JOIN dim_geography dg
		USING (geography_key)
GROUP BY
	dg.country_name
ORDER BY
	num_customer DESC;


-- City Performance --
-- 4. Which cities contribute the most revenue?
SELECT
	dg.city ,
	sum(t.sales_amount) AS total_revenue, count (*) AS num
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
JOIN dim_geography dg
		USING (geography_key)
GROUP BY
	dg.city
ORDER BY
	total_revenue DESC;

-- 5. Which cities have the highest average spending per customer?

SELECT
	dg.city ,
	sum(t.sales_amount) AS total_revenue,
	count (DISTINCT dc.customer_key ) AS num_customer, count(*) AS quantity,
	round(sum(t.sales_amount) / count (DISTINCT dc.customer_key ),2) AS avg_per_cus
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
JOIN dim_geography dg
		USING (geography_key)
GROUP BY
	dg.city
ORDER BY
	avg_per_cus DESC;

-- 6. Which cities have the highest number of customers? 


SELECT
	dg.city ,
	count(DISTINCT dc.customer_key ) AS num_customer
FROM
	fact_sales t
JOIN dim_customer dc
		USING (customer_key)
JOIN dim_geography dg
		USING (geography_key)
GROUP BY
	dg.city
ORDER BY
	num_customer DESC;
	
-- Sales Territory Analysis 
-- 7. Which sales territory performs the best?

SELECT
	sales_territory_region,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_sales_territory dst
		USING (sales_territory_key)
GROUP BY
	sales_territory_region
ORDER BY
	revenue DESC;  

-- 8. Which sales territory underperforms?
SELECT
	sales_territory_region,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_sales_territory dst
		USING (sales_territory_key)
GROUP BY
	sales_territory_region
ORDER BY
	revenue;  
-- 9. How does revenue distribution vary across regions?
WITH tmp AS (
SELECT
	sales_territory_region,
	sum(t.sales_amount) AS revenue, 
	sum(t.sales_amount) * 100 / sum(sum(t.sales_amount)) OVER() AS SHARE
FROM
	fact_sales t
JOIN dim_sales_territory dst
		USING (sales_territory_key)
GROUP BY
	sales_territory_region
ORDER BY
	revenue
)

SELECT
	sales_territory_region,
	revenue,
	round(SHARE, 2) || '%'
FROM
	tmp ;


-- V. Profitability Analysis
-- Profit Performance -- 
-- 1. What is the total profit generated? (Revenue - Cost)
SELECT
	SUM(sales_amount - order_quantity * product_standard_cost) AS total_profit,
	sum(t.sales_amount) AS sales_amount
FROM
	fact_sales t
	
-- 2. What is the overall profit margin? (Profit Margin (%) → Profit / Revenue) 
	
SELECT
	SUM(sales_amount - order_quantity * product_standard_cost) AS total_profit,
	sum(t.sales_amount) AS sales_amount,
	Round(SUM(sales_amount - order_quantity * product_standard_cost) / sum(t.sales_amount),2) AS profit_margin
FROM
	fact_sales t
	
-- 3. Which products generate the highest profit? 
	
SELECT
	dp.product_name ,
	t.sales_amount - t.order_quantity * t.product_standard_cost AS Profit_by_Product
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
GROUP BY dp.product_name, Profit_by_Product
ORDER BY
	Profit_by_Product DESC;


	--- ver 2 ---
	SELECT DISTINCT 
		dp.product_name ,
		t.sales_amount - t.order_quantity *  t.product_standard_cost AS Profit_by_Product
	FROM
		fact_sales t
	JOIN dim_product dp
			USING (product_key)
	ORDER BY
		Profit_by_Product DESC;
	
-- 4. Which product categories generate the highest profit?
SELECT 
	dp.category ,
	round(sum(t.sales_amount), 2) AS sales_amount,
	round(sum(t.sales_amount - t.order_quantity *  t.product_standard_cost ), 2) AS Profit_by_category, 
	round(round(sum(t.sales_amount - t.order_quantity *  t.product_standard_cost ), 2) / round(sum(t.sales_amount), 2),2)
FROM 
	fact_sales t
JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.category
ORDER BY
	Profit_by_category DESC;

-- Margin Analysis --
-- 5. Which products have the highest profit margins?
SELECT DISTINCT 
	dp.product_name ,
	round((t.sales_amount - t.order_quantity *  t.product_standard_cost ) / t.sales_amount ,2) AS profit_margin_by_product
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
ORDER BY
	profit_margin_by_product DESC
LIMIT 10; 

-- 6. Which products have low margins despite strong sales?

WITH product_kpi AS (
    SELECT
        product_key,

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
    GROUP BY product_key
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


----------
WITH performence_metric AS (
SELECT
	DISTINCT dp.product_name,
	t.sales_amount ,
	round((t.sales_amount - t.order_quantity * t.product_standard_cost), 2) AS profit,
	round((t.sales_amount - t.order_quantity * t.product_standard_cost), 2) / t.sales_amount AS margin
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)

), 
ranked AS (
SELECT
	*,
	percent_rank() OVER (
	ORDER BY sales_amount) AS revenue_rank,
	percent_rank() OVER (
	ORDER BY margin) AS margin_rank
FROM
	performence_metric
),
segment AS (
SELECT
	*,
	CASE
		WHEN revenue_rank >= 0.7
		AND margin_rank >= 0.7 THEN 'STAR'
		WHEN revenue_rank >= 0.7
		AND margin_rank<0.3 THEN 'RISK (High Sales - Low Margin)'
		WHEN revenue_rank<0.3
		AND margin_rank >= 0.7 THEN 'OPPORTUNITY'
		ELSE 'LOW PERFORMER'
	END AS product_segment
FROM
	ranked
)
SELECT
	*
FROM
	segment
WHERE
	product_segment = 'RISK (High Sales - Low Margin)'



WITH product_kpi AS (
    SELECT
        dp.product_name,

        -- Revenue theo product
        SUM(t.sales_amount) AS revenue,

        -- Cost theo product
        SUM(t.order_quantity * t.product_standard_cost) AS cost,

        -- Profit theo product
        SUM(t.sales_amount - t.order_quantity * t.product_standard_cost) AS profit,
        COUNT (*) AS count
    FROM fact_sales t
    JOIN dim_product dp
        USING (product_key)
    GROUP BY dp.product_name
    ORDER BY revenue DESC
),

product_metric AS (
    SELECT
        *,
        -- Margin chuẩn (không tính theo từng dòng nữa)
        profit / NULLIF(revenue, 0) AS margin
    FROM product_kpi
),

ranked AS (
    SELECT
        *,
        PERCENT_RANK() OVER (ORDER BY revenue) AS revenue_rank,
        PERCENT_RANK() OVER (ORDER BY margin) AS margin_rank
    FROM product_metric
),

segmented AS (
    SELECT
        *,
        CASE
            WHEN revenue_rank >= 0.7 AND margin_rank >= 0.7
                THEN 'STAR'

            WHEN revenue_rank >= 0.7 AND margin_rank < 0.3
                THEN 'RISK (High Sales - Low Margin)'

            WHEN revenue_rank < 0.3 AND margin_rank >= 0.7
                THEN 'OPPORTUNITY'

            ELSE 'LOW PERFORMER'
        END AS product_segment
    FROM ranked
)

SELECT *
FROM segmented
WHERE product_segment = 'RISK (High Sales - Low Margin)'
ORDER BY revenue DESC;

--------------------
WITH product_kpi AS (
SELECT
	dp.product_name,
	sum(t.sales_amount) AS revenue, 
	sum(t.order_quantity * t.product_standard_cost ) AS COST, 
	sum(t.sales_amount) - sum(t.order_quantity * t.product_standard_cost ) AS profit, 
	round((sum(t.sales_amount) - sum(t.order_quantity * t.product_standard_cost )) / sum(t.sales_amount), 2) AS margin
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.product_name 
	
),
ranked AS (
SELECT
	* ,
	percent_rank() OVER(ORDER BY revenue) AS revenue_rank, 
	percent_rank() OVER(ORDER BY margin) AS margin_rank
FROM
	product_kpi
),
segment_product AS (
SELECT
	*,
	CASE
		WHEN revenue_rank >= 0.7
		AND margin_rank >= 0.7 THEN 'Star'
		WHEN revenue_rank >= 0.7
		AND margin_rank < 0.3 THEN 'Rish - (Hight Sales - Low Margin)'
		WHEN revenue_rank < 0.3
		AND margin_rank >= 0.7 THEN 'Oppoturnity'
		ELSE 'Low Performence'
	END AS product_segment
FROM
	ranked 
)
SELECT
	*
FROM
	segment_product
WHERE
	product_segment = 'Rish - (Hight Sales - Low Margin)'
ORDER BY revenue 


-- V. Time-Based Analysis 
-- Annual Trends --
-- 
SELECT dd."year" , count(DISTINCT dd.month_name )
FROM fact_sales t 
JOIN 
dim_date dd 
ON t.order_date_key = dd.date_key 
GROUP BY dd."year" 

-- 1. How has revenue evolved year by year?
WITH revenue_change AS (
SELECT
	dd."year" ,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
WHERE dd."year" IN (2020, 2021,2022)
GROUP BY
	dd.YEAR
ORDER BY
	dd."year" 
)	
SELECT
	*,
	LAG(revenue,1,0) OVER (
	ORDER BY YEAR) AS pre_year ,
	round((revenue - LAG(revenue,1,0) OVER (ORDER BY YEAR)) * 100 / nullif(LAG(revenue,1,0) OVER (ORDER BY YEAR),0) , 2 )|| '%' AS growth
FROM
	revenue_change

-- 2. How has profit evolved year by year?
WITH revenue_change AS (
SELECT
	dd."year" ,
	sum(t.sales_amount) AS revenue, 
	sum(t.sales_amount - t.order_quantity * t.product_standard_cost) AS profit 
FROM
	fact_sales t
JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
WHERE dd."year" IN (2020, 2021,2022)

GROUP BY
	dd.YEAR
ORDER BY
	dd."year" 
)	
SELECT
	*,
	LAG(profit, 1, 0) OVER (ORDER BY YEAR) AS profit_pre_year, 
		round(((profit - LAG(profit, 1, 0) OVER (ORDER BY YEAR) ) * 100 
		/ nullif((	LAG(profit, 1, 0) OVER (ORDER BY YEAR)),0)),2) || '%' AS growth
	
FROM
	revenue_change

-- Monthly Trends -- 

-- 1. Which months consistently perform best?
WITH revenue_by_month AS (
SELECT
	dd."year",
	dd.month_name ,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
GROUP BY
	dd."year" ,
	dd.month_name 

),
ranked AS (
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY YEAR
ORDER BY
	revenue DESC) AS ranking
FROM
	revenue_by_month

)
SELECT
	month_name, count (*)
FROM
	ranked
WHERE
	ranking IN (1, 2, 3)
GROUP BY month_name
ORDER BY count DESC; 

-- 2. Which months consistently perform worst?

WITH revenue_by_month AS (
SELECT
	dd."year",
	dd.month_name ,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_date dd 
ON
	t.order_date_key = dd.date_key
GROUP BY
	dd."year" ,
	dd.month_name 

),
ranked AS (
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY YEAR
ORDER BY
	revenue ASC) AS ranking
FROM
	revenue_by_month

)
SELECT
	month_name, count (*)
FROM
	ranked
WHERE
	ranking IN (1, 2, 3)
GROUP BY month_name
ORDER BY count DESC;

------- Advanced Business Questions ----------
-- Pareto Analysis -- 
-- 1. Do 20% of products generate 80% of total revenue?
-- total_revenue = 29358677.89

WITH revenue_by_product AS (
SELECT
	dp.product_name,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.product_name
ORDER BY
	revenue DESC
),
pareto_revenue AS (
SELECT
	*,
	sum(revenue) OVER(ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS running_total
	, sum(revenue) over() AS total_revenue
FROM
	revenue_by_product
)
SELECT
	count(*) AS top_product_percent
FROM
	pareto_revenue
WHERE
	running_total <= 0.8 * total_revenue 


-- 2. Which products belong to the most valuable 20%?
	

WITH revenue_by_product AS (
SELECT
	dp.product_name,
	sum(t.sales_amount) AS revenue
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.product_name
ORDER BY
	revenue DESC
),
pareto_revenue AS (
SELECT
	*,
	sum(revenue) OVER(ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS running_total
	, sum(revenue) over() AS total_revenue
FROM
	revenue_by_product
)
SELECT
	*
FROM
	pareto_revenue
WHERE
	running_total <= 0.2 * total_revenue 


-- 3. What percentage of customers return for additional purchases?
WITH customer_orders AS (
    SELECT
        customer_key,
        COUNT(DISTINCT order_key) AS num_orders
    FROM fact_sales
    GROUP BY customer_key
)
SELECT
    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE num_orders > 1)
        / COUNT(*),
        2
    ) || '%' AS repeat_rate 
FROM customer_orders;



SELECT count(DISTINCT order_key)
FROM fact_sales 

SELECT count(*)
FROM (SELECT
	customer_key
FROM
	(
	SELECT
		customer_key ,
		order_key
	FROM
		fact_sales
	GROUP BY
		customer_key ,
		order_key )
GROUP BY
	customer_key
HAVING
	count(*) > 1
)
--- ver 2
SELECT COUNT(*)
FROM (
    SELECT
        customer_key
    FROM fact_sales
    GROUP BY customer_key
    HAVING COUNT(DISTINCT order_key) > 1
) t;



-- profit pool analysis by product category --
WITH kpi AS (
SELECT
	dp.category ,
	sum(t.sales_amount) AS revenue ,
	round(sum(t.order_quantity * t.product_standard_cost), 2) AS COST
,
	sum(t.sales_amount) - round(sum(t.order_quantity * t.product_standard_cost), 2) AS profit
FROM
	fact_sales t
JOIN dim_product dp
		USING (product_key)
GROUP BY
	dp.category ), 
kpis AS (
SELECT
	*,
	sum(revenue) OVER() AS total_revenue ,
	sum(profit) OVER() AS total_profit
FROM
	kpi )
SELECT
	category,
	round( revenue / total_revenue * 100 , 2) || '%' AS revenue_share,
	round( profit / total_profit * 100 , 2) || '%' AS profit_share,
	round( profit / total_profit * 100 , 2) - round( revenue / total_revenue * 100 , 2) AS GAP
FROM
	kpis









	