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
2. Which markets contribute the most revenue?
3. Are there seasonal sales patterns?

## Product Profitability

1. Which product categories generate the most revenue?
2. Which categories contribute the most profit?
3. Is revenue concentrated in a small number of products?

## Customer Behavior

1. How often do customers return to purchase?
2. How long does it take customers to make another purchase?
3. How effectively are customer cohorts retained?

## Strategic Opportunities

1. Which product categories deserve additional investment?
2. Which customer groups drive the majority of revenue?
3. Which markets present the greatest growth opportunities?

---

# Key Findings

## 1. Revenue is highly concentrated in a few territories

Sales distribution shows strong concentration in several key markets:

| Territory | Revenue Share |
|------------|------------|
| Australia | 30.86% |
| Southwest | 19.48% |
| Northwest | 12.43% |
| United Kingdom | 11.55% |

### Insight

More than half of company revenue originates from a small number of territories.

### Recommendation

- Continue investing in high-performing markets.
- Investigate underperforming regions for expansion opportunities.
- Develop territory-specific marketing strategies.

---

## 2. The business relies heavily on the Bikes category

### Profit Pool Analysis

| Category | Revenue Share | Profit Share | Gap |
|-----------|-----------|-----------|------|
| Bikes | 96.46% | 95.24% | -1.22 |
| Accessories | 2.39% | 3.63% | +1.24 |
| Clothing | 1.16% | 1.13% | -0.03 |

### Insight

Bikes generate the vast majority of revenue and profit.

However, Accessories contribute a larger share of profit than revenue, indicating higher profitability.

### Recommendation

- Promote accessory bundles alongside bicycle purchases.
- Develop cross-selling campaigns.
- Expand high-margin accessory offerings.

---

## 3. Revenue is concentrated in a limited number of products

Top-selling products are dominated by the Mountain-200 product line.

### Insight

A small number of products drive a disproportionate amount of revenue.

This creates concentration risk if demand shifts away from these products.

### Recommendation

- Diversify revenue sources.
- Analyze product dependency risk.
- Develop supporting product lines.

---

## 4. Customer repurchase cycle is relatively long

### Repurchase Analysis

| Metric | Value |
|----------|---------|
| Median Repurchase Cycle | 255 Days |
| Standard Deviation | 265 Days |

### Insight

Customers typically take around eight months before making another purchase.

This pattern is consistent with durable goods such as bicycles.

### Recommendation

- Introduce maintenance reminders.
- Create loyalty programs.
- Promote accessories shortly after bicycle purchases.

---

## 5. Customer retention declines rapidly after acquisition

### Cohort Analysis

Across most cohorts:

- Month 0 retention = 100%
- Month 1 retention ≈ 2%–5%

### Insight

Most customers purchase only once during the first month.

Long-term customer retention is weak.

### Recommendation

- Implement post-purchase engagement campaigns.
- Offer targeted promotions.
- Create customer membership programs.

---

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
