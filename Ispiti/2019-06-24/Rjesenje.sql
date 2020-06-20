----------------------------------------------------------------1.
/*
Koristeći isključivo SQL kod, kreirati bazu pod vlastitim brojem indeksa sa defaultnim postavkama.
*/
CREATE DATABASE BP2_2019_06_24
USE BP2_2019_06_24

/*
Unutar svoje baze podataka kreirati tabele sa sljedećom struktorom:
--NARUDZBA
a) Narudzba
NarudzbaID, primarni ključ
Kupac, 40 UNICODE karaktera
PunaAdresa, 80 UNICODE karaktera
DatumNarudzbe, datumska varijabla, definirati kao datum
Prevoz, novčana varijabla
Uposlenik, 40 UNICODE karaktera
GradUposlenika, 30 UNICODE karaktera
DatumZaposlenja, datumska varijabla, definirati kao datum
BrGodStaza, cjelobrojna varijabla
*/
CREATE TABLE Narudzba
(
	NarudzbaID INT,
	Kupac NVARCHAR (40),
	PunaAdresa NVARCHAR (80),
	DatumNarudzbe DATE,
	Prevoz MONEY, 
	Uposlenik NVARCHAR (40), 
	GradUposlenika NVARCHAR (30), 
	DatumZaposlenja DATE,
	BrGodStaza INT,
	CONSTRAINT PK_Narudzba PRIMARY KEY (NarudzbaID)
);
GO

--PROIZVOD
/*
b) Proizvod
ProizvodID, cjelobrojna varijabla, primarni ključ
NazivProizvoda, 40 UNICODE karaktera
NazivDobavljaca, 40 UNICODE karaktera
StanjeNaSklad, cjelobrojna varijabla
NarucenaKol, cjelobrojna varijabla
*/
CREATE TABLE Proizvod
(
	ProizvodID INT,
	NazivProizvoda NVARCHAR (40),
	NazivDobavljaca NVARCHAR (40),
	StanjeNaSklad INT,
	NarucenaKol INT,
	CONSTRAINT PK_ProizvodID PRIMARY KEY (ProizvodID)
);
GO

--DETALJINARUDZBE
/*
c) DetaljiNarudzbe
NarudzbaID, cjelobrojna varijabla, obavezan unos
ProizvodID, cjelobrojna varijabla, obavezan unos
CijenaProizvoda, novčana varijabla
Kolicina, cjelobrojna varijabla, obavezan unos
Popust, varijabla za realne vrijednosti
Napomena: Na jednoj narudžbi se nalazi jedan ili više proizvoda.
*/
CREATE TABLE DetaljiNarudzbe
(
	NarudzbaID INT not null,
	ProizvodID INT not null,
	CijenaProizvoda MONEY,
	Kolicina INT not null,
	Popust REAL,
	CONSTRAINT FK_Detalji_Narudzba FOREIGN KEY (NarudzbaID) REFERENCES Narudzba (NarudzbaID),
	CONSTRAINT FK_Detalji_Proizvod FOREIGN KEY (ProizvodID) REFERENCES Proizvod (ProizvodID),
	CONSTRAINT PK_DetaljiNarudzbe PRIMARY KEY (NarudzbaID, ProizvodID)
);
GO


----------------------------------------------------------------2.
--2a) narudzbe
/*
Koristeći bazu Northwind iz tabela Orders, Customers i Employees importovati podatke po sljedećem pravilu:
OrderID -> ProizvodID
ComapnyName -> Kupac
PunaAdresa - spojeno adresa, poštanski broj i grad, pri čemu će se između riječi staviti srednja crta sa razmakom prije i poslije nje
OrderDate -> DatumNarudzbe
Freight -> Prevoz
Uposlenik - spojeno prezime i ime sa razmakom između njih
City -> Grad iz kojeg je uposlenik
HireDate -> DatumZaposlenja
BrGodStaza - broj godina od datum zaposlenja
*/
INSERT INTO Narudzba 
SELECT 
	O.OrderID, 
	C.CompanyName, 
	C.Address + ' - ' + C.PostalCode + ' - ' + C.City,
	O.OrderDate,
	O.Freight, 
	E.LastName + ' ' + E.FirstName, 
	E.City, 
	E.HireDate, 
	DATEDIFF (YEAR, E.HireDate, GETDATE ()) 
