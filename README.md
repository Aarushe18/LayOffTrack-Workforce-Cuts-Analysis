<p align="center">
  <img src="https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=mysql&logoColor=white" />
  <img src="https://img.shields.io/badge/Data%20Cleaning-4CAF50?style=for-the-badge" />
  <img src="https://img.shields.io/badge/EDA-2196F3?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Data%20Analysis-9C27B0?style=for-the-badge" />
</p>


# LayoffTrack: Cleaning + EDA on Workforce Cuts

**LayoffTrack** is a two-part data analysis portfolio project that combines **data cleaning** and **exploratory data analysis (EDA)** to understand global workforce layoffs using a publicly available dataset. This project identifies key **trends**, **patterns**, and **insights** about layoffs across companies, industries, and countries over time.

Understanding layoffs helps businesses, economists, and policy-makers gauge economic shifts, identify vulnerable sectors, and assess company performance. This project processes raw data into a cleaned format and explores it through SQL to uncover important insights.


## Project Segments

This project is divided into two main parts:

1. **Data Cleaning (SQL-based)**
2. **Exploratory Data Analysis (SQL-based)**


### 1. Data Cleaning Segment

#### Raw Dataset

The dataset was sourced from **[Kaggle - Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)**. It contains information such as:

- Company name  
- Industry  
- Country  
- Total layoffs  
- Percentage of workforce laid off  
- Date of layoff  
- Funding stage  
- And more...

#### Cleaning Process

Performed using **SQL in MySQL Workbench**. Major steps included:

- **Removing Duplicates**: Used `ROW_NUMBER()` window function to identify and delete duplicate records.
- **Standardizing Data**: Trimmed whitespaces, converted all text to lowercase, and corrected inconsistent entries.
- **Handling Nulls/Blanks**: Replaced blank strings with `NULL` and analyzed missing values in key columns.
- **Date Formatting**: Extracted `year` and `month` for better time-series analysis.
- **Dropping Unnecessary Columns**: Removed redundant or empty columns that didn’t add value to the analysis.

All cleaning was done in a **staging table (`layoffs_staging`)** to preserve the raw data.


### 2. Exploratory Data Analysis Segment

After cleaning, various SQL queries were run to uncover insights such as:

- **Total layoffs by year**
- **Top companies with the highest layoffs**
- **Layoffs by country and industry**
- **Month-over-month layoff trends**
- **Layoff percentage insights** (e.g., companies with 100% layoffs)
- **Funding stage analysis**
- **Missing value patterns** (e.g., correlation between missing data and layoff size)

These queries helped highlight the **most affected sectors**, **layoff waves by time**, and **anomalies like full workforce cuts**.

### Key Insights

- Layoffs peaked in **2022**, especially during Q1 and Q4.
- The **tech sector** was the most affected industry overall.
- Companies like **Meta, Amazon, Google, and Twitter** had the highest layoff counts.
- The **United States** experienced the largest share of global layoffs.
- Early-stage startups (Seed, Series A/B) were hit hard, often due to funding pressures.
- Some companies laid off **100% of their workforce**, indicating shutdowns.
- Layoffs often followed **funding rounds**, suggesting restructuring or downsizing.
- Many records had **missing or incomplete data**, especially from smaller firms.



### Tools & Technologies Used

| Category        | Tools                     |
|----------------|----------------------------|
| Language        | SQL                        |
| Platform        | MySQL Workbench            |
| Data Source     | [Kaggle - Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022) |
| Visualization (Optional) | Power BI / Tableau / Excel |

