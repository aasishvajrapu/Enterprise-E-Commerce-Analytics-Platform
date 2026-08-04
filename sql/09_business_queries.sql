-- 1. Total Revenue
SELECT ROUND(SUM(price),2) AS total_revenue
FROM warehouse.fact_sales;

-- 2. Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM warehouse.fact_sales;

-- 3. Average Order Value
SELECT ROUND(SUM(price)/COUNT(DISTINCT order_id),2) AS average_order_value
FROM warehouse.fact_sales;

-- 4. Monthly Revenue
SELECT
    d.year,
    d.month,
    ROUND(SUM(f.price),2) AS revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d
ON f.date_key=d.date_key
GROUP BY d.year,d.month
ORDER BY d.year,d.month;

-- 5. Revenue by State
SELECT
    c.customer_state,
    ROUND(SUM(f.price),2) revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_customer c
ON f.customer_key=c.customer_key
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- 6. Top 10 Products
SELECT
    p.product_category,
    ROUND(SUM(f.price),2) revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_product p
ON f.product_key=p.product_key
GROUP BY p.product_category
ORDER BY revenue DESC
LIMIT 10;

-- 7. Top 10 Sellers
SELECT
    s.seller_city,
    ROUND(SUM(f.price),2) revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_seller s
ON f.seller_key=s.seller_key
GROUP BY s.seller_city
ORDER BY revenue DESC
LIMIT 10;

-- 8. Top 10 Customers
SELECT
    c.customer_city,
    ROUND(SUM(f.price),2) spend
FROM warehouse.fact_sales f
JOIN warehouse.dim_customer c
ON f.customer_key=c.customer_key
GROUP BY c.customer_key,c.customer_city
ORDER BY spend DESC
LIMIT 10;

-- 9. Review Score Distribution
SELECT review_score,COUNT(*) total_orders
FROM warehouse.fact_sales
GROUP BY review_score
ORDER BY review_score;

-- 10. Average Delivery Days
SELECT ROUND(AVG(delivery_days),2) avg_delivery_days
FROM warehouse.fact_sales;

-- 11. Revenue by Review Score
SELECT
 review_score,
 ROUND(SUM(price),2) revenue
FROM warehouse.fact_sales
GROUP BY review_score
ORDER BY review_score DESC;

-- 12. Freight Analysis
SELECT
 ROUND(AVG(freight_value),2) avg_freight,
 MAX(freight_value) max_freight,
 MIN(freight_value) min_freight
FROM warehouse.fact_sales;

-- 13. Top Categories by Sales
SELECT
 p.product_category,
 COUNT(*) items_sold
FROM warehouse.fact_sales f
JOIN warehouse.dim_product p
ON f.product_key=p.product_key
GROUP BY p.product_category
ORDER BY items_sold DESC
LIMIT 10;

-- 14. Monthly Order Trend
SELECT
 d.year,
 d.month,
 COUNT(DISTINCT order_id) orders_count
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d
ON f.date_key=d.date_key
GROUP BY d.year,d.month
ORDER BY d.year,d.month;

-- 15. Highest Revenue Month
SELECT
 d.year,
 d.month,
 ROUND(SUM(price),2) revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d
ON f.date_key=d.date_key
GROUP BY d.year,d.month
ORDER BY revenue DESC
LIMIT 1;

-- 16. Lowest Revenue Month
SELECT
 d.year,
 d.month,
 ROUND(SUM(price),2) revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d
ON f.date_key=d.date_key
GROUP BY d.year,d.month
ORDER BY revenue
LIMIT 1;

-- 17. Orders by Weekday
SELECT
 d.weekday,
 COUNT(DISTINCT order_id) total_orders
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d
ON f.date_key=d.date_key
GROUP BY d.weekday
ORDER BY total_orders DESC;

-- 18. Average Product Price
SELECT ROUND(AVG(price),2) average_price
FROM warehouse.fact_sales;

-- 19. Revenue by Quarter
SELECT
 d.year,
 d.quarter,
 ROUND(SUM(price),2) revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d
ON f.date_key=d.date_key
GROUP BY d.year,d.quarter
ORDER BY d.year,d.quarter;

-- 20. Seller Ranking
SELECT
 seller_key,
 ROUND(SUM(price),2) revenue,
 RANK() OVER(ORDER BY SUM(price) DESC) seller_rank
FROM warehouse.fact_sales
GROUP BY seller_key;

-- 21. Running Monthly Revenue
SELECT
 d.year,
 d.month,
 ROUND(SUM(price),2) revenue,
 ROUND(SUM(SUM(price)) OVER(ORDER BY d.year,d.month),2) running_revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d
ON f.date_key=d.date_key
GROUP BY d.year,d.month;

-- 22. Top 5 States
SELECT
 c.customer_state,
 ROUND(SUM(price),2) revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_customer c
ON f.customer_key=c.customer_key
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 5;

-- 23. Negative Delivery Days Check
SELECT COUNT(*) negative_delivery
FROM warehouse.fact_sales
WHERE delivery_days<0;

-- 24. Highest Value Orders
SELECT
 order_id,
 ROUND(SUM(price),2) order_value
FROM warehouse.fact_sales
GROUP BY order_id
ORDER BY order_value DESC
LIMIT 10;

-- 25. Project Complete
SELECT 'Business queries executed successfully.' AS status;