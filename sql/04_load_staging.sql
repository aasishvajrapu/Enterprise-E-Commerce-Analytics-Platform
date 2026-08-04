

---------------------------------------------------------------
-- Clear Existing Data
---------------------------------------------------------------

TRUNCATE TABLE staging.order_items CASCADE;
TRUNCATE TABLE staging.orders CASCADE;
TRUNCATE TABLE staging.customers CASCADE;
TRUNCATE TABLE staging.products CASCADE;
TRUNCATE TABLE staging.payments CASCADE;
TRUNCATE TABLE staging.reviews CASCADE;
TRUNCATE TABLE staging.sellers CASCADE;

---------------------------------------------------------------
-- Customers
---------------------------------------------------------------

INSERT INTO staging.customers
(
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM raw.customers;

---------------------------------------------------------------
-- Orders
---------------------------------------------------------------

INSERT INTO staging.orders
(
    order_id,
    customer_id,
    order_status,
    purchase_timestamp,
    purchase_date,
    purchase_year,
    purchase_month,
    purchase_quarter,
    purchase_weekday,
    approved_at,
    delivered_carrier_date,
    delivered_customer_date,
    estimated_delivery_date,
    delivery_days
)
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    DATE(order_purchase_timestamp),
    EXTRACT(YEAR FROM order_purchase_timestamp)::INTEGER,
    EXTRACT(MONTH FROM order_purchase_timestamp)::INTEGER,
    EXTRACT(QUARTER FROM order_purchase_timestamp)::INTEGER,
    TO_CHAR(order_purchase_timestamp,'Day'),
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    CASE
        WHEN order_delivered_customer_date IS NULL THEN NULL
        ELSE order_delivered_customer_date::DATE
             - order_purchase_timestamp::DATE
    END
FROM raw.orders;

---------------------------------------------------------------
-- Order Items
---------------------------------------------------------------

INSERT INTO staging.order_items
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT DISTINCT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM raw.order_items
ON CONFLICT (order_id, order_item_id) DO NOTHING;

---------------------------------------------------------------
-- Products
---------------------------------------------------------------

INSERT INTO staging.products
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
SELECT
    p.product_id,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    ),
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    (
        p.product_length_cm
        * p.product_height_cm
        * p.product_width_cm
    )
FROM raw.products p
LEFT JOIN raw.category_translation t
ON p.product_category_name = t.product_category_name;

---------------------------------------------------------------
-- Payments
---------------------------------------------------------------

INSERT INTO staging.payments
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    is_installment
)
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    CASE
        WHEN payment_installments > 1 THEN TRUE
        ELSE FALSE
    END
FROM raw.payments;

---------------------------------------------------------------
-- Reviews
---------------------------------------------------------------

INSERT INTO staging.reviews
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    review_sentiment
)
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    CASE
        WHEN review_score = 5 THEN 'Excellent'
        WHEN review_score = 4 THEN 'Good'
        WHEN review_score = 3 THEN 'Average'
        WHEN review_score = 2 THEN 'Poor'
        ELSE 'Very Poor'
    END
FROM raw.reviews;

---------------------------------------------------------------
-- Sellers
---------------------------------------------------------------

INSERT INTO staging.sellers
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM raw.sellers;

---------------------------------------------------------------
-- Success
---------------------------------------------------------------

SELECT 'STAGING DATA LOADED SUCCESSFULLY' AS status;