FROM Northwind.dbo.Customers AS C 
	INNER JOIN Northwind.dbo.Orders AS O ON C.CustomerID = O.CustomerID 
	INNER JOIN Northwind.dbo.Employees AS E ON O.EmployeeID = E.EmployeeID


SELECT * FROM Narudzba

--proizvod
/*
Koristeći bazu Northwind iz tabela Products i Suppliers putem podupita importovati podatke po sljedećem pravilu:
ProductID -> ProizvodID
ProductName -> NazivProizvoda 
CompanyName -> NazivDobavljaca 
UnitsInStock -> StanjeNaSklad 
UnitsOnOrder -> NarucenaKol 
*/
INSERT INTO Proizvod
SELECT 
	P.ProductID, 
	P.ProductName, 
	( 
	  SELECT S.ComapanyName 
	  FROM Northwind.dbo.Suppliers AS S 
	  WHERE S.SupplierID = P.SupplierID 
	),
	P.UnitsInStock, 
	P.UnitsOnOrder
FROM Northwind.dbo.Products AS P 
WHERE P.SupplierID IN (SELECT S.SupplierID FROM Northwind.dbo.Suppliers AS S)


--detaljinarudzbe
/*
Koristeći bazu Northwind iz tabele Order Details importovati podatke po sljedećem pravilu:
OrderID -> NarudzbaID
ProductID -> ProizvodID
CijenaProizvoda - manja zaokružena vrijednost kolone UnitPrice, npr. UnitPrice = 3,60 CijenaProizvoda = 3,00
*/
INSERT INTO DetaljiNarudzbe
SELECT 
	OD.OrderID, 
	OD.ProductID, 
	FLOOR (OD.UnitPrice),
	OD.Quantity, 
	OD.Discount
FROM Northwind.dbo.[Order Details] AS OD 
	INNER JOIN Northwind.dbo.Products AS P ON OD.ProductID = P.ProductID



----------------------------------------------------------------3.
--3a
/*
U tabelu Narudzba dodati kolonu SifraUposlenika kao 20 UNICODE karaktera. 
Postaviti uslov da podatak mora biti dužine tačno 15 karaktera.
*/
--DODAVANJE I POPUNJAVANJE KOLONE SifraUposlenika U NARUDZBA
ALTER TABLE Narudzba
ADD SifraUposlenika NVARCHAR (20) CONSTRAINT CK_Sifra CHECK (LEN (SifraUposlenika) = 15)



--3b
/*
Kolonu SifraUposlenika popuniti na način da se obrne string koji se dobije spajanjem grada uposlenika i prvih 10 karaktera datuma 
zaposlenja pri čemu se između grada i 10 karaktera nalazi jedno prazno mjesto. Provjeriti da li je izvršena izmjena.
*/
UPDATE Narudzba
SET SifraUposlenika = LEFT (REVERSE (GradUposlenika + ' ' + CONVERT (NVARCHAR (10), DatumZaposlenja)), 15)

SELECT * FROM Narudzba


--3c
/*
U tabeli Narudzba u koloni SifraUposlenika izvršiti zamjenu svih zapisa kojima grad uposlenika završava slovom "d" tako da se umjesto toga
 ubaci slučajno generisani string dužine 20 karaktera. Provjeriti da li je izvršena zamjena.
*/
--BRISANJE OGRANICENJA NA SifraUposlenika
ALTER TABLE Narudzba
DROP CONSTRAINT CK_Sifra


--ZAMJENA SVIH VRIJEDNOSTI SifraUposlenika KOJIMA NAZIV GRADA ZAVRŠAVA SLOVOM D
UPDATE Narudzba
SET SifraUposlenika = LEFT (NEWID(), 20)
WHERE RIGHT (GradUposlenika, 1) LIKE ('%d')


