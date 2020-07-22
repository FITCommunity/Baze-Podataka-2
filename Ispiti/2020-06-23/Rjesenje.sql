----------------------------
--1.
----------------------------
/*
Kreirati bazu pod vlastitim brojem indeksa
*/
CREATE DATABASE BP2_2020_06_23 
GO
USE BP2_2020_06_23 
GO
-----------------------------------------------------------------------
--Prilikom kreiranja tabela voditi računa o njihovom međusobnom odnosu.
-----------------------------------------------------------------------
/*
a) 
Kreirati tabelu dobavljac sljedeće strukture:
	- dobavljac_id - cjelobrojna vrijednost, primarni ključ
	- dobavljac_br_rac - 50 unicode karaktera
	- naziv_dobavljaca - 50 unicode karaktera
	- kred_rejting - cjelobrojna vrijednost
*/
CREATE TABLE Dobavljac(
	DobavljacID INT CONSTRAINT PK_Dobavljac PRIMARY KEY (DobavljacID),
	Dobavljac_br_rac NVARCHAR(50),
	NazivDobavljaca NVARCHAR(50),
	KredRating INT
);
GO
SELECT * FROM Dobavljac
/*
b)
Kreirati tabelu narudzba sljedeće strukture:
	- narudzba_id - cjelobrojna vrijednost, primarni ključ
	- narudzba_detalj_id - cjelobrojna vrijednost, primarni ključ
	- dobavljac_id - cjelobrojna vrijednost
	- dtm_narudzbe - datumska vrijednost
	- naruc_kolicina - cjelobrojna vrijednost
	- cijena_proizvoda - novčana vrijednost
*/
CREATE TABLE Narudzba(
	NarudzbaID INT,
	NarudzbaDetaljID INT,
	DobavljacID INT,
	DatumNarudzbe DATE,
	NarucenaKolicina INT,
	CijenaProizvoda MONEY,
	CONSTRAINT PK_Narudzba PRIMARY KEY(NarudzbaID, NarudzbaDetaljID),
	CONSTRAINT FK_Narudzba_Dobavljac FOREIGN KEY (DobavljacID) REFERENCES Dobavljac (DobavljacID)
);
GO
SELECT * FROM Narudzba
/*
c)
Kreirati tabelu dobavljac_proizvod sljedeće strukture:
	- proizvod_id cjelobrojna vrijednost, primarni ključ
	- dobavljac_id cjelobrojna vrijednost, primarni ključ
	- proiz_naziv 50 unicode karaktera
	- serij_oznaka_proiz 50 unicode karaktera
	- razlika_min_max cjelobrojna vrijednost
	- razlika_max_narudzba cjelobrojna vrijednost
*/
CREATE TABLE DobavljacProizvodi(
	ProizvodID INT,
	DobavljacID INT,
	ProizvodNaziv NVARCHAR(50),
	SerijskaOznaka NVARCHAR(50),
	RazlikaMinMax INT,
	RazlikaMaxNarudzba INT,
	CONSTRAINT PK_DobavljacProizvodi PRIMARY KEY (ProizvodID, DobavljacID),
	CONSTRAINT FK_Dobavljac_Proizvoda FOREIGN KEY (DobavljacID) REFERENCES Dobavljac(DobavljacID)
);
GO
SELECT * FROM DobavljacProizvodi
--10 bodova
----------------------------
--2. Insert podataka
----------------------------
/*
a) 
U tabelu dobavljac izvršiti insert podataka iz tabele Purchasing.Vendor prema sljedećoj strukturi:
	BusinessEntityID -> dobavljac_id 
	AccountNumber -> dobavljac_br_rac 
	Name -> naziv_dobavljaca
	CreditRating -> kred_rejting
*/
INSERT INTO Dobavljac
SELECT V.BusinessEntityID, V.AccountNumber, V.Name, V.CreditRating
FROM AdventureWorks2017.[Purchasing].[Vendor] AS V

SELECT * FROM Dobavljac

/*
b) 
U tabelu narudzba izvršiti insert podataka iz tabela Purchasing.PurchaseOrderHeader i Purchasing.PurchaseOrderDetail prema sljedećoj strukturi:
	PurchaseOrderID -> narudzba_id
	PurchaseOrderDetailID -> narudzba_detalj_id
	VendorID -> dobavljac_id 
	OrderDate -> dtm_narudzbe 
	OrderQty -> naruc_kolicina 
	UnitPrice -> cijena_proizvoda
*/
INSERT INTO Narudzba
SELECT POH.PurchaseOrderID, POD.PurchaseOrderDetailID, POH.VendorID, POH.OrderDate, POD.OrderQty, POD.UnitPrice
FROM AdventureWorks2017.[Purchasing].[PurchaseOrderHeader] AS POH
INNER JOIN AdventureWorks2017.[Purchasing].[PurchaseOrderDetail] AS POD
ON POH.PurchaseOrderID=POD.PurchaseOrderID

