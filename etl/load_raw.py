"""
Load Raw Data Module
Enterprise E-Commerce Analytics Platform
"""

from sqlalchemy import text
from database import get_engine


TABLE_MAPPING = {
    "olist_customers_dataset": "customers",
    "olist_geolocation_dataset": "geolocation",
    "olist_order_items_dataset": "order_items",
    "olist_order_payments_dataset": "payments",
    "olist_order_reviews_dataset": "reviews",
    "olist_orders_dataset": "orders",
    "olist_products_dataset": "products",
    "olist_sellers_dataset": "sellers",
    "product_category_name_translation": "category_translation",
}


def load_raw_data(datasets):
    """
    Loads every dataframe into the PostgreSQL raw schema.
    """

    engine = get_engine()

    print("\n" + "=" * 70)
    print("LOADING RAW LAYER")
    print("=" * 70)

    with engine.begin() as conn:

        for dataset_name, df in datasets.items():

            table_name = TABLE_MAPPING.get(dataset_name)

            if table_name is None:
                print(f"[WARNING] No table mapping for {dataset_name}")
                continue

            print("\n" + "-" * 70)
            print(f"Dataset : {dataset_name}")
            print(f"Table   : raw.{table_name}")
            print(f"Rows    : {len(df):,}")

            try:

                # Empty table before loading
                conn.execute(
                    text(f"TRUNCATE TABLE raw.{table_name};")
                )

                # Load dataframe
                df.to_sql(
                    name=table_name,
                    schema="raw",
                    con=conn,
                    if_exists="append",
                    index=False,
                )

                print(f"[SUCCESS] Loaded {len(df):,} rows.")

            except Exception as e:

                print("\n" + "=" * 70)
                print("[ERROR] LOAD FAILED")
                print("=" * 70)

                print(f"Dataset : {dataset_name}")
                print(f"Table   : raw.{table_name}")

                print("\nException:")
                print(e)

                raise

    print("\n" + "=" * 70)
    print("RAW LAYER LOADED SUCCESSFULLY")
    print("=" * 70)