SELECT * FROM Narudzba


----------------------------------------------------------------4.
/*
Koristeći svoju bazu iz tabela Narudzba i DetaljiNarudzbe kreirati pogled koji će imati sljedeću strukturu: Uposlenik, SifraUposlenika, 
ukupan broj proizvoda izveden iz NazivProizvoda, uz uslove da je dužina sifre uposlenika 20 karaktera, 
te da je ukupan broj proizvoda veći od 2. Provjeriti sadržaj pogleda, pri čemu se treba izvršiti sortiranje po 
ukupnom broju proizvoda u opadajućem redoslijedu.*/
CREATE VIEW view_SifraUposlenika AS
SELECT 
	N.Uposlenik, 
	N.SifraUposlenika, 
	COUNT (P.NazivProizvoda) AS UkupnoProdatihProizvoda
FROM Narudzba AS N 
	INNER JOIN DetaljiNarudzbe AS DN ON DN.NarudzbaID = N.NarudzbaID
	INNER JOIN Proizvod AS P ON DN.ProizvodID = P.ProizvodID
WHERE LEN (N.SifraUposlenika) = 20
GROUP BY N.Uposlenik, N.SifraUposlenika
HAVING COUNT (P.NazivProizvoda) > 2

SELECT * FROM view_SifraUposlenika
ORDER BY UkupnoProdatihProizvoda DESC



----------------------------------------------------------------5. 
/*
Koristeći vlastitu bazu kreirati proceduru nad tabelom Narudzbe kojom će se dužina podatka u koloni SifraUposlenika smanjiti sa 20 na 4 
slučajno generisana karaktera. Pokrenuti proceduru. */
CREATE PROCEDURE sifra_Narudzbe AS
BEGIN 
	UPDATE Narudzba
	SET SifraUposlenika = LEFT (NEWID (), 4)
	WHERE LEN (SifraUposlenika) = 20
END

EXEC sifra_Narudzbe


----------------------------------------------------------------6.
/*
Koristeći vlastitu bazu podataka kreirati pogled koji će imati sljedeću strukturu: NazivProizvoda, 
Ukupno - ukupnu sumu prodaje proizvoda uz uzimanje u obzir i popusta. Suma mora biti zakružena na dvije decimale. 
U pogled uvrstiti one proizvode koji su naručeni, uz uslov da je suma veća od 10000. 
Provjeriti sadržaj pogleda pri čemu ispis treba sortirati u opadajućem redoslijedu po vrijednosti sume.
*/
CREATE VIEW view_Ukupno AS
SELECT	
	P.NazivProizvoda, 
	ROUND (SUM (DN.CijenaProizvoda * DN.Kolicina * (1- DN.Popust)), 2) AS Ukupno
FROM DetaljiNarudzbe AS DN 
	INNER JOIN Proizvod AS P ON DN.ProizvodID = P.ProizvodID
WHERE P.NarucenaKol > 0
GROUP BY P.NazivProizvoda
HAVING ROUND (SUM (DN.CijenaProizvoda * DN.Kolicina * (1- DN.Popust)), 2) > 10000

SELECT * FROM view_Ukupno
ORDER BY Ukupno DESC



----------------------------------------------------------------7.
--7a
/*
Koristeći vlastitu bazu podataka kreirati pogled koji će imati sljedeću strukturu: Kupac, NazivProizvoda, 
suma po cijeni proizvoda pri čemu će se u pogled smjestiti samo oni zapisi kod kojih je cijena proizvoda veća od srednje vrijednosti 
cijene proizvoda. Provjeriti sadržaj pogleda pri čemu izlaz treba sortirati u rastućem redoslijedu izračunatoj sumi.
*/
CREATE VIEW view_sr_vrij_cijene AS
SELECT
	N.Kupac, 
	P.NazivProizvoda, 
	SUM (DN.CijenaProizvoda) AS SumaPoCijeni
