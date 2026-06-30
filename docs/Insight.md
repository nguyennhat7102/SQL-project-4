# AdventureWorks Sales & Customer Analytics

## Project Overview

AdventureWorks is a bicycle retailer operating across multiple regions and product categories. The objective of this project is to analyze sales performance, profitability, customer behavior, and retention patterns to identify opportunities for revenue growth and profit optimization.

### Tools Used

- PostgreSQL
- SQL (CTE, Window Functions, Cohort Analysis)
- Data Warehouse Modeling (Star Schema)
- Power BI (Visualization)

---

# Business Questions

## Revenue Growth

1. How has revenue changed over time?

| Year | Revenue | YoY Growth |
| --- | --- | --- |
| 2020 | 7.08M | — |
| 2021 | 5.84M | -17.43% |
| 2022 | 16.35M | 179.87% |
> Insight: After a 17.43% decline in 2021, revenue experienced a strong rebound in 2022, suggesting substantial business growth.
### Recommendation

> **Investigate the key drivers behind the strong growth in 2022, such as high-performing products, customer acquisition, or successful sales campaigns, and replicate these strategies in future periods.**
>
2. Which markets contribute the most revenue?

| Sales Territory |   Revenue |
| --------------- | --------: |
| Australia       | **9.06M** |
| Southwest       | **5.72M** |
| Northwest       | **3.65M** |
| United Kingdom  | **3.39M** |
| Germany         | **2.89M** |
| France          | **2.64M** |
| Canada          | **1.98M** |
| Southeast       |       12K |
| Northeast       |        6K |
| Central         |        3K |

> Insight: Australia generated the highest revenue (9.06M), followed by Southwest (5.72M), while Central, Northeast, and Southeast contributed only a negligible share of total sales.

### Recommendation

>Maintain investment in high-performing markets such as Australia while investigating the low-performing regions to identify potential issues related to customer coverage, product demand, or sales strategy.
3. Are there seasonal sales patterns?

| Month | 2020 | 2021 | 2022 |
| --- | --- | --- | --- |
| 1–2 | 6–8% | 8–9% | 4–5% |
| 3–5 | 6–8% | 6–7% | 6–8% |
| **6** | **10.43%** | **9.50%** | **10.05%** |
| 7–9 | 8–9% | 7–9% | 8–9% |
| **10** | **10.01%** | **9.16%** | **10.23%** |
| **11** | **9.34%** | **9.21%** | **10.89%** |
| **12** | **9.46%** | **10.69%** | **11.46%** |

> Insight: Sales exhibit a clear seasonal pattern. Revenue contribution consistently increases during the second half of the year, particularly from June and again from October to December. June serves as the first sales peak, while Q4 (October–December) consistently contributes the largest share of annual revenue, indicating stronger customer demand toward year-end.

### Recommendation
>Prepare inventory, marketing campaigns, and staffing resources before the peak sales periods, especially from June and during Q4, to maximize revenue opportunities.

## Product Profitability

1. Which product categories generate the most revenue?

| Category    |       Revenue | Quantity Sold |
| ----------- | ------------: | ------------: |
| Bikes       | 28,318,145.32 |        15,205 |
| Accessories |    700,759.96 |        36,092 |
| Clothing    |    339,772.61 |         9,101 |


>Insight: Although Accessories account for the highest sales volume, their low unit prices result in a relatively small contribution to total revenue. In contrast, Bikes generate substantially higher revenue with fewer units sold, indicating that bicycles are high-value products and remain the company's primary revenue driver.

### Recommendation
>Continue prioritizing the **Bikes** category in inventory planning and marketing campaigns, as it contributes the largest share of revenue.
Use **Accessories** as complementary products through cross-selling or bundle promotions to increase average order value.
Review the **Clothing** category to identify opportunities for product improvement or targeted promotions.
2. Which categories contribute the most profit?

| Category    |     Revenue |      Profit |
| ----------- | ----------: | ----------: |
| **Bikes**       | **$28.32M** | **$11.51M** |
| Accessories |      $0.70M |      $0.44M |
| Clothing    |      $0.34M |      $0.14M |

