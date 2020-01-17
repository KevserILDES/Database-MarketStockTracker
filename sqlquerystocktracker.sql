CREATE DATABASE STOCKTRACKER3

CREATE TABLE STOCKCATEGORY(
id int NOT NULL,
scname varchar(25) NOT NULL,
CONSTRAINT StockCategory_PK PRIMARY KEY(id),
constraint StockCategory_UC unique (scname)
);

CREATE TABLE BRAND(
id int NOT NULL,
bname varchar(25) NOT NULL,
CONSTRAINT Brand_PK PRIMARY KEY(id)
);

CREATE TABLE REYON(
id int NOT NULL,
rname varchar(25) NOT NULL,
CONSTRAINT Reyon_PK PRIMARY KEY(id)
);

CREATE TABLE VAT(
id int NOT NULL,
vname varchar(25) NOT NULL,
ratio int,
CONSTRAINT Vat_PK PRIMARY KEY(id)
);
CREATE TABLE STOCKQUANTITY(
id int NOT NULL,
qAmount int NOT NULL,
CONSTRAINT StockQuantity_PK PRIMARY KEY(id)
);
CREATE TABLE STOCK(
id int NOT NULL,
sname varchar(25) NOT NULL,
StockCategoryId int,
BrandId int,
ReyonId int,
PurchaseTax int,
SaleTax int,
VatId int,
expirationDate date,
StockQuantityId int,
CONSTRAINT Stock_PK PRIMARY KEY(id),
CONSTRAINT Stock_FK1 FOREIGN KEY(StockCategoryId) REFERENCES STOCKCATEGORY(id),
CONSTRAINT Stock_FK2 FOREIGN KEY(BrandId) REFERENCES BRAND(id),
CONSTRAINT Stock_FK3 FOREIGN KEY(ReyonId) REFERENCES REYON(id),
constraint Stock_FK4 FOREIGN KEY(StockQuantityId) references STOCKQUANTITY(id),
CONSTRAINT Stock_FK5 FOREIGN KEY(VatId) REFERENCES VAT(id)
);
ALTER TABLE STOCKQUANTITY ADD Stock_id int  CONSTRAINT StockQuantity_FK FOREIGN KEY REFERENCES STOCK(id);


CREATE TABLE SUPPLIER(
id int NOT NULL,
city varchar(15),
street varchar(15),
num int,
phone varchar(11),
Sname varchar(25)
CONSTRAINT Supplier_PK PRIMARY KEY(id),
);

CREATE TABLE SUPP_SCHEDULE(
Stock_id int NOT NULL,
Supply_id int NOT NULL,
quantity int,
dateSupp date DEFAULT SYSDATETIME() NULL,
CONSTRAINT Supp_Schedule_PK PRIMARY KEY(Stock_id,Supply_id),
CONSTRAINT Supp_Schedule_FK1 FOREIGN KEY(Stock_id) REFERENCES STOCK(id),
CONSTRAINT Supp_Schedule_FK2 FOREIGN KEY(Supply_id) REFERENCES SUPPLIER(id),
);

CREATE TABLE BUYER(
id int NOT NULL,
city varchar(15),
street varchar(15),
num int,
phone varchar(11),
nameb varchar(25)
CONSTRAINT Buyer_PK PRIMARY KEY(id),
);

CREATE TABLE BUY_SCHEDULE(
Stock_id int NOT NULL,
Buyer_id int NOT NULL,
quantity int,
dateBuy date DEFAULT SYSDATETIME(),
CONSTRAINT Buy_Schedule_PK PRIMARY KEY(Stock_id,Buyer_id),
CONSTRAINT Buy_Schedule_FK1 FOREIGN KEY(Stock_id) REFERENCES STOCK(id),
CONSTRAINT Buy_Schedule_FK2 FOREIGN KEY(Buyer_id) REFERENCES BUYER(id),
);

CREATE TABLE TRASH_INFO(
Stock_id int NOT NULL,
eDate date DEFAULT SYSDATETIME() NOT NULL,
quantity int,
CONSTRAINT Trash_Info_PK PRIMARY KEY(Stock_id,eDate),
CONSTRAINT Trash_Info_FK FOREIGN KEY(Stock_id) REFERENCES STOCK(id),
);

CREATE TABLE STOCKPRICEARCHIVE(
id int NOT NULL,
StockId int,
dateChanged DATE,
oldPrice int,
newPrice int,
CONSTRAINT StockPriceArchive_PK PRIMARY KEY(id),
CONSTRAINT StockPriceArchive_FK FOREIGN KEY(StockId) REFERENCES STOCK(id)
);

CREATE TABLE LABELL(
id int NOT NULL,
StockId int,
oldPrice int,
newPrice int,
CONSTRAINT Label_PK PRIMARY KEY(id),
CONSTRAINT Label_FK FOREIGN KEY(StockId) REFERENCES STOCK(id)
);

CREATE TABLE UNIT(
id int NOT NULL,
uname varchar(25) NOT NULL,
CONSTRAINT Unit_PK PRIMARY KEY(id)
);

