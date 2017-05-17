USE [master];
GO
IF EXISTS(SELECT * from sys.databases where name = 'AirTicketSystem')
DROP DATABASE [AirTicketSystem];
GO
CREATE DATABASE [AirTicketSystem];
GO

USE [AirTicketSystem];
GO

CREATE TABLE [BHall] (
	[Hno] INT PRIMARY KEY,
	[Haddr] VARCHAR(30),
	[Hmanager] INT
);

CREATE TABLE [cellphone] (
	[Ptype] VARCHAR(30) PRIMARY KEY,
	[Pdate] DATE,
	[Pprice] INT
);

CREATE TABLE [SaleRecord] (
	[Sno] INT PRIMARY KEY,
	[Ptype] VARCHAR(30),
	[Sdate] DATE,
	[Salesman] INT,
	[Hno] INT,
	FOREIGN KEY ([Ptype])
		REFERENCES [cellphone]([Ptype])
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY ([Hno])
		REFERENCES [BHall]([Hno])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE [cellUser] (
	[pnumber] VARCHAR(20) PRIMARY KEY,
	[username] VARCHAR(30) NOT NULL,
	[uid] VARCHAR(30) UNIQUE NOT NULL,
	[email] VARCHAR(30) CHECK(email LIKE '%_@_%_.__%')
);

CREATE TABLE [phoneMFee] (
	[pnumber] VARCHAR(20) NOT NULL,
	[mdate] DATE,
	[mfee1] INT,
	[mfee2] INT,
	[mfee3] INT,
	[mtotal] AS ([mfee1] + [mfee2] + [mfee3]),
	FOREIGN KEY ([pnumber])
		REFERENCES [cellUser]([pnumber])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE [phonePaid] (
	[pnumber] VARCHAR(20) NOT NULL,
	[pdate] DATE,
	[paid] INT,
	FOREIGN KEY ([pnumber])
		REFERENCES [cellUser]([pnumber])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE [phoneFeeHistory] (
	[pnumber] VARCHAR(20) NOT NULL,
	[pmonth] DATE,
	[fee] INT,
	[type] INT,
	[pbalance] INT,
	FOREIGN KEY ([pnumber])
		REFERENCES [cellUser]([pnumber])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE USER [manager] WITHOUT LOGIN;
CREATE USER [sales1] WITHOUT LOGIN;
CREATE USER [sales2] WITHOUT LOGIN;
CREATE USER [sales3] WITHOUT LOGIN;
CREATE USER [oper1] WITHOUT LOGIN;
CREATE USER [oper2] WITHOUT LOGIN;
CREATE USER [user1] WITHOUT LOGIN;

ALTER USER [manager] WITH DEFAULT_SCHEMA = [dbo];
ALTER USER [sales1] WITH DEFAULT_SCHEMA = [dbo];
ALTER USER [sales2] WITH DEFAULT_SCHEMA = [dbo];
ALTER USER [sales3] WITH DEFAULT_SCHEMA = [dbo];
ALTER USER [oper1] WITH DEFAULT_SCHEMA = [dbo];
ALTER USER [oper2] WITH DEFAULT_SCHEMA = [dbo];
ALTER USER [user1] WITH DEFAULT_SCHEMA = [dbo];

CREATE ROLE [rolem];
CREATE ROLE [role1];
CREATE ROLE [role2];
CREATE ROLE [roleu];

GRANT INSERT, DELETE, SELECT, UPDATE, ALTER, REFERENCES
ON [BHall]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER, REFERENCES
ON [cellphone]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER, REFERENCES
ON [SaleRecord]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER, REFERENCES
ON [cellUser]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER, REFERENCES
ON [phoneMFee]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER, REFERENCES
ON [phonePaid]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER, REFERENCES
ON [phoneFeeHistory]
TO [rolem]
WITH GRANT OPTION;
GO


EXEC sp_addrolemember N'rolem', N'manager'
GO
EXEC sp_addrolemember N'role1', N'sales1'
GO
EXEC sp_addrolemember N'role1', N'sales2'
GO
EXEC sp_addrolemember N'role1', N'sales3'
GO
EXEC sp_addrolemember N'role2', N'oper1'
GO
EXEC sp_addrolemember N'role2', N'oper2'
GO
EXEC sp_addrolemember N'roleu', N'user1'
GO

SETUSER 'manager';
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER
ON [BHall]
TO [role1]
AS [rolem];
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER
ON [cellphone]
TO [role1]
AS [rolem];
GRANT INSERT, DELETE, SELECT, UPDATE, ALTER
ON [SaleRecord]
TO [role1]
AS [rolem];
GO

GRANT INSERT, SELECT, DELETE, UPDATE([username], [uid], [email]), ALTER
ON [cellUser]
TO [role2]
AS [rolem];
GRANT INSERT, SELECT, DELETE, UPDATE([mdate], [mfee1], [mfee2], [mfee3], [mtotal]), ALTER
ON [phoneMFee]
TO [role2]
AS [rolem];
GRANT INSERT, SELECT, DELETE, UPDATE([pdate], [paid]), ALTER
ON [phonePaid]
TO [role2]
AS [rolem];
GRANT SELECT
ON [phoneFeeHistory]
TO [role2]
AS [rolem];
GO

GRANT SELECT
ON [cellphone]
TO [roleu]
AS [rolem];
GRANT SELECT
ON [cellUser]
TO [roleu]
AS [rolem];
GRANT SELECT
ON [phoneMFee]
TO [roleu]
AS [rolem];
GRANT SELECT
ON [phonePaid]
TO [roleu]
AS [rolem];
GRANT SELECT
ON [phoneFeeHistory]
TO [roleu]
AS [rolem];
GO

GO
CREATE TRIGGER phoneFeeHistory_AfterInsertphoneMFee_TRG 
ON [phoneMFee]
AFTER INSERT
AS
BEGIN
  IF EXISTS (SELECT i.[pnumber] FROM [phoneFeeHistory], Inserted AS i)
  BEGIN
    INSERT INTO [phoneFeeHistory]
	SELECT TOP 1 [pnumber], [pmonth], [fee], [type], [pbalance]
	FROM (
	  SELECT i.[pnumber] AS [pnumber], [phoneFeeHistory].[pmonth] AS [oldMonth], i.[mdate] AS [pmonth], (i.[mfee1] + i.[mfee2] + i.[mfee3]) AS [fee], 0 AS [type], ([phoneFeeHistory].[pbalance] - i.[mfee1]- i.[mfee2] - i.[mfee3]) AS [pbalance]
	  FROM [phoneFeeHistory], Inserted AS i
	  WHERE [phoneFeeHistory].[pnumber] = i.[pnumber]
    ) AS [newHistory]
    ORDER BY [pmonth] DESC, [oldMonth] DESC;
  END ELSE
  BEGIN
	INSERT INTO [phoneFeeHistory]
	SELECT *
	FROM (
	  SELECT i.[pnumber] AS [pnumber], i.[mdate] AS [pmonth], (i.[mfee1] + i.[mfee2] + i.[mfee3]) AS [fee], 0 AS [type], (-i.[mfee1] - i.[mfee2] - i.[mfee3]) AS [pbalance]
	  FROM Inserted AS i
    ) AS [newHistory]
  END
END
GO

GO
CREATE TRIGGER phoneFeeHistory_AfterInsertphonePaid_TRG 
ON [phonePaid]
AFTER INSERT
AS
BEGIN
  IF EXISTS (SELECT i.[pnumber] FROM [phoneFeeHistory], inserted AS i)
  BEGIN
    INSERT INTO [phoneFeeHistory]
	SELECT TOP 1 [pnumber], [pmonth], [fee], [type], [pbalance]
	FROM (
	  SELECT i.[pnumber] AS [pnumber], [phoneFeeHistory].[pmonth] AS [oldMonth], i.[pdate] AS [pmonth], i.[paid] AS [fee], 1 AS [type], ([phoneFeeHistory].[pbalance] + i.[paid]) AS [pbalance]
	  FROM [phoneFeeHistory], Inserted AS i
	  WHERE [phoneFeeHistory].[pnumber] = i.[pnumber]
    ) AS [newHistory]
    ORDER BY [pmonth] DESC, [oldMonth] DESC;
  END ELSE
  BEGIN
	INSERT INTO [phoneFeeHistory]
	SELECT *
	FROM (
	  SELECT i.[pnumber] AS [pnumber], i.[pdate] AS [pmonth], i.[paid] AS [fee], 1 AS [type], i.[paid] AS [pbalance]
	  FROM Inserted AS i
    ) AS [newHistory]
  END
END
GO
SETUSER;


SETUSER 'sales1';
INSERT INTO [BHall] VALUES(1, '»ª¿Æ', 1);
INSERT INTO [cellphone] VALUES('HUST-001', '2017-01-01', 1000);
INSERT INTO [SaleRecord] VALUES(1, 'HUST-001', '2017-01-02', 1, 1);
SETUSER;


SETUSER 'oper1';
INSERT INTO [cellUser] VALUES('13723332333', 'user1', '340910188109232333', 'sabertazimi@gmail.com');
INSERT INTO [phoneMFee]([pnumber], [mdate], [mfee1], [mfee2], [mfee3]) VALUES('13723332333', '2017-01-31', 30, 30, 30);
INSERT INTO [phonePaid] VALUES('13723332333', '2017-02-01', 100);
INSERT INTO [phoneMFee]([pnumber], [mdate], [mfee1], [mfee2], [mfee3]) VALUES('13723332333', '2017-02-28', 20, 30, 40);
INSERT INTO [phoneMFee]([pnumber], [mdate], [mfee1], [mfee2], [mfee3]) VALUES('13723332333', '2017-03-31', 40, 50, 20);
SETUSER;


SETUSER 'manager';
SELECT * FROM [SaleRecord];
SELECT * FROM [cellUser];
SELECT * FROM [phoneMFee];
SELECT * FROM [cellphone], [SaleRecord] WHERE [cellphone].[Ptype] = [SaleRecord].[Ptype];
SELECT * FROM [BHall], [SaleRecord] WHERE [BHall].[Hno] = [SaleRecord].[Hno];
SELECT * FROM [cellUser] WHERE [pnumber] = '13723332333';
SELECT [pnumber], SUM([mtotal]), DATEPART(YEAR, [mdate]) AS [year], DATEPART(MONTH, [mdate]) AS [month] FROM [phoneMFee] GROUP BY [pnumber], DATEPART(YEAR, [mdate]), DATEPART(MONTH, [mdate]);
SELECT * FROM [cellUser], [phoneFeeHistory] WHERE [cellUser].[pnumber] = [phoneFeeHistory].[pnumber] AND [pbalance] < 0;
SETUSER;


SETUSER 'sales1';
SELECT * FROM [SaleRecord];
SELECT * FROM [cellUser];
SELECT * FROM [phoneMFee];
SELECT * FROM [cellphone], [SaleRecord] WHERE [cellphone].[Ptype] = [SaleRecord].[Ptype];
SELECT * FROM [BHall], [SaleRecord] WHERE [BHall].[Hno] = [SaleRecord].[Hno];
SELECT * FROM [cellUser] WHERE [pnumber] = '13723332333';
SELECT [pnumber], SUM([mtotal]), DATEPART(YEAR, [mdate]) AS [year], DATEPART(MONTH, [mdate]) AS [month] FROM [phoneMFee] GROUP BY [pnumber], DATEPART(YEAR, [mdate]), DATEPART(MONTH, [mdate]);
SELECT * FROM [cellUser], [phoneFeeHistory] WHERE [cellUser].[pnumber] = [phoneFeeHistory].[pnumber] AND [pbalance] < 0;
SETUSER;


SETUSER 'oper1';
SELECT * FROM [SaleRecord];
SELECT * FROM [cellUser];
SELECT * FROM [phoneMFee];
SELECT * FROM [cellphone], [SaleRecord] WHERE [cellphone].[Ptype] = [SaleRecord].[Ptype];
SELECT * FROM [BHall], [SaleRecord] WHERE [BHall].[Hno] = [SaleRecord].[Hno];
SELECT * FROM [cellUser] WHERE [pnumber] = '13723332333';
SELECT [pnumber], SUM([mtotal]), DATEPART(YEAR, [mdate]) AS [year], DATEPART(MONTH, [mdate]) AS [month] FROM [phoneMFee] GROUP BY [pnumber], DATEPART(YEAR, [mdate]), DATEPART(MONTH, [mdate]);
SELECT * FROM [cellUser], [phoneFeeHistory] WHERE [cellUser].[pnumber] = [phoneFeeHistory].[pnumber] AND [pbalance] < 0;
SETUSER;


SETUSER 'user1';
SELECT * FROM [SaleRecord];
SELECT * FROM [cellUser];
SELECT * FROM [phoneMFee];
SELECT * FROM [cellphone], [SaleRecord] WHERE [cellphone].[Ptype] = [SaleRecord].[Ptype];
SELECT * FROM [BHall], [SaleRecord] WHERE [BHall].[Hno] = [SaleRecord].[Hno];
SELECT * FROM [cellUser] WHERE [pnumber] = '13723332333';
SELECT [pnumber], SUM([mtotal]), DATEPART(YEAR, [mdate]) AS [year], DATEPART(MONTH, [mdate]) AS [month] FROM [phoneMFee] GROUP BY [pnumber], DATEPART(YEAR, [mdate]), DATEPART(MONTH, [mdate]);
SELECT * FROM [cellUser], [phoneFeeHistory] WHERE [cellUser].[pnumber] = [phoneFeeHistory].[pnumber] AND [pbalance] < 0;
SETUSER;


REVOKE INSERT
ON [BHall]
FROM [rolem] CASCADE;

SETUSER 'manager';
INSERT INTO [BHall] VALUES(2, 'Îä´ó', 2);
SETUSER;

SETUSER 'manager';
REVOKE SELECT
ON [SaleRecord]
FROM [roleu] CASCADE
AS [rolem];
SETUSER;

SETUSER 'user1';
SELECT * FROM [SaleRecord];
SETUSER;