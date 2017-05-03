IF EXISTS(SELECT * from sys.databases where name = 'ChinaMobile')
DROP DATABASE [ChinaMobile];
GO
CREATE DATABASE [ChinaMobile];
GO

USE [ChinaMobile];
GO

IF OBJECT_ID('SaleRecord', 'U') IS NOT NULL 
DROP TABLE [SaleRecord];
IF OBJECT_ID('BHall', 'U') IS NOT NULL 
DROP TABLE [BHall];
IF OBJECT_ID('cellphone', 'U') IS NOT NULL 
DROP TABLE [cellphone];
IF OBJECT_ID('phoneMFee', 'U') IS NOT NULL 
DROP TABLE [phoneMFee];
IF OBJECT_ID('phonePaid', 'U') IS NOT NULL 
DROP TABLE [phonePaid];
IF OBJECT_ID('phoneFeeHistory', 'U') IS NOT NULL 
DROP TABLE [phoneFeeHistory];
IF OBJECT_ID('cellUser', 'U') IS NOT NULL 
DROP TABLE [cellUser];

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
	[mtotal] INT,
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
	[pmonth] INT,
	[fee] INT,
	[type] INT,
	[pbalance] INT,
	FOREIGN KEY ([pnumber])
		REFERENCES [cellUser]([pnumber])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

USE [master]
GO
DROP LOGIN [manager]
DROP LOGIN [sales1]
DROP LOGIN [sales2]
DROP LOGIN [sales3]
DROP LOGIN [oper1]
DROP LOGIN [oper2]
DROP LOGIN [user1]
GO

USE [ChinaMobile]
GO

CREATE LOGIN [manager] WITH PASSWORD = '123456798';
CREATE USER [manager] FOR LOGIN [manager];
CREATE LOGIN [sales1] WITH PASSWORD = '123456798';
CREATE USER [sales1] FOR LOGIN [sales1];
CREATE LOGIN [sales2] WITH PASSWORD = '123456798';
CREATE USER [sales2] FOR LOGIN [sales2];
CREATE LOGIN [sales3] WITH PASSWORD = '123456798';
CREATE USER [sales3] FOR LOGIN [sales3];
CREATE LOGIN [oper1] WITH PASSWORD = '123456798';
CREATE USER [oper1] FOR LOGIN [oper1];
CREATE LOGIN [oper2] WITH PASSWORD = '123456798';
CREATE USER [oper2] FOR LOGIN [oper2];
CREATE LOGIN [user1] WITH PASSWORD = '123456798';
CREATE USER [user1] FOR LOGIN [user1];
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

--GRANT CREATE TRIGGER
--ON [ChinaMobile]
--TO [rolem]
--WITH GRANT OPTION;
GRANT DELETE, SELECT, UPDATE, REFERENCES
ON [BHall]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, REFERENCES
ON [cellphone]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, REFERENCES
ON [SaleRecord]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, REFERENCES
ON [cellUser]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, REFERENCES
ON [phoneMFee]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, REFERENCES
ON [phonePaid]
TO [rolem]
WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE, REFERENCES
ON [phoneFeeHistory]
TO [rolem]
WITH GRANT OPTION;
GO

GRANT INSERT, DELETE, SELECT, UPDATE
ON [BHall]
TO [role1];
GRANT INSERT, DELETE, SELECT, UPDATE
ON [cellphone]
TO [role1];
GRANT INSERT, DELETE, SELECT, UPDATE
ON [SaleRecord]
TO [role1];
GO

GRANT INSERT, SELECT, DELETE, UPDATE([username], [uid], [email])
ON [cellUser]
TO [role2];
GRANT INSERT, SELECT, DELETE, UPDATE([mdate], [mfee1], [mfee2], [mfee3], [mtotal])
ON [phoneMFee]
TO [role2];
GRANT INSERT, SELECT, DELETE, UPDATE([pdate], [paid])
ON [phonePaid]
TO [role2];
GRANT SELECT
ON [phoneFeeHistory]
TO [role2];
GO

GRANT SELECT
ON [cellphone]
TO [roleu];
GRANT SELECT
ON [cellUser]
TO [roleu];
GRANT SELECT
ON [phoneMFee]
TO [roleu];
GRANT SELECT
ON [phonePaid]
TO [roleu];
GRANT SELECT
ON [phoneFeeHistory]
TO [roleu];
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
SETUSER;


SETUSER 'user1';
SELECT * FROM [SaleRecord];
SELECT * FROM [cellUser];
SELECT * FROM [phoneMFee];
SELECT * FROM [cellphone], [SaleRecord] WHERE [cellphone].[Ptype] = [SaleRecord].[Ptype];
SELECT * FROM [BHall], [SaleRecord] WHERE [BHall].[Hno] = [SaleRecord].[Hno];
SELECT * FROM [cellUser] WHERE [pnumber] = '13723332333';
SELECT * FROM [phoneMFee];
SELECT * FROM [cellUser], [phoneFeeHistory] WHERE [pbalance] < 0;
SETUSER;

REVOKE INSERT
ON [BHall]
FROM [rolem];

SETUSER 'manager';
INSERT INTO [BHall] VALUES(2, 'Îä´ó', 2);
SETUSER;