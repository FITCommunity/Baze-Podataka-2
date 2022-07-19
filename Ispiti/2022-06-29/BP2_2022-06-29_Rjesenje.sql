--29.06.2022.

--BAZE PODATAKA II – ISPIT

--***Prilikom izrade zadataka, OBAVEZNO iznad svakog zadatka napisati redni broj zadatka npr (4c). Zadaci koji ne budu oznaèeni na prethodno definisan naèin neæe biti evaluirani.

--1.	Kroz SQL kod kreirati bazu podataka sa imenom vašeg broja indeksa.
CREATE DATABASE brojIndexa
GO
USE brojIndexa
GO
--2.	U kreiranoj bazi podataka kreirati tabele sa sljedeæom strukturom:
--a)	Proizvodi
--•	ProizvodID, cjelobrojna vrijednost i primarni kljuè, autoinkrement
--•	Naziv, 50 UNICODE karaktera (obavezan unos)
--•	SifraProizvoda, 25 UNICODE karaktera (obavezan unos)
--•	Boja, 15 UNICODE karaktera 
--•	NazivKategorije, 50 UNICODE (obavezan unos)
--•	Tezina, decimalna vrijednost sa 2 znaka iza zareza
CREATE TABLE Proizvodi
(
	ProizvodID INT CONSTRAINT PK_Proizvod PRIMARY KEY IDENTITY(1,1),
	Naziv NVARCHAR(50) NOT NULL,
	SifraProizvoda NVARCHAR(25) NOT NULL,
	Boja NVARCHAR(15), 
	NazivKategorije  NVARCHAR(50) NOT NULL,
	Tezina DECIMAL(18,2)

)
GO
--b)	ZaglavljeNarudzbe 
--•	NarudzbaID, cjelobrojna vrijednost i primarni kljuè, autoinkrement
--•	DatumNarudzbe, polje za unos datuma i vremena (obavezan unos)
--•	DatumIsporuke, polje za unos datuma i vremena
--•	ImeKupca, 50 UNICODE (obavezan unos)
--•	PrezimeKupca, 50 UNICODE (obavezan unos)
--•	NazivTeritorije, 50 UNICODE (obavezan unos)
--•	NazivRegije, 50 UNICODE (obavezan unos)
--•	NacinIsporuke, 50 UNICODE (obavezan unos)
CREATE TABLE ZaglavljeNarudzbe
(
	NarudzbaID INT CONSTRAINT PK_ZaglavljeNarudzbe PRIMARY KEY IDENTITY(1,1),
	DatumNarudzbe DATETIME NOT NULL,
	DatumIsporuke DATETIME,
	ImeKupca NVARCHAR(50) NOT NULL,
	PrezimeKupca NVARCHAR(50) NOT NULL, 
	NazivTeritorije NVARCHAR(50) NOT NULL,
	NazivRegije NVARCHAR(50) NOT NULL,
	NacinIsporuke NVARCHAR(50) NOT NULL
)
GO
--c)	DetaljiNarudzbe
--•	NarudzbaID, cjelobrojna vrijednost, strani kljuè
--•	ProizvodID, cjelobrojna vrijednost, strani kljuè
--•	Cijena, novèani tip (obavezan unos),
--•	Kolicina, skraæeni cjelobrojni tip (obavezan unos),
--•	Popust, novèani tip (obavezan unos)
CREATE TABLE DetaljiNarudzbe
(
	NarudzbaID INT NOT NULL CONSTRAINT FK_ZaglavljeNarudzbe FOREIGN KEY REFERENCES ZaglavljeNarudzbe(NarudzbaID),
	ProizvodID INT NOT NULL CONSTRAINT FK_Proizvodi FOREIGN KEY REFERENCES Proizvodi(ProizvodID),
	Cijena MONEY NOT NULL,
	Kolicina SMALLINT NOT NULL,
	Popust MONEY NOT NULL,
	DetaljiNarudzbe INT CONSTRAINT PK_DetaljiNarudzbe PRIMARY KEY IDENTITY(1,1)
)
GO
--**Jedan proizvod se može više puta naruèiti, dok jedna narudžba može sadržavati više proizvoda. U okviru jedne narudžbe jedan proizvod se može naruèiti više puta.
--7 bodova
--3.	Iz baze podataka AdventureWorks u svoju bazu podataka prebaciti sljedeæe podatke:
--a)	U tabelu Proizvodi dodati sve proizvode, na mjestima gdje nema pohranjenih podataka o težini zamijeniti vrijednost sa 0
--•	ProductID -> ProizvodID
--•	Name  -> Naziv 	
--•	ProductNumber -> SifraProizvoda
--•	Color -> Boja 
--•	Name (ProductCategory) -> NazivKategorije
--•	Weight -> Tezina
SET IDENTITY_INSERT  Proizvodi ON
INSERT INTO Proizvodi(ProizvodID,Naziv,SifraProizvoda,Boja,NazivKategorije,Tezina)
SELECT P.ProductID,P.Name,P.ProductNumber,P.Color,PC.Name,ISNULL(P.Weight,0)
FROM AdventureWorks2017.Production.Product AS P
INNER JOIN AdventureWorks2017.Production.ProductSubcategory AS PS
ON P.ProductSubcategoryID=PS.ProductSubcategoryID
INNER JOIN AdventureWorks2017.Production.ProductCategory AS PC
ON PS.ProductCategoryID=PC.ProductCategoryID
SET IDENTITY_INSERT  Proizvodi OFF
GO

