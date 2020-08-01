--1
/*
a) Kreirati bazu podataka pod vlastitim brojem indeksa.

--Prilikom kreiranja tabela voditi racuna o medjusobnom odnosu izmedju tabela.

b) Kreirati tabelu radnik koja ce imati sljedecu strukturu:
	-radnikID, cjelobrojna varijabla, primarni kljuc
	-drzavaID, 15 unicode karaktera
	-loginID, 256 unicode karaktera
	-god_rod, cjelobrojna varijabla
	-spol, 1 unicode karakter


c) Kreirati tabelu nabavka koja ce imati sljedecu strukturu:
	-nabavkaID, cjelobrojna varijabla, primarni kljuc
	-status, cjelobrojna varijabla
	-radnikID, cjelobrojna varijabla
	-br_racuna, 15 unicode karaktera
	-naziv_dobavljaca, 50 unicode karaktera
	-kred_rejting, cjelobrojna varijabla

c) Kreirati tabelu prodaja koja ce imati sljedecu strukturu:
	-prodajaID, cjelobrojna varijabla, primarni kljuc, inkrementalno punjenje sa pocetnom vrijednoscu 1, samo neparni brojevi
	-prodavacID, cjelobrojna varijabla
	-dtm_isporuke, datumsko-vremenska varijabla
	-vrij_poreza, novcana varijabla
	-ukup_vrij, novcana varijabla
	-online_narudzba, bit varijabla sa ogranicenjem kojim se mogu unijeti samo cifre 0 i 1
*/
--a
CREATE DATABASE BP2_2020_07_24;
USE BP2_2020_07_24;

--b
CREATE TABLE radnik
(
	radnikID INT CONSTRAINT PK_radnik PRIMARY KEY,
	drzavaID NVARCHAR(15),
	loginID NVARCHAR(256),
	god_rod INT,
	spol NVARCHAR(1)
);

--c
CREATE TABLE nabavka
(
	nabavkaID INT CONSTRAINT PK_nabavka PRIMARY KEY,
	status INT,
	radnikID INT CONSTRAINT FK_radnik_nabavka FOREIGN KEY REFERENCES radnik (radnikID),
	br_racuna NVARCHAR(15),
	naziv_dobavljaca NVARCHAR(50),
	kred_rejting INT
);
--d
CREATE TABLE prodaja
(
	prodajaID INT CONSTRAINT PK_prodaja PRIMARY KEY IDENTITY(1, 2),
	prodavacID INT CONSTRAINT FK_radnik_prodaja FOREIGN KEY REFERENCES radnik (radnikID),
	dtm_isporuke DATETIME,
	vrij_poreza MONEY,
	ukup_vrij MONEY,
	online_narudzba BIT
);
/*
--2
Import podataka

a) Iz tabele Employee iz šeme HumanResources baze AdventureWorks2017 u tabelu radnik importovati podatke po sljedecem pravilu:
	-BusinessEntityID -> radnikID
	-NationalIDNumber -> drzavaID
	-LoginID -> loginID
	-godina iz kolone BirthDate -> god_rod
	-Gender -> spol

b) Iz tabela PurchaseOrderHeader i Vendor šeme Purchasing baze AdventureWorks2017 u tabelu nabavka importovati podatke po sljedecem pravilu:
	-PurchaseOrderID -> dobavljanjeID
	-Status -> status
	-EmployeeID -> radnikID
	-AccountNumber -> br_racuna
	-Name -> naziv_dobavljaca
	-CreditRating -> kred_rejting

c) Iz tabele SalesOrderHeader šeme Sales baze AdventureWorks2017 u tabelu prodaja importovati podatke po sljedecem pravilu:
	-SalesPersonID -> prodavacID
	-ShipDate -> dtm_isporuke
	-TaxAmt -> vrij_poreza
	-TotalDue -> ukup_vrij
	-OnlineOrderFlag -> online_narudzba
*/
--a
INSERT INTO radnik
SELECT 
	E.BusinessEntityID,
	E.NationalIDNumber,
	E.LoginID,
	YEAR(E.BirthDate),
	E.Gender
FROM AdventureWorks2017.HumanResources.Employee as E

--b
INSERT INTO nabavka
SELECT 
	POH.PurchaseOrderID,
	POH.Status,
	POH.EmployeeID,
	V.AccountNumber,
	V.Name,
	V.CreditRating
FROM AdventureWorks2017.Purchasing.PurchaseOrderHeader AS POH
	INNER JOIN AdventureWorks2017.Purchasing.Vendor AS V ON V.BusinessEntityID = POH.VendorID

