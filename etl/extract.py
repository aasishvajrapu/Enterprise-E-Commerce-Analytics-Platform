from pathlib import Path

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DATA = PROJECT_ROOT / "data" / "raw"


def extract_data():
    """
    Reads every CSV from the raw data folder.

    Returns:
        dict[str, pd.DataFrame]
    """

    datasets = {}

    csv_files = sorted(RAW_DATA.glob("*.csv"))

    for file in csv_files:
        print(f"Reading {file.name}")

        datasets[file.stem] = pd.read_csv(file)

    return datasets