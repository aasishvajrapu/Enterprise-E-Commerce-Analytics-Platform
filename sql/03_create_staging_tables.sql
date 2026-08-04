-- ============================================================
-- Enterprise E-Commerce Analytics Platform
-- 03_create_staging_tables.sql
-- Creates the Staging Layer
-- PostgreSQL Compatible
-- ============================================================

---------------------------------------------------------------
-- Drop Existing Tables
---------------------------------------------------------------

DROP TABLE IF EXISTS staging.order_items CASCADE;
DROP TABLE IF EXISTS staging.orders CASCADE;
DROP TABLE IF EXISTS staging.customers CASCADE;
DROP TABLE IF EXISTS staging.products CASCADE;
DROP TABLE IF EXISTS staging.payments CASCADE;
DROP TABLE IF EXISTS staging.reviews CASCADE;
DROP TABLE IF EXISTS staging.sellers CASCADE;

---------------------------------------------------------------
-- Customers
---------------------------------------------------------------

CREATE TABLE staging.customers (

    customer_id TEXT PRIMARY KEY,

    customer_unique_id TEXT NOT NULL,

    customer_city TEXT,

    customer_state CHAR(2)

);

---------------------------------------------------------------
-- Orders
---------------------------------------------------------------

CREATE TABLE staging.orders (

    order_id TEXT PRIMARY KEY,

    customer_id TEXT NOT NULL,

    order_status TEXT,

    purchase_timestamp TIMESTAMP,

    purchase_date DATE,

    purchase_year INTEGER,

    purchase_month INTEGER,

    purchase_quarter INTEGER,

    purchase_weekday TEXT,

    approved_at TIMESTAMP,

    delivered_carrier_date TIMESTAMP,

    delivered_customer_date TIMESTAMP,

    estimated_delivery_date TIMESTAMP,

    delivery_days INTEGER

);

---------------------------------------------------------------
-- Order Items
---------------------------------------------------------------

CREATE TABLE staging.order_items (

    order_id TEXT,

    order_item_id INTEGER,

    product_id TEXT,

    seller_id TEXT,

    shipping_limit_date TIMESTAMP,

    price NUMERIC(10,2),

    freight_value NUMERIC(10,2),

    PRIMARY KEY (order_id, order_item_id)

);

---------------------------------------------------------------
-- Products
---------------------------------------------------------------

CREATE TABLE staging.products (

    product_id TEXT PRIMARY KEY,

    product_category TEXT,

    product_name_length NUMERIC,

    product_description_length NUMERIC,

    product_photos_qty NUMERIC,

    product_weight_g NUMERIC,

    product_length_cm NUMERIC,

    product_height_cm NUMERIC,

    product_width_cm NUMERIC,

    product_volume_cm3 NUMERIC

);

---------------------------------------------------------------
-- Payments
---------------------------------------------------------------

CREATE TABLE staging.payments (

    order_id TEXT,

    payment_sequential INTEGER,

    payment_type TEXT,

    payment_installments INTEGER,

    payment_value NUMERIC(10,2),

    is_installment BOOLEAN,

    PRIMARY KEY (order_id, payment_sequential)

);

---------------------------------------------------------------
-- Reviews
---------------------------------------------------------------

CREATE TABLE staging.reviews (

    review_id TEXT,

    order_id TEXT,

    review_score INTEGER,

    review_comment_title TEXT,

    review_comment_message TEXT,

    review_creation_date TIMESTAMP,

    review_answer_timestamp TIMESTAMP,

    review_sentiment TEXT,

    PRIMARY KEY (review_id, order_id)

);

---------------------------------------------------------------
-- Sellers
---------------------------------------------------------------

CREATE TABLE staging.sellers (

    seller_id TEXT PRIMARY KEY,

    seller_zip_code_prefix INTEGER,

    seller_city TEXT,

    seller_state CHAR(2)

);

---------------------------------------------------------------
-- Indexes
---------------------------------------------------------------

CREATE INDEX idx_staging_orders_customer
ON staging.orders(customer_id);

CREATE INDEX idx_staging_order_items_product
ON staging.order_items(product_id);

CREATE INDEX idx_staging_order_items_seller
ON staging.order_items(seller_id);

CREATE INDEX idx_staging_payments_order
ON staging.payments(order_id);

CREATE INDEX idx_staging_reviews_order
ON staging.reviews(order_id);

---------------------------------------------------------------
-- Success Message
---------------------------------------------------------------

SELECT 'Staging tables created successfully.' AS status;