--c
INSERT INTO prodaja (prodavacID, dtm_isporuke, vrij_poreza, ukup_vrij, online_narudzba)
SELECT 
	SOH.SalesPersonID,
	SOH.ShipDate,
	SOH.TaxAmt,
	SOH.TotalDue,
	SOH.OnlineOrderFlag
FROM AdventureWorks2017.Sales.SalesOrderHeader AS SOH

/*
--3
a) U tabelu radnik dodati kolonu st_kat (starosna kategorija), tipa 3 karaktera.

b) Prethodno kreiranu kolonu popuniti po principu:
	starosna kategorija			uslov
	I							osobe do 30 godina starosti (ukljucuje se i 30)
	II							osobe od 31 do 49 godina starosti
	III							osobe preko 50 godina starosti

c) Neka osoba sa navrsenih 65 godina odlazi u penziju.
Prebrojati koliko radnika ima 10 ili manje godina do penzije.
Rezultat upita iskljucivo treba biti poruka:
'Broj radnika koji imaju 10 ili manje godina do penzije je' nakon cega slijedi prebrojani broj.
Nece se priznati rjesenje koje kao rezultat upita vraca vise kolona.
*/
--a
ALTER TABLE radnik
ADD st_kat NVARCHAR(3)
GO

--b
UPDATE radnik
SET st_kat = 
	CASE
		WHEN YEAR(CURRENT_TIMESTAMP) - god_rod <= 30 THEN 'I'
		WHEN YEAR(CURRENT_TIMESTAMP) - god_rod BETWEEN 31 AND 49 THEN 'II'
		WHEN YEAR(CURRENT_TIMESTAMP) - god_rod >= 50 THEN 'III'
	END;

SELECT * FROM radnik;

--c
SELECT 'Broj radnika koji imaju 10 ili manje godina do penzije je ' + CONVERT(NVARCHAR, COUNT(*))
FROM radnik
WHERE 65 - (YEAR(CURRENT_TIMESTAMP) - god_rod) BETWEEN 1 AND 10;
/*
--4
a) U tabeli prodaja kreirati kolonu stopa_poreza (10 unicode karaktera)

b) Prethodno kreiranu kolonu popuniti kao kolicnik vrij_poreza i ukup_vrij.
Stopu poreza izraziti kao cijeli broj s oznakom %, pri cemu je potrebno da izmedju brojcane vrijednosti i znaka % bude prazno mjesto.
(Npr: 14.00 %)
*/
--a
ALTER TABLE prodaja
ADD stopa_poreza NVARCHAR(10)

--b
UPDATE prodaja
SET stopa_poreza = CONVERT(NVARCHAR, vrij_poreza / ukup_vrij * 100) + ' %';

SELECT * FROM prodaja;
GO;
/*
--5
a) Koristeci tabelu nabavka kreirati pogled view_slova sljedece strukture:
	-slova
	-prebrojano, prebrojani broj pojavljivanja slovnih dijelova podatka u koloni br_racuna.

b) Koristeci pogled view_slova odrediti razliku vrijednosti izmedju prebrojanih i srednje vrijednosti kolone.
Rezultat treba da sadrzi kolone slova, prebrojano i razliku.
Sortirati u rastucem redoslijedu prema razlici.
*/

--a
CREATE VIEW view_slova
AS
	SELECT SUBSTRING(br_racuna, 0, LEN(br_racuna) - 3) AS slova, COUNT(*) AS prebrojano
	FROM nabavka
	GROUP BY SUBSTRING(br_racuna, 0, LEN(br_racuna) - 3)

SELECT * FROM view_slova

--b
SELECT 
	slova,
	prebrojano,
	prebrojano - (SELECT AVG(prebrojano) FROM  view_slova) AS razlika
FROM view_slova
ORDER BY razlika


/*
--6
a) Koristeci tabelu prodaja kreirati pogled view_stopa sljedece strukture:
	-prodajaID
	-stopa_poreza
	-stopa_num, u kojoj ce biti numericka vrijednost stope poreza

b) Koristeci pogled view_stopa, a na osnovu razlike izmedju vrijednosti u koloni stopa_num i srednje vrijednosti stopa poreza
za svaki proizvodID navesti poruku 'manji', odnosno, 'veci'.
*/
--a
CREATE VIEW view_stopa
AS
	SELECT 
		prodajaID,
		stopa_poreza,
		CONVERT(FLOAT, SUBSTRING(stopa_poreza, 0, LEN(stopa_poreza) - 1)) AS stopa_num
	FROM prodaja

--b
SELECT *,
	CASE
		WHEN stopa_num > (SELECT AVG(stopa_num) FROM view_stopa) THEN 'veci'
		WHEN stopa_num < (SELECT AVG(stopa_num) FROM view_stopa) THEN 'manji'
	END
