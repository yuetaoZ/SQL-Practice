/*
	Answer following questions
	1.	In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
		I would prefer joins, because it is more efficient, especially in a iterative sentence.
	2.	What is CTE and when to use it?
		CTE stands for Common Table Expressions, it can create a temporary table for use and can make the code cleaner to read.
	3.	What are Table Variables? What is their scope and where are they created in SQL Server?
		Table variables are local variables that helps to stre data temporarily. The scope of a Table variable is its branch.
	4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
		DELETE and TRUNCATE both delete data from data, where TRANCATE will just delete the data without scanning it.
		Therefore, TRUNCATE has a better performance.
	5.	What is Identity column? How does DELETE and TRUNCATE affect it?
		Identity column is an index column created by the database itself.
		DELETE will remove data but not reset the identity.
		TRUNCATE on the other hand will reset the identity to its seed value.
	6.	What is difference between “delete from table_name” and “truncate table table_name”?
		Delete can used to remove all rows or only a seubset of rows. Truncate removes all rows.
*/

--Write queries for following scenarios
--All scenarios are based on Database NORTHWND.
--1.List all cities that have both Employees and Customers.
	select distinct e.City 
	from Employees e inner join Customers c 
	on e.City = c.City
--2.List all cities that have Customers but no Employee.
--a.Use sub-query
	select distinct City 
	from Customers where City not in 
	(select City from Employees)
--b.Do not use sub-query
	select distinct c.City from Customers c inner join
	(
	select c.City
	from Customers c inner join Employees e
	on c.City = e.City
	) as commCity 
	on c.City != commCity.City
--3.List all products and their total order quantities throughout all orders.
	select ProductName, Quantity
	from Products p inner join [Order Details] od
	on p.ProductID = od.ProductID
--4.List all Customer Cities and total products ordered by that city.
	select co.city, count(od.Quantity) 'total products' from 
	(select c.City, o.OrderID
	from Customers c left join Orders o
	on c.CustomerID = o.CustomerID) as co left join 
	[Order Details] od
	on co.OrderID = od.OrderID
	group by co.City
--5.List all Customer Cities that have at least two customers.
--a.Use union

--b.Use sub-query and no union
	select City from Customers
	group by City
	having COUNT(City) > 2
--6.List all Customer Cities that have ordered at least two different kinds of products.
	select c.City
	from 
	(
	select o.CustomerID, count(distinct p.CategoryID) kind
	from ([Order Details] od inner join Orders o
	on od.OrderID = o.OrderID) 
	inner join Products p
	on od.ProductID = p.ProductID
	group by o.CustomerID
	) ck
	inner join Customers c
	on ck.CustomerID = c.CustomerID
	group by c.City
	having sum(ck.kind) > 2

--7.List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
	select distinct c.ContactName
	from Customers c inner join Orders o
	on c.CustomerID = o.CustomerID
	where c.City != o.ShipCity
--8.List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
	select top 5 c.City, od.ProductID, p.UnitPrice, count(od.ProductID) numOfOrder
	from
	Orders o inner join [Order Details] od
	on o.OrderID = od.OrderID
	inner join Customers c
	on o.CustomerID = c.CustomerID
	inner join Products p
	on od.ProductID = p.ProductID
	group by c.City, od.ProductID, p.UnitPrice
	order by numOfOrder desc

--9.List all cities that have never ordered something but we have employees there.
--a.Use sub-query
	select City from Employees where City not in (
	select c.City
	from Orders o inner join Customers c
	on o.CustomerID = c.CustomerID
	)
--b.Do not use sub-query
	
--10.List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
--11.How do you remove the duplicates record of a table?
--12.Sample table to be used for solutions below- Employee ( empid integer, mgrid integer, deptid integer, salary integer) Dept (deptid integer, deptname text)
--Find employees who do not manage anybody.
--13.Find departments that have maximum number of employees. (solution should consider scenario having more than 1 departments that have maximum number of employees). Result should only have - deptname, count of employees sorted by deptname.
--14.Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.
