USE QuanLiNhaXe;
GO

--EMPLOYEE
CREATE PROC LoadEmployee
AS
BEGIN
	SELECT *
	FROM ViewEmployee
END
GO

CREATE PROC InputEmployee
    @Eid INT,
    @Name CHAR(50),
    @Birthday DATE,
    @Address CHAR(255),
    @Phone NVARCHAR(12),
    @Gender CHAR(10),
    @Area INT,
    @MG_id INT,
	@Password CHAR(100),
    @Base_Salary INT
AS
BEGIN
    INSERT INTO dbo.Employee
    (
        Eid,
        Name,
        Birthday,
        Address,
        Phone,
        Gender,
        Area,
        MG_id,
		Password,
        Base_Salary
    )
    VALUES
    (@Eid, @Name, @Birthday, @Address, @Phone, @Gender, @Area, @MG_id, @Password, @Base_Salary);
END;
GO

CREATE PROC UpdateEmployee
    @Eid INT,
    @Name CHAR(50),
    @Birthday DATE,
    @Address CHAR(255),
    @Phone NVARCHAR(12),
    @Gender CHAR(10),
    @Area INT,
    @MG_id INT,
    @Password CHAR(100),
    @Base_Salary INT
AS
BEGIN
    UPDATE dbo.Employee
    SET Name = @Name,
        Birthday = @Birthday,
        Address = @Address,
        Phone = @Phone,
        Gender = @Gender,
        Area = @Area,
        MG_id = @MG_id,
		Password = @Password, 
        Base_Salary = @Base_Salary
    WHERE Eid = @Eid;
END;
GO

CREATE PROC DeleteEmployee
(@id INT)
AS
BEGIN
    BEGIN TRANSACTION DeleteEmployee;
    DELETE dbo.Work
    WHERE Eid = @id;
    DELETE dbo.Salary
    WHERE Eid = @id;
    DELETE dbo.Employee
    WHERE Eid = @id;
    COMMIT TRANSACTION DeleteEmployee;
END;
GO

CREATE PROCEDURE FindEmployee @Ten NVARCHAR(100)
AS
BEGIN
    SELECT*
	FROM Employee
    WHERE Employee.Name LIKE '%' + @Ten + '%';
END;
GO

CREATE PROCEDURE CountEmployee
AS
BEGIN
    SELECT COUNT(*)
    FROM Employee;
END;
GO

--CUSTOMER
CREATE PROC LoadCustomer
AS
    BEGIN
	SELECT	*
	    FROM ViewCustomer
END 
GO

CREATE PROCEDURE CountCustomer
AS
BEGIN
    SELECT COUNT(*)
    FROM Customer;
END;
GO

CREATE PROC InputCustomer
    @Cid INT,
    @NgayLamThe DATE,
    @NgayHetHan DATE
AS
BEGIN
    INSERT INTO dbo.Customer
    (
        Cid,
		NgayLamThe,
		NgayHetHan
    )
    VALUES
    (@Cid, @NgayLamThe, @NgayHetHan);
END;
GO

CREATE PROC UpdateCustomer
	@Cid INT,
    @NgayLamThe DATE,
    @NgayHetHan DATE
AS
BEGIN
    UPDATE dbo.Customer
    SET	NgayLamThe = @NgayLamThe,
		NgayHetHan = @NgayHetHan
    WHERE Cid = @Cid;
END;
GO

CREATE PROC DeleteCustomer
(@id INT)
AS
BEGIN
    BEGIN TRANSACTION DeleteCustomer;
    DELETE dbo.Ticket
    WHERE Cid = @id;
    DELETE dbo.Customer
    WHERE Cid = @id;
    COMMIT TRANSACTION DeleteCustomer;
END;
GO

--TICKET
CREATE PROC LoadTicket
AS
    BEGIN
	SELECT	*
	    FROM ViewTicket
END 
GO

CREATE PROC InputTicket
    @Cid INT,
	@Eid INT,
    @NgayGui DATE,
    @GioVao TIME,
    @GioRa Time
AS
BEGIN
    INSERT INTO dbo.Ticket
    (
        Cid,
        Eid,
        NgayGui,
        GioVao,
		GioRa
    )
    VALUES
    (@Cid, @Eid,  @NgayGui, @GioVao, @GioRa);
END;
GO

CREATE PROC UpdateTicket
     @Cid INT,
	@Eid INT,
    @NgayGui DATE,
    @GioVao TIME,
    @GioRa Time
AS
BEGIN
    UPDATE dbo.Ticket
    SET Eid = @Eid,
		NgayGui = @NgayGui,
        GioVao = @GioVao,
		GioRa = @GioRa
    WHERE Cid = @Cid;
