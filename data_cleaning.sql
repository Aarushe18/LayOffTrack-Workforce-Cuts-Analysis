-- ===========================================================
--           DATA CLEANING PROJECT - LAYOFFS DATASET
-- ===========================================================

-- STEP 0: View Raw Data
SELECT * 
FROM layoffs;


-- STEP 1: Create a Staging Table to Clean Data Safely --


CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;


-- STEP 2: Remove Duplicate Records --


-- Identify duplicates using ROW_NUMBER
SELECT *, ROW_NUMBER() OVER (
  PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
) AS row_num
FROM layoffs_staging;

-- More detailed duplicate check across all columns
WITH duplicate_cte AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY company, location, industry, total_laid_off, 
               percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
  FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- View specific example of possible duplicate
SELECT *
FROM layoffs_staging
WHERE company = 'casper';

-- Attempt to delete duplicates directly from CTE (this won't work in MySQL)
-- (For reference only - not executable)
-- DELETE FROM duplicate_cte WHERE row_num > 1;


-- STEP 3: Create New Table (layoffs_staging2) with Row Numbers --


CREATE TABLE `layoffs_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
  ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, 
                 percentage_laid_off, `date`, stage, country, funds_raised_millions
  ) AS row_num
FROM layoffs_staging;

-- View duplicate rows (row_num > 1)
SELECT * FROM layoffs_staging2
WHERE row_num > 1;

-- Disable safe updates (needed for DELETE)
SET SQL_SAFE_UPDATES = 0;

-- Delete exact duplicates
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2;


-- STEP 4: Standardize the Data --


-- Trim extra spaces from company names 
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize Industry Names 
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Check crypto variants
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Set all Crypto variations to "Crypto"
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize Country Names 
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Remove trailing periods from country names
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- Standardize Date Format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Modify column type to DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;


-- STEP 5: Handle NULLs and Missing Values


-- Check for NULLs in total_laid_off and percentage_laid_off
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Check for NULL or blank industry values
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
   OR industry = '';

-- Specific case check: Airbnb
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Convert blank industry values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Use existing rows to populate NULL industries based on matching company/location
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
  AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Spot check: Bally's
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


-- STEP 6: Delete Rows with No Useful Information


-- Rows with both total_laid_off and percentage_laid_off NULL
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Delete completely blank layoff records
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- STEP 7: Final Clean-Up


-- Drop temporary column used for deduplication
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final cleaned table
SELECT *
FROM layoffs_staging2;