--b)	U tabelu ZaglavljeNarudzbe dodati sve narudžbe
--•	SalesOrderID -> NarudzbaID
--•	OrderDate -> DatumNarudzbe
--•	ShipDate -> DatumIsporuke
--•	FirstName (Person) -> ImeKupca
--•	LastName (Person) -> PrezimeKupca
--•	Name (SalesTerritory) -> NazivTeritorije
--•	Group (SalesTerritory) -> NazivRegije
--•	Name (ShipMethod) -> NacinIsporuke
SET IDENTITY_INSERT ZaglavljeNarudzbe ON
INSERT INTO ZaglavljeNarudzbe(NarudzbaID,DatumNarudzbe,DatumIsporuke,ImeKupca,PrezimeKupca,NazivTeritorije,NazivRegije,NacinIsporuke)
SELECT SOH.SalesOrderID,SOH.OrderDate,SOH.ShipDate,PP.FirstName,PP.LastName,ST.Name,ST.[Group],SM.Name
FROM AdventureWorks2017.Sales.SalesOrderHeader AS SOH
INNER JOIN AdventureWorks2017.Sales.Customer AS SC
ON SOH.CustomerID=SC.CustomerID
INNER JOIN AdventureWorks2017.Person.Person AS PP
ON SC.PersonID=PP.BusinessEntityID
INNER JOIN AdventureWorks2017.Sales.SalesTerritory AS ST
ON ST.TerritoryID=SOH.TerritoryID
INNER JOIN AdventureWorks2017.Purchasing.ShipMethod AS SM
ON SOH.ShipMethodID=SM.ShipMethodID
SET IDENTITY_INSERT ZaglavljeNarudzbe OFF
GO
--c)	U tabelu DetaljiNarudzbe dodati sve stavke narudžbe
--•	SalesOrderID -> NarudzbaID
--•	ProductID -> ProizvodID
--•	UnitPrice -> Cijena
--•	OrderQty -> Kolicina
--•	UnitPriceDiscount -> Popust
--8 bodova
INSERT INTO DetaljiNarudzbe
SELECT SOD.SalesOrderID,SOD.ProductID,SOD.UnitPrice,SOD.OrderQty,SOD.UnitPriceDiscount
FROM AdventureWorks2017.Sales.SalesOrderDetail AS SOD
GO
--4.	
--a)	(6 bodova) Kreirati upit koji æe prikazati ukupan broj uposlenika po odjelima. Potrebno je prebrojati samo one uposlenike koji su trenutno aktivni, odnosno rade na datom odjelu. Takoðer, samo uzeti u obzir one uposlenike koji imaju više od 10 godina radnog staža (ne ukljuèujuæi graniènu vrijednost). Rezultate sortirati preba broju uposlenika u opadajuæem redoslijedu. (AdventureWorks2017)
USE AdventureWorks2017
SELECT D.Name,COUNT(*) 'Broj uposlenika'
FROM HumanResources.Employee AS E
INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH
ON E.BusinessEntityID=EDH.BusinessEntityID
INNER JOIN HumanResources.Department AS D
ON EDH.DepartmentID=D.DepartmentID
WHERE EDH.EndDate IS NULL AND DATEDIFF(YEAR,E.HireDate,GETDATE())>10
GROUP BY D.Name
ORDER BY 2 DESC
GO
--, SUM(IIF(POD.RejectedQty>100,1,0)) 'Broj stavki'
--b)	Kreirati upit koji prikazuje po mjesecima ukupnu vrijednost poruèene robe za skladište, te ukupnu kolièinu primljene robe, iskljuèivo u 2012 godini. Uslov je da su troškovi prevoza bili izmeðu 500 i 2500, a da je dostava izvršena CARGO transportom. Takoðer u rezultatima upita je potrebno prebrojati stavke narudžbe na kojima je odbijena kolièina veæa od 100.(AdventureWorks2017)
USE AdventureWorks2017
--1. NAÈIN
  SELECT MONTH(POH.OrderDate) 'Mjesec', SUM(POD.LineTotal), SUM(POD.ReceivedQty),SUM(IIF(POD.RejectedQty>100,1,0)) 'Broj stavki'
  FROM Purchasing.PurchaseOrderHeader AS POH
  INNER JOIN Purchasing.PurchaseOrderDetail AS POD
  ON POH.PurchaseOrderID=POD.PurchaseOrderID
  INNER JOIN Purchasing.ShipMethod AS SM
  ON POH.ShipMethodID=SM.ShipMethodID
  WHERE YEAR(POH.OrderDate)=2012 AND POH.Freight BETWEEN 500 AND 2500 AND SM.Name LIKE '%CARGO%'
  GROUP BY MONTH(POH.OrderDate)  