FROM view_stopa
GO;
/*
--7 
Koristeci pogled view_stopa_poreza kreirati proceduru proc_stopa_poreza tako da je prilikom izvrsavanja moguce unijeti bilo koji broj
parametara (mozemo ostaviti bilo koji parametar bez unijete vrijednosti), pri cemu ce se prebrojati broj zapisa po stopi poreza uz 
uslov da se dohvate samo oni zapisi u kojima je stopa poreza veca od 10%.
Proceduru pokrenuti za sljedece vrijednosti:
	-stopa poreza = 12, 15 i 21
*/
CREATE PROCEDURE proc_stopa_poreza
(
	@prodajaID INT = NULL,
	@stopa_poreza NVARCHAR(10) = NULL,
	@stopa_num FLOAT = NULL
)
AS
BEGIN
	SELECT COUNT(*)
	FROM view_stopa
	WHERE 
		prodajaID = @prodajaID OR
		stopa_poreza = @stopa_poreza OR
		stopa_num = @stopa_num AND stopa_num > 10
END

EXEC proc_stopa_poreza 12
EXEC proc_stopa_poreza 15
EXEC proc_stopa_poreza 21
GO;
/*
--8
Kreirati proceduru proc_prodaja kojom ce se izvrsiti promjena vrijednosti u koloni online_narudzba tabele prodaja.
Promjena ce se vrsiti tako sto ce se 0 zamijeniti sa NO, a 1 sa YES.
Pokrenuti proceduru kako bi se izvrsile promjene, a nakon toga onemoguciti da se u koloni unosi bilo kakva druga vrijednost osim NO ili
YES.
*/
CREATE PROCEDURE proc_prodaja
AS
BEGIN
	ALTER TABLE prodaja
	ALTER COLUMN online_narudzba NVARCHAR(3)

	UPDATE prodaja
	SET online_narudzba =
		CASE
			WHEN online_narudzba = 1 THEN 'YES'
			WHEN online_narudzba = 0 THEN 'NO'
		END

	ALTER TABLE prodaja
	ADD CONSTRAINT online_narudzba_value_check CHECK (online_narudzba = 'YES' OR online_narudzba = 'NO')
END

EXEC proc_prodaja
SELECT * FROM prodaja

/* Provjera online_narudzba_value_check CONSTRAINTA */
UPDATE prodaja 
SET online_narudzba =
	CASE
		WHEN online_narudzba = 'YES' THEN '1'
		WHEN online_narudzba = 'NO'  THEN '0'
	END 

/*
--9
a) Nad kolonom god_rod tabele radnik kreirati ogranicenje kojim ce se onemoguciti unos bilo koje godine iz buducnosti kao godina rodjenja.
Testirati funkcionalnost kreiranog ogranicenja navodjenjem koda za insert podataka kojim ce se kao godina rodjenja pokusati unijeti
bilo koja godina iz buducnosti.

b) Nad kolonom drzavaID tabele radnik kreirati ogranicenje kojim ce se ograniciti duzina podatka na 7 znakova.
Ako je prethodno potrebno, izvrsiti prilagodbu kolone, pri cemu nije dozvoljeno prilagodjavati podatke cija duzina iznosi 7 ili manje znakova.
Testirati funkcionalnost kreiranog ogranicenja navodjenjem koda za insert podataka kojim ce se u drzavaID pokusati unijeti podatak duzi 
od 7 znakova bilo koja godina iz buducnosti.
*/
--a
ALTER TABLE radnik
ADD CONSTRAINT god_buducnosti_check CHECK (god_rod < CONVERT(INT, YEAR(CURRENT_TIMESTAMP)))

INSERT INTO radnik
VALUES (20000, 'A', 'A', 2500, 'M', 'I');

--b
UPDATE radnik
SET drzavaID = LEFT(drzavaID, 7)
WHERE LEN(drzavaID) > 7

ALTER TABLE radnik
ADD CONSTRAINT drzavaID_duzina_check CHECK (LEN(drzavaID) <= 7)

INSERT INTO radnik
VALUES (20000, '12345678', 'A', 1980, 'M', 'I');

/*
--10
Kreirati backup baze na default lokaciju, obrisati bazu a zatim izvrsiti restore baze. 
Uslov prihvatanja koda je da se moze izvrsiti.
*/
BACKUP DATABASE BP2_2020_07_24
TO DISK = 'BP2_2020_07_24.bak'
GO

USE master
DROP DATABASE BP2_2020_07_24

RESTORE DATABASE BP2_2020_07_24 FROM DISK = 'BP2_2020_07_24.bak'
USE BP2_2020_07_24