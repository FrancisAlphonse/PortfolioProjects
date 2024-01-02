select *
from PortfolioProject..Covid_Deaths

-- Select Data that we are going to be starting with
select location, date, population, total_cases, total_deaths, new_cases
from PortfolioProject..Covid_Deaths
where continent is not null
order by 1,2

--Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from PortfolioProject..Covid_Deaths
where location like '%India%'
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
select location, date, population, total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as PercentPopulationInfected
from PortfolioProject..Covid_Deaths
where location like '%India%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population
select location, population, max(total_cases) as HighestInfectionCount, 
max((CONVERT(float, total_cases)) / NULLIF(CONVERT(float, population), 0))*100 as PercentPopulationInfected
from PortfolioProject..Covid_Deaths
--where location like '%India%'
group by location, population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

select location, max(cast(total_deaths as int)) as TotalDeathCounts
from PortfolioProject..Covid_Deaths
--where location like '%India%'
where continent is not null
group by location
order by TotalDeathCounts desc

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathCounts
from PortfolioProject..Covid_Deaths
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCounts desc


-- Global Numbers
select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..Covid_Deaths
--where location like '%India%'
where continent is not null
order by 1,2


-- Looking at the data
select *
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccination vac
on dea.location = vac.location
and dea.date = vac.date


--Looking at Total Population vs Vaccination
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
select dea.continent, dea.location, dea.date, dea.population
, vac.new_vaccinations 
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query
with PopvsVac (Continent, Location, Date, Population, New_Vaccination
,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population
, vac.new_vaccinations 
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *
from PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query
drop table if exists #PercentPopulationVaccination
create table #PercentPopulationVaccination
(continent nvarchar(255)
,location nvarchar(255)
,date datetime
,population numeric
,New_Vaccination numeric
,RollingPeopleVaccinated numeric)
insert into #PercentPopulationVaccination
select dea.continent, dea.location, dea.date, dea.population
, vac.new_vaccinations 
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *, (RollingPeopleVaccinated/Population)*100 as VaccinationPercentage
from #PercentPopulationVaccination


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
