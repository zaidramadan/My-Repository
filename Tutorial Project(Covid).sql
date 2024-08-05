select*
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4
/*
select*
from PortfolioProject..CovidVaccinations
order by 3,4
*/
-----------------------------------------------------------------------------
--select Data that we'er gonna be using:
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-----------------------------------------------------------------------------
-- Looking at Total Cases VS Total Deaths
-- Shows the likelihood of dying if you contract covid in your country:
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
WHERE location like '%states%' and
continent is not null
order by 1,2

-----------------------------------------------------------------------------
-- Looking at Total Cases VS Population 
-- Shows what percentage of population got covid:
select location, date, population, total_cases, (total_cases/population)*100 as PersentPopulationInfected
from PortfolioProject..CovidDeaths
WHERE location like '%states%'
order by 1,2

-----------------------------------------------------------------------------
-- Looking for countries with highest infection rate compared to population:
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as
	PersentPopulationInfected
from PortfolioProject..CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population 
/*
Column Selection: Any column that is not part of an aggregate function and is selected in the SELECT statement must be included in the GROUP BY clause. 
This is a requirement in SQL to ensure that the query is logically correct and the results are accurate.
*/
order by PersentPopulationInfected desc

-----------------------------------------------------------------------------
-- Showing countries with highest death count per population:
select location, MAX(CAST(Total_deaths as int)) as TotalDeatCount
from PortfolioProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
GROUP BY location
order by TotalDeatCount desc

-----------------------------------------------------------------------------
-- Break Things down By continent
-- Showing continents with the highest death count per population:
select Continent, MAX(CAST(Total_deaths as int)) as TotalDeatCount
from PortfolioProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
GROUP BY Continent
order by TotalDeatCount desc
-----------------------------------------------------------------------------

-- Global Numbers
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--WHERE location like '%states%' and
WHERE continent is not null
--group by date
order by 1,2

-----------------------------------------------------------------------------
--Looking at Total Population vs Vaccination 
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated )--here we used a CTE
-- columns number in the CTE and the name of each column must be the same in the select statement  
as
(
Select dea.continent, dea.Location, dea.date, dea.Population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population)*100 -- here the the alias name connot be used in this way, in this case we'll deal with CTE or Temp tables
From portfolioProject..CovidDeaths dea
Join portfolioProject..CovidVaccinations vac
	on dea.Location = vac.Location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac