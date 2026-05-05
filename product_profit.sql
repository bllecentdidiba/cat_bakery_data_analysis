--Business Context: Ginger Ramsay, owner of a cat bakery, needs to understand customer behavior, product performance to grow his business.

--1:Data Exploration(Understanding our data) and Cleaning

-- Let's check what tables we have:
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'; 

-- Look at each table structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'customer_info';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'product_info';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'order_info';

-- Look for missing values in customer_info
SELECT 
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_count,
    COUNT(customer_name) AS customer_names,
    COUNT(contact_no) AS customer_contacts,
    COUNT(birthday) AS customer_birthdays
FROM customer_info;

-- Missing values in product_info
SELECT 
    COUNT(*) AS total_rows,
    COUNT(product_id) AS product_id_count,
    COUNT(product_name) AS product_names,
    COUNT(sales_price) AS product_prices,
    COUNT("Cost") AS product_costs
FROM product_info;

--Duplicates in order_info
SELECT order_id, COUNT(*) AS duplicate_count
FROM order_info
GROUP BY order_id
HAVING COUNT(*) > 1;
--No duplicate for this table!

--Here the customer_info table has a date issue, the structure is text and the format is DD/MM/YYYY

UPDATE customer_info
SET birthday = TO_DATE(birthday, 'DD/MM/YYYY');
SELECT * 
FROM CUSTOMER_INFO;


--2: Business Questions to solve
--Which products are most profitable? Should we discontinue any?
WITH product_profit AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.sales_price,
        p."Cost",
        (p.sales_price - p."Cost") AS profit_per_unit,	
        ROUND(((p.sales_price - p."Cost") / p."Cost")::numeric,4) * 100 AS profit_margin_percent,
        COUNT(DISTINCT o.order_id) AS times_ordered,
        SUM(o.qty) AS total_units_sold,
        SUM(o.qty * (p.sales_price - p."Cost")) AS total_profit
    FROM product_info p
    LEFT JOIN order_info o ON p.product_id = o.product_id
    GROUP BY p.product_id, p.product_name, p.sales_price, p."Cost"
)
SELECT *,
       RANK() OVER (ORDER BY total_profit DESC) AS profit_rank,
       RANK() OVER (ORDER BY profit_margin_percent DESC) AS margin_rank
FROM product_profit ORDER BY total_profit DESC;

--Which months have highest sales and when should we run promotions?
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month_num,
        TO_CHAR(order_date, 'Month') AS month_name,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(o.qty) AS total_units_sold,  
        SUM(o.qty * (p.sales_price - p."Cost")) AS total_profit
    FROM order_info o
    JOIN product_info p ON o.product_id = p.product_id
    WHERE order_date IS NOT NULL
    GROUP BY year, month_num, month_name
)
SELECT *,
       ROUND((100 * total_profit / SUM(total_profit) OVER ())::numeric,4) AS profit_percentage_of_total,
       LAG(total_profit) OVER (ORDER BY year, month_num) AS previous_month_profit,
       100 * (total_profit - LAG(total_profit) OVER (ORDER BY year, month_num)) / 
             LAG(total_profit) OVER (ORDER BY year, month_num) AS month_over_month_growth
FROM monthly_sales
ORDER BY year, month_num;

--Who are our most valuable customers and how can we segment them for targeted marketing?
-- I first calculated RFM metrics
WITH customer_orders AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.contact_no,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(o.qty * (p.sales_price - p."Cost")) AS monetary,
        MAX(o.order_date) AS last_order_date,
        CURRENT_DATE::DATE AS analysis_date
    FROM customer_info c
    JOIN order_info o ON c.customer_id = o.customer_id
    JOIN product_info p ON o.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name, c.contact_no
),
rfm_scores AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY frequency DESC) AS frequency_score, -- Using NTILE(4) to segment customers into quartiles based on behavior
           NTILE(4) OVER (ORDER BY monetary DESC) AS monetary_score,
           NTILE(4) OVER (ORDER BY (analysis_date - last_order_date)) AS recency_score
    FROM customer_orders
	)
SELECT *, (recency_score + frequency_score + monetary_score) AS rfm_total,
       CASE 
           WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Lifeline'
           WHEN recency_score >= 3 AND frequency_score >= 2 THEN 'Loyal Customers'
           WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'Uncertain customers'
           WHEN recency_score = 1 AND frequency_score = 1 THEN 'Lost'
           ELSE 'Attention Needed'
       END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total DESC;

