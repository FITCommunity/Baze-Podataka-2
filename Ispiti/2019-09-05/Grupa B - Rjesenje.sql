

/*
Napomena: 

1. Prilikom  bodovanja rješenja prioritet ima razultat koji treba upit da vrati (broj zapisa, vrijednosti agregatnih funkcija...).
U slučaju da rezultat upita nije tačan, a pogled, tabela... koji su rezultat tog upita se koriste u narednim zadacima, tada se rješenja narednih zadataka, 
bez obzira na tačnost koda, ne boduju punim brojem bodova, jer ni ta rješenja ne mogu vratiti tačan rezultat (broj zapisa, vrijednosti agregatnih funkcija...).

2. Tokom pisanja koda obratiti posebnu pažnju na tekst zadatka i ono što se traži zadatkom. 
Prilikom pregleda rada pokreće se kod koji se nalazi u sql skripti i sve ono što nije urađeno prema zahtjevima zadatka 
ili je pogrešno urađeno predstavlja grešku. Shodno navedenom na uvidu se ne prihvata prigovor da je neki dio koda posljedica previda 
("nisam vidio", "slučajno sam to napisao"...) 
*/


/*
1.
a) Kreirati bazu pod vlAStitim brojem indeksa.
*/
CREATE DATABASE BP2_2019_09_05_B
GO
USE BP2_2019_09_05_B
GO


/* 
b) Kreiranje tabela.
Prilikom kreiranja tabela voditi računa o odnosima između tabela.
I. Kreirati tabelu produkt sljedeće strukture:
	- produktID, cjelobrojna varijabla, primarni ključ
	- jed_cijena, novčana varijabla
	- kateg_naziv, 15 unicode karaktera
	- mj_jedinica, 20 unicode karaktera
	- dobavljac_naziv, 40 unicode karaktera
	- dobavljac_post_br, 10 unicode karaktera
*/
CREATE TABLE produkt
(
	produktID INT CONSTRAINT PK_produkt PRIMARY KEY (produktID),
	jed_cijena MONEY,
	kateg_naziv NVARCHAR (15),
	mj_jedinica NVARCHAR (20),
	dobavljac_naziv NVARCHAR (40),
	dobavljac_post_br NVARCHAR (10)
) 

/*
II. Kreirati tabelu narudzba sljedeće strukture:
	- narudzbaID, cjelobrojna varijabla, primarni ključ
	- dtm_narudzbe, datumska varijabla za unos samo datuma
	- dtm_isporuke, datumska varijabla za unos samo datuma
	- grad_isporuke, 15 unicode karaktera
	- klijentID, 5 unicode karaktera
	- klijent_naziv, 40 unicode karaktera
	- prevoznik_naziv, 40 unicode karaktera
*/
CREATE TABLE narudzba
(
	narudzbaID INT CONSTRAINT PK_narudzba PRIMARY KEY (narudzbaID),
	dtm_narudzbe DATE,
	dtm_isporuke DATE,
	grad_isporuke NVARCHAR (15),
	klijentID NVARCHAR (5),
	klijent_naziv NVARCHAR (40),
	prevoznik_naziv NVARCHAR (40)
)

/*
III. Kreirati tabelu narudzba_produkt sljedeće strukture:
	- narudzbaID, cjelobrojna varijabla, obavezan unos
	- produktID, cjelobrojna varijabla, obavezan unos
	- uk_cijena, novčana varijabla
*/
CREATE TABLE narudzba_produkt
(
	narudzbaID INT not null,
	produktID INT not null,
	uk_cijena MONEY,
	CONSTRAINT PK_narudzba_produkt PRIMARY KEY (narudzbaID, produktID),
	CONSTRAINT FK_nar_pr_narudzba FOREIGN KEY (narudzbaID) REFERENCES narudzba (narudzbaID),
	CONSTRAINT FK_nar_pr_produkt FOREIGN KEY (produktID) REFERENCES produkt (produktID)
)

