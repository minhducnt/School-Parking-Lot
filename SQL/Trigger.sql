USE QuanLiNhaXe
GO
----------Trigger khi UPDATE Employee----------
GO

CREATE TRIGGER T_UpdateEmployee
ON dbo.Employee
FOR UPDATE
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @ManagerID INT
	DECLARE @Age INT
	DECLARE @oldpass CHAR(100)
	DECLARE @newpass CHAR(100)
	DECLARE @Salary INT 

	SELECT @EmployeeID = Deleted.Eid ,@oldpass = Password FROM Deleted
	SELECT @ManagerID = MG_id ,@newpass = Password ,@Age = YEAR(GETDATE())-YEAR(Birthday),@Salary = Base_Salary FROM Inserted

	IF (@Age < 18 OR @Age > 60)
		BEGIN
			RAISERROR('Nhan vien phai trong do tuoi lao dong',16,1)
			ROLLBACK
			RETURN 
		END
	--Neu nhan vien duoc dua len lam quan ly
	IF (@ManagerID = @EmployeeID)
		BEGIN
			-----Kiem tra quan ly luon phai lon hon 30 tuoi
			IF (@Age<30)
			BEGIN
				RAISERROR('Nhan vien quan ly phai tu 30 tuoi',16,1)
				ROLLBACK
				RETURN
			END
			-----Kiem tra luong co ban cua nhan vien
			IF (@Salary < 11000000)
			BEGIN
				RAISERROR('Nhan vien quan ly phai co luong co ban tu 11.000.000 VND',16,1)
				ROLLBACK
				RETURN
			END
		END
	ELSE IF (@Salary < 8000000)
			BEGIN
				RAISERROR('Nhan vien phai co luong co ban trên 8.000.000 VND',16,1)
				ROLLBACK
				RETURN
			END
	IF(@oldpass = @newpass) RETURN
	BEGIN TRANSACTION
		DECLARE @SQLstring NVARCHAR(MAX)
		SET @SQLstring = 'ALTER LOGIN [' + TRY_CONVERT(NVARCHAR(10),@EmployeeID) + '] WITH PASSWORD = ''' + @newpass + ''''
		EXECUTE @SQLstring
		IF @ManagerID = @EmployeeID
		BEGIN
		EXECUTE sp_droprolemember @rolename = 'employee',
		                              @membername = @EmployeeID
		EXECUTE sp_addrolemember @rolename = 'manager',
										@membername = @EmployeeID
		END
		IF (@@ERROR <> 0)
		BEGIN
			RAISERROR(N'FOUND ERROR UPDATE',16,1)
			ROLLBACK TRANSACTION
			RETURN
		END
	COMMIT
END
GO

----------Trigger khi DELETE Employee----------
CREATE TRIGGER T_DeleteEmployee
ON dbo.Employee
FOR DELETE
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @Area INT
	DECLARE @ManagerID INT
	DECLARE @COUNT INT 
	SELECT @EmployeeID = Eid,@Area = Area,@ManagerID = MG_id FROM Deleted
	--Neu nhan vien la quan ly
	IF (@ManagerID = @EmployeeID)
	BEGIN
		--Kiem tra so nhan vien đang quan ly
		SELECT @COUNT = COUNT(Eid) FROM dbo.Employee WHERE MG_id = @ManagerID
		IF @COUNT <> 0
			BEGIN
				RAISERROR('Chi duoc xoa quan ly khong phu trach nhan vien nao !',16,1)
				ROLLBACK
				RETURN
			END
		--Kiem tra khu vuc con quan ly khac khong
		SET @COUNT = 0
		SELECT @COUNT = COUNT(MG_id) FROM dbo.Employee WHERE Area = @Area
		IF @COUNT = 0 
			BEGIN
				RAISERROR('Khu vuc khong con quan ly, Khong the xoa quan ly hien tai !',16,1)
				ROLLBACK
				RETURN
			END
	END
	--Nhan vien binh thuong
	ELSE
		BEGIN
			SELECT @COUNT = COUNT(Eid) FROM dbo.Employee WHERE Area = @Area AND MG_id <> Eid
			IF @COUNT = 0
			BEGIN
				RAISERROR('Khu vuc khong con nhan vien, Khong the xoa nhan vien hien tai !',16,1)
				ROLLBACK
				RETURN
			END
		END
	BEGIN TRANSACTION
		--Delete user
		DECLARE @DropUser NVARCHAR(MAX)
		SET @DropUser = 'DROP USER [' + TRY_CONVERT(NVARCHAR(10),@EmployeeID) +']'
		EXEC (@DropUser)
		--Delete Login
		DECLARE @DropLogin NVARCHAR(MAX)
		SET @DropLogin = 'DROP LOGIN [' + TRY_CONVERT(NVARCHAR(10),@EmployeeID)+']'
		EXEC (@DropLogin)

		IF (@@ERROR<>0)
		BEGIN
			RAISERROR(N'FOUND ERROR DELETE',16,1)
			ROLLBACK TRANSACTION
			RETURN
		END
	COMMIT
END
GO

----------Trigger khi INSERT Employee----------
CREATE TRIGGER T_InsertEmploy
ON dbo.Employee
FOR INSERT
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @Password CHAR(100)
	DECLARE @ManagerID INT
	DECLARE @Age INT
	DECLARE @Salary INT
	SELECT @EmployeeID = Eid,@Password = Password,@ManagerID = MG_id, @Age = YEAR(GETDATE())-YEAR(Birthday),@Salary = Base_Salary FROM Inserted
	
	-----Kiem tra nhan vien phu hop tuoi lao dong
	IF (@Age < 18 OR @Age > 60)
		BEGIN
			RAISERROR('Nhan vien phai trong do tuoi lao dong',16,1)
			ROLLBACK
			RETURN
		END
	IF (@Age<30 AND @ManagerID = @EmployeeID)
			BEGIN
				RAISERROR('Nhan vien quan ly phai tu 30 tuoi',16,1)
				ROLLBACK
				RETURN
			END
	-----Kiem tra luong co ban cua nhan vien
	IF (@Salary < 11000000 AND @ManagerID = @EmployeeID)
		BEGIN
			RAISERROR('Nhan vien quan ly phai co luong co ban tu 11.000.000 VND',16,1)
			ROLLBACK
			RETURN
		END
	ELSE IF (@Salary < 8000000)
		BEGIN
			RAISERROR('Nhan vien phai co luong co ban trên 8.000.000 VND',16,1)
			ROLLBACK
			RETURN
		END
	BEGIN TRANSACTION
		--Login
		DECLARE @CreateLogin VARCHAR(MAX)
		SET @CreateLogin = 'CREATE LOGIN [' + TRY_CONVERT(NVARCHAR(10),@EmployeeID) + '] WITH PASSWORD = ''' + @Password + '''' + ', DEFAULT_DATABASE=[QuanLiNhaXe]'
		EXEC (@CreateLogin)
		--User
		DECLARE @CreateUser VARCHAR(MAX)
		SET @CreateUser = 'CREATE USER [' + TRY_CONVERT(VARCHAR(10),@EmployeeID) + '] FOR LOGIN ['+ TRY_CONVERT(NVARCHAR(10),@EmployeeID) + ']'
		EXECUTE (@CreateUser)
		--Role
		IF @EmployeeID = @ManagerID
			BEGIN
			EXECUTE sp_addrolemember @rolename = 'manager',
										 @membername = @EmployeeID
			END
		ELSE
			BEGIN
			EXECUTE sp_addrolemember @rolename = 'employee',
										 @membername = @EmployeeID
			END

		IF (@@ERROR<>0)
			BEGIN
				RAISERROR(N'FOUND ERROR CREATE',16,1)
				ROLLBACK TRANSACTION
				RETURN
			END
	COMMIT
END
GO

CREATE TRIGGER T_UpdateSalary
ON dbo.Salary
FOR UPDATE
AS
BEGIN
	DECLARE @Id INT
	DECLARE @TotalSalary INT
	DECLARE @BasicSalary INT
	DECLARE @Fine INT

	SELECT @TotalSalary = Total, @Fine = Fine, @Id = Eid FROM Inserted
	SELECT @BasicSalary = Base_Salary FROM dbo.Employee WHERE @Id = Eid
	IF (@Fine>@BasicSalary)
		BEGIN
			RAISERROR('Tien phat khong the vuot qua luong co ban',16,1)
			ROLLBACK
			RETURN
		END
	IF (@TotalSalary <> @BasicSalary - @Fine)
		BEGIN
			RAISERROR('Tinh luong sai, vui long tinh lai (Luong = Luong co ban - tien phat)',16,1)
			ROLLBACK
			RETURN
		END
END
GO

CREATE TRIGGER T_InsertCustomer
ON dbo.Customer
FOR INSERT
AS
BEGIN
	DECLARE @Ngaylamthe DATE
	DECLARE @Ngayhethan DATE
	SELECT @Ngaylamthe=NgayLamThe, @Ngayhethan = NgayHetHan FROM Inserted

	IF (@Ngayhethan <= @Ngaylamthe)
		BEGIN
			RAISERROR('Ngay het han sai, vui long nhap lai',16,1)
			ROLLBACK
			RETURN
		END
END
GO

CREATE TRIGGER T_InsertTicket
ON dbo.Ticket
FOR INSERT
AS
BEGIN
	DECLARE @Area INT
	DECLARE @Slot INT
	DECLARE @Eid INT
	DECLARE @Cid INT
	DECLARE @NgayGui DATE
	DECLARE @GioVao TIME(0)
	DECLARE @GioRa TIME(0)
	DECLARE @CountCar INT
	DECLARE @Opentime TIME(0)
	DECLARE @Closetime TIME(0)

	SELECT @Eid = Eid, @NgayGui = NgayGui, @GioVao = GioVao, @GioRa = GioRa, @Cid = Cid FROM Inserted
	SELECT @Area = Area FROM dbo.Employee WHERE @Eid = Employee.Eid
	SELECT @CountCar = COUNT(*) FROM (SELECT * FROM dbo.Ticket WHERE NgayGui = @NgayGui) k INNER JOIN (SELECT Eid FROM dbo.Employee WHERE @Area = Employee.Area) q ON q.Eid = k.Eid
	SELECT @Slot = Size, @Opentime=Opentime,@Closetime =Closetime FROM dbo.Area WHERE Area.Aid = @Area
	IF (@GioVao < @Opentime OR @GioVao > @Closetime)
		BEGIN
			RAISERROR('Khu vuc chua den gio hoat dong, quy khach vui long thong cam',16,1)
			ROLLBACK
			RETURN
		END
	IF (@CountCar = @Slot)
		BEGIN
			RAISERROR('Khu nay da het cho, quy khach vui long qua khu khac',16,1)
			ROLLBACK
			RETURN
		END
	IF (@GioVao >= @GioRa)
		BEGIN
			RAISERROR('Nhap sai thoi gian ra vao vui long thu lai',16,1)
			ROLLBACK
			RETURN
		END
END
GO

CREATE TRIGGER T_UpdateTicket
ON dbo.Ticket
FOR UPDATE
AS
BEGIN
	DECLARE @Area INT
	DECLARE @Eid INT
	DECLARE @Slot INT
	DECLARE @NgayGui DATE
	DECLARE @GioVao TIME(0)
	DECLARE @GioRa TIME(0)
	DECLARE @CountCar INT
	DECLARE @Opentime TIME(0)
	DECLARE @Closetime TIME(0)

	DECLARE @Area_old INT
	DECLARE @Eid_old INT
	DECLARE @NgayGui_old DATE

	SELECT @Eid = Eid, @NgayGui = NgayGui, @GioVao = GioVao, @GioRa = GioRa FROM Inserted
	SELECT @Area = Area FROM dbo.Employee WHERE @Eid = Employee.Eid
	SELECT @CountCar = COUNT(*) FROM (SELECT * FROM dbo.Ticket WHERE NgayGui = @NgayGui) k INNER JOIN (SELECT Eid FROM dbo.Employee WHERE @Area = Employee.Area) q ON q.Eid = k.Eid
	SELECT @Slot = Size, @Opentime=Opentime,@Closetime =Closetime FROM dbo.Area WHERE Area.Aid = @Area

	SELECT @Eid_old = Eid, @NgayGui_old = NgayGui FROM Deleted
	SELECT @Area_old = Area FROM dbo.Employee WHERE @Eid_old = Employee.Eid

	--Thay doi ngay gui xe
	IF @NgayGui <> @NgayGui_old
		BEGIN
			RAISERROR('Khong the thay doi ngay gui',16,1)
			ROLLBACK
			RETURN
		END
	IF @Area <> @Area_old 
		BEGIN
		IF (@GioVao < @Opentime OR @GioVao > @Closetime)
			BEGIN
				RAISERROR('Khu vuc chua den gio hoat dong, quy khach vui long thong cam',16,1)
				ROLLBACK
				RETURN
			END
		IF (@CountCar = @Slot)
			BEGIN
				RAISERROR('Khu nay da het cho, quy khach vui long qua khu khac',16,1)
				ROLLBACK
				RETURN
			END
		END
	IF (@GioVao >= @GioRa)
		BEGIN
			RAISERROR('Nhap sai thoi gian ra vao vui long thu lai',16,1)
			ROLLBACK
			RETURN
		END
END
GO

CREATE TRIGGER T_UpdateWork
ON dbo.Work
FOR UPDATE,DELETE
AS
BEGIN
	DECLARE @Area INT
	DECLARE @Date_old DATE
	DECLARE @Id_old INT

	SELECT @Id_old = Eid, @Date_old = NgayLam FROM Deleted
	SELECT @Area = Area FROM dbo.Employee WHERE @Id_old = Eid

	--Kiem tra con ai lam chung khu khong ?
	IF NOT EXISTS (SELECT COUNT(*) FROM (SELECT Eid,Area FROM dbo.Employee WHERE Area = @Area AND Eid <> MG_id) q INNER JOIN (SELECT * FROM dbo.Work WHERE NgayLam = @Date_old) k ON q.Eid = k.Eid)
		BEGIN
			RAISERROR('Thieu nguoi lam nen khong the thay doi hoac xoa',16,1)
			ROLLBACK
			RETURN
		END
END
GO