GO  
--2. NAÈIN  
  SELECT MONTH(POH.OrderDate) 'Mjesec', SUM(POD.LineTotal), SUM(POD.ReceivedQty),(SELECT COUNT(*)
																					FROM Purchasing.PurchaseOrderHeader AS POH1
																					INNER JOIN Purchasing.PurchaseOrderDetail AS POD1
																					ON POH1.PurchaseOrderID=POD1.PurchaseOrderID
																					INNER JOIN Purchasing.ShipMethod AS SM1
																					ON POH1.ShipMethodID=SM1.ShipMethodID
																					WHERE MONTH(POH.OrderDate)=MONTH(POH1.OrderDate) AND                                                     POD1.RejectedQty>100 AND YEAR(POH1.OrderDate)=2012 AND													POH1.Freight BETWEEN 500 AND 2500 AND SM1.Name LIKE '%CARGO%')
  FROM Purchasing.PurchaseOrderHeader AS POH
  INNER JOIN Purchasing.PurchaseOrderDetail AS POD
  ON POH.PurchaseOrderID=POD.PurchaseOrderID
  INNER JOIN Purchasing.ShipMethod AS SM
  ON POH.ShipMethodID=SM.ShipMethodID
  WHERE YEAR(POH.OrderDate)=2012 AND POH.Freight BETWEEN 500 AND 2500 AND SM.Name LIKE '%CARGO%'
  GROUP BY MONTH(POH.OrderDate)

GO

--3. NAÈIN
 SELECT Q.Mjesec, SUM(Q.[Ukupna vrijednost]) 'Ukupna vrijednost', SUM(Q.[Ukupna kolièina])  'Ukupna kolièina',SUM(Q.[Stavke narudzbe]) 'Stavke narudzbe'