>Insight: The business relies heavily on the Bikes category, which accounts for the vast majority of both revenue and profit. This indicates that bicycles are the company's core products and the primary driver of financial performance. In contrast, Accessories and Clothing generate relatively small financial contributions and likely serve as complementary product categories.

### Recommenđation
>Continue prioritizing investment in the Bikes category through inventory planning, marketing campaigns, and product development.Promote Accessories as bundle products with bicycles to increase cross-selling opportunities and average order value.
Review the Clothing category to identify opportunities for improving sales performance or optimizing the product portfolio.


3. Is revenue concentrated in a small number of products?

| Product                 | Revenue (USD) | Quantity Sold |
| ----------------------- | ------------: | ------------: |
| Mountain-200 Black, 46  |  1,373,469.91 |           620 |
| Mountain-200 Black, 42  |  1,363,142.43 |           614 |
| Mountain-200 Silver, 38 |  1,339,462.86 |           596 |
| Mountain-200 Silver, 46 |  1,301,100.17 |           580 |
| Mountain-200 Black, 38  |  1,294,866.44 |           582 |
| Mountain-200 Silver, 42 |  1,257,434.64 |           560 |
| Road-150 Red, 48        |  1,205,876.99 |           337 |
| Road-150 Red, 62        |  1,202,298.72 |           336 |
| Road-150 Red, 52        |  1,080,637.54 |           302 |
| Road-150 Red, 56        |  1,055,589.65 |           295 |

>Insight: Revenue appears to be concentrated in a relatively small number of premium bicycle models, particularly the Mountain-200 and Road-150 series. These flagship products are the primary drivers of sales performance, while demand is distributed across multiple frame sizes rather than a single product variant.

### Recommendation
>Ensure adequate inventory for the Mountain-200 and Road-150 product lines, especially during peak sales periods.
Prioritize these flagship products in marketing campaigns and promotional activities.
Analyze customer preferences behind these models to guide future product development and product portfolio decisions.



## Customer Behavior

1. How often do customers return to purchase?

| Purchase Count | Number of Customers | Percentage |
| -------------: | ------------------: | ---------: |
|              1 |              11,624 |     62.89% |
|              2 |               5,453 |     29.50% |
|              3 |               1,163 |      6.29% |
|              4 |                 150 |      0.81% |
|              5 |                  51 |      0.28% |
|             6+ |                  39 |      0.23% |

>Insight: The customer base is dominated by one-time buyers, indicating that customer retention remains a challenge. Although nearly one-third of customers return for a second purchase, only a small fraction continue purchasing regularly. This suggests that the business is more effective at acquiring

### Recommendation
>Introduce loyalty or membership programs to encourage repeat purchases.
Launch personalized email or discount campaigns targeting one-time buyers to increase the likelihood of a second purchase.
Analyze the purchasing behavior of frequent customers (4+ purchases) to identify characteristics that can be replicated across the broader customer base.
2. Which age group generates the highest revenue?


| Age Group  | Revenue (USD) |
| ---------- | ------------: |
| Middle Age |   **19.82M** |
| Senior     |    **8.99M** |
| Adult      |    **0.55M** |

>Insight: Middle-aged customers are the company's primary customer segment and contribute the majority of total revenue. Senior customers also represent a valuable customer base, while younger adults contribute only a small share of sales. This suggests that purchasing power is concentrated among older customer groups.

### Recommendation
> Prioritize marketing campaigns and product offerings for Middle Age customers, as they are the largest revenue contributors.
Continue developing products and promotions tailored to Senior customers to strengthen their engagement.
Investigate why the Adult segment generates relatively low revenue, such as differences in purchasing power, product preferences, or marketing reach.


3. Who are the Top 10 customers by revenue?

