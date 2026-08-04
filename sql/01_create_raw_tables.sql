CREATE TABLE raw.customers (

    customer_id TEXT PRIMARY KEY,

    customer_unique_id TEXT NOT NULL,

    customer_zip_code_prefix INTEGER NOT NULL,

    customer_city TEXT NOT NULL,

    customer_state CHAR(2) NOT NULL

);