FROM
(SELECT MONTH(POH.OrderDate) 'Mjesec', SUM(POD.LineTotal) 'Ukupna vrijednost', SUM(POD.ReceivedQty) 'Ukupna kolièina', (SELECT COUNT(*)
																														FROM
																														AdventureWorks2017.Purchasing.PurchaseOrderDetail AS POD1
																														 WHERE POD1.RejectedQty>100 AND POD.PurchaseOrderID=POD1.PurchaseOrderID) 'Stavke narudzbe'

FROM Purchasing.PurchaseOrderDetail AS POD
INNER JOIN Purchasing.PurchaseOrderHeader AS POH
ON POD.PurchaseOrderID=POH.PurchaseOrderID
INNER JOIN Purchasing.ShipMethod AS SM
ON POH.ShipMethodID=SM.ShipMethodID
WHERE YEAR(POH.OrderDate)=2012 AND (POH.Freight BETWEEN 500 AND 2500) AND SM.Name LIKE '%CARGO%'
GROUP BY MONTH(POH.OrderDate), POD.PurchaseOrderID) AS Q
GROUP BY Q.Mjesec

GO
 --PROVJERA
 SELECT POH.OrderDate, POD.RejectedQty, POD.PurchaseOrderDetailID, POH.PurchaseOrderID
 FROM Purchasing.PurchaseOrderHeader AS POH
 INNER JOIN Purchasing.PurchaseOrderDetail AS POD
 ON POH.PurchaseOrderID=POD.PurchaseOrderID
 INNER JOIN Purchasing.ShipMethod AS SM
 ON POH.ShipMethodID=SM.ShipMethodID
 WHERE YEAR(POH.OrderDate)=2012 AND POH.Freight BETWEEN 500 AND 2500 AND SM.Name LIKE '%CARGO%' AND MONTH(POH.OrderDate) =1
  --GROUP BY MONTH(POH.OrderDate), POD.RejectedQty
GO  
--c)	(11 bodova) Prikazati ukupan broj narudžbi koje su obradili uposlenici, za svakog uposlenika pojedinaèno. Uslov je da su narudžbe kreirane u 2011 ili 2012 godini, te da je u okviru jedne narudžbe odobren popust na dvije ili više stavki. Takoðer uzeti u obzir samo one narudžbe koje su isporuèene u Veliku Britaniju, Kanadu ili Francusku. (AdventureWorks2017)

SELECT PP.LastName,PP.FirstName, COUNT(*) 'Broj narudžbi'
FROM Person.Person AS PP
INNER JOIN HumanResources.Employee AS E
ON PP.BusinessEntityID=E.BusinessEntityID
INNER JOIN Sales.SalesPerson AS SP
ON SP.BusinessEntityID=E.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS SOH
ON SOH.SalesPersonID=SP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
ON ST.TerritoryID=SOH.TerritoryID
WHERE YEAR(SOH.OrderDate) IN (2011,2012) AND ST.Name IN ('United Kingdom', 'Canada', 'France') AND (SELECT COUNT(*)
																									FROM Sales.SalesOrderDetail AS SOD
																									WHERE SOD.SalesOrderID=SOH.SalesOrderID AND 
																									SOD.UnitPriceDiscount>0) >=2
GROUP BY PP.LastName,PP.FirstName
ORDER BY 3 DESC

GO




--d)	(11 bodova) Napisati upit koji æe prikazati sljedeæe podatke o proizvodima: naziv proizvoda, naziv kompanije dobavljaèa, kolièinu na skladištu, te kreiranu šifru proizvoda. Šifra se sastoji od sljedeæih vrijednosti: (Northwind)
--1)	Prva dva slova naziva proizvoda
--2)	Karakter /
--3)	Prva dva slova druge rijeèi naziva kompanije dobavljaèa, uzeti u obzir one kompanije koje u nazivu imaju 2 ili 3 rijeèi
--4)	ID proizvoda po pravilu ukoliko se radi o jednocifrenom broju na njega dodati slovo 'a', u ostalim sluèajevima dodati obrnutu vrijednost broja
--Npr. Za proizvod sa nazivom Chai i sa dobavljaèem naziva Exotic Liquids, šifra æe btiti Ch/Li1a.

