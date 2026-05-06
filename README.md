# Cat Bakery Data & Business Analysis

This project analyses customer, product, and transactional data to generate actionable business insights aimed at improving profitability, customer retention, and operational performance.

Using PostgreSQL (CTEs, window functions, aggregations) and Excel dashboards, the analysis focuses on identifying key revenue drivers, customer risk segments, and performance trends.

## 1. Business Objective

- Identify top-performing and underperforming products  
- Detect customer retention risks using RFM segmentation  
- Analyse monthly performance trends to uncover revenue fluctuations  
- Provide data-driven recommendations to improve profitability  

## 2. Key Insights

### Product Performance

- **Salmon Bagel** generated the highest total profit (R465), making it the strongest revenue contributor  
- **Tuna Cheese Bake** achieved a 100% profit margin, indicating high per-unit profitability  
- **Salmon Roll** and **Pawstry** generate ~R3 profit per unit, showing potential pricing inefficiencies  

**Insight:** Profitability is concentrated in a few products while others reduce overall margins  

### Customer Segmentation (RFM Analysis)

- ~40% of customers fall into the “Attention Needed” segment (high historical spend, low recent activity)  
- Only two high-value loyal customers have been identified  

**Insight:** A large portion of revenue is at risk due to declining customer engagement  

### Monthly Performance Trends

- Profit declined by 28% in June, indicating a potential demand issue at this particular month  
- Performance recovered by almost 60% in August, this suggests seasonal effects  
- Total profit (Jan–Sep) was R2,330  

**Insight:** Revenue volatility suggests inconsistent demand or lack of sustained engagement strategies  

## 3. Recommendations

### Short-Term Actions

- Re-engage “Attention Needed” customers through targeted promotions or personalised offers  
- Review pricing for low-margin products (Salmon Roll, Pawstry)  

### Medium-Term Strategy (3 Months)

- Implement a customer loyalty programme to improve retention and customer lifetime value  
- Introduce product bundling strategies to increase sales of low-performing items (more revenue per order)
- Launch targeted marketing campaigns ahead of historically strong months ( July → August growth period)  

## 4. Business Impact

If implemented, these recommendations are expected to:

- Improve customer retention and reduce revenue leakage  
- Increase average order value through bundling strategies  
- Stabilise monthly revenue performance  
- Enhance overall profitability  

- Enhance overall profitability

## 📊 Visual 1: Total Profit by Product

![Total Profit by Product](images/profit_bar_chart.png)

*Salmon Bagel leads with R465 profit. Top 3 products generate 48% of total profit.*

---

## 📊 Visual 2: Strategic Quadrant Analysis

![Profit Margin vs Total Profit](images/scatter_quadrant.png)

*Products in top-right (Stars) = high profit + high margin. Bottom-left (Dogs) = low profit + low margin → consider discontinuing.*

---

## 📊 Visual 3: Monthly Profit Trend

![Monthly Profit Dashboard](images/monthly_dashboard.png)

*Peak months: April (R334) and August (R323). June dropped 28% from May. August recovered with 60% growth.*
