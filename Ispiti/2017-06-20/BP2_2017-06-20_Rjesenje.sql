/*
1.	Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. 
Fajlove baze podataka smjestiti na sljedeće lokacije:
a)	Data fajl: D:\BP2\Data
b)	Log fajl: D:\BP2\Log

*/

CREATE DATABASE BP2_2017_06_20 ON PRIMARY
(
	NAME = BP2_2017_06_20_dat , 
	FILENAME = 'C:\BP2\data\BP2_2017_06_20_dat.mdf'
)
LOG ON
(
	NAME = BP2_2017_06_20_log , 
	FILENAME = 'C:\BP2\log\BP2_2017_06_20_log.ldf'
)
GO

USE BP2_2017_06_20
GO
/*
2.	U svojoj bazi podataka kreirati tabele sa sljedećom strukturom:
a)	Proizvodi
i.	ProizvodID, cjelobrojna vrijednost i primarni ključ
ii.	Sifra, polje za unos 25 UNICODE karaktera (jedinstvena vrijednost i obavezan unos)
iii.	Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
iv.	Kategorija, polje za unos 50 UNICODE karaktera (obavezan unos)
v.	Cijena, polje za unos decimalnog broja (obavezan unos)
b)	Narudzbe
i.	NarudzbaID, cjelobrojna vrijednost i primarni ključ,
ii.	BrojNarudzbe, polje za unos 25 UNICODE karaktera (jedinstvena vrijednost i obavezan unos)
iii.	Datum, polje za unos datuma (obavezan unos),
iv.	Ukupno, polje za unos decimalnog broja (obavezan unos)
c)	StavkeNarudzbe
i.	ProizvodID, cjelobrojna vrijednost i dio primarnog ključa,
ii.	NarudzbaID, cjelobrojna vrijednost i dio primarnog ključa,
iii.	Kolicina, cjelobrojna vrijednost (obavezan unos)
iv.	Cijena, polje za unos decimalnog broja (obavezan unos)
v.	Popust, polje za unos decimalnog broja (obavezan unos)

*/
CREATE TABLE Proizvodi
(
	ProizvodID INT CONSTRAINT PK_Proizvodi PRIMARY KEY,
	Sifra NVARCHAR(25) CONSTRAINT uq_sifra UNIQUE NOT NULL,
	Naziv NVARCHAR(50) NOT NULL,
	Kategorija NVARCHAR(50) NOT NULL,
	Cijena DECIMAL(8,2) NOT NULL
)

CREATE TABLE Narudzbe
(
	NarudzbaID INT CONSTRAINT PK_Narudzbe PRIMARY KEY,
	BrojNarudzbe NVARCHAR(25) CONSTRAINT uq_brojnarudzbe UNIQUE NOT NULL,
	Datum DATE NOT NULL,
	Ukupno DECIMAL(8,2) NOT NULL
)

CREATE TABLE StavkeNarudzbe
(
	ProizvodID INT CONSTRAINT FK_StavkeNarudzbe_Proizvodi FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID),
	NarudzbaID INT CONSTRAINT FK_StavkeNarudzbe_Narudzbe  FOREIGN KEY(NarudzbaID) REFERENCES Narudzbe(NarudzbaID),
	CONSTRAINT PK_StavkeNarudzbe PRIMARY KEY(ProizvodID, NarudzbaID),
	Kolicina INT NOT NULL,
	Cijena DECIMAL(8,2) NOT NULL,
	Popust DECIMAL(8,2) NOT NULL,
	Iznos DECIMAL(8,2) NOT NULL
)

