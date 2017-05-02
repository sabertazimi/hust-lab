IF EXISTS(SELECT * from sys.databases where name = 'ChinaMobile')
DROP DATABASE [ChinaMobile];
GO
CREATE DATABASE [ChinaMobile];
GO

USE [ChinaMobile];
GO

IF OBJECT_ID('BHall', 'U') IS NOT NULL 
DROP TABLE [BHall];
IF OBJECT_ID('SaleRecord', 'U') IS NOT NULL 
DROP TABLE [SaleRecord];
IF OBJECT_ID('cellphone', 'U') IS NOT NULL 
DROP TABLE [cellphone];
IF OBJECT_ID('cellUser', 'U') IS NOT NULL 
DROP TABLE [cellUser];
IF OBJECT_ID('phoneMFee', 'U') IS NOT NULL 
DROP TABLE [phoneMFee];
IF OBJECT_ID('phonePaid', 'U') IS NOT NULL 
DROP TABLE [phonePaid];
IF OBJECT_ID('phoneFeeHistory', 'U') IS NOT NULL 
DROP TABLE [phoneFeeHistory];

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


SETUSER 'Manager';

CREATE TABLE [Manager] (
	id INT PRIMARY KEY
);

SETUSER;
-- CREATE TABLE (


--CREATE USER [Manager];
--GO
--CREATE ROLE [rolem];
--GRANT ALL ON 

--SETUSER 'mary';  
--GO  
--GRANT SELECT ON computer_types TO joe;  
--GO  
----To revert to the original user  
--SETUSER;