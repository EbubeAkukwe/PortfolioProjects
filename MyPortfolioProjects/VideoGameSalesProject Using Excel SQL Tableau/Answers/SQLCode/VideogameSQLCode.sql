Select *
From VideoGameSalesCleaned

--Getting only needed data
Select Genre, Year, Platform,NA_Sales,EU_Sales,JP_Sales,Other_Sales,Unknown_Sales
From VideoGameSalesCleaned
Order by 1,2

--Getting data for Genre with known year of release
Select Genre, Year, Platform,NA_Sales,EU_Sales,JP_Sales,Other_Sales,Unknown_Sales
From VideoGameSalesCleaned
Where Year is Not NULL
Order by 1,2

--Adding Total_Sales cell to the Table and rounding up to 2dp
--Will be useful in calculations
Select Genre, Year, Platform,NA_Sales,EU_Sales,JP_Sales,Other_Sales,Unknown_Sales, 
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL
Order by 1,2

--To Grab all Playstion Series Data and Save to GrabData Folder
Select Genre, Year, Platform,NA_Sales,EU_Sales,JP_Sales,Other_Sales,Unknown_Sales, 
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'PS%'
Order by Genre, Year

--To Grab all Xbox Series Data and Save to GrabData Folder
Select Genre, Year, Platform,NA_Sales,EU_Sales,JP_Sales,Other_Sales,Unknown_Sales, 
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'X%'
Order by Genre, Year

--Which year did Playstation had the most sales
--Using CTE to work on the PlayStation Data
With PlayStationSales AS (
Select Year,
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'PS%'
)
Select DISTINCT(year), SUM(Total_Sales) over (partition by year) as Yearly_Sales 
From PlayStationSales
Order by Yearly_Sales DESC
--delete the DESC and run to get smallest Yearly_Sales at the top

--From result 2004 is the year with the most Playstation sales and 2017 with lowest sales


--Which genre do playstation sell more of and by how many percent 
--Using CTE to work on the PlayStation Data

With PlayStationSales AS (
Select Genre,
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'PS%'
)
Select DISTINCT(Genre), SUM(Total_Sales) over (partition by Genre) as Yearly_Sales
From PlayStationSales
Order by Yearly_Sales DESC
--Playstation sells more of the Action genre

--creating playstation sales temp table to work with 

Create Table #PlayStationSales 
(
Genre varchar(50),
Total_Sales float
)

--Inserting playsation sales data into the temp table

Insert Into #PlayStationSales
Select Genre,
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'PS%'

--checking temp table

Select *
From #PlayStationSales

--Creating Genre Temp table
Drop Table If Exists #PlayStationGenreSales
Create Table #PlayStationGenreSales (
Genre varchar(50),
Yearly_Sales float,
)

Insert Into #PlayStationGenreSales
Select DISTINCT(Genre), SUM(Total_Sales) over (partition by Genre) as Yearly_Sales
From #PlayStationSales
--Order by Yearly_Sales DESC

--checking Genre Temp table
Select *
From #PlayStationGenreSales

--Calculating percentage Yearly_Sales
Select Genre , convert(float(1),Yearly_sales) as Yearly_Sales, cast((Yearly_Sales/SUM(Yearly_Sales) over())*100 as float(1)) as Yearly_Sales_Percent
From
#PlayStationGenreSales
Order by Yearly_Sales_Percent DESC
--Action Genre has the highest yearly sales with 24.61 percent
--Removing the DESC and Puzzle Genre has the lowest yearly sales and by 0.68 percent



--Calculating Xbox Data

--Which year did Xbox had the most sales
--Using CTE to work on the Xbox Data
With XboxSales AS (
Select Year,
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'PS%'
)
Select DISTINCT(year), SUM(Total_Sales) over (partition by year) as Yearly_Sales 
From XboxSales
Order by Yearly_Sales DESC
--delete the DESC and run to get smallest Yearly_Sales at the top

--From result 2004 is the year with the most Xbox sales and 2017 with lowest sales


