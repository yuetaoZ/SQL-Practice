/*
	Answer following questions
1.	What is View? What are the benefits of using views?
	View is a virtual table based on the result-set of an SQL statement.
	The benefits of using views include present a subset of the data contained in a table
	without explosure of the underlying tables to the outer world. A given user may have
	permission to query the view, while denied access to the rest of the base table.

2.	Can data be modified through views?
	We CAN only modify data on views based on only ONE of the tables involved at a time
	by using reference the underlying data in the table columns directly. 
	In other words, we CAN'T modify any data that related to any aggregation function,
	such as COUNT, SUM, MIN, MAX, TOP...
	nor any set operation, such as UNION, UNION ALL, JOIN, GROUP BY, HAVING...
	
3.	What is stored procedure and what are the benefits of using it?
	A stored procedure is a prepared SQL code that we can save, so the code can be reuesed
	over and over again. So if we have an SQL query that we write over and over again,
	we can save it as a stored procedure, and then just call it to execute it.
	The benefit of using it is: a stored procedure allows to execute SQL queries by a
	single call, which could minimize the use of slow networks and improve roundtrip response time.

4.	What is the difference between view and stored procedure?
	A view represents a virtual table. We can join multiple tables in a view and use the
	view to present the data as if the data were coming from a single table.

	A stored procedure uses parameters to do a function.(material table) 
	Whether it is updating and inserting data, or returning single valuew or data sets.

5.	What is the difference between stored procedure and functions?
	A procedure is used to perform certain task in order. A function can be called by
	procedure. Afunction returns a value and control to calling function or code.
	A procedure returns the control but not any value to calling function or code.

6.	Can stored procedure return multiple result sets?
	No, stored procedure can not return multiple values. However, multiple stored procedure
	can be written and invoked from within a single statement.

7.	Can stored procedure be executed as part of SELECT Statement? Why?
	No, stored procedures are typically executed with an EXEC statement. However,
	we can execute a stored procedure implicityly from within a SELECT statement by 
	re-writing the stored procedure in function and call as needed.

8.	What is Trigger? What types of Triggers are there?
	A trigger is a special type of stored procedures that is automatically executed when
	an event occurs in a specific database server.

9.	What are the scenarios to use Triggers?
	DML triggers run when a user tries to modify data through 
	a data manipulation language(DML) event. DML events are INSERT,
	UPDATE, or DELETE statements on a table or view.

10.	What is the difference between Trigger and Stored Procedure?
	Stored procedures are a pieces of the code in written in PL/SQL to do
	some specific task. Trigger is a stored procedure that runs automatically when
	various events happen(eg. update, insert, delete).

*/

/*
	Write queries for following scenarios Use Northwind database. 
	All questions are based on assumptions described by
	the Database Diagram sent to you yesterday. When inserting, make up info 
	if necessary. Write query for each step. Do not use IDE. 
	BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.
*/
USE Northwind
GO
--1.Lock tables Region, Territories, EmployeeTerritories and Employees. 
--	Insert following information into the database. 
--	In case of an error, no changes should be made to DB.

--	a.A new region called “Middle Earth”;
	SELECT * FROM Region
	INSERT INTO Region(RegionID, RegionDescription) VALUES (5, 'Middle Earth');
--	b.A new territory called “Gondor”, belongs to region “Middle Earth”;
	SELECT * FROM Territories
	INSERT INTO Territories(TerritoryID, TerritoryDescription, RegionID) VALUES (54, 'Gondor', 5)
--	c.A new employee “Aragorn King” who's territory is “Gondor”.
	SELECT * FROM Employees
	SET IDENTITY_INSERT Employees ON
	INSERT INTO Employees(EmployeeID, LastName, FirstName, Region) VALUES (10, 'King', 'Aragorn', 'Gondor')
	SET IDENTITY_INSERT Employees OFF
	GO

--2.Change territory “Gondor” to “Arnor”.
	SELECT * FROM Territories
	UPDATE Territories SET TerritoryDescription = 'Arnor' WHERE TerritoryDescription = 'Gondor'

--3.Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget WHERE or you will delete everything.) 
--	In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.
	SELECT * FROM Region
	DELETE FROM Territories WHERE RegionID = 5
	DELETE FROM Region WHERE RegionDescription = 'Middle Earth' 
	GO


--4.Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.	
	CREATE VIEW view_product_order_zhu AS 
	SELECT P.ProductName, OD.Quantity
	FROM Products P INNER JOIN [Order Details] OD
	ON P.ProductID = OD.ProductID
	GO

	SELECT * FROM view_product_order_zhu
	GO


--5.Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
	CREATE PROCEDURE sp_product_order_quantity_zhu(@ProductID int)
	AS
	SELECT P.ProductID, OD.Quantity
	FROM Products P INNER JOIN [Order Details] OD
	ON P.ProductID = OD.ProductID
	WHERE P.ProductID = @ProductID

	exec sp_product_order_quantity_zhu @ProductID = 1;
	GO

--6.Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input 
--	and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
	CREATE PROCEDURE sp_product_order_city_zhu(@ProductName nvarchar(40))
	AS
	SELECT TOP 5 City, SUM(Quantity) AS Quantity
	FROM Products P INNER JOIN [Order Details] OD
	ON P.ProductID = OD.ProductID
	INNER JOIN Orders O
	ON OD.OrderID = O.OrderID
	INNER JOIN Customers C
	ON O.CustomerID = C.CustomerID
	WHERE P.ProductName = @ProductName
	GROUP BY City
	Order by SUM(Quantity) DESC
	GO

	EXEC sp_product_order_city_zhu @ProductName = 'Tofu'
	GO


--7.Lock tables Region, Territories, EmployeeTerritories and Employees. 
--	Create a stored procedure “sp_move_employees_[your_last_name]” that automatically find all employees in territory “Tory”; 
--	if more than 0 found, insert a new territory “Stevens Point” of region “North” to the database, and then move those employees to “Stevens Point”.
	CREATE PROCEDURE sp_move_employees_zhu
	AS
	IF EXISTS(
	SELECT * FROM Employees E INNER JOIN Territories T
	ON E.Region = T.TerritoryDescription
	WHERE E.Region = 'Tory')
	BEGIN 
		INSERT INTO Territories(TerritoryDescription, RegionID) VALUES ('Stevens Point', 3)
		UPDATE Employees
		SET Region = 'Stevens Point'
		WHERE Region = 'Tory'
	END
	GO
	

--8.Create a trigger that when there are more than 100 employees in territory “Stevens Point”, move them back to Troy. 
--	(After test your code,) remove the trigger. Move those employees back to “Troy”, if any. Unlock the tables.



/*9.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
10.	 Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
11.	Create a stored procedure named “sp_your_last_name_1” that returns all cites that have at least 2 customers who have bought no or only one kind of product. Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).
12.	How do you make sure two tables have the same data?
14.
First Name	Last Name	Middle Name
John	Green	
Mike	White	M
Output should be
Full Name
John Green
Mike White M.
Note: There is a dot after M when you output.
15.
Student	Marks	Sex
Ci	70	F
Bob	80	M
Li	90	F
Mi	95	M
Find the top marks of Female students.
If there are to students have the max score, only output one.
16.
Student	Marks	Sex
Li	90	F
Ci	70	F
Mi	95	M
Bob	80	M
How do you out put this?

*/