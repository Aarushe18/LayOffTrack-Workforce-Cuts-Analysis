-- Look at the entire dataset
SELECT * 
FROM layoffs_staging2;

-- Check the highest number of layoffs and highest percentage of layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Find companies that laid off 100% of their employees
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Total layoffs for each company
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- Check the earliest and latest dates in the dataset
SELECT MIN(`date`) AS start_date, MAX(`date`) AS end_date
FROM layoffs_staging2;

-- Total layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Total layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- Total layoffs for each year
SELECT YEAR(`date`) AS layoff_year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY layoff_year
ORDER BY layoff_year DESC;

-- Total layoffs by company stage (like early-stage, late-stage)
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- Monthly layoffs and their rolling total over time
WITH layoffs_by_month AS (
  SELECT 
    DATE_FORMAT(date, '%Y-%m') AS layoff_month,
    SUM(total_laid_off) AS monthly_total
  FROM layoffs_staging2
  GROUP BY layoff_month
)

SELECT 
  layoff_month,
  monthly_total,
  SUM(monthly_total) OVER (ORDER BY layoff_month) AS rolling_total
FROM layoffs_by_month;

-- Top 5 companies with the most layoffs each year
WITH company_year_layoffs AS (
  SELECT 
    company,
    YEAR(date) AS layoff_year,
    SUM(COALESCE(total_laid_off, 0)) AS total_laid_off
  FROM layoffs_staging2
  WHERE YEAR(date) IS NOT NULL
  GROUP BY company, layoff_year
),
company_year_ranked AS (
  SELECT 
    *, 
    DENSE_RANK() OVER (PARTITION BY layoff_year ORDER BY total_laid_off DESC) AS `rank`
  FROM company_year_layoffs
)

SELECT *
FROM company_year_ranked
WHERE `rank` <= 5
ORDER BY layoff_year, `rank`;