----------------------------------------------------------------------------------------------------------------------------
/*
2. Import podataka
a) Iz tabela Categories, Product i Suppliers baze Northwind u tabelu produkt importovati podatke prema pravilu:
	- ProductID -> produktID
	- QuantityPerUnit -> mj_jedinica
	- UnitPrice -> jed_cijena
	- CategoryName -> kateg_naziv
	- CompanyName -> dobavljac_naziv
	- PostalCode -> dobavljac_post_br
*/
INSERT INTO produkt
SELECT p.ProductID, p.UnitPrice, c.CategoryName, p.QuantityPerUnit, s.CompanyName, s.PostalCode
FROM Northwind.dbo.Categories AS c INNER JOIN Northwind.dbo.Products AS p 
	ON c.CategoryID = p.CategoryID INNER JOIN Northwind.dbo.Suppliers AS s
	   ON p.SupplierID = s.SupplierID


/*
a) Iz tabela Customers, Orders i Shipers baze Northwind u tabelu narudzba importovati podatke prema pravilu:
	- OrderID -> narudzbaID
	- OrderDATE -> dtm_narudzbe
	- ShippedDATE -> dtm_isporuke
	- ShipCity -> grad_isporuke
	- CustomerID -> klijentID
	- CompanyName -> klijent_naziv
	- CompanyName -> prevoznik_naziv
*/
INSERT INTO narudzba
SELECT o.OrderID, o.OrderDATE, o.ShippedDATE, o.ShipCity, c.CustomerID, c.CompanyName, s.CompanyName
FROM Northwind.dbo.Customers AS c INNER JOIN Northwind.dbo.Orders AS o
	ON c.CustomerID = o.CustomerID INNER JOIN Northwind.dbo.Shippers AS s
		ON o.ShipVia = s.ShipperID


/*
c) Iz tabele Order Details baze Northwind u tabelu narudzba_produkt importovati podatke prema pravilu:
	- OrderID -> narudzbaID
	- ProductID -> produktID
	- uk_cijena <- produkt jedinične cijene i količine
uz uslov da je odobren popust 5% na produkt.
*/
INSERT INTO narudzba_produkt
SELECT OrderID, ProductID, UnitPrice * Quantity
FROM Northwind.dbo.[Order Details]
WHERE Discount = 0.05
--185
--10 bodova


----------------------------------------------------------------------------------------------------------------------------
/*
3. 
a) Koristeći tabele narudzba i narudzba_produkt kreirati pogled view_uk_cijena koji će imati strukturu:
	- narudzbaID
	- klijentID
	- uk_cijena_cijeli_dio
	- uk_cijena_feninzi - prikazati kao cijeli broj  
Obavezno pregledati sadržaj pogleda.
b) Koristeći pogled view_uk_cijena kreirati tabelu nova_uk_cijena uz uslov da se preuzmu samo oni zapisi u kojima su feninzi veći od 49. 
U tabeli trebaju biti sve kolone iz pogleda, te nakon njih kolona uk_cijena_nova u kojoj će ukupna cijena biti zaokružena na veću vrijednost. 
Npr. uk_cijena = 10, feninzi = 90 -> uk_cijena_nova = 11
*/
--a
CREATE VIEW view_uk_cijena
AS
SELECT n.narudzbaID, n.klijentID, FLOOR (np.uk_cijena) AS uk_cijena_cijeli_dio, RIGHT (np.uk_cijena,2) AS uk_cijena_feninzi
FROM narudzba_produkt AS np INNER JOIN narudzba AS n
	 ON	np.narudzbaID = n.narudzbaID

SELECT * FROM view_uk_cijena



--b
SELECT narudzbaID, klijentID, uk_cijena_cijeli_dio, uk_cijena_feninzi, uk_cijena_cijeli_dio + 1 AS uk_cijena_nova into nova_uk_cijena
FROM view_uk_cijena
WHERE uk_cijena_feninzi > 49

SELECT * FROM nova_uk_cijena


