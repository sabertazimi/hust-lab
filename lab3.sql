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

SELECT * FROM Flight;
SELECT * FROM Seat;
SELECT * FROM Ticket;
SELECT * FROM Ring;
SELECT * FROM Bill;

--DELETE FROM [Ticket];
--DELETE FROM [Ring];
--DELETE FROM [Bill];
--UPDATE [Seat]
--SET [Sstate] = 0
--WHERE [Fno] = 'BJGZ1' AND [Stype] = 'Ò»µÈ×ù' AND [Sstate] = 1;