/*
3.	Iz baze podataka AdventureWorks2014 u svoju bazu podataka prebaciti sljedeće podatke:
a)	U tabelu Proizvodi dodati sve proizvode koji su prodavani u 2014. godini
i.	ProductNumber -> Sifra
ii.	Name -> Naziv
iii.	ProductCategory (Name) -> Kategorija
iv.	ListPrice -> Cijena
b)	U tabelu Narudzbe dodati sve narudžbe obavljene u 2014. godini
i.	SalesOrderNumber -> BrojNarudzbe
ii.	OrderDate - > Datum
iii.	TotalDue -> Ukupno
c)	U tabelu StavkeNarudzbe prebaciti sve podatke o detaljima narudžbi urađenih u 2014. godini
i.	OrderQty -> Kolicina
ii.	UnitPrice -> Cijena
iii.	UnitPriceDiscount -> Popust
iv.	LineTotal -> Iznos 
	Napomena: Zadržati identifikatore zapisa!	

*/
--a
INSERT INTO Proizvodi
SELECT DISTINCT 
	P.ProductID,
	P.ProductNumber,
	P.Name,
	PC.Name,
	P.ListPrice
FROM AdventureWorks2014.Production.Product AS P 
	INNER JOIN AdventureWorks2014.Production.ProductSubcategory AS PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID 
	INNER JOIN AdventureWorks2014.Production.ProductCategory AS PC ON PS.ProductCategoryID = PC.ProductCategoryID 
	INNER JOIN AdventureWorks2014.Sales.SalesOrderDetail AS SOD ON P.ProductID = SOD.ProductID 
	INNER JOIN AdventureWorks2014.Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE DATEPART(YEAR,SOH.OrderDate) = 2014

SELECT * FROM Proizvodi


--b
INSERT INTO Narudzbe
SELECT SOH.SalesOrderID, SOH.SalesOrderNumber, SOH.OrderDate, SOH.TOtalDue
FROM AdventureWorks2014.Sales.SalesOrderHeader AS SOH
WHERE DATEPART(YEAR,soh.OrderDate) = 2014

--c

INSERT INTO StavkeNarudzbe
SELECT 
	SOD.ProductID,
	SOH.SalesOrderID,
	SOD.OrderQty,
	SOD.UnitPrice,
	SOD.UnitPriceDiscount,
	SOD.LineTOtal
FROM AdventureWorks2014.Sales.SalesOrderDetail AS SOD 
	INNER JOIN AdventureWorks2014.Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE DATEPART(YEAR,SOH.OrderDate) = 2014

/*
4.	U svojoj bazi podataka kreirati novu tabelu Skladista sa poljima SkladisteID i Naziv, 
a zatim je povezati sa tabelom Proizvodi u relaciji više prema više. 
Za svaki proizvod na skladištu je potrebno čuvati količinu (cjelobrojna vrijednost).
*/
CREATE TABLE Skladista
(
	SkladisteID INT CONSTRAINT PK_Skladiste PRIMARY KEY IDENTITY(1,1),
	Naziv NVARCHAR(50) NOT NULL
)

CREATE table SkladisteProizvodi
(
	SkladisteID INT CONSTRAINT FK_SkladisteProizvodi_Skladiste FOREIGN KEY(SkladisteID) REFERENCES Skladista(SkladisteID),
	ProizvodID INT CONSTRAINT FK_SkladisteProizvodi_Proizvodi FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID),
	CONSTRAINT PK_SkladisteProizvodi PRIMARY KEY(SkladisteID,ProizvodID),
	Kolicina int NOT NULL
)

/*
5.	U tabelu Skladista  dodati tri skladišta proizvoljno, a zatim za sve proizvode na svim skladištima postaviti količinu na 0 komada.
*/
INSERT INTO Skladista
values ('Skladiste 1'), ('Skladiste 2'), ('Skladiste 3')

INSERT INTO SkladisteProizvodi
SELECT 
(
	SELECT SkladisteID 
	FROM Skladista 
	WHERE SkladisteID = 3
),
ProizvodID,0
FROM Proizvodi

SELECT * FROM SkladisteProizvodi
/*
6.	Kreirati uskladištenu proceduru koja vrši izmjenu stanja skladišta (količina).
Kao parametre proceduri proslijediti identifikatore proizvoda i skladišta, te količinu.	
*/

