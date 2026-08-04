-- ============================================================================
-- Enterprise E-Commerce Analytics Platform
-- 06_load_dimensions.sql
-- Load Warehouse Dimension Tables
-- PostgreSQL Compatible
-- Ready for DBeaver
-- ============================================================================

BEGIN;

-- ============================================================================
-- Clear Existing Dimension Tables
-- ============================================================================

TRUNCATE TABLE warehouse.dim_customer RESTART IDENTITY CASCADE;
TRUNCATE TABLE warehouse.dim_product RESTART IDENTITY CASCADE;
TRUNCATE TABLE warehouse.dim_seller RESTART IDENTITY CASCADE;
TRUNCATE TABLE warehouse.dim_date RESTART IDENTITY CASCADE;

-- ============================================================================
-- Load Customer Dimension
-- ============================================================================

INSERT INTO warehouse.dim_customer
(
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
)
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM staging.customers
WHERE customer_id IS NOT NULL;

-- ============================================================================
-- Load Product Dimension
-- ============================================================================

INSERT INTO warehouse.dim_product
(
    product_id,
    product_category,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_volume_cm3
)
SELECT DISTINCT
    product_id,
    COALESCE(product_category, 'Unknown'),
    COALESCE(product_name_length, 0),
    COALESCE(product_description_length, 0),
    COALESCE(product_photos_qty, 0),
    COALESCE(product_weight_g, 0),
    COALESCE(product_length_cm, 0),
    COALESCE(product_height_cm, 0),
    COALESCE(product_width_cm, 0),
    COALESCE(product_volume_cm3, 0)
FROM staging.products
WHERE product_id IS NOT NULL;

-- ============================================================================
-- Load Seller Dimension
-- ============================================================================

INSERT INTO warehouse.dim_seller
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT DISTINCT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM staging.sellers
WHERE seller_id IS NOT NULL;

-- ============================================================================
-- Load Date Dimension
-- Generates a complete calendar from the earliest to latest purchase date
-- ============================================================================

INSERT INTO warehouse.dim_date
(
    full_date,
    year,
    quarter,
    month,
    month_name,
    weekday,
    week_number
)
SELECT
    d::DATE,
    EXTRACT(YEAR FROM d)::INTEGER,
    EXTRACT(QUARTER FROM d)::INTEGER,
    EXTRACT(MONTH FROM d)::INTEGER,
    TRIM(TO_CHAR(d, 'Month')),
    TRIM(TO_CHAR(d, 'Day')),
    EXTRACT(WEEK FROM d)::INTEGER
FROM generate_series
(
    (
        SELECT MIN(purchase_date)::DATE
        FROM staging.orders
    ),
    (
        SELECT MAX(purchase_date)::DATE
        FROM staging.orders
    ),
    INTERVAL '1 day'
) AS d;

-- ============================================================================
-- VALIDATION
-- ============================================================================

SELECT
    'dim_customer' AS table_name,
    COUNT(*) AS total_rows
FROM warehouse.dim_customer;

SELECT
    'dim_product' AS table_name,
    COUNT(*) AS total_rows
FROM warehouse.dim_product;

SELECT
    'dim_seller' AS table_name,
    COUNT(*) AS total_rows
FROM warehouse.dim_seller;

SELECT
    'dim_date' AS table_name,
    COUNT(*) AS total_rows
FROM warehouse.dim_date;

-- ============================================================================
-- SOURCE VS WAREHOUSE VALIDATION
-- ============================================================================

SELECT
    'Customers' AS dimension,
    (SELECT COUNT(DISTINCT customer_id) FROM staging.customers) AS staging_count,
    (SELECT COUNT(*) FROM warehouse.dim_customer) AS warehouse_count;

SELECT
    'Products' AS dimension,
    (SELECT COUNT(DISTINCT product_id) FROM staging.products) AS staging_count,
    (SELECT COUNT(*) FROM warehouse.dim_product) AS warehouse_count;

SELECT
    'Sellers' AS dimension,
    (SELECT COUNT(DISTINCT seller_id) FROM staging.sellers) AS staging_count,
    (SELECT COUNT(*) FROM warehouse.dim_seller) AS warehouse_count;

SELECT
    'Dates' AS dimension,
    (
        SELECT
            (
                MAX(purchase_date)::DATE -
                MIN(purchase_date)::DATE
            ) + 1
        FROM staging.orders
    ) AS expected_dates,
    (
        SELECT COUNT(*)
        FROM warehouse.dim_date
    ) AS warehouse_dates;

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

SELECT *
FROM warehouse.dim_customer
ORDER BY customer_key
LIMIT 10;

SELECT *
FROM warehouse.dim_product
ORDER BY product_key
LIMIT 10;

SELECT *
FROM warehouse.dim_seller
ORDER BY seller_key
LIMIT 10;

SELECT *
FROM warehouse.dim_date
ORDER BY date_key
LIMIT 10;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

SELECT
    'Dimension tables loaded successfully.' AS status;

COMMIT;