END;
GO

CREATE PROC DeleteTicket
(@id INT)
AS
BEGIN
    BEGIN TRANSACTION DeleteTicket;
    DELETE dbo.Ticket
    WHERE Cid = @id;
    COMMIT TRANSACTION DeleteTicket;
END;
GO

--AREA
CREATE PROC LoadArea
AS
    BEGIN
	SELECT	*
	    FROM ViewArea
END 
GO

CREATE PROC InputArea
    @Aid INT,
    @Location CHAR(25),
    @Size INT,
    @Opentime TIME(0),
    @Closetime TIME(0)
AS
BEGIN
    INSERT INTO dbo.Area
    (
        Aid,
        Location,
        Size,
        Opentime,
        Closetime
    )
    VALUES
    (@Aid, @Location, @Size, @Opentime, @Closetime);
END;
GO

CREATE PROC UpdateArea
    @Aid INT,
    @Location CHAR(25),
    @Size INT,
    @Opentime TIME(0),
    @Closetime TIME(0)
AS
BEGIN
    UPDATE dbo.Area
    SET Location = @Location,
        Size = @Size,
        Opentime = @Opentime,
        Closetime = @Closetime
    WHERE Aid = @Aid;
END;
GO

CREATE PROC DeleteArea 
(@id INT)
AS
BEGIN
	DECLARE @Employee INT
    BEGIN TRANSACTION DeleteArea;
    DELETE dbo.Customer
    WHERE Cid = @id;
	IF EXISTS (SELECT * FROM dbo.Employee WHERE Area = Eid)
    BEGIN
	DELETE dbo.Employee WHERE Area = @id;
	END
    DELETE dbo.Area
    WHERE Aid = @id;
    COMMIT TRANSACTION DeleteArea;
END;
GO

--SALARY
CREATE PROC LoadSalary
AS
    BEGIN
	SELECT	*
	    FROM ViewSalary
END
GO

CREATE PROC InputSalary
    @Eid INT,
    @Month INT,
    @Year INT,
    @Fine INT,
    @Total INT
AS
BEGIN
    INSERT INTO dbo.Salary
    (
        Eid,
        Month,
        Year,
        Fine,
        Total
    )
    VALUES
    (@Eid, @Month, @Year, @Fine, @Total);
END;
GO

CREATE PROC UpdateSalary
    @Eid INT,
    @Month INT,
    @Year INT,
    @Fine INT,
    @Total INT
AS
BEGIN
    UPDATE dbo.Salary
    SET Month = @Month,
        Year = @Year,
        Fine = @Fine,
        Total = @Total
    WHERE Eid = @Eid;
END;
GO

CREATE PROC DeleteSalary
(@id INT)
AS
BEGIN
    BEGIN TRANSACTION DeleteSalary;
    DELETE dbo.Salary
    WHERE Eid = @id;
    COMMIT TRANSACTION DeleteSalary;
END;
GO

--WORK
CREATE PROC LoadWork
AS
    BEGIN
	SELECT	*
	    FROM ViewWork
END
GO

CREATE PROC InputWork
    @Eid INT,
    @NgayLam DATE
AS
BEGIN
    INSERT INTO dbo.Work
    (
		Eid,
        NgayLam
  
    )
    VALUES
    (@Eid, @NgayLam);
END;
GO

CREATE PROC UpdateWork
 @Eid INT,
    @NgayLam DATE
AS
BEGIN
    UPDATE dbo.Work
    SET NgayLam = @NgayLam
    WHERE Eid = @Eid;
END;
GO

CREATE PROC DeleteWork
	 @Eid INT,
    @NgayLam DATE
AS
BEGIN
    BEGIN TRANSACTION DeleteWork;
	DELETE dbo.Ticket WHERE Eid = @Eid AND NgayGui = @NgayLam;
    DELETE dbo.Work WHERE Eid = @Eid AND NgayLam = @NgayLam;
    COMMIT TRANSACTION DeleteWork;
END;
GO

CREATE PROC FindEmployee (@id_area int)
AS
BEGIN
SELECT * FROM dbo.Fn_searchemployee(@id_area) employee
END;
Go

CREATE PROC ThongTinGuiXe (@ngay date, @id_area int)
AS
BEGIN
SELECT * FROM dbo.Fn_thontinguixe(@ngay,@id_area)
END;
Go

CREATE PROC SoLuongXeTrongNgay(@ngay date)
AS
BEGIN
SELECT
    dbo.Fn_SoLuongXeTrongNgay(@ngay) soluongxe
END;
Go

CREATE PROC Max_Salary
AS
BEGIN
SELECT
    dbo.Max_Salary() maxluong
END;
Go