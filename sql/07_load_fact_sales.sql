-- ============================================================================
-- Enterprise E-Commerce Analytics Platform
-- 07_load_fact_sales.sql
-- Load Warehouse Fact Table
-- PostgreSQL Compatible
-- ============================================================================
BEGIN;

TRUNCATE TABLE warehouse.fact_sales RESTART IDENTITY CASCADE;

WITH payment_totals AS (
    SELECT order_id,SUM(payment_value) AS total_payment
    FROM staging.payments
    GROUP BY order_id
),
order_totals AS (
    SELECT order_id,SUM(price) AS total_order_price
    FROM staging.order_items
    GROUP BY order_id
),
review_scores AS (
    SELECT order_id,MAX(review_score) AS review_score
    FROM staging.reviews
    GROUP BY order_id
)

INSERT INTO warehouse.fact_sales
(
order_id,
order_item_id,
customer_key,
product_key,
seller_key,
date_key,
price,
freight_value,
payment_value,
review_score,
delivery_days
)
SELECT
oi.order_id,
oi.order_item_id,
dc.customer_key,
dp.product_key,
ds.seller_key,
dd.date_key,
COALESCE(oi.price,0)::numeric(12,2),
COALESCE(oi.freight_value,0)::numeric(12,2),
CASE
WHEN COALESCE(ot.total_order_price,0)=0 THEN 0::numeric(12,2)
ELSE ROUND((((COALESCE(oi.price,0)/ot.total_order_price)*COALESCE(pt.total_payment,0))::numeric),2)
END::numeric(12,2),
COALESCE(rs.review_score,0),
COALESCE(o.delivery_days,0)
FROM staging.order_items oi
JOIN staging.orders o
ON oi.order_id=o.order_id
JOIN warehouse.dim_customer dc
ON o.customer_id=dc.customer_id
JOIN warehouse.dim_product dp
ON oi.product_id=dp.product_id
JOIN warehouse.dim_seller ds
ON oi.seller_id=ds.seller_id
JOIN warehouse.dim_date dd
ON o.purchase_date=dd.full_date
LEFT JOIN payment_totals pt
ON oi.order_id=pt.order_id
LEFT JOIN order_totals ot
ON oi.order_id=ot.order_id
LEFT JOIN review_scores rs
ON oi.order_id=rs.order_id;

SELECT 'Fact Rows' AS metric,COUNT(*) AS value FROM warehouse.fact_sales;
SELECT 'Distinct Orders' AS metric,COUNT(DISTINCT order_id) AS value FROM warehouse.fact_sales;
SELECT 'Sales Total' AS metric,ROUND(SUM(price),2) AS value FROM warehouse.fact_sales;
SELECT 'Allocated Payments' AS metric,ROUND(SUM(payment_value),2) AS value FROM warehouse.fact_sales;

SELECT
(SELECT COUNT(*) FROM staging.order_items) AS source_order_items,
(SELECT COUNT(*) FROM warehouse.fact_sales) AS fact_rows;

SELECT
(SELECT COUNT(DISTINCT order_id) FROM staging.orders) AS source_orders,
(SELECT COUNT(DISTINCT order_id) FROM warehouse.fact_sales) AS fact_orders;

SELECT *
FROM warehouse.fact_sales
ORDER BY sales_key
LIMIT 20;

SELECT 'FACT TABLE LOADED SUCCESSFULLY' AS status;

COMMIT;
