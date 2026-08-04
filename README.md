# Enterprise E-Commerce Analytics Platform

## Overview

The Enterprise E-Commerce Analytics Platform is an end-to-end data engineering and business intelligence solution designed to transform raw e-commerce transactional data into meaningful business insights.

The project demonstrates a complete analytics workflow including data extraction, transformation, validation, warehousing, business analysis, forecasting, and interactive dashboard development using industry-standard tools.

---

## Objectives

- Build an automated ETL pipeline
- Design a PostgreSQL data warehouse
- Perform data cleaning and validation
- Develop analytical SQL queries
- Build an interactive Power BI dashboard
- Generate business insights from transactional data
- Implement basic sales forecasting

---

## Technology Stack

| Category | Technologies |
|-----------|--------------|
| Programming Language | Python |
| Database | PostgreSQL |
| Data Processing | Pandas, NumPy |
| Visualization | Power BI |
| Notebook Environment | Jupyter Notebook |
| Version Control | Git, GitHub |
| Query Language | SQL |

---

## Project Architecture

```
                Raw CSV Files
                      │
                      ▼
              Data Extraction
                      │
                      ▼
            Data Cleaning & Validation
                      │
                      ▼
              Staging Layer
                      │
                      ▼
          Enterprise Data Warehouse
                      │
                      ▼
          Business Analysis using SQL
                      │
                      ▼
          Interactive Power BI Dashboard
                      │
                      ▼
              Business Insights
```

---

## Repository Structure

```
Enterprise-E-Commerce-Analytics-Platform
│
├── config/
│   └── config.py
│
├── dashboard/
│   └── SalesDashboard.pbix
│
├── data/
│
├── etl/
│   ├── extract.py
│   ├── transform.py
│   ├── clean.py
│   ├── validate.py
│   ├── load_data.py
│   ├── pipeline.py
│   └── ...
│
├── forecasting/
│   └── forecast.py
│
├── notebooks/
│   └── EDA.ipynb
│
├── sql/
│   ├── 01_create_raw_tables.sql
│   ├── 02_create_raw_tables.sql
│   ├── 03_create_staging_tables.sql
│   ├── 04_load_staging.sql
│   ├── 05_create_warehouse_tables.sql
│   ├── 06_load_dimensions.sql
│   ├── 07_load_fact_sales.sql
│   ├── 08_quality_checks.sql
│   ├── 09_business_queries.sql
│   └── analysis.sql
│
├── requirements.txt
└── README.md
```

---

## ETL Workflow

The ETL pipeline consists of the following stages:

1. Extraction of raw e-commerce datasets
2. Data cleaning and preprocessing
3. Duplicate detection and validation
4. Loading into staging tables
5. Creation of warehouse dimensions and fact tables
6. Business query execution
7. Dashboard visualization

---

## Data Warehouse Design

The warehouse follows a **Star Schema** consisting of:

### Dimension Tables

- Customer
- Product
- Seller
- Date

### Fact Table

- Sales

This design enables efficient analytical queries and reporting.

---

## Dashboard Features

The Power BI dashboard provides interactive reporting through the following KPIs:

- Total Sales
- Total Orders
- Total Customers
- Total Sellers
- Total Products
- Average Customer Review

### Visualizations

- Monthly Sales Trend
- Sales by Customer State
- Top Product Categories
- Sales by Seller City
- Interactive Year Filter
- Customer State Filter
- Product Category Filter

---

## Business Insights

The platform enables users to answer questions such as:

- Which products generate the highest revenue?
- Which customer regions contribute the most sales?
- Which sellers perform best?
- How do sales vary over time?
- How does customer satisfaction impact sales?

---

## Forecasting

The forecasting module provides basic sales prediction capabilities using historical sales data, enabling trend analysis and future planning.

---

## Dataset

This project utilizes the **Brazilian E-Commerce Public Dataset by Olist**, available on Kaggle.

The raw dataset is excluded from this repository due to size limitations.

---

## Installation

### Clone the repository

```bash
git clone https://github.com/aasishvajrapu/Enterprise-E-Commerce-Analytics-Platform.git
```

### Navigate to the project

```bash
cd Enterprise-E-Commerce-Analytics-Platform
```

### Install dependencies

```bash
pip install -r requirements.txt
```

### Configure the database

Update your PostgreSQL credentials inside:

```
config/config.py
```

or create a `.env` file.

### Execute SQL scripts

Run the SQL scripts sequentially:

```
01_create_raw_tables.sql
02_create_raw_tables.sql
03_create_staging_tables.sql
04_load_staging.sql
05_create_warehouse_tables.sql
06_load_dimensions.sql
07_load_fact_sales.sql
08_quality_checks.sql
09_business_queries.sql
```

### Execute the ETL Pipeline

```bash
python etl/pipeline.py
```

### Open Dashboard

Open the following Power BI file:

```
dashboard/SalesDashboard.pbix
```

---

## Dashboard Preview

Add a screenshot of the dashboard here.

```
dashboard/dashboard_preview.png
```

Example:

```markdown
![Dashboard](dashboard/dashboard_preview.png)
```

---

## Skills Demonstrated

- Data Engineering
- ETL Pipeline Development
- Data Cleaning
- Data Validation
- Data Warehousing
- PostgreSQL
- SQL
- Power BI
- Business Intelligence
- Data Visualization
- Exploratory Data Analysis
- Sales Forecasting
- Git
- GitHub

---

## Future Enhancements

- Workflow orchestration using Apache Airflow
- Docker containerization
- Cloud deployment (AWS/Azure)
- Real-time data ingestion
- Predictive machine learning models
- CI/CD pipeline integration

---

## Author

**Aasish Vajrapu**

GitHub: https://github.com/aasishvajrapu

LinkedIn: *Add your LinkedIn profile*

---

## License

This project is intended for educational and portfolio purposes.