| Customer Key | Customer Name     | Total Revenue (USD) |
| -----------: | ----------------- | ------------------: |
|       12,301 | Nichole Nara      |           13,295.38 |
|       12,132 | Kaitlyn Henderson |           13,294.27 |
|       12,308 | Margaret He       |           13,269.27 |
|       12,131 | Randall Dominguez |           13,265.99 |
|       12,300 | Adriana Gonzalez  |           13,242.70 |
|       12,321 | Rosa Hu           |           13,215.65 |
|       12,124 | Brandi Gill       |           13,195.64 |
|       12,307 | Brad She          |           13,173.19 |
|       12,296 | Francisco Sara    |           13,164.64 |
|       11,433 | Maurice Shan      |           12,909.67 |


> Insight: The company's highest-value customers contribute similar levels of revenue, indicating that revenue is not heavily dependent on a single customer. This balanced distribution reduces business risk and suggests a diversified customer base among top spenders.

### Recommendation

>Maintain strong relationships with these high-value customers through loyalty programs and personalized services.
Identify common characteristics (e.g., age group, geographic region, or purchasing preferences) shared by the top customers to support customer acquisition and retention strategies.
Expand marketing efforts toward customers with similar profiles to grow the high-value customer segment.

## Strategic Opportunities

1. How does each sales territory perform?

| Sales Territory | Customers |      Revenue |       Profit | Profit Margin | Revenue Share |
| --------------- | --------: | -----------: | -----------: | ------------: | ------------: |
| Australia       |     3,591 | 9,061,000.72 | 3,685,842.70 |        40.68% |        30.86% |
| Southwest       |     4,450 | 5,718,151.07 | 2,371,749.15 |        41.48% |        19.48% |
| Northwest       |     3,341 | 3,649,866.72 | 1,519,620.17 |        41.63% |        12.43% |
| United Kingdom  |     1,913 | 3,391,712.24 | 1,390,482.93 |        41.00% |        11.55% |
| Germany         |     1,780 | 2,894,312.36 | 1,187,364.58 |        41.02% |         9.86% |
| France          |     1,810 | 2,644,017.74 | 1,086,258.26 |        41.08% |         9.01% |
| Canada          |     1,571 | 1,977,844.89 |   829,910.67 |        41.96% |         6.74% |
| Southeast       |        12 |    12,238.85 |     5,332.37 |        43.57% |         0.04% |
| Northeast       |         8 |     6,532.47 |     2,902.71 |        44.44% |         0.02% |
| Central         |         8 |     3,000.83 |     1,350.89 |        45.02% |         0.01% |

> Insight: Although Southwest has the highest number of customers, Australia generates substantially more revenue with fewer customers. This indicates that customers in Australia likely have a higher average spending level than those in Southwest. Additionally, the similar profit margins across the major territories suggest that differences in business performance are primarily driven by customer value rather than operational efficiency.

### Recommendation
>Prioritize investment in Australia, as it is the company's strongest-performing market in terms of revenue contribution.
Investigate customer purchasing behavior in Australia to identify factors contributing to higher customer spending and apply these insights to other markets.
Analyze Average Revenue per Customer and Average Order Value by sales territory to better understand why Southwest, despite having the largest customer base, generates lower revenue than Australia.
The Central, Northeast, and Southeast territories contribute less than 0.1% of total revenue. These markets should be monitored but are not immediate priorities for resource allocation or expansion.

2. Which sales territory has the highest average revenue per customer?

| Sales Territory | Customers |      Revenue | Avg. Revenue per Customer |
| --------------- | --------: | -----------: | ------------------------: |
| Australia       |     3,591 | 9,061,000.72 |              **2,523.25** |
| United Kingdom  |     1,913 | 3,391,712.24 |              **1,772.98** |
| Germany         |     1,780 | 2,894,312.36 |              **1,626.02** |
| France          |     1,810 | 2,644,017.74 |              **1,460.78** |
| Southwest       |     4,450 | 5,718,151.07 |              **1,284.98** |
| Canada          |     1,571 | 1,977,844.89 |              **1,258.97** |
| Northwest       |     3,341 | 3,649,866.72 |              **1,092.45** |
| Southeast       |        12 |    12,238.85 |                  1,019.90 |
| Northeast       |         8 |     6,532.47 |                    816.56 |
| Central         |         8 |     3,000.83 |                    375.10 |

