from extract import extract_data

datasets = extract_data()

print("\nDatasets Loaded\n")

for name, df in datasets.items():
    print(f"{name:40} {df.shape}")