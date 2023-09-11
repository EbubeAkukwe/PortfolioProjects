Select *
From PortfolioProject..CovidDeaths
where continent is not NULL
Order by 3,4

--Updating empty continent cells as NULL

UPDATE PortfolioProject..CovidDeaths
Set continent = NULL
Where continent = ''

--Select *
--From PortfolioProject..CovidVaccination
--Order by 3,4

--Select data to use

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not NULL
Order by 1,2

--Looking at the Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths,
Case 
When total_cases = 0 Then NULL
Else
(total_deaths/total_cases)* 100
End as DeathPercentageByCases
From PortfolioProject..CovidDeaths
Where location = 'Nigeria' AND continent is not NULL
Order by 1,2

--Looking at Total Cases vs Population
-- Shows what percentage of the population has covid

Select location, date, total_cases, population,
Case 
When total_cases = 0 Then NULL
Else
(total_cases/population)* 100
End as DeathPercentageByPopulation
From PortfolioProject..CovidDeaths
Where location = 'Nigeria' AND continent is not NULL
Order by 1,2

--Countries with highest infection rate compared to population

Select Population ,Location, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as 
PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
where continent is not NULL
Group by location, population 
Order by PercentPopulationInfected desc

--Showing countries with highest deathcount per population
Select Location, max(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
where continent is not NULL 
Group by location 
Order by TotalDeathCount desc

--Showing continents with highest deathcount per population
Select continent, max(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
where continent is not NULL 
Group by continent 
Order by TotalDeathCount

--Continents with highest death count per population
Select continent, max(total_deaths) as MaxTotalDeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is Not NULL
Group by continent
Order by MaxTotalDeathPercentage

--Global Deaths

Select SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
CASE
When SUM(cast(new_cases as int)) = 0 Then NULL
Else
(SUM(cast(new_deaths as int))/SUM(new_cases))*100
END as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is Not NULL
--Group by date
Order by 1,2


--Covid Vaccinations

--Looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as bigint)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location AND dea.date = vac.date
	Where dea.continent is not NULL
	Order by 2,3

--Using CTE

With PopulationVsVaccination (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as bigint)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location AND dea.date = vac.date
	Where dea.continent is not NULL
	--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100
From PopulationVsVaccination

--Temp Table
--Drop Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population bigint,
--New_Vaccinations int,
--RollingPeopleVaccinated bigint
--)

--Insert into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
--, SUM(Cast(vac.new_vaccinations as bigint)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--From PortfolioProject..CovidDeaths dea 
--Join PortfolioProject..CovidVaccination vac
--	On dea.location = vac.location AND dea.date = vac.date
--	Where dea.continent is not NULL
--	--Order by 2,3

--Select *, (RollingPeopleVaccinated/Population) * 100
--From #PercentPopulationVaccinated



--Creating view to store data for later visualizations

 Create View PercentPopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as bigint)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location AND dea.date = vac.date
	Where dea.continent is not NULL
	--Order by 2,3

Select *
From PortfolioProject..PercentPopulationVaccinated