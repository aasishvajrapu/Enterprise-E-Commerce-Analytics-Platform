"""
Transform Module
Enterprise E-Commerce Analytics Platform
"""

import pandas as pd


TIMESTAMP_COLUMNS = {
    "olist_orders_dataset": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],

    "olist_order_items_dataset": [
        "shipping_limit_date",
    ],

    "olist_order_reviews_dataset": [
        "review_creation_date",
        "review_answer_timestamp",
    ],
}


def transform_data(datasets):
    """
    Convert timestamp columns to datetime.
    """

    print("\n" + "=" * 70)
    print("TRANSFORMING DATA")
    print("=" * 70)

    transformed = {}

    for dataset_name, df in datasets.items():

        df = df.copy()

        if dataset_name in TIMESTAMP_COLUMNS:

            for column in TIMESTAMP_COLUMNS[dataset_name]:

                df[column] = pd.to_datetime(
                    df[column],
                    errors="coerce"
                )

        transformed[dataset_name] = df

        print(f"Processed: {dataset_name}")

    print("\nTransformation Complete")

    return transformed