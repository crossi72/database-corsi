DECLARE @values INT;
DECLARE @i INT;

SET @values = 10000;
SET @i = 0;

TRUNCATE TABLE posizioni;

WHILE @i < @values
BEGIN
	INSERT INTO posizioni(magazzino, corsia, scaffale, posizione, articolo)
	VALUES (
	(SELECT TOP 1 ID FROM magazzini ORDER BY NEWID()) --magazzino casuale
	, CONVERT(INT, RAND() * 20 + 1) --corsia fra 1 e 20
	, CONVERT(INT, RAND() * 50 + 1) --scaffale fra 1 e 50
	, CONVERT(INT, RAND() * 100 + 1) --posizione fra 1 e 100
	, (SELECT TOP 1 ID FROM articoli ORDER BY NEWID()) --articolo casuale
	)
	;
	SET @i = @i+ 1
END
