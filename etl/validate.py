from pathlib import Path
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parent.parent
PROFILE_DIR = PROJECT_ROOT / "data" / "profiling"

PROFILE_DIR.mkdir(parents=True, exist_ok=True)


def validate_data(datasets: dict[str, pd.DataFrame]):
    """
    Validate extracted datasets and generate a report.
    """

    report = []

    print("\n" + "=" * 70)
    print("VALIDATION REPORT")
    print("=" * 70)

    for name, df in datasets.items():

        rows = len(df)
        cols = len(df.columns)
        duplicates = int(df.duplicated().sum())
        missing = int(df.isnull().sum().sum())

        print(f"\n{name}")
        print(f"Rows       : {rows:,}")
        print(f"Columns    : {cols}")
        print(f"Duplicates : {duplicates:,}")
        print(f"Missing    : {missing:,}")

        report.append({
            "dataset": name,
            "rows": rows,
            "columns": cols,
            "missing_values": missing,
            "duplicate_rows": duplicates
        })

    report_df = pd.DataFrame(report)

    report_path = PROFILE_DIR / "validation_report.csv"
    report_df.to_csv(report_path, index=False)

    print("\nValidation report saved to:")
    print(report_path)

    return datasets