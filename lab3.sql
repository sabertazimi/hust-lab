USE [master];
GO
IF EXISTS(SELECT * from sys.databases where name = 'AirTicketSystem')
DROP DATABASE [AirTicketSystem];
GO
CREATE DATABASE [AirTicketSystem];
GO

USE [AirTicketSystem];
GO

CREATE TABLE [Flight] (
	[Fno] VARCHAR(20) PRIMARY KEY,
	[Start] VARCHAR(10) NOT NULL,
	[End] VARCHAR(10) NOT NULL,
	[Ftime] DATETIME NOT NULL
);

CREATE TABLE [Seat] (
	[Fno] VARCHAR(20),
	[Sno] INT CHECK([Sno] > 0),
	[Stype] VARCHAR(10) NOT NULL,
	[Sprice] INT NOT NULL CHECK([Sprice] > 0),
	[Sstate] BIT NOT NULL,
	PRIMARY KEY ([Fno], [Sno]),
	FOREIGN KEY ([Fno])
		REFERENCES [Flight]([Fno])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE [Ticket] (
	[Tno] VARCHAR(20) PRIMARY KEY,
	[Fno] VARCHAR(20),
	[Sno] INT,
	[Vid] VARCHAR(20) NOT NULL,
	[Tstate] INT NOT NULL,
	[Ttime] DATETIME NOT NULL,
	FOREIGN KEY ([Fno], [Sno])
		REFERENCES [Seat]([Fno], [Sno])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE [Ring] (
	[Tno] VARCHAR(20) PRIMARY KEY,
	[Rtime] DATETIME NOT NULL,
	FOREIGN KEY ([Tno])
		REFERENCES [Ticket]([Tno])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE [Bill] (
	[Bno] VARCHAR(20) PRIMARY KEY,
	[Btype] INT,
	[Tno] VARCHAR(20),
	[Btime] DATETIME NOT NULL,
	FOREIGN KEY ([Tno])
		REFERENCES [Ticket]([Tno])
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

INSERT INTO [Flight] VALUES('BJSH1', 'Beijing', 'Shanghai', '2017-5-31 8:00:00');
INSERT INTO [Flight] VALUES('BJGZ1', 'Beijing', 'Guangzhou', '2017-5-31 12:00:00');
INSERT INTO [Flight] VALUES('BJSZ1', 'Beijing', 'Shenzhen', '2017-5-31 16:00:00');
INSERT INTO [Flight] VALUES('BJWH1', 'Beijing', 'Wuhan', '2017-5-31 20:00:00');

--GO
--CREATE TRIGGER phoneFeeHistory_AfterInsertphoneMFee_TRG 
--ON [phoneMFee]
--AFTER INSERT
--AS
--BEGIN
--  IF EXISTS (SELECT i.[pnumber] FROM [phoneFeeHistory], Inserted AS i)
--  BEGIN
--    INSERT INTO [phoneFeeHistory]
--	SELECT TOP 1 [pnumber], [pmonth], [fee], [type], [pbalance]
--	FROM (
--	  SELECT i.[pnumber] AS [pnumber], [phoneFeeHistory].[pmonth] AS [oldMonth], i.[mdate] AS [pmonth], (i.[mfee1] + i.[mfee2] + i.[mfee3]) AS [fee], 0 AS [type], ([phoneFeeHistory].[pbalance] - i.[mfee1]- i.[mfee2] - i.[mfee3]) AS [pbalance]
--	  FROM [phoneFeeHistory], Inserted AS i
--	  WHERE [phoneFeeHistory].[pnumber] = i.[pnumber]
--    ) AS [newHistory]
--    ORDER BY [pmonth] DESC, [oldMonth] DESC;
--  END ELSE
--  BEGIN
--	INSERT INTO [phoneFeeHistory]
--	SELECT *
--	FROM (
--	  SELECT i.[pnumber] AS [pnumber], i.[mdate] AS [pmonth], (i.[mfee1] + i.[mfee2] + i.[mfee3]) AS [fee], 0 AS [type], (-i.[mfee1] - i.[mfee2] - i.[mfee3]) AS [pbalance]
--	  FROM Inserted AS i
--    ) AS [newHistory]
--  END
--END
--GO

--GO
--CREATE TRIGGER phoneFeeHistory_AfterInsertphonePaid_TRG 
--ON [phonePaid]
--AFTER INSERT
--AS
--BEGIN
--  IF EXISTS (SELECT i.[pnumber] FROM [phoneFeeHistory], inserted AS i)
--  BEGIN
--    INSERT INTO [phoneFeeHistory]
--	SELECT TOP 1 [pnumber], [pmonth], [fee], [type], [pbalance]
--	FROM (
--	  SELECT i.[pnumber] AS [pnumber], [phoneFeeHistory].[pmonth] AS [oldMonth], i.[pdate] AS [pmonth], i.[paid] AS [fee], 1 AS [type], ([phoneFeeHistory].[pbalance] + i.[paid]) AS [pbalance]
--	  FROM [phoneFeeHistory], Inserted AS i
--	  WHERE [phoneFeeHistory].[pnumber] = i.[pnumber]
--    ) AS [newHistory]
--    ORDER BY [pmonth] DESC, [oldMonth] DESC;
--  END ELSE
--  BEGIN
--	INSERT INTO [phoneFeeHistory]
--	SELECT *
--	FROM (
--	  SELECT i.[pnumber] AS [pnumber], i.[pdate] AS [pmonth], i.[paid] AS [fee], 1 AS [type], i.[paid] AS [pbalance]
--	  FROM Inserted AS i
--    ) AS [newHistory]
--  END
--END
--GO