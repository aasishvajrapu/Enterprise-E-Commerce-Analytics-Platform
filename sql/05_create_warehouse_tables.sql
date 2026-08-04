-- ============================================================
-- Enterprise E-Commerce Analytics Platform
-- 05_create_warehouse_tables.sql
-- Creates the Warehouse Layer (Star Schema)
-- PostgreSQL Compatible
-- ============================================================

---------------------------------------------------------------
-- Drop Existing Warehouse Tables
---------------------------------------------------------------

DROP TABLE IF EXISTS warehouse.fact_sales CASCADE;
DROP TABLE IF EXISTS warehouse.dim_customer CASCADE;
DROP TABLE IF EXISTS warehouse.dim_product CASCADE;
DROP TABLE IF EXISTS warehouse.dim_seller CASCADE;
DROP TABLE IF EXISTS warehouse.dim_date CASCADE;

---------------------------------------------------------------
-- Customer Dimension
---------------------------------------------------------------

CREATE TABLE warehouse.dim_customer
(
    customer_key SERIAL PRIMARY KEY,

    customer_id TEXT UNIQUE,

    customer_unique_id TEXT,

    customer_city TEXT,

    customer_state CHAR(2)
);

---------------------------------------------------------------
-- Product Dimension
---------------------------------------------------------------

CREATE TABLE warehouse.dim_product
(
    product_key SERIAL PRIMARY KEY,

    product_id TEXT UNIQUE,

    product_category TEXT,

    product_name_length INTEGER,

    product_description_length INTEGER,

    product_photos_qty INTEGER,

    product_weight_g NUMERIC,

    product_length_cm NUMERIC,

    product_height_cm NUMERIC,

    product_width_cm NUMERIC,

    product_volume_cm3 NUMERIC
);

---------------------------------------------------------------
-- Seller Dimension
---------------------------------------------------------------

CREATE TABLE warehouse.dim_seller
(
    seller_key SERIAL PRIMARY KEY,

    seller_id TEXT UNIQUE,

    seller_zip_code_prefix INTEGER,

    seller_city TEXT,

    seller_state CHAR(2)
);

---------------------------------------------------------------
-- Date Dimension
---------------------------------------------------------------

CREATE TABLE warehouse.dim_date
(
    date_key SERIAL PRIMARY KEY,

    full_date DATE UNIQUE,

    year INTEGER,

    quarter INTEGER,

    month INTEGER,

    month_name TEXT,

    weekday TEXT,

    week_number INTEGER
);

---------------------------------------------------------------
-- Sales Fact Table
---------------------------------------------------------------

CREATE TABLE warehouse.fact_sales
(
    sales_key BIGSERIAL PRIMARY KEY,

    order_id TEXT,

    order_item_id INTEGER,

    customer_key INTEGER,

    product_key INTEGER,

    seller_key INTEGER,

    date_key INTEGER,

    price NUMERIC(12,2),

    freight_value NUMERIC(12,2),

    payment_value NUMERIC(12,2),

    review_score INTEGER,

    delivery_days INTEGER,

    FOREIGN KEY (customer_key)
        REFERENCES warehouse.dim_customer(customer_key),

    FOREIGN KEY (product_key)
        REFERENCES warehouse.dim_product(product_key),

    FOREIGN KEY (seller_key)
        REFERENCES warehouse.dim_seller(seller_key),

    FOREIGN KEY (date_key)
        REFERENCES warehouse.dim_date(date_key)
);

---------------------------------------------------------------
-- Helpful Indexes
---------------------------------------------------------------

CREATE INDEX idx_fact_customer
ON warehouse.fact_sales(customer_key);

CREATE INDEX idx_fact_product
ON warehouse.fact_sales(product_key);

CREATE INDEX idx_fact_seller
ON warehouse.fact_sales(seller_key);

CREATE INDEX idx_fact_date
ON warehouse.fact_sales(date_key);

---------------------------------------------------------------
-- Success
---------------------------------------------------------------

SELECT 'WAREHOUSE TABLES CREATED SUCCESSFULLY' AS status;