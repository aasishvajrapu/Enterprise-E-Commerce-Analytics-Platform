-- ============================================================================
-- Enterprise E-Commerce Analytics Platform
-- 08_quality_checks.sql
-- Data Quality & Reconciliation Checks
-- PostgreSQL Compatible
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. Row Count Validation
-- ============================================================================

SELECT 'staging.customers' AS table_name, COUNT(*) AS rows FROM staging.customers
UNION ALL
SELECT 'warehouse.dim_customer', COUNT(*) FROM warehouse.dim_customer
UNION ALL
SELECT 'staging.products', COUNT(*) FROM staging.products
UNION ALL
SELECT 'warehouse.dim_product', COUNT(*) FROM warehouse.dim_product
UNION ALL
SELECT 'staging.sellers', COUNT(*) FROM staging.sellers
UNION ALL
SELECT 'warehouse.dim_seller', COUNT(*) FROM warehouse.dim_seller
UNION ALL
SELECT 'staging.order_items', COUNT(*) FROM staging.order_items
UNION ALL
SELECT 'warehouse.fact_sales', COUNT(*) FROM warehouse.fact_sales;

-- ============================================================================
-- 2. Duplicate Surrogate Keys
-- ============================================================================

SELECT 'dim_customer' AS table_name, COUNT(*)-COUNT(DISTINCT customer_key) AS duplicate_keys
FROM warehouse.dim_customer;

SELECT 'dim_product', COUNT(*)-COUNT(DISTINCT product_key)
FROM warehouse.dim_product;

SELECT 'dim_seller', COUNT(*)-COUNT(DISTINCT seller_key)
FROM warehouse.dim_seller;

SELECT 'dim_date', COUNT(*)-COUNT(DISTINCT date_key)
FROM warehouse.dim_date;

SELECT 'fact_sales', COUNT(*)-COUNT(DISTINCT sales_key)
FROM warehouse.fact_sales;

-- ============================================================================
-- 3. NULL Checks
-- ============================================================================

SELECT
SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS null_customer_key,
SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS null_product_key,
SUM(CASE WHEN seller_key IS NULL THEN 1 ELSE 0 END) AS null_seller_key,
SUM(CASE WHEN date_key IS NULL THEN 1 ELSE 0 END) AS null_date_key,
SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment
FROM warehouse.fact_sales;

-- ============================================================================
-- 4. Foreign Key Integrity
-- ============================================================================

SELECT COUNT(*) AS orphan_customers
FROM warehouse.fact_sales f
LEFT JOIN warehouse.dim_customer d
ON f.customer_key=d.customer_key
WHERE d.customer_key IS NULL;

SELECT COUNT(*) AS orphan_products
FROM warehouse.fact_sales f
LEFT JOIN warehouse.dim_product d
ON f.product_key=d.product_key
WHERE d.product_key IS NULL;

SELECT COUNT(*) AS orphan_sellers
FROM warehouse.fact_sales f
LEFT JOIN warehouse.dim_seller d
ON f.seller_key=d.seller_key
WHERE d.seller_key IS NULL;

SELECT COUNT(*) AS orphan_dates
FROM warehouse.fact_sales f
LEFT JOIN warehouse.dim_date d
ON f.date_key=d.date_key
WHERE d.date_key IS NULL;

-- ============================================================================
-- 5. Revenue Reconciliation
-- ============================================================================

SELECT
ROUND((SELECT SUM(price) FROM staging.order_items),2) AS staging_sales,
ROUND((SELECT SUM(price) FROM warehouse.fact_sales),2) AS warehouse_sales;

-- ============================================================================
-- 6. Payment Reconciliation
-- ============================================================================

SELECT
ROUND((SELECT SUM(payment_value) FROM staging.payments),2) AS staging_payments,
ROUND((SELECT SUM(payment_value) FROM warehouse.fact_sales),2) AS warehouse_payments;

-- ============================================================================
-- 7. Date Validation
-- ============================================================================

SELECT
MIN(full_date) AS min_date,
MAX(full_date) AS max_date,
COUNT(*) AS total_dates
FROM warehouse.dim_date;

-- ============================================================================
-- 8. Review Score Validation
-- ============================================================================

SELECT review_score, COUNT(*) AS records
FROM warehouse.fact_sales
GROUP BY review_score
ORDER BY review_score;

-- ============================================================================
-- 9. Delivery Days Validation
-- ============================================================================

SELECT COUNT(*) AS negative_delivery_days
FROM warehouse.fact_sales
WHERE delivery_days < 0;

-- ============================================================================
-- 10. ETL Health Summary
-- ============================================================================

SELECT 'Fact Rows' AS check_name,
CASE WHEN (SELECT COUNT(*) FROM warehouse.fact_sales)>0 THEN 'PASS' ELSE 'FAIL' END AS status
UNION ALL
SELECT 'Revenue Match',
CASE WHEN ROUND((SELECT SUM(price) FROM staging.order_items),2)=
ROUND((SELECT SUM(price) FROM warehouse.fact_sales),2)
THEN 'PASS' ELSE 'FAIL' END
UNION ALL
SELECT 'Customer FK',
CASE WHEN (
SELECT COUNT(*) FROM warehouse.fact_sales f
LEFT JOIN warehouse.dim_customer d
ON f.customer_key=d.customer_key
WHERE d.customer_key IS NULL)=0
THEN 'PASS' ELSE 'FAIL' END;

COMMIT;

SELECT 'QUALITY CHECKS COMPLETED SUCCESSFULLY' AS status;