----------------------------------------------------------------------------------------------------------------------------
/*
4. 
Koristeći tabelu uk_cijena_nova kreiranu u 3. zadatku kreirati proceduru tako da je prilikom izvršavanja moguće unijeti bilo 
koji broj parametara (možemo ostaviti bilo koji parametar bez unijete vrijednosti). 
Proceduru pokrenuti za sljedeće vrijednosti varijabli:
1. narudzbaID - 10730
2. klijentID  - ERNSH
*/
GO
CREATE PROCEDURE proc_uk_cijena
(
	@narudzbaID INT = NULL,
	@klijentID NVARCHAR (5) = NULL,
	@uk_cijena_cijeli_dio DECIMAL (5,2) = NULL,
	@uk_cijena_feninzi DECIMAL (5,2) = NULL,
	@uk_cijena_nova DECIMAL (5,2) = NULL
)
AS
BEGIN
	SELECT narudzbaID, klijentID, uk_cijena_cijeli_dio, uk_cijena_feninzi, uk_cijena_nova
	FROM nova_uk_cijena
	WHERE narudzbaID = @narudzbaID OR
		  klijentID = @klijentID OR
		  uk_cijena_cijeli_dio = @uk_cijena_cijeli_dio  OR
		  uk_cijena_feninzi = @uk_cijena_feninzi OR
		  uk_cijena_nova = @uk_cijena_nova
END

EXEC proc_uk_cijena @narudzbaID = 10730


EXEC proc_uk_cijena @klijentID = ERNSH



----------------------------------------------------------------------------------------------------------------------------
/*
5.
Koristeći tabelu produkt kreirati proceduru proc_post_br koja će prebrojati zapise u kojima poštanski broj dobavljača počinje ciFROM. 
Potrebno je dati prikaz poštanskog broja i ukupnog broja zapisa po poštanskom broju. Nakon kreiranja pokrenuti proceduru.
*/
GO
CREATE PROCEDURE proc_post_br
AS
BEGIN
	SELECT dobavljac_post_br, COUNT (dobavljac_post_br) AS broj_po_post_br
	FROM produkt
	WHERE LEFT (dobavljac_post_br,1) LIKE '[0-9]'
	GROUP BY dobavljac_post_br
END
GO

EXEC proc_post_br

-------------------------------------------------------------------
/*
6.
a) Iz tabele narudzba kreirati pogled view_prebrojano sljedeće strukture:
	- klijent_naziv
	- prebrojano - ukupan broj narudžbi po nazivu klijent
Obavezno napisati naredbu za pregled sadržaja pogleda.
b) Napisati naredbu kojom će se prikazati maksimalna vrijednost kolone prebrojano.
c) Iz pogleda kreiranog pod a) dati pregled zapisa u kojem će osim kolona iz pogleda prikazati razlika maksimalne vrijednosti i 
kolone prebrojano uz uslov da se ne prikazuje zapis u kojem se nalazi maksimlana vrijednost.
*/
GO
CREATE VIEW view_prebrojano
AS
SELECT klijent_naziv, COUNT (narudzbaID) AS prebrojano
FROM narudzba
GROUP BY klijent_naziv
GO

SELECT * FROM view_prebrojano


SELECT MAX (prebrojano) FROM view_prebrojano


SELECT klijent_naziv, prebrojano, (SELECT MAX (prebrojano) FROM view_prebrojano) - prebrojano
FROM view_prebrojano
WHERE prebrojano != (SELECT MAX (prebrojano) FROM view_prebrojano)
ORDER BY 2



-------------------------------------------------------------------
/*
7.
a) U tabeli produkt dodati kolonu lozinka, 20 unicode karaktera 
b) Kreirati proceduru kojom će se izvršiti punjenje kolone lozinka na sljedeći način:
	- ako je u dobavljac_post_br podatak sačinjen samo od cifara, lozinka se kreira obrtanjem niza znakova koji se 
	dobiju spajanjem zadnja četiri znaka kolone mj_jedinica i kolone dobavljac_post_br
	- ako podatak u dobavljac_post_br podatak sadrži jedno ili više slova na bilo kojem mjestu, 
	lozinka se kreira obrtanjem slučajno generisanog niza znakova
Nakon kreiranja pokrenuti proceduru.
Obavezno provjeriti sadržaj tabele narudžba.
*/
--a
ALTER TABLE produkt
ADD lozinka NVARCHAR (20)

