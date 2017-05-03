USE [ChinaMobile];
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

--CREATE TRIGGER TableX_AfterInsert_TRG 
--ON TableX 
--AFTER INSERT
--AS
--BEGIN
--  UPDATE TableX AS t
--  SET t.newcolumn = t.oldcolumn
--  FROM Inserted AS i
--  WHERE t.PK = i.PK ; 
--END