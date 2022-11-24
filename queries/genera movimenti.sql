DECLARE @fromDate DATETIME = '2020-01-01'
DECLARE @toDate   DATETIME =  '2021-31-12'

DECLARE @seconds INT;
DECLARE @random INT;
DECLARE @duration INT;
DECLARE @milliseconds INT;

DECLARE @values INT;
DECLARE @i INT;

SET @values = 100000;
SET @i = 0;

TRUNCATE TABLE movimenti;

WHILE @i < @values
BEGIN
	SET @seconds = DATEDIFF(SECOND, @fromDate, @toDate)
	SET @random = ROUND(((@seconds-1) * RAND()), 0)
	SET @duration = (ROUND((5*60* RAND()), 0) + 10) * 1000 --durata casuale fra 10 secondi e 5 minuti
	SET @milliseconds = ROUND((999 * RAND()), 0)

	INSERT INTO movimenti(mezzo, articolo, daPosizione, aPosizione, inizio, fine)
	VALUES (
	(SELECT TOP 1 ID FROM mezzi ORDER BY NEWID()) --mezzo casuale
	, (SELECT TOP 1 ID FROM articoli ORDER BY NEWID()) --articolo casuale
	, (SELECT TOP 1 ID FROM posizioni ORDER BY NEWID()) --da posizione casuale
	, (SELECT TOP 1 ID FROM posizioni ORDER BY NEWID()) --a posizione casuale
	, (SELECT DATEADD(MILLISECOND, @milliseconds, DATEADD(SECOND, @random, @fromDate))) --datestamp inizio casuale
	, (SELECT DATEADD(MILLISECOND, @milliseconds + @duration, DATEADD(SECOND, @random, @fromDate))) --datestamp fine casuale
	)
	;
	SET @i = @i+ 1
END

--aggiorno gli articoli nelle posizioni impostando il valore del campo articolo
--all'ultimo movimento di ogni articolo presente nella tabella movimenti
UPDATE posizioni
SET articolo = drvTbl.articolo
FROM (
	SELECT articolo, aPosizione, MAX(fine) AS massimo
	FROM movimenti
	GROUP BY articolo, aPosizione
	) drvTbl
INNER JOIN posizioni ON posizioni.id = drvTbl.aPosizione