USE Northwind 
GO
SELECT P.ProductName,S.CompanyName,P.UnitsInStock,LEFT(P.ProductName,2)+'/'+LEFT(SUBSTRING(S.CompanyName,CHARINDEX(' ',S.CompanyName)+1,LEN(S.CompanyName)),2)+IIF(P.ProductID BETWEEN 1 AND 9,'a', REVERSE(P.ProductID)), P.ProductID
FROM Products AS P
INNER JOIN Suppliers AS S
ON P.SupplierID=S.SupplierID
WHERE LEN(S.CompanyName)-LEN(REPLACE(S.CompanyName,' ','')) IN (1,2)

GO
--		37 bodova
--5.	
--a)	(3 boda) U kreiranoj bazi kreirati index kojim æe se ubrzati pretraga prema šifri i nazivu proizvoda. Napisati upit za potpuno iskorištenje indexa.
USE brojIndexa
GO

CREATE INDEX IX_Search_Products
ON Proizvodi(SifraProizvoda,Naziv)

SELECT P.SifraProizvoda,P.Naziv
FROM Proizvodi AS P
WHERE P.SifraProizvoda LIKE 'F%' AND P.Naziv LIKE 'H%'
--b)	(7 bodova) U kreiranoj bazi kreirati proceduru sp_search_products kojom æe se vratiti podaci o proizvodima na osnovu kategorije kojoj pripadaju ili težini. Korisnici ne moraju unijeti niti jedan od parametara ali u tom sluèaju procedura ne vraæa niti jedan od zapisa. Korisnicima unosom veæ prvog slova kategorije se trebaju osvježiti zapisi, a vrijednost unesenog parametra težina æe vratiti one proizvode èija težina je veæa od  unesene vrijednosti.
GO
CREATE PROCEDURE sp_search_products
(
@Kategorija NVARCHAR(50)=NULL,
@Tezina DECIMAL(18,2)=NULL
)
AS
BEGIN
	SELECT*
	FROM Proizvodi AS P
	WHERE P.NazivKategorije LIKE @Kategorija+'%' OR P.Tezina>@Tezina
END
GO


