/*
SELECT Statment
*, Top, Distinct, Count, As, Max, Min, Avg
*/
/*selecting the top 5 rows of every column in EmployeeDemographics Table:
Select Top 5 *  
From EmployeeDemographics 
*/
/*selecting FirstName and LastName columns in EmployeeDemographics Table:
Select  FirstName, LastName
From EmployeeDemographics 
*/
/*
Select Distinct(specific column)  
From EmployeeDemographics 
*/
/* return the number of rows that contain non null values in LastName column
Select Count(LastName)  AS LastNameCount -- AS return a name for the data retrieved
From EmployeeDemographics 
*/
------------------------------------------------------
--video 7
--Where statement : =, <, >, <>, And, Or, like, Null, Not Null, In
/* select every record in EmployeeDemographics where does not equal Jim.
Select *
From EmployeeDemographics
WHERE FirstName <> 'Jim'
*/
/* select every LastName where only starts with S.
Select *
From EmployeeDemographics
WHERE LirstName LIKE 'S%'
*/
/* select every LastName where S in anywhere in LastName.
Select *
From EmployeeDemographics
WHERE LirstName LIKE '%S%'
*/
/* IN: compairs many values, it seems like equal many values
Select *
From EmployeeDemographics
WHERE FirstName IN ('Jim','Michael')
*/
------------------------------------------------------
--video 8
Select Gender, COUNT(Gender)
From [SQL Tutorial].dbo.EmployeeDemographics
GROUP BY Gender

------------------------------------------------------
--video 7
/*
Inner Joins, Full/Left/Right Outer Joins
*/
Select* 
From [SQL Tutorial].dbo.EmployeeDemographics
Inner Join [SQL Tutorial].dbo.EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--------
Select* 
From [SQL Tutorial].dbo.EmployeeDemographics
full Outer Join [SQL Tutorial].dbo.EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

------------------------------------------------------
--video 8
/*
Union --> UNION IS USED TO APPENED TWO TABLES WITH EACH OTHER(SAME COLUMNS) without duplicates
Union All --> regaredless of duplicates
*/
Select* 
From [SQL Tutorial].dbo.EmployeeDemographics
Union
Select* 
From [SQL Tutorial].dbo.WareHouseEmployeeDemographics

------------------------------------------------------
--video 9
/*
Case statement --> retrieve a query then make a condition on it
*/
Select FirstName, LastName, Age,
CASE
	WHEN Age > 30 THEN 'old'
	when Age BETWEEN 27 and 30 then 'young'
	else 'Baby'
END
From [SQL Tutorial].dbo.EmployeeDemographics
where Age is not null
order by Age
--------------
SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
	WHEN JobTitle = 'Accontant' THEN Salary + (Salary * .05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001)
	ELSE Salary + (Salary * .03)