CREATE TABLE STOCKUNIT(
id int NOT NULL,
StockId int,
UnitId int,
ratio int,
referenceId int,
CONSTRAINT StockUnit_PK PRIMARY KEY(id),
CONSTRAINT StockUnit_FK1 FOREIGN KEY(StockId) REFERENCES STOCK(id),
CONSTRAINT StockUnit_FK2 FOREIGN KEY(UnitId) REFERENCES UNIT(id),
CONSTRAINT StockUnit_FK3 FOREIGN KEY(referenceId) REFERENCES STOCKUNIT(id)
);

CREATE TABLE COMPANY(
id int NOT NULL,
lname varchar(25),
city varchar(25),
district varchar(25),
street varchar(25),
number int,
CONSTRAINT Company_PK PRIMARY KEY(id),
);

CREATE TABLE LOCATIONN(
id int NOT NULL,
lname varchar(25),
city varchar(25),
district varchar(25),
street varchar(25),
number int,
CompanyId int,
CONSTRAINT Locationn_PK PRIMARY KEY(id),
CONSTRAINT Locationn_FK FOREIGN KEY(CompanyId) REFERENCES COMPANY(id),
);

CREATE TABLE STOCKUNITBARCODE(
id int NOT NULL,
StockUnitId int,
barcode varchar(15),
CONSTRAINT StockUnitBarcode_PK PRIMARY KEY(id),
CONSTRAINT StockUnitBarcode_FK FOREIGN KEY(StockUnitId) REFERENCES STOCKUNIT(id),
);

CREATE TABLE STOCKUNITPRICE(
id int NOT NULL,
LocationId int,
StockUnitId int,
price int,
isSale bit,
CONSTRAINT StockUnitPrice_PK PRIMARY KEY(id),
CONSTRAINT StockUnitPrice_FK1 FOREIGN KEY(LocationId) REFERENCES LOCATIONN(id),
CONSTRAINT StockUnitPrice_FK2 FOREIGN KEY(StockUnitId) REFERENCES STOCKUNIT(id),
);

CREATE TABLE COMPANYBALANCE(
id int NOT NULL,
CompanyId int,
debit int,
credit int,
balance int,
CONSTRAINT CompanyBalance_PK PRIMARY KEY(id),
CONSTRAINT CompanyBalance_FK FOREIGN KEY(CompanyId) REFERENCES COMPANY(id)
);

CREATE TABLE EXPENSE(
id int NOT NULL,
CompanyId int,
explanation varchar(30),
amountOfExpense int,
CONSTRAINT Expense_PK PRIMARY KEY(id),
CONSTRAINT Expense_FK FOREIGN KEY(CompanyId) REFERENCES COMPANY(id)
);

CREATE TABLE EMPLOYEE(
id int NOT NULL,
CompanyId int,
ename varchar(25),
city varchar(25),
street varchar(25),
number int,
EmployeeType char,
dateHiring date default SYSDATETIME() NOT NULL,
daysWorked int,
birthDate date,
age int,
pass varchar(50),
CONSTRAINT Employee_PK PRIMARY KEY(id),
CONSTRAINT Employee_FK FOREIGN KEY(CompanyId) REFERENCES COMPANY(id)
);
UPDATE EMPLOYEE SET age=DATEDIFF(year,birthDate,GETDATE());
UPDATE EMPLOYEE SET daysWorked=DATEDIFF(year,dateHiring,GETDATE());

CREATE INDEX Employee_In
ON EMPLOYEE (age)

CREATE TABLE COMPANYPHONENUMBER(
cid int NOT NULL,
phoneNumber varchar(11) NOT NULL,
CONSTRAINT CompanyPhoneNumber_PK PRIMARY KEY(cid,phoneNumber),
CONSTRAINT CompanyPhoneNumber_FK FOREIGN KEY(cid) REFERENCES COMPANY(id)
);

CREATE TABLE EMPLOYEEPHONENUMBER(
eid int NOT NULL,
phoneNumber varchar(11) NOT NULL,
CONSTRAINT EmployeePhoneNumber_PK PRIMARY KEY(eid,phoneNumber),
CONSTRAINT EmployeePhoneNumber_FK FOREIGN KEY(eid) REFERENCES EMPLOYEE(id)
);

GO

CREATE VIEW lessStock
AS
SELECT
	s.id AS StockId,
	s.sname AS StockName,
	s.BrandId,
	s.ReyonId,
	sq.id AS SqId,
	sq.qAmount,
	sc.id AS ScId,
	sc.scName AS ScName
FROM
    STOCK AS s,STOCKQUANTITY AS sq, STOCKCATEGORY AS sc
WHERE
	s.StockQuantityId=sq.id AND
	s.StockCategoryId=sc.id AND
	sq.qAmount<50;
GO

CREATE VIEW expireSoon
AS
SELECT
	s.id AS StockId,
	s.sname AS StockName,
	s.BrandId,
	s.ReyonId,
	s.expirationDate,
	s.StockCategoryId,
	sc.scName AS ScName,
	DATEDIFF(day, SYSDATETIME(),s.expirationDate) AS diff
FROM
    STOCK AS s, STOCKCATEGORY AS sc