EXEC sp_search_products 'Clothing'
EXEC sp_search_products @Tezina=2.2
EXEC sp_search_products
--c)	(18 bodova) Zbog proglašenja dobitnika nagradne igre održane u prva dva mjeseca drugog kvartala 2013 godine potrebno je kreirati upit. Upitom æe se prikazati treæa najveæa narudžba (vrijednost bez popusta) za svaki mjesec pojedinaèno. Obzirom da je u pravilima nagradne igre potrebno nagraditi 2 osobe (muškarca i ženu) za svaki mjesec, potrebno je u rezultatima upita prikazati pored navedenih stavki i o kojem se kupcu radi odnosno ime i prezime, te koju je nagradu osvojio. Nagrade se dodjeljuju po sljedeæem pravilu:
--•	za žene u prvom mjesecu drugog kvartala je stoni mikser, dok je za muškarce usisivaè
--•	za žene u drugom mjesecu drugog kvartala je pegla, dok je za muškarc multicooker
-- Obzirom da za kupce nije eksplicitno naveden spol, odreðivat æe se po pravilu: Ako je zadnje slovo imena a, smatra se da je osoba ženskog spola u suprotnom radi se o osobi muškog spola. Rezultate u formiranoj tabeli dobitnika sortirati prema vrijednosti narudžbe u opadajuæem redoslijedu. (AdventureWorks2017)
--28 bodova
--6.	Dokument teorija_28_06_2022, preimenovati vašim brojem indeksa, te u tom dokumentu izraditi pitanja.
--20 bodova
--SQL skriptu (bila prazna ili ne) imenovati Vašim brojem indeksa npr IB200001.sql, te istu zajedno sa .docx dokumentom kompromitovati  u jednu datoteku naziva npr IB200001.zip i upload-ovati na ftp u folder Upload.
--Maksimalan broj bodova:100  
--Prag prolaznosti: 55
GO
	USE AdventureWorks2017
	SELECT*
	FROM(SELECT TOP 1 T1.SalesOrderID,T1.FirstName,T1.LastName,T1.[Ukupna vrijednost], T1.Nagrada
	FROM (SELECT TOP 3 SOH.SalesOrderID,PP.FirstName,PP.LastName ,SUM(SOD.UnitPrice*SOD.OrderQty) 'Ukupna vrijednost','Stoni mikser' Nagrada
	FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	INNER JOIN Sales.Customer AS SC
	ON SOH.CustomerID=SC.CustomerID
	INNER JOIN Person.Person AS PP
	ON SC.PersonID=PP.BusinessEntityID
	WHERE YEAR(SOH.OrderDate)=2013 AND MONTH(SOH.OrderDate)=4 AND RIGHT(PP.FirstName,1)='a'
	GROUP BY SOH.SalesOrderID,PP.FirstName,PP.LastName
	ORDER BY 4 DESC) AS T1
	ORDER BY 4 ASC) AS T2
	UNION
	SELECT*
	FROM(SELECT TOP 1 T1.SalesOrderID,T1.FirstName,T1.LastName,T1.[Ukupna vrijednost], T1.Nagrada
	FROM (SELECT TOP 3 SOH.SalesOrderID,PP.FirstName,PP.LastName ,SUM(SOD.UnitPrice*SOD.OrderQty) 'Ukupna vrijednost','Usisivaè' Nagrada
	FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	INNER JOIN Sales.Customer AS SC
	ON SOH.CustomerID=SC.CustomerID
	INNER JOIN Person.Person AS PP
	ON SC.PersonID=PP.BusinessEntityID
	WHERE YEAR(SOH.OrderDate)=2013 AND MONTH(SOH.OrderDate)=4 AND RIGHT(PP.FirstName,1)<>'a'
	GROUP BY SOH.SalesOrderID,PP.FirstName,PP.LastName
	ORDER BY 4 DESC) AS T1
	ORDER BY 4 ASC) AS T2
	UNION
		SELECT*
	FROM(SELECT TOP 1 T1.SalesOrderID,T1.FirstName,T1.LastName,T1.[Ukupna vrijednost], T1.Nagrada
	FROM (SELECT TOP 3 SOH.SalesOrderID,PP.FirstName,PP.LastName ,SUM(SOD.UnitPrice*SOD.OrderQty) 'Ukupna vrijednost','Pegla' Nagrada
	FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	INNER JOIN Sales.Customer AS SC
	ON SOH.CustomerID=SC.CustomerID
	INNER JOIN Person.Person AS PP
	ON SC.PersonID=PP.BusinessEntityID
	WHERE YEAR(SOH.OrderDate)=2013 AND MONTH(SOH.OrderDate)=5 AND RIGHT(PP.FirstName,1)='a'
	GROUP BY SOH.SalesOrderID,PP.FirstName,PP.LastName
	ORDER BY 4 DESC) AS T1
	ORDER BY 4 ASC) AS T2
	UNION
	SELECT*
	FROM(SELECT TOP 1 T1.SalesOrderID,T1.FirstName,T1.LastName,T1.[Ukupna vrijednost], T1.Nagrada
	FROM (SELECT TOP 3 SOH.SalesOrderID,PP.FirstName,PP.LastName ,SUM(SOD.UnitPrice*SOD.OrderQty) 'Ukupna vrijednost','Multicooker' Nagrada
	FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	INNER JOIN Sales.Customer AS SC
	ON SOH.CustomerID=SC.CustomerID
	INNER JOIN Person.Person AS PP
	ON SC.PersonID=PP.BusinessEntityID
	WHERE YEAR(SOH.OrderDate)=2013 AND MONTH(SOH.OrderDate)=5 AND RIGHT(PP.FirstName,1)<>'a'
	GROUP BY SOH.SalesOrderID,PP.FirstName,PP.LastName
	ORDER BY 4 DESC) AS T1
	ORDER BY 4 ASC) AS T2
	ORDER BY [Ukupna vrijednost] DESC
