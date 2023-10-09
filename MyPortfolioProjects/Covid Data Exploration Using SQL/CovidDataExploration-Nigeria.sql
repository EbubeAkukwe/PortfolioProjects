--Creating Table to store Nigeria Covid Data
Drop Table If Exists NigeriaCovidData
Create Table NigeriaCovidData
(Location varchar(50),
Population nvarchar(50),
Date datetime,
TotalTests nvarchar(50),
PositiveRate nvarchar(50),
TotalCases nvarchar(50),
PeopleFullyVaccinated nvarchar(50),
TotalDeaths nvarchar(50),
PercentageVaccinated nvarchar(50),
DeathPercentage nvarchar(50)
)

--Joining Covid Deaths and Covid Vaccinations Global Data to grab
--Grabbing data that concerns Nigeria only(i.e location as Nigeria) to store in NigeriaCovidData

Select CovidDeaths.Location, Population, CovidVaccinations.date, total_tests, positive_rate, total_cases, people_fully_vaccinated, total_deaths, (cast(people_fully_vaccinated as int)/population)*100 as PercentageVaccinated, (total_deaths/population)*100 as DeathPercentage
From CovidDeaths
JOIN CovidVaccinations
On
CovidDeaths.location = CovidVaccinations.location AND 
CovidDeaths.date = CovidVaccinations.date
Where CovidVaccinations.Location = 'Nigeria'
Order by 1,2


--Inserting Data into the NigeriaCovidData Table Using Insert
Insert into NigeriaCovidData
Select CovidDeaths.Location, Population, CovidVaccinations.date, convert(int,rtrim(total_tests)), convert(float,rtrim(positive_rate)), convert(int,rtrim(total_cases)), convert(int,rtrim(people_fully_vaccinated)), convert(int,rtrim(total_deaths)), (convert(int,rtrim(people_fully_vaccinated))/population)*100 as PercentageVaccinated, (convert(int,rtrim(total_deaths))/population)*100 as DeathPercentage
From CovidDeaths
JOIN CovidVaccinations
On
CovidDeaths.location = CovidVaccinations.location AND 
CovidDeaths.date = CovidVaccinations.date
Where CovidVaccinations.Location = 'Nigeria'

--Grabbing Covid Data from NigeriaCovidData Table when The TotalTests is not 0
Select *
From NigeriaCovidData
Where TotalTests <> 0
Order by 1,2

--Creating Procedure to Grab Data from NigeriaCovidData Table
Create Procedure GetNigeriaCovidData
AS
Select *
From NigeriaCovidData
Where TotalTests <> 0
Order by 1,2

--Running Procedure
Exec GetNigeriaCovidData