WHERE
	(DATEDIFF(day, SYSDATETIME(),s.expirationDate) < 5) AND s.StockCategoryId=sc.id;

GO

CREATE TRIGGER incrementQuantity ON SUPP_SCHEDULE 
AFTER INSERT AS 
BEGIN
	DECLARE @id int;
	DECLARE @quant int;
	select @id=Stock_id from inserted
	select @quant=quantity from inserted
	UPDATE STOCKQUANTITY
SET qAmount = qAmount + @quant
WHERE Stock_id=@id;
     
END;

GO


CREATE TRIGGER decrementQuantity ON BUY_SCHEDULE 
AFTER INSERT AS 
BEGIN
	DECLARE @id int;
	DECLARE @quant int;
	select @id=Stock_id from inserted
	select @quant=quantity from inserted
	UPDATE STOCKQUANTITY
SET qAmount = qAmount - @quant
WHERE Stock_id=@id;
    
END;

GO

CREATE TRIGGER decrementQuantity2 ON TRASH_INFO 
AFTER INSERT AS 
BEGIN
	DECLARE @id int;
	DECLARE @quant int;
	select @id=Stock_id from inserted
	select @quant=quantity from inserted
	UPDATE STOCKQUANTITY
SET qAmount = qAmount - @quant
WHERE Stock_id=@id;
    
END;

GO

CREATE VIEW StockInMovements
AS
SELECT
	s.id AS StockId,
	s.sname AS StockName,
	s.BrandId,
	s.ReyonId,
	ssc.Supply_id AS Supplier,
	ssc.quantity AS Supply_quantity,
	ssc.dateSupp AS EnterDate	
FROM
    STOCK AS s,SUPP_SCHEDULE AS ssc
WHERE
	s.id=ssc.Stock_id 

GO

CREATE VIEW StockOutMovements
AS
SELECT
	s.id AS StockId,
	s.sname AS StockName,
	s.BrandId,
	s.ReyonId,
	bsc.Buyer_id AS Buyer,
	bsc.quantity AS Buy_quantity,
	bsc.Buyer_id AS ExitDay

FROM
    STOCK AS s, BUY_SCHEDULE AS bsc
WHERE
	s.id=bsc.Stock_id
GO


CREATE VIEW StockTrashMovements
AS
SELECT
	s.id AS StockId,
	s.sname AS StockName,
	s.BrandId,
	s.ReyonId,
	ti.quantity AS trashQuantity,
	ti.eDate AS expireDatee

FROM
    STOCK AS s, TRASH_INFO AS ti
WHERE
	s.id=ti.Stock_id
GO

SELECT STOCK.id,STOCK.sname,SUPP_SCHEDULE.Supply_id,SUPP_SCHEDULE.quantity,
SUPP_SCHEDULE.dateSupp,BUY_SCHEDULE.Buyer_id,BUY_SCHEDULE.quantity,BUY_SCHEDULE.dateBuy
FROM STOCK, SUPP_SCHEDULE, BUY_SCHEDULE
WHERE STOCK.id=SUPP_SCHEDULE.Stock_id AND STOCK.id=BUY_SCHEDULE.Stock_id;

GO

CREATE PROCEDURE AStockMovement
	@stid smallint
AS
SELECT id,sname,Supply_id,dateSupp,Buyer_id,dateBuy FROM STOCK AS s, SUPP_SCHEDULE AS ssc,BUY_SCHEDULE AS bsc
WHERE s.id = @stid
AND ssc.Stock_id = @stid
AND bsc.Stock_id = @stid;

GO

/****** Object:  Trigger [dbo].[EMPLOYEE_AFTER_UPDATE]    Script Date: 15.12.2019 19:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[EMPLOYEE_AFTER_UPDATE]
   ON  [dbo].[EMPLOYEE]
   AFTER  UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update [dbo].[EMPLOYEE] SET DAYSWORKED = DATEDIFF(DAY, dateHiring, GETDATE())
	--WHERE ID IN (SELECT ID FROM inserted)

END

GO
/****** Object:  Trigger [dbo].[EMPLOYEE_AFTER_INSERT]    Script Date: 15.12.2019 19:21:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[EMPLOYEE_AFTER_INSERT]
   ON  [dbo].[EMPLOYEE]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	update [dbo].[EMPLOYEE] SET dateHiring = GETDATE()
	WHERE id IN (SELECT id FROM INSERTED)
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANYWITHDEBIT]    Script Date: 15.12.2019 19:32:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_COMPANYWITHDEBIT]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.lname,CB.balance FROM COMPANY C 
	JOIN COMPANYBALANCE CB ON CB.CompanyId=C.id AND CB.balance > 0
END

GO
/****** Object:  StoredProcedure [dbo].[SP_RAISESTOCKPRICEWITHRATIO]    Script Date: 15.12.2019 19:33:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_RAISESTOCKPRICEWITHRATIO]
	-- Add the parameters for the stored procedure here
	@RAISERATIO decimal,
	@ISTOSALE bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE STOCKUNITPRICE SET price=price*@RAISERATIO WHERE isSale=@ISTOSALE
END

GO