END AS SalaryAfterRaise -- here AS means the name that will be displayed for the retrieved column name
From [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

------------------------------------------------------
--video 10
/*
Having Clause
*/
SELECT  JobTitle, COUNT(JobTitle)
From [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1	--THE AGGREGATE FUNCTIONS CONOT BE USED WITHIN A WHERE STATEMENT IT MUST BE USED WITHIN A HAVING STATEMENT
							--THE HAVING STATEMENT ALWAYSE MUST BE AFTER THE GROUP BY STATEMENT AND BEFORE THE ORDER BY STATEMENT
------------------------------------------------------
--video 11
/*
UPDATING / DELETING DATA
*/
-- UPDATING
SELECT*
From [SQL Tutorial].dbo.EmployeeDemographics

update [SQL Tutorial].dbo.EmployeeDemographics
set EmployeeID = 1012 -- what i wanna update
where FirstName = 'Holly' AND LastName = 'Flax' -- specefing the row to be updated

update [SQL Tutorial].dbo.EmployeeDemographics
set Age = 31, Gender = 'Female' -- what i wanna update
where EmployeeID = 1012 -- specefing the row to be updated

-- DELETING
SELECT*
From [SQL Tutorial].dbo.EmployeeDemographics

DELETE FROM [SQL Tutorial].dbo.EmployeeDemographics
where EmployeeID = 1005
------------------------------------------------------
--video 12
/*
ALIASING -->aliasing refers to giving a temporary name to a table or a column within a specific query.
These aliases are used to enhance readability and simplify complex queries.
it makes a short cut for a table name,etc.. (aliases --> variables)
*/
SELECT FirstName + ' ' + LastName AS FullName
From [SQL Tutorial].dbo.EmployeeDemographics
------------------------------------------------------
--video 13
/*
PARTITION BY
*/
Select FirstName, LastName, Gender, Salary, 
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
From [SQL Tutorial]..EmployeeDemographics dem
join [SQL Tutorial]..EmployeeSalary sal
	on dem.EmployeeID = sal.EmployeeID

Select Gender, COUNT(Gender) TotalGender -- when using COUNT() function it has to be contained in either an aggregate function or the GROUP BY clause.
From [SQL Tutorial]..EmployeeDemographics dem
join [SQL Tutorial]..EmployeeSalary sal
	on dem.EmployeeID = sal.EmployeeID
GROUP BY Gender 

------------------------------------------------------
--video 14
/*
CTE(COMMON TABLE EXPRESSON) --> A TEMPORARY SNAPSHOT FROM TABLES RETRIEVED BY A SELECT STATEMENT.
							--> SEEMS LIKE VARIABLES FOR SELECTED TABLES
							--> IT CAN BE USED JUST ONCE AND STRAIGHT AFTER ITS CONTENT  
*/
WITH CTE_Employee as
(
select FirstName, LastName, Gender, Salary 
, COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
, COUNT(Salary) OVER (PARTITION BY Gender) as AvgSalary
From [SQL Tutorial]..EmployeeDemographics dem
join [SQL Tutorial]..EmployeeSalary sal
	on dem.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
Select FirstName, AvgSalary
FROM CTE_Employee

------------------------------------------------------
--video 15
/*
TEMP TABLES --> SAME AS CTE BUT IT CAN BE USED MANY TIMES
			--> FIRST DECLERATION (BY CREATE)
			--> SECOND INITIATION (BY INSERT) 
*/
DROP TABLE IF EXISTS #Temp_Employee1
--DECLERATION
CREATE TABLE #Temp_Employee1 -- hash sign (#) is used when creating a temp table.
(
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int
)
--INITIATION
INSERT INTO #Temp_Employee1
SELECT JobTitle, COUNT(JobTitle), Avg(Age), Avg(Salary)
From [SQL Tutorial]..EmployeeDemographics dem
join [SQL Tutorial]..EmployeeSalary sal
	on dem.EmployeeID = sal.EmployeeID
GROUP BY JobTitle
SELECT* 
FROM #Temp_Employee1

------------------------------------------------------
--video 16
/*
String Functions: TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower
*/
--Drop Table EmployeeErrors;
CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM --> IT REMOVES THE SPACES FROM THE ROWS IN A SPECEFIC COLUMN  
Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

-- Using Replace
Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors

-- Using Substring
Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)

-- Using UPPER and lower
Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors

------------------------------------------------------
--video 17
/*
STORED PROCEDURES --> is like a (custom function) TO BE CALLED WHEN ITS NEEDED.
				  --> It consists of one or more SQL statements grouped together.
				  --> You create it once and then call it repeatedly whenever needed.
				  Purpose:
					Reusability: Instead of writing the same SQL query over and over, you save it as a stored procedure.
					Efficiency: It reduces redundancy and improves performance.
					Parameterization: You can pass parameters to a stored procedure, allowing it to act based on those values.
*/
CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)

Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM [SQL Tutorial]..EmployeeDemographics emp
JOIN [SQL Tutorial]..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;

DROP PROCEDURE IF EXISTS Temp_Employee2
CREATE PROCEDURE Temp_Employee2 
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)

Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM [SQL Tutorial]..EmployeeDemographics emp
JOIN [SQL Tutorial]..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
where JobTitle = @JobTitle --- make sure to change this in this script from original above
group by JobTitle

Select * 
From #temp_employee3
GO;

exec Temp_Employee2 @jobtitle = 'Salesman'
exec Temp_Employee2 @jobtitle = 'Accountant'

------------------------------------------------------
--video 18
/*
Subqueries (in the Select, From, and Where Statement) --> nested or inner queries
*/
Select EmployeeID, JobTitle, Salary
From EmployeeSalary

-- Subquery in Select
Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID

-- Subquery in From
Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID

-- Subquery in Where
Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30)