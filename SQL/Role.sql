USE QuanLiNhaXe
GO
------------------ROLE---------------------
--Public
----------View-----------
GRANT SELECT ON dbo.ViewEmployee TO PUBLIC
GRANT SELECT ON dbo.ViewWork TO PUBLIC
GRANT SELECT ON dbo.ViewEmployee TO PUBLIC
GRANT SELECT ON dbo.ViewTicket TO PUBLIC
GRANT SELECT ON dbo.ViewSalary TO PUBLIC
GRANT SELECT ON dbo.ViewArea TO PUBLIC
--Private
CREATE ROLE manager
GO 
CREATE ROLE employee
GO
---------Function--------
GRANT SELECT ON dbo.Fn_searchemployee TO manager
GRANT SELECT ON dbo.Fn_thontinguixe TO manager
GRANT EXECUTE ON dbo.Fn_SoLuongXeTrongNgay TO manager
GRANT EXECUTE ON dbo.Max_Salary TO manager
GRANT EXECUTE ON dbo.Fn_GetIDFromDB TO manager

GRANT SELECT ON dbo.Fn_thontinguixe TO employee
GRANT EXECUTE ON dbo.Fn_SoLuongXeTrongNgay TO employee
GRANT EXECUTE ON dbo.Fn_GetIDFromDB TO employee
----------Proceduce------
--manager
GRANT EXECUTE, ALTER ON dbo.LoadArea TO manager
GRANT EXECUTE, ALTER ON dbo.LoadCustomer TO manager
GRANT EXECUTE, ALTER ON dbo.LoadEmployee TO manager
GRANT EXECUTE, ALTER ON dbo.LoadSalary TO manager
GRANT EXECUTE, ALTER ON dbo.LoadTicket TO manager
GRANT EXECUTE, ALTER ON dbo.LoadWork TO manager
GRANT EXECUTE, ALTER ON dbo.CountEmployee TO manager
GRANT EXECUTE, ALTER ON dbo.CountCustomer TO manager
GRANT EXECUTE, ALTER ON dbo.DeleteCustomer TO manager
GRANT EXECUTE, ALTER ON dbo.DeleteEmployee TO manager
GRANT EXECUTE, ALTER ON dbo.DeleteTicket TO manager
GRANT EXECUTE, ALTER ON dbo.DeleteWork TO manager
GRANT EXECUTE, ALTER ON dbo.InputCustomer TO manager
GRANT EXECUTE, ALTER ON dbo.InputEmployee TO manager
GRANT EXECUTE, ALTER ON dbo.InputWork TO manager
GRANT EXECUTE, ALTER ON dbo.InputTicket TO manager
GRANT EXECUTE, ALTER ON dbo.UpdateSalary TO manager
GRANT EXECUTE, ALTER ON dbo.UpdateCustomer TO manager
GRANT EXECUTE, ALTER ON dbo.UpdateTicket TO manager
GRANT EXECUTE, ALTER ON dbo.UpdateWork TO manager
GRANT EXECUTE, ALTER ON dbo.UpdateEmployee TO manager

--employee
GRANT EXECUTE ON dbo.LoadArea TO employee
GRANT EXECUTE ON dbo.LoadCustomer TO employee
GRANT EXECUTE ON dbo.LoadEmployee TO employee
GRANT EXECUTE ON dbo.LoadSalary TO employee
GRANT EXECUTE ON dbo.LoadTicket TO employee
GRANT EXECUTE ON dbo.LoadWork TO employee
GRANT EXECUTE ON dbo.CountCustomer TO employee
GRANT EXECUTE ON dbo.DeleteCustomer TO employee
GRANT EXECUTE ON dbo.InputCustomer TO employee
GRANT EXECUTE ON dbo.UpdateTicket TO employee
GRANT EXECUTE ON dbo.InputTicket TO employee
GRANT EXECUTE ON dbo.UpdateEmployee TO employee
