from extract import extract_data
from validate import validate_data
from clean import clean_data
from transform import transform_data
from load_raw import load_raw_data


def run_pipeline():

    datasets = extract_data()

    datasets = validate_data(datasets)

    datasets = clean_data(datasets)

    datasets = transform_data(datasets)

    load_raw_data(datasets)


if __name__ == "__main__":
    run_pipeline()