SELECT * FROM Narudzba
/*
c) 
U tabelu dobavljac_proizvod izvršiti insert podataka iz tabela Purchasing.ProductVendor i Production.Product prema sljedećoj strukturi:
	ProductID -> proizvod_id 
	BusinessEntityID -> dobavljac_id 
	Name -> proiz_naziv 
	ProductNumber -> serij_oznaka_proiz
	MaxOrderQty - MinOrderQty -> razlika_min_max 
	MaxOrderQty - OnOrderQty -> razlika_max_narudzba
uz uslov da se povuku samo oni zapisi u kojima ProductSubcategoryID nije NULL vrijednost.
*/
INSERT INTO DobavljacProizvodi
SELECT P.ProductID, V.BusinessEntityID, P.Name, P.ProductNumber,
(PV.MaxOrderQty-PV.MinOrderQty) AS RazlikaMinMax, (PV.MaxOrderQty-PV.OnOrderQty) AS RazlikaMaxNarudzba
FROM AdventureWorks2017.[Purchasing].[Vendor] AS V INNER JOIN AdventureWorks2017.[Purchasing].[ProductVendor] AS PV
ON PV.BusinessEntityID = V.BusinessEntityID INNER JOIN AdventureWorks2017.[Production].[Product] AS P
ON PV.ProductID = P.ProductID
WHERE P.ProductSubcategoryID IS NOT NULL

SELECT * FROM DobavljacProizvodi
GO
--10 bodova

----------------------------
--3.
----------------------------
/*
Koristeći sve tri tabele iz vlastite baze kreirati pogled view_dob_god sljedeće strukture:
	- dobavljac_id
	- proizvod_id
	- naruc_kolicina
	- cijena_proizvoda
	- ukupno, kao proizvod naručene količine i cijene proizvoda
Uslov je da se dohvate samo oni zapisi u kojima je narudžba obavljena 2013. ili 2014. godine 
i da se broj računa dobavljača završava cifrom 1. */
CREATE VIEW view_dob_god AS
SELECT 
	D.DobavljacID, 
	DP.ProizvodID, 
	N.NarucenaKolicina, 
	N.CijenaProizvoda,
	N.NarucenaKolicina * N.CijenaProizvoda AS Ukupno
FROM Dobavljac AS D 
	INNER JOIN Narudzba AS N ON D.DobavljacID = N.DobavljacID
	INNER JOIN DobavljacProizvodi AS DP ON DP.DobavljacID = D.DobavljacID
WHERE (YEAR(N.DatumNarudzbe) = 2013 OR YEAR(N.DatumNarudzbe) = 2014) AND
	  D.Dobavljac_br_rac LIKE '%1'
GROUP BY D.DobavljacID, DP.ProizvodID, N.NarucenaKolicina, N.CijenaProizvoda

SELECT * FROM view_dob_god
GO
--10 bodova

----------------------------
--4.
----------------------------
/*
Koristeći pogled view_dob_god kreirati proceduru proc_dob_god koja će sadržavati parametar naruc_kolicina i imati sljedeću strukturu:
	- dobavljac_id
	- proizvod_id
	- suma_ukupno, sumirana vrijednost kolone ukupno po dobavljac_id i proizvod_id
Uslov je da se dohvataju samo oni zapisi u kojima je naručena količina trocifreni broj.
Nakon kreiranja pokrenuti proceduru za vrijednost naručene količine 300.
*/
CREATE PROCEDURE proc_dob_god
(
	@naruc_kolicina INT
)
AS
BEGIN
	SELECT 
		DobavljacID, 
		ProizvodID, 
		NarucenaKolicina,
		SUM(Ukupno) AS suma_ukupno
	FROM view_dob_god
	WHERE (NarucenaKolicina > 99) AND (NarucenaKolicina < 1000) AND NarucenaKolicina = @naruc_kolicina 
	GROUP BY DobavljacID, ProizvodID, NarucenaKolicina
END

EXEC proc_dob_god 550
--10 bodova
----------------------------
--5.
----------------------------
/*
a)
Tabelu dobavljac_proizvod kopirati u tabelu dobavljac_proizvod_nova.
b) 
Iz tabele dobavljac_proizvod_nova izbrisati kolonu razlika_min_max.
c)
U tabeli dobavljac_proizvod_nova kreirati novu kolonu razlika. 
Kolonu popuniti razlikom vrijednosti kolone razlika_max_narudzba i srednje vrijednosti ove kolone,
uz uslov da ako se u zapisu nalazi NULL vrijednost u kolonu razlika smjestiti 0.
*/
--15 bodova 
--a)
SELECT * INTO DobavljacProizvodNova
FROM DobavljacProizvodi
SELECT * FROM DobavljacProizvodNova

--b)
ALTER TABLE DobavljacProizvodNova
DROP COLUMN RazlikaMinMax
SELECT * FROM DobavljacProizvodNova

--c)
ALTER TABLE DobavljacProizvodNova
ADD Razlika INT
SELECT * FROM DobavljacProizvodNova

