import pandas as pd


def clean_data(datasets: dict[str, pd.DataFrame]):
    """
    Clean datasets before transformation.

    Parameters
    ----------
    datasets : dict[str, pd.DataFrame]

    Returns
    -------
    dict[str, pd.DataFrame]
    """

    cleaned = {}

    for name, df in datasets.items():

        df = df.copy()

        # Fix Olist spelling mistakes
        df.rename(
            columns={
                "product_name_lenght": "product_name_length",
                "product_description_lenght": "product_description_length",
            },
            inplace=True,
        )

        # Standardize column names
        df.columns = (
            df.columns.str.strip()
            .str.lower()
        )

        cleaned[name] = df

    print("\nCleaning Complete\n")

    return cleaned