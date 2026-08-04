-- ===========================================
-- Enterprise E-Commerce Analytics Platform
-- Raw Layer Tables
-- ===========================================

-- Customers
CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix INTEGER NOT NULL,
    customer_city TEXT NOT NULL,
    customer_state CHAR(2) NOT NULL
);

-- Orders
CREATE TABLE IF NOT EXISTS raw.orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    order_status TEXT NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP NOT NULL
);

-- Order Items
CREATE TABLE IF NOT EXISTS raw.order_items (
    order_id TEXT NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id TEXT NOT NULL,
    seller_id TEXT NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    freight_value NUMERIC(10,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id)
);

-- Payments
CREATE TABLE IF NOT EXISTS raw.payments (
    order_id TEXT NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type TEXT NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value NUMERIC(10,2) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential)
);

-- Reviews
CREATE TABLE IF NOT EXISTS raw.reviews (
    review_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    review_score INTEGER NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP NOT NULL
);

-- Products
CREATE TABLE IF NOT EXISTS raw.products (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_length NUMERIC,
    product_description_length NUMERIC,
    product_photos_qty NUMERIC,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

-- Sellers
CREATE TABLE IF NOT EXISTS raw.sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix INTEGER NOT NULL,
    seller_city TEXT NOT NULL,
    seller_state CHAR(2) NOT NULL
);

-- Geolocation
CREATE TABLE IF NOT EXISTS raw.geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city TEXT,
    geolocation_state CHAR(2)
);

-- Category Translation
CREATE TABLE IF NOT EXISTS raw.category_translation (
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);