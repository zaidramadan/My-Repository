-- Exploratory Data Analysis

select * 
from layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percent_laid_off)
from layoffs_staging2;

SELECT *
from layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
from layoffs_staging2
group by company
ORDER By 2 desc;

SELECT industry, SUM(total_laid_off)
from layoffs_staging2
group by industry
ORDER By 2 desc;

SELECT year(`date`), SUM(total_laid_off)
from layoffs_staging2
group by year(`date`)
ORDER By 1 desc;

SELECT stage, SUM(total_laid_off)
from layoffs_staging2
group by stage
ORDER By 1 desc;

SELECT company, AVG(percentage_laid_off)
from layoffs_staging2
group by company
ORDER By 2 desc;

SELECT substring(`date`,1,7) AS `MONTH`, sum(total_laid_off)
From layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
order by 1 ASC;

WITH Rolling_Total AS
(
SELECT substring(`date`,1,7) AS `MONTH`, sum(total_laid_off) AS total_off
From layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
order by 1 ASC
)
select `MONTH`, total_off, sum(total_off) OVER(order by `MONTH`) AS rolling_total -- summing the current month total and the monthes before it (a rolling total of layoffs).
FROM Rolling_Total;	

SELECT company, year(`date`), SUM(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with Company_Year (company, years, total_laid_off) AS
(
SELECT company, year(`date`), SUM(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank AS
(
select *, dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select *
FROM Company_Year_Rank
WHERE Ranking <= 5;