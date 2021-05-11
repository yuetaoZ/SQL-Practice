USE [AdventureWorks2019]

--1
select ProductID, Name, Color, ListPrice
from Production.Product

--2
select ProductID, Name, Color, ListPrice
from Production.Product where ListPrice = 0

--3
select ProductID, Name, Color, ListPrice
from Production.Product where Color is null

--4
select ProductID, Name, Color, ListPrice
from Production.Product where Color is not null

--5
select ProductID, Name, Color, ListPrice
from Production.Product where Color is not null and ListPrice > 0

--6
select 'Product ' + Name + ' (with ProductID ' + cast(ProductID as varchar) +  ') has price: '+ cast(ListPrice as varchar) as Report
from Production.Product where Color is not null

--7
select 'NAME: ' + name + ' -- COLOR: ' + Color
from Production.Product where Color is not null

--8
select ProductID, Name
from Production.Product where ProductID between 400 and 500

--9
select ProductID, Name, Color
from Production.Product where Color = 'Black' or Color = 'blue'

--10
select 'Product ' + Name +'(' + cast(ProductID as varchar) + ') is ' + Color as Report
from Production.Product where Color is not null

--11
select name, ListPrice
from Production.Product where Name like 'S%' order by Name, ListPrice

--12
select name, ListPrice
from Production.Product where Name like 'S%' or Name like 'A%' order by Name

--13
select name, ListPrice
from Production.Product where (Name like 'S%' or Name like 'P%'  or Name like 'O%') and Name not like '_K%' order by Name

--14
select distinct Name, Color
from Production.Product where Color is not null order by Name desc

--15
select distinct ProductSubcategoryID, Color
from Production.Product where ProductSubcategoryID is not null and Color is not null

--16
SELECT ProductSubCategoryID
      , LEFT([Name],35) AS [Name]
      , Color, ListPrice 
FROM Production.Product
WHERE (Color not IN ('Red','Black') AND ProductSubCategoryID != 1)
	  OR (Color IN ('Red','Black') AND ProductSubCategoryID = 1)
	  OR ListPrice BETWEEN 1000 AND 2000
ORDER BY ProductID

--17
select distinct ProductSubcategoryID, Name, Color, ListPrice
from Production.Product where ProductSubcategoryID is not null and Color is not null
	 and ProductSubcategoryID between 1 and 14
	 and Name like 'HL%'
	 or Name like 'Road-350-W%'
	 or Name like 'Mountain-500%'
	 order by ProductSubcategoryID desc