UPDATE DobavljacProizvodNova
SET Razlika = RazlikaMaxNarudzba - d.Prosijek
FROM (SELECT AVG(RazlikaMaxNarudzba) AS Prosijek FROM DobavljacProizvodNova) d

SELECT * FROM DobavljacProizvodNova

ALTER TABLE DobavljacProizvodNova
DROP COLUMN Razlika
SELECT * FROM DobavljacProizvodNova
----------------------------
--6.
----------------------------
/*
Prebrojati koliko u tabeli dobavljac_proizvod ima različitih serijskih oznaka proizvoda koje završavaju bilo kojim slovom 
engleskog alfabeta, a koliko ima onih koji ne završavaju bilo kojim slovom engleskog alfabeta. Upit treba da vrati poruke:
	'Različitih serijskih oznaka proizvoda koje završavaju slovom engleskog alfabeta ima:' iza čega slijedi broj zapisa 
	i
	'Različitih serijskih oznaka proizvoda koje NE završavaju slovom engleskog alfabeta ima:' iza čega slijedi broj zapisa
*/
--10 bodova
SELECT 'Različitih serijskih oznaka proizvoda koje završavaju slovom engleskog alfabeta ima: ' + 
		CONVERT(NVARCHAR,(SELECT COUNT(*) 
				FROM DobavljacProizvodi 
				WHERE SerijskaOznaka LIKE '%[A-Za-z]')) AS Zavrsavaju,
	   'Različitih serijskih oznaka proizvoda koje NE završavaju slovom engleskog alfabeta ima: ' + 
		CONVERT(NVARCHAR,(SELECT COUNT(*) 
				FROM DobavljacProizvodi 
				WHERE SerijskaOznaka NOT LIKE '%[A-Za-z]')) AS Ne_Zavrsavaju

SELECT * FROM DobavljacProizvodi

----------------------------
--7.
----------------------------
/*
a)
Dati informaciju o dužinama podatka u koloni serij_oznaka_proiz tabele dobavljac_proizvod. 
b)
Dati informaciju o broju različitih dužina podataka u koloni serij_oznaka_proiz tabele dobavljac_proizvod. 
Poruka treba biti u obliku: 'Kolona serij_oznaka_proiz ima ___ različite dužinr podataka.' 
Na mjestu donje crte se nalazi izračunati brojčani podatak.
*/
--10 bodova
SELECT * FROM DobavljacProizvodi
--a)
SELECT LEN(SerijskaOznaka) AS DuzinaPodatka
FROM DobavljacProizvodi
--b) --Treba biti da ima 3 razlicite duzine, a ovako ih posebno ispisuje
SELECT 'Kolona SerijskaOznakaProiz ima ' + CONVERT(nvarchar,(LEN(SerijskaOznaka))) + ' razlicite duzine podataka.' AS Duzina
FROM DobavljacProizvodi
GROUP BY LEN(SerijskaOznaka)

----------------------------
--8.
----------------------------
/*
Prebrojati kod kolikog broja dobavljača je broj računa kreiran korištenjem više od jedne riječi iz naziva dobavljača. 
Jednom riječi se podrazumijeva skup slova koji nije prekinut blank (space) znakom. 
*/
--10 bodova
SELECT COUNT(*)
FROM Dobavljac
WHERE LEN(Dobavljac_br_rac) - LEN(REPLACE(Dobavljac_br_rac, ' ', '')) + 1 > 1
----------------------------
--9.
----------------------------
/*
Koristeći pogled view_dob_god kreirati proceduru proc_djeljivi koja će sadržavati parametar prebrojano i 
kojom će se prebrojati broj pojavljivanja vrijednosti u koloni naruc_kolicina koje su djeljive sa 100. 
Sortirati po koloni prebrojano. Nakon kreiranja pokrenuti proceduru za sljedeću vrijednost parametra prebrojano = 10
*/
--13 bodova
SELECT * FROM view_dob_god
GO

CREATE PROCEDURE proc_djeljivi
(
	@Prebrojano INT = 100
)
AS
BEGIN
		SELECT NarucenaKolicina, COUNT(NarucenaKolicina) AS Prebrojano
		FROM view_dob_god
		WHERE (NarucenaKolicina % @Prebrojano) = 0
		GROUP BY NarucenaKolicina
		ORDER BY Prebrojano
END

EXEC proc_djeljivi 10
----------------------------
--10.
----------------------------
/*
a) Kreirati backup baze na default lokaciju.
b) Napisati kod kojim će biti moguće obrisati bazu.
c) Izvršiti restore baze.
Uslov prihvatanja kodova je da se mogu pokrenuti.
*/
--2 boda
--a) Backup Baze
BACKUP DATABASE BP2_2020_06_23
TO DISK = 'BP2_2020_06_23.bak'
GO
--b) Brisanje Baze
USE master
DROP DATABASE BP2_2020_06_23
--c) Restore Baze
RESTORE DATABASE BP2_2020_06_23 FROM DISK = 'Disk na kojem se nalazi .bak fajl'