CREATE procedure proc_SkladisteProizvodi_Update
(
	@SkladisteID INT,
	@ProizvodID INT,
	@Kolicina INT
)
AS
BEGIN
	UPDATE SkladisteProizvodi
	SET Kolicina = Kolicina + @Kolicina
	WHERE SkladisteID = @SkladisteID AND ProizvodID = @ProizvodID
END

EXEC proc_SkladisteProizvodi_Update 1,707,150

SELECT * FROM SkladisteProizvodi


/*
7.	Nad tabelom Proizvodi kreirati non-clustered indeks nad poljima Sifra i Naziv, 
a zatim napisati proizvoljni upit koji u potpunosti iskorištava kreirani indeks. 
Upit obavezno mora sadržavati filtriranje podataka.
*/
USE BP2_2017_06_20

CREATE NON CLUSTERED INDEX IX_Proizvodi_Sifra_Naziv
ON Proizvodi(Sifra,Naziv)

SELECT Sifra,Naziv
FROM Proizvodi
WHERE Sifra LIKE '%[0-5]'

/*8.	Kreirati trigger koji će spriječiti brisanje zapisa u tabeli Proizvodi.*/
CREATE TRIGGER tr_Proizovid_delete
ON Proizvodi INSTEAD OF DELETE
AS
BEGIN
	PRINT 'Nije dozvoljeno brisanje zapisa'
	ROLLBACK
END

DELETE FROM Proizvodi
WHERE ProizvodID = 707

/*
9.	Kreirati view koji prikazuje sljedeće kolone: šifru, naziv i cijenu proizvoda, ukupnu prodanu količinu i ukupnu zaradu od prodaje.
*/

CREATE view view_Proizvod_Narudzbe
AS
SELECT 
	P.Sifra,
	P.Naziv,
	P.Cijena,
	SUM(SN.Kolicina) AS [Ukupno prodano],
	SUM((SN.Cijena - (SN.Cijena * SN.Popust)) * SN.Kolicina) AS Ukupno
FROM Proizvodi AS P 
	INNER JOIN StavkeNarudzbe AS SN ON P.ProizvodID = SN.ProizvodID 
GROUP BY P.Sifra,P.Naziv,P.Cijena

SELECT * FROM view_Proizvod_Narudzbe
GO
/*
10.	Kreirati uskladištenu proceduru koja će za unesenu šifru proizvoda prikazivati ukupnu prodanu količinu i ukupnu zaradu.
Ukoliko se ne unese šifra proizvoda procedura treba da prikaže prodaju svih proizovda. U proceduri koristiti prethodno kreirani view.	
*/
CREATE procedure proc_view_Proizvod_Narudzbe_SelectBySifra
(
	@Sifra nvarchar(25) = null
)
AS
BEGIN
	SELECT [Ukupno prodano], Ukupno
	FROM view_Proizvod_Narudzbe
	WHERE Sifra = @Sifra OR @Sifra IS NULL
END

EXEC proc_view_Proizvod_Narudzbe_SelectBySifra 'LJ-0192-S'

EXEC proc_view_Proizvod_Narudzbe_SelectBySifraa
/*
11.	U svojoj bazi podataka kreirati novog korisnika za login student te mu dodijeliti odgovarajuću permisiju
kako bi mogao izvršavati prethodno kreiranu proceduru.
*/
CREATE USER novi FROM LOGIN student

GRANT EXECUTE ON proc_view_Proizvod_Narudzbe_SelectBySifra TO novi

/*12.	Napraviti full i diferencijalni backup baze podataka na lokaciji D:\BP2\Backup	 */

BACKUP DATABASE BP2_2017_06_20 TO
DISK ='C:\BP2\Backup\BP2_2017_06_20.bak'

BACKUP DATABASE BP2_2017_06_20 TO
DISK ='C:\BP2\Backup\BP2_2017_06_20_dif.bak'
WITH DIFFERENTIAL