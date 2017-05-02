CREATE TRIGGER TableX_AfterInsert_TRG 
ON TableX 
AFTER INSERT
AS
BEGIN
  UPDATE TableX AS t
  SET t.newcolumn = t.oldcolumn
  FROM Inserted AS i
  WHERE t.PK = i.PK ; 
END