--b
GO
CREATE PROCEDURE proc_lozinka
AS
BEGIN
	UPDATE produkt
	SET lozinka = REVERSE (right (mj_jedinica,4) + dobavljac_post_br)
	WHERE dobavljac_post_br not like '[A-Z]%' and dobavljac_post_br not like '%[A-Z]%' and dobavljac_post_br not like '%[A-Z]'
	UPDATE produkt
	SET lozinka = REVERSE (left (NEWID(),20))
	WHERE dobavljac_post_br like '[A-Z]%' or dobavljac_post_br like '%[A-Z]%' or dobavljac_post_br like '%[A-Z]'
END
GO

EXEC proc_lozinka


SELECT * FROM produkt



-------------------------------------------------------------------
/*
8. 
a) Kreirati pogled kojim sljedeće strukture:
	- produktID,
	- dobavljac_naziv,
	- grad_isporuke
	- period_do_isporuke koji predstavlja vremenski period od datuma narudžbe do datuma isporuke
Uslov je da se dohvate samo oni zapisi u kojima je narudzba realizirana u okviru 4 sedmice.
Obavezno pregledati sadržaj pogleda.

b) Koristeći pogled view_isporuka kreirati tabelu isporuka u koju će biti smještene sve kolone iz pogleda. 
*/
GO
CREATE VIEW view_isporuka
AS
SELECT p.produktID, p.dobavljac_naziv, n.grad_isporuke, DATEDIFF (DAY, dtm_narudzbe, dtm_isporuke) AS period_do_isporuke 
FROM narudzba AS n INNER JOIN narudzba_produkt AS np
	 ON n.narudzbaID = np.narudzbaID INNER JOIN produkt AS p
		ON np.produktID = p.produktID
WHERE DATEDIFF (DAY, dtm_narudzbe, dtm_isporuke) <= 28
GO

SELECT * FROM view_isporuka


SELECT * into isporuka
FROM view_isporuka





-------------------------------------------------------------------
/*
9.
a) U tabeli isporuka dodati kolonu red_br_sedmice, 10 unicode karaktera.
b) U tabeli isporuka izvršiti UPDATE kolone red_br_sedmice ( prva, druga, treca, cetvrta) u zavisnosti od vrijednosti u koloni period_do_isporuke. 
Pokrenuti proceduru
c) Kreirati pregled kojim će se prebrojati broj zapisa po rednom broju sedmice. 
Pregled treba da sadrži redni broj sedmice i ukupan broj zapisa po rednom broju.
*/

--a
ALTER TABLE isporuka
ADD red_br_sedmice NVARCHAR (10)

--b
UPDATE isporuka
SET red_br_sedmice= 'prva'
WHERE period_do_isporuke <= 7

UPDATE isporuka
SET red_br_sedmice= 'druga'
WHERE period_do_isporuke between 8 and 14

UPDATE isporuka
SET red_br_sedmice= 'treca'
WHERE period_do_isporuke between 15 and 21

UPDATE isporuka
SET red_br_sedmice= 'cetvrta'
WHERE period_do_isporuke between 22 and 28


--c
SELECT red_br_sedmice, COUNT (red_br_sedmice)
FROM isporuka
GROUP BY red_br_sedmice

-------------------------------------------------------------------
/*
10.
a) Kreirati backup baze na default lokaciju.
b) Kreirati proceduru kojom će se u jednom izvršavanju obrisati svi pogledi i procedure u bazi. Pokrenuti proceduru.
*/
--a
BACKUP DATABASE BPII_2019_9_I_1
TO DISK = 'BP2_2019_09_05_B.bak'


--b
CREATE PROCEDURE proc_delete
AS
BEGIN
	DROP VIEW view_uk_cijena
	DROP PROCEDURE proc_lozinka, proc_post_br, proc_uk_cijena
END

EXEC proc_delete

