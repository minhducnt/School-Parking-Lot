	USE QuanLiNhaXe;
GO

-- Trả về danh sách nhân viên theo từng khu vực làm việc
--@id_area là cụm từ nhập tìm kiếm
CREATE FUNCTION Fn_searchemployee(@id_area int)
RETURNS @employee_list TABLE (
		MaNV INT NOT NULL,
		TenNV char(50) NOT NULL,
		birthday DATE NOT NULL,
		address char(255) NOT NULL,
		phone char(12) NOT NULL,
		gender char(12) NOT NULL,
		area INT NOT NULL,
		id_mg INT NOT NULL,
		base_salary INT NOT NULL,
		password char(100) NOT NULL
)
AS 
BEGIN 
	INSERT into @employee_list select * FROM dbo.Employee where Area=@id_area
	RETURN;
END
GO
--- trả về thông tin gửi xe theo khu vực trong một ngày cụ thể
--@ngay là cụm từ tìm kiếm theo ngày nhập, @id_area là khu vực muốn tìm kiếm
CREATE FUNCTION Fn_thontinguixe(@ngay date, @id_area int)
RETURNS @date_list table(
		MaKH INT NOT NULL,
		MaNV INT NOT NULL ,
		MaNhaXe INT NOT NULL,
		NgayGui DATE NOT NULL,
		GioVao time(0) NOT NULL,
		GioRa time(0) NOT NULL
)
AS 
BEGIN 
	INSERT INTO @date_list
	SELECT q.Cid,q.Eid,k.Area,q.NgayGui,q.GioVao,q.GioRa FROM
	(SELECT * FROM dbo.Ticket WHERE  NgayGui = @ngay) q  INNER JOIN dbo.Employee AS k ON k.Eid = q.Eid
	WHERE @id_area = k.Area
	RETURN
END
GO
-- Hàm trả về tổng số lượng xe giữ được trong một ngày cụ  thể
---Trong đó @ngay là cụm từ dùng dể tìm kiếm theo ngày
CREATE FUNCTION Fn_SoLuongXeTrongNgay(@ngay date)
RETURNS int
as
begin
	declare @dem int
	select @dem = count(*)
	from dbo.Ticket
	where NgayGui = @ngay
	return @dem
END
GO 

--- Trả về total lương lớn nhất hiện có
CREATE FUNCTION Max_Salary()
RETURNS INT
AS
BEGIN
DECLARE @Luong INT
SELECT @Luong = MAX(Total) FROM dbo.Salary
RETURN @Luong
END
GO

--Trả về id lớn nhất trong bảng Work
CREATE FUNCTION Fn_GetIDFromDB()
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SELECT @id = MAX(Eid) FROM dbo.Work
		IF(@id IS NULL)
			RETURN 0
	RETURN @id
END

DECLARE @CountTN INT
SELECT @CountTN = COUNT(*) 
FROM THANNHAN 
WHERE (
	IF(ngthan > 0 AND ngthan < 3): luong += 10tr 
	ELSe: luong += ....
)

CREATE FUNCTION Fn_CountTN()
RETURNS INT
AS
BEGIN
	DECLARE @CountTN INT
	SELECT @CountTN = COUNT(*) 
	FROM THANNHAN 
	WHERE (
		IF(ngthan > 0 AND ngthan < 3): luong += 10tr 
		ELSe: luong += ....
	)
END