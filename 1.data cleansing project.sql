select *
from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize Data (edit missed spelling things)
-- 3. Null values or blank values 
-- 4. remove any unnecessary columns
----------------------------------

-- 1. Remove Duplicates:

CREATE TABLE Layoffs_staging-- create layoffs staging table from the existed layoff table to do data preperation.
like layoffs;-- here only the columns will be created.

select *
from Layoffs_staging;

INSERT Layoffs_staging -- here the rows will be created. 
select *
from layoffs;

select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
from layoffs_staging;


WITH duplicate_cte As -- creating a CTE to reuse the code 
(
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
from layoffs_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;


CREATE TABLE `layoffs_staging2` ( -- creating another staging table to remove duplicates
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

insert into layoffs_staging2
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
from layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0; -- temporarily disable the safe update mode for your current session.

DELETE -- deleting the duplicates
FROM layoffs_staging2
WHERE row_num > 1;
----------------------------------------
-- 2. Standardize Data:

select company, Trim(company)
FROM layoffs_staging2;

Update layoffs_staging2
set company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry like 'Crypto%';

update layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT distinct country, TRIM(TRAILING '.' FROM country)
from layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 -- the altering step should always be done on a staging table not the original one 
MODIFY COLUMN `date` DATE;

select *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
where industry IS NULL 
OR industry = '';

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';