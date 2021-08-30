USE QuanLiNhaXe;
GO

--EMPLOYEE
CREATE VIEW ViewEmployee
AS
SELECT *
FROM dbo.Employee;
GO

--CUSTOMER
CREATE VIEW ViewCustomer
AS
SELECT  *
FROM dbo.Customer
GO

--WORK
CREATE VIEW ViewWork
AS
SELECT *
FROM dbo.Work;
GO

--SALARY
CREATE VIEW ViewSalary
AS
SELECT *
FROM dbo.Salary;
GO

--TICKET
CREATE VIEW ViewTicket
AS
SELECT *
FROM dbo.Ticket;
GO

--AREA
CREATE VIEW ViewArea
AS
SELECT *
FROM dbo.Area;
GO