FROM DetaljiNarudzbe AS DN 
	INNER JOIN Narudzba AS N ON DN.NarudzbaID = N.NarudzbaID 
	INNER JOIN Proizvod AS P ON DN.ProizvodID = P.ProizvodID
WHERE DN.CijenaProizvoda > (SELECT AVG (CijenaProizvoda) FROM DetaljiNarudzbe)
GROUP BY N.Kupac, P.NazivProizvoda

SELECT * FROM view_sr_vrij_cijene
ORDER BY SumaPoCijeni


--7b
/*
Koristeći vlastitu bazu podataka kreirati proceduru kojom će se, koristeći prethodno kreirani pogled, definirati parametri: kupac, 
NazivProizvoda i SumaPoCijeni. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara 
(možemo ostaviti bilo koji parametar bez unijete vrijednosti), uz uslov da vrijednost sume bude veća od srednje vrijednosti suma 
koje su smještene u pogled. Sortirati po sumi cijene. Procedura se treba izvršiti ako se unese vrijednost za bilo koji parametar.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. SumaPoCijeni = 123
2. Kupac = Hanari Carnes
3. NazivProizvoda = Côte de Blaye
*/
CREATE PROCEDURE sp_sr_vrij_cijene 
(
	@Kupac NVARCHAR (40) = NULL,
	@NazivProizvoda NVARCHAR (40) = NULL,
	@SumaPoCijeni MONEY = NULL
)
AS
BEGIN
	SELECT 
		Kupac,
		NazivProizvoda, 
		SumaPoCijeni 
	FROM view_sr_vrij_cijene
	WHERE SumaPoCijeni > (SELECT AVG (SumaPoCijeni) FROM view_sr_vrij_cijene) AND 
		  Kupac = @Kupac OR
		  NazivProizvoda = @NazivProizvoda OR
		  SumaPoCijeni = @SumaPoCijeni
	ORDER BY SumaPoCijeni
END

EXEC sp_sr_vrij_cijene @SumaPoCijeni = 123

EXEC sp_sr_vrij_cijene @Kupac = 'Hanari Carnes'

EXEC sp_sr_vrij_cijene @NazivProizvoda = 'Côte de Blaye'


----------------------------------------------------------------8.
/*
a) Kreirati indeks nad tabelom Proizvod. Potrebno je indeksirati NazivDobavljaca. Uključiti i kolone StanjeNaSklad i NarucenaKol. 
Napisati proizvoljni upit nad tabelom Proizvod koji u potpunosti koristi prednosti kreiranog indeksa.*/
--a
CREATE NONCLUSTERED INDEX IX_StanjeNaSklad ON Proizvod
(
	NazivDobavljaca ASC
)
INCLUDE (StanjeNaSklad, NarucenaKol)

SELECT * FROM Proizvod
WHERE NazivDobavljaca = 'Pavlova, Ltd.' AND StanjeNaSklad > 10 AND NarucenaKol < 10

/*b) Uraditi disable indeksa iz prethodnog koraka.*/
ALTER INDEX [IX_StanjeNaSklad] 
ON Proizvod
DISABLE

----------------------------------------------------------------9.
/*Napraviti backup baze podataka na default lokaciju servera.*/

BACKUP DATABASE BP2_2019_06_24 
TO DISK = 'BP2_2019_06_24.bak'


----------------------------------------------------------------10.
/*Kreirati proceduru kojom će se u jednom pokretanju izvršiti brisanje svih pogleda i procedura koji su kreirani u Vašoj bazi.*/
CREATE PROCEDURE brisanje 
AS
BEGIN
	DROP VIEW [dbo].[view_SifraUposlenika]
	DROP VIEW [dbo].[view_Ukupno]
	DROP VIEW [dbo].[view_sr_vrij_cijene]
	DROP PROCEDURE [dbo].[sifra_Narudzbe]
	DROP PROCEDURE [dbo].[sp_sr_vrij_cijene]
END

EXEC brisanje