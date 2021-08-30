CREATE DATABASE QuanLiNhaXe;
GO
USE QuanLiNhaXe;
GO
CREATE TABLE dbo.Area
(
    Aid INT PRIMARY KEY,
    Location CHAR(25) NOT NULL,
    Size INT CHECK (Size > 300) NOT NULL,
    Opentime TIME(0) NOT NULL,
    Closetime TIME(0) NOT NULL,
);

CREATE TABLE dbo.Employee
(
    Eid INT NOT NULL,
    Name CHAR(50) NOT NULL,
    Birthday DATE NOT NULL,
    Address CHAR(255) NOT NULL,
    Phone CHAR(12) NOT NULL,
    Gender CHAR(12) NOT NULL,
    Area INT NOT NULL,
    MG_id INT NOT NULL REFERENCES dbo.Employee (Eid),
    Base_Salary INT NOT NULL,
	Password CHAR(100) NOT NULL DEFAULT 1,
    PRIMARY KEY (Eid),
    FOREIGN KEY (Area) REFERENCES dbo.Area (Aid)
);

CREATE TABLE dbo.Work
(
    Eid INT NOT NULL,
    NgayLam DATE NOT NULL,
    PRIMARY KEY (
                    Eid,
                    NgayLam
                ),
    FOREIGN KEY (Eid) REFERENCES dbo.Employee (Eid)
);
GO



CREATE TABLE dbo.Salary
(
    Eid INT
        REFERENCES dbo.Employee (Eid) NOT NULL,
    Month INT CHECK (Month > 0
                     AND Month < 13
                    ) NOT NULL,
    Year INT NOT NULL,
    Fine INT NOT NULL,
    Total INT NOT NULL,
    PRIMARY KEY (Eid),
);

GO
CREATE TABLE dbo.Customer
(
    Cid INT NOT NULL,
    NgayLamThe DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    PRIMARY KEY (Cid),
);
GO

CREATE TABLE dbo.Ticket
(
    Cid INT NOT NULL,
    Eid INT NOT NULL,
    NgayGui DATE NOT NULL,
    GioVao TIME(0) NOT NULL,
    GioRa TIME(0) NOT NULL,
    PRIMARY KEY (Cid,Eid),
    FOREIGN KEY (Cid) REFERENCES Customer (Cid),
    FOREIGN KEY (Eid,NgayGui) REFERENCES dbo.Work (Eid,NgayLam)
);
GO