> Insight: Customer value varies significantly across sales territories. Australia stands out not only as the largest revenue-generating market but also as the market with the highest average revenue per customer, indicating that customers there spend substantially more on average. In contrast, Southwest relies on a larger customer base to generate revenue rather than higher customer spending.

### Recommendation 
> Prioritize customer retention and premium product offerings in Australia, where customers demonstrate the highest purchasing value.
Investigate the purchasing behavior of Australian customers to identify successful sales strategies that can be replicated in other markets.
For Southwest, focus on increasing customer spending through upselling, cross-selling, and personalized promotions rather than solely acquiring more customers.
Do not over-interpret the results for Central, Northeast, and Southeast, as their customer bases are too small (8–12 customers) to provide representative insights.
3. Which sales territory has the highest average order value?

| Sales Territory | Orders |      Revenue | Avg. Order Value |
| --------------- | -----: | -----------: | ---------------: |
| Australia       |  6,716 | 9,061,000.72 |     **1,349.17** |
| Germany         |  2,483 | 2,894,312.36 |     **1,165.65** |
| United Kingdom  |  3,028 | 3,391,712.24 |     **1,120.12** |
| France          |  2,482 | 2,644,017.74 |     **1,065.28** |
| Southwest       |  5,472 | 5,718,151.07 |     **1,044.98** |
| Northwest       |  4,057 | 3,649,866.72 |       **899.65** |
| Southeast       |     17 |    12,238.85 |           719.93 |
| Northeast       |     10 |     6,532.47 |           653.25 |
| Canada          |  3,344 | 1,977,844.89 |           591.46 |
| Central         |      9 |     3,000.83 |           333.43 |

> Insight: Australia not only leads in total revenue but also achieves the highest average order value, suggesting that customers place larger or higher-value orders. In contrast, Southwest generates revenue through a higher volume of orders rather than higher-value transactions. This indicates different purchasing behaviors across sales territories.

### Recommendation 
Continue promoting premium products and bundled offerings in Australia, where customers consistently place higher-value orders.
Explore opportunities to increase basket size in Southwest through cross-selling, upselling, and product bundle promotions.
Compare product mix and pricing strategies between Australia and Southwest to identify practices that could improve order value in lower-performing markets.
Treat insights from Central, Northeast, and Southeast with caution because their sample sizes are too small for reliable business decisions.


# Advanced Analytics Techniques Applied

## Pareto Analysis

Purpose:

Identify whether a small proportion of products generates most company revenue.

Business Value:

- Inventory optimization
- Product prioritization
- Revenue risk assessment

---

## Profit Pool Analysis

Purpose:

Compare revenue contribution against profit contribution.

Business Value:

- Resource allocation
- Product strategy
- Margin optimization

---

## Cohort Retention Analysis

Purpose:

Measure customer retention over time.

Business Value:

- Customer lifecycle understanding
- Marketing effectiveness evaluation
- Retention strategy development

---

## Repurchase Cycle Analysis

Purpose:

Estimate the typical time between purchases.

Business Value:

- Campaign timing optimization
- Customer engagement planning
- Demand forecasting

---

# Business Recommendations

### Short-Term

- Increase accessory cross-selling.
- Focus marketing investment on high-performing territories.
- Improve post-purchase customer engagement.

### Medium-Term

- Reduce dependency on a small number of products.
- Develop customer retention initiatives.
- Expand profitable accessory categories.

### Long-Term

- Build customer lifetime value tracking.
- Introduce loyalty and membership programs.
- Improve retention across future customer cohorts.

---

# Conclusion

The analysis reveals that AdventureWorks is driven primarily by bicycle sales and a small number of key territories. While revenue performance is strong, customer retention remains a challenge and profit opportunities exist within high-margin accessory products.

Future growth should focus on increasing customer lifetime value, strengthening retention, and expanding profitable product categories.