--Which genre do playstation sell more of and by how many percent 
--Using CTE to work on the PlayStation Data

With XboxSales AS (
Select Genre,
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'X%'
)
Select DISTINCT(Genre), SUM(Total_Sales) over (partition by Genre) as Yearly_Sales
From XboxSales
Order by Yearly_Sales DESC
--Xbox sells more of the Shooter genre

--creating xbox sales temp table to work with 

Create Table #XboxSales 
(
Genre varchar(50),
Total_Sales float
)

--Inserting playsation sales data into the temp table

Insert Into #XboxSales
Select Genre,
cast((NA_Sales+EU_Sales+JP_Sales+Other_Sales) as float(1)) as Total_Sales
From VideoGameSalesCleaned
Where Year is Not NULL AND Platform LIKE 'X%'

--checking temp table

Select *
From #XboxSales

--Creating Genre Temp table
Drop Table If Exists #XboxGenreSales
Create Table #XboxGenreSales (
Genre varchar(50),
Yearly_Sales float,
)

Insert Into #XboxGenreSales
Select DISTINCT(Genre), SUM(Total_Sales) over (partition by Genre) as Yearly_Sales
From #XboxSales
--Order by Yearly_Sales DESC

--checking Genre Temp table
Select *
From #XboxGenreSales

--Calculating percentage Yearly_Sales
Select Genre , convert(float(1),Yearly_sales) as Yearly_Sales, cast((Yearly_Sales/SUM(Yearly_Sales) over())*100 as float(1)) as Yearly_Sales_Percent
From
#XboxGenreSales
Order by Yearly_Sales_Percent DESC
--Shooter Genre has the highest yearly sales with 28.70 percent
--Removing the DESC and Puzzle Genre has the lowest yearly sales and by 0.084 percent


--Calculating The Sales Ratio

--Joining the playstation and xbox yearly sales data
--Creating playstation total sales Temp Table

Drop Table if Exists #PlayStation_Total_Sales
CREATE Table #PlayStation_Total_Sales (
ID float,
PlayStation_Total_Sales float
)

Insert Into #PlayStation_Total_Sales
Select 1 as ID, SUM(Total_Sales) over () as Total_PlayStation_Sales
From #PlayStationSales

SELECT DISTINCT(PlayStation_Total_Sales),ID
FROM #PlayStation_Total_Sales


--Creating Xbox total sales Temp Table
Drop Table if Exists #Xbox_Total_Sales
CREATE Table #Xbox_Total_Sales (
ID float,
Xbox_Total_Sales float
)

Insert Into #Xbox_Total_Sales
Select 1 as ID, SUM(Total_Sales) over () as Total_Xbox_Sales
From #XboxSales

SELECT DISTINCT(Xbox_Total_Sales),ID
FROM #Xbox_Total_Sales

--Creating Total Sales Table and Iinserting both Total Sales table there

--Joining tables

With #PSXbox_Total_Sales AS (
SELECT DISTINCT(PlayStation_Total_Sales) , Xbox_Total_Sales,#Xbox_Total_Sales.ID
FROM #PlayStation_Total_Sales
FULL JOIN
#Xbox_Total_Sales
ON
#PlayStation_Total_Sales.ID = #Xbox_Total_Sales.ID
)
--Select *
--From #PSXbox_Total_Sales
--Calculating Sales Ratio
Select PlayStation_Total_Sales, Xbox_Total_Sales,
CASE WHEN Xbox_Total_Sales < PlayStation_Total_Sales THEN cast((Xbox_Total_Sales/PlayStation_Total_Sales) as float(1))
ELSE
cast((PlayStation_Total_Sales/Xbox_Total_Sales) as float(1))
END AS SalesRatio
From #PSXbox_Total_Sales

--Sales Ratio is 0.3844 which is Approximately 0.4 i.e 4/10
--So Xbox Sells 4 Games per every 10 Games sold by PlayStation
--OR Xbox Sells 1 Games per every 2 Games sold by PlayStation (Approximately xD)









