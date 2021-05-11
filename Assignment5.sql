--Answer following questions
--1.	What is an object in SQL?
--	An object in a SQL Server is used to store or reference data. 
--	For example, tables, views, clusters, sequences, indexes, and synonyms.
--2.	What is Index? What are the advantages and disadvantages of using Indexes?
--Advantages:
	--Speed up SELECT query
	--Helps to make a row unique or without duplicates(primary, unique)
	--If index is set to fill-text index, then we can search against large string values.
	--For example to find a word from a sentece etc.
--Disadvantages:
	--Indexes take additional disk space.
	--Indexes slow down INSERT, UPTDATE and DELETE, but will speed up UPDATE if the WHERE condition has an indexed field.
	--INSERT, UPDATE and DELETE becomes slower because on each operation the indexes must also be updated.
--3.	What are the types of Indexes?
	-- Clustered Index, Non-Clustered Index, Unique Index, Filtered Index, Columnstore Index, Hash Index

--4.	Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
	-- When we create a PRIMARY KEY constraint, a unique clustered index on the column or columns is automatically created if a clustered index on the table does not already exist and we do not specify a unique nonclustered index. The primary key column cannot allow NULL values.
--5.	Can a table have multiple clustered index? Why?
	-- There can be only one clustered index per table, because the data rows themselves can be stored in only one order.
	-- The only time the data rows in a table are stored in sorted order is when the table contains a clustered index.
--6.	Can an index be created on multiple columns? Is yes, is the order of columns matter?
	-- Yes, indexes can be composites and the order is important because of the left most principle.
--7.	Can indexes be created on views?
	-- Yes. The first index created on a view must be a unique clustered index. Creating a unique clustered index on a view improves query performance because the view is stored in the database in the same way a table with a clustered index is stored. The query optimizer may use indexed views to speed up the query execution.

--8.	What is normalization? What are the steps (normal forms) to achieve normalization?
	-- Normalization is a database design technique that reduces data redundancy and eliminates undesirable characteristics like Insertion, Update and Deletion Anomalies.
	-- Normalization rules divides larger tables into smaller tables and links them using relationships.
	-- The purpose of Normalization in SQL is to eliminate redundaant (repetitive) data and ensure data is stored logically.
--9.	What is denormalization and under which scenarios can it be preferable?
	-- Denormalization is a database optimization technique in which we add redundant data to one or more tables.
	-- This can help us avoid costly joins in a relational database.
	-- Note that denormalization does not mean not doing normalization. It is an optimization technique that is applied after doing normalization.

--10.	How do you achieve Data Integrity in SQL Server?
	-- We can apply Entity integrity to the Table by specifying a primary key, unique key, and not null.
	-- Referential integrity ensures the relationship between the Tables. We can apply this using a Foreign Key constraint.
--11.	What are the different kinds of constraint do SQL Server have?
	-- NOT NULL, ensures that a column cannot have a NULL value
	-- UNIQUE, ensures that all values in a column are different.
	-- PRIMARY KEY, a combination of a NOT NULL and UNIQUE
--12.	What is the difference between Primary Key and Unique Key?
	-- PRIMARIY KEY can not accept NULL values while UNIQUE KEY can.
	-- We can have only one PRIMARY KEY in a table while more than one UNIQUE KEY.
	-- PRIMARY KEY creates clustered index while UNIQUE KEY creates non-clustered index.
--13.	What is foreign key?
	-- A FOREIGN KEY is a field(or collection of fields) in one table, that refers to the PRIMARY KEY in another table.
--14.	Can a table have multiple foreign keys?
	-- Yes, a table may have multiple foreign keys, and each foreign key can have a different parent table.
--15.	Does a foreign key have to be unique? Can it be null?
	-- No, a foreign key doesn't have to be unique and it can be null.
	-- The reason that it can be more value on foreign key is it could have a one to many relationship.
	-- The reason that it can be null is we need it to be null for not knowing data.
--16.	Can we create indexes on Table Variables or Temporary Tables?
	-- We can not create indexes on Table Variables while we can have indexs on temporary tables.
--17.	What is Transaction? What types of transaction levels are there in SQL Server?
	-- A transaction is a logical unit of work that contains one or more SQL statements.
	-- A transaction is an atomic unit.
	-- Transaction levels: Read Committed, Read Uncommitted, Repeatable Read, Serializable, Snapshot.

--Write queries for following scenarios
--1.Write an sql statement that will display the name of each customer and the sum of order totals placed by that customer during the year 2002
	Create table customer(cust_id int,  iname varchar (50)) 
	Create table orders(order_id int,cust_id int,amount money,order_date smalldatetime)

	SELECT c.iname, SUM(o.amount) total
	FROM customer c inner join orders o
	ON c.cust_id = o.cust_id
	WHERE o.order_date BETWEEN '1/1/2002' AND '12/31/2002'

--2.The following table is used to store information about company’s personnel:
	Create table person (id int, firstname varchar(100), lastname varchar(100))
--	insert into person values (1, 'Coco', 'Ale')
--	insert into person values (2, 'GoGo', 'Bee')
--write a query that returns all employees whose last names  start with “A”.
	SELECT id, firstname, lastname
	FROM person 
	WHERE lastname like 'A%'

--3.The information about company’s personnel is stored in the following table:
--	Create table person(person_id int primary key, manager_id int null, name varchar(100)not null) The filed managed_id contains the person_id of the employee’s manager.
--	Please write a query that would return the names of all top managers(an employee who does not have  a manger, and the number of people that report directly to this manager.

--4. List all events that can cause a trigger to be executed.
	--DML Events
	--DDL Events
	--LOGON Event

--5. Generate a destination schema in 3rd Normal Form.  Include all necessary fact, join, and dictionary tables, and all Primary and Foreign Key relationships.  The following assumptions can be made:
--a. Each Company can have one or more Divisions.
--b. Each record in the Company table represents a unique combination 
--c. Physical locations are associated with Divisions.
--d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
--e. Contacts can be associated with one or more divisions and the address, but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.
