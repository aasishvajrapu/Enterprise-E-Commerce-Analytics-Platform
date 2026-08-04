import pandas as pd
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent

reviews = pd.read_csv(
    PROJECT_ROOT / "data" / "raw" / "olist_order_reviews_dataset.csv"
)

duplicates = reviews[reviews.duplicated(subset=["review_id"], keep=False)]

print(f"Total Rows: {len(reviews):,}")
print(f"Duplicate review_id rows: {len(duplicates):,}")

if len(duplicates) > 0:
    print(duplicates.head(20))