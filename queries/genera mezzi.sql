DECLARE @values INT;
DECLARE @i INT;

SET @values = 50;
SET @i = 0;

TRUNCATE TABLE mezzi;

WHILE @i < @values
BEGIN
	INSERT INTO mezzi(nome, tipo)
	VALUES (
	(SELECT LEFT (CAST (NEWID () AS NVARCHAR(MAX)) , 10)) --nome casuale
	, (SELECT TOP 1 ID FROM tipi_mezzo ORDER BY NEWID()) --tipo casuale
	)
	;
	SET @i = @i+ 1
END
