from pathlib import Path
import pandas as pd

# Project root
PROJECT_ROOT = Path(__file__).resolve().parent.parent

# Raw data folder
RAW_DATA = PROJECT_ROOT / "data" / "raw"

csv_files = sorted(RAW_DATA.glob("*.csv"))

print("=" * 70)
print("DATA PROFILING REPORT")
print("=" * 70)

for file in csv_files:
    print(f"\nDataset: {file.name}")

    df = pd.read_csv(file)

    print(f"Rows: {df.shape[0]}")
    print(f"Columns: {df.shape[1]}")

    print("\nColumns:")
    print(list(df.columns))

    print("\nData Types:")
    print(df.dtypes)

    print("\nMissing Values:")
    print(df.isnull().sum())

    print(f"\nDuplicate Rows: {df.duplicated().sum()}")

    print("-" * 70)