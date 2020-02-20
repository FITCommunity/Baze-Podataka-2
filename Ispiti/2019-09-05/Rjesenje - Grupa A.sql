/*
Napomena:

1. Prilikom  bodovanja rješenja priORitet ima razultat koji treba upit da vrati (broj zapisa, vrijednosti agregatnih funkcija...).
U slučaju da rezultat upita nije tačan, a pogled, tabela... koji su rezultat tog upita se kORiste u narednim zadacima, 
tada se rješenja narednih zadataka, bez obzira na tačnost koda, ne boduju punim brojem bodova, jer ni ta rješenja ne mogu vratiti tačan rezultat 
(broj zapisa, vrijednosti agregatnih funkcija...).

2. Tokom pisanja koda obratiti posebnu pažnju na tekst zadatka i ono što se traži zadatkom. 
Prilikom pregleda rada pokreće se kod koji se nalazi u sql skripti i sve ono što nije urađeno prema zahtjevima zadatka 
ili je pogrešno urađeno predstavlja grešku. Shodno navedenom na uvidu se ne prihvata prigovor da je neki dio koda posljedica previda 
("nisam vidio", "slučajno sam to napisao"...) 
*/


/*
1.
a) Kreirati bazu pod vlastitim brojem indeksa.
*/
CREATE DATABASE BP2_2019_09_05_A
GO

USE BP2_2019_09_05_A
GO


/* 
b) Kreiranje tabela.
Prilikom kreiranja tabela voditi računa o odnosima između tabela.
I. Kreirati tabelu narudzba sljedeće strukture:
	narudzbaID, cjelobrojna varijabla, primarni ključ
	dtm_narudzbe, datumska varijabla za unos samo datuma
	dtm_ispORuke, datumska varijabla za unos samo datuma
	prevoz, novčana varijabla
	klijentID, 5 unicode karaktera
	klijent_naziv, 40 unicode karaktera
	prevoznik_naziv, 40 unicode karaktera
*/
CREATE TABLE narudzba
(
	narudzbaID INT CONSTRAINT PK_narudzba PRIMARY KEY (narudzbaID),
	dtm_narudzbe DATE,
	dtm_ispORuke DATE,
	prevoz MONEY,
	klijentID NVARCHAR (5),
	klijent_naziv NVARCHAR (40),
	prevoznik_naziv NVARCHAR (40)
);

/*
II. Kreirati tabelu proizvod sljedeće strukture:
	- proizvodID, cjelobrojna varijabla, primarni ključ
	- mj_jedinica, 20 unicode karaktera
	- jed_cijena, novčana varijabla
	- kateg_naziv, 15 unicode karaktera
	- dobavljac_naziv, 40 unicode karaktera
	- dobavljac_web, tekstualna varijabla
*/
CREATE TABLE proizvod
(
	proizvodID INT CONSTRAINT PK_proizvod PRIMARY KEY (proizvodID),
	mj_jedinica NVARCHAR (20),
	jed_cijena MONEY,
	kateg_naziv NVARCHAR (15),
	dobavljac_naziv NVARCHAR (40),
	dobavljac_web TEXT
); 

/*
III. Kreirati tabelu narudzba_proizvod sljedeće strukture:
	- narudzbaID, cjelobrojna varijabla, obavezan unos
	- proizvodID, cjelobrojna varijabla, obavezan unos
	- uk_cijena, novčana varijabla
*/
CREATE TABLE narudzba_proizvod
(
	narudzbaID INT NOT NULL,
	proizvodID INT NOT NULL,
	uk_cijena MONEY,
	CONSTRAINT PK_narudzba_proizvod PRIMARY KEY (narudzbaID, proizvodID),
	CONSTRAINT FK_nar_pr_narudzba FOREIGN key (narudzbaID) REFERENCES narudzba (narudzbaID),
	CONSTRAINT FK_nar_pr_proizvod FOREIGN key (proizvodID) REFERENCES proizvod (proizvodID)
);

-------------------------------------------------------------------
/*
2. ImpORt podataka
a) Iz tabela Customers, ORders i Shipers baze NORthwind impORtovati podatke prema pravilu:
	- ORderID -> narudzbaID
	- ORderDATE -> dtm_narudzbe
	- ShippedDATE -> dtm_ispORuke
	- Freight -> prevoz
	- CustomerID -> klijentID
	- CompanyName -> klijent_naziv
	- CompanyName -> prevoznik_naziv
*/
INSERT INTO narudzba
SELECT o.ORderID, o.ORderDATE, o.ShippedDATE, o.Freight, c.CustomerID, c.CompanyName, s.CompanyName
FROM NORthwind.dbo.Customers AS c INNER JOIN NORthwind.dbo.ORders AS o
	 ON c.CustomerID = o.CustomerID INNER JOIN NORthwind.dbo.Shippers AS s
		ON o.ShipVia = s.ShipperID

/*
b) Iz tabela CateGORies, Product i Suppliers baze NORthwind impORtovati podatke prema pravilu:
	- ProductID -> proizvodID
	- QuantityPerUnit -> mj_jedinica
	- UnitPrice -> jed_cijena
	- CateGORyName -> kateg_naziv
	- CompanyName -> dobavljac_naziv
	- HomePage -> dobavljac_web
*/
INSERT INTO proizvod
SELECT p.ProductID, p.QuantityPerUnit, p.UnitPrice, c.CateGORyName, s.CompanyName, s.HomePage
FROM NORthwind.dbo.CateGORies AS c INNER JOIN NORthwind.dbo.Products AS p 
	 ON c.CateGORyID = p.CateGORyID INNER JOIN NORthwind.dbo.Suppliers AS s
		ON p.SupplierID = s.SupplierID


/*
c) Iz tabele ORder Details baze NORthwind impORtovati podatke prema pravilu:
	- ORderID -> narudzbaID
	- ProductID -> proizvodID
	- uk_cijena <- proizvod jedinične cijene i količine
uz uslov da nije odobren popust na proizvod.
*/
INSERT INTO narudzba_proizvod
SELECT OrderID, ProductID, UnitPrice * Quantity
FROM Northwind.dbo.[order Details]
WHERE Discount = 0



-------------------------------------------------------------------
/*
3. 
KORisteći tabele proizvod i narudzba_proizvod kreirati pogled view_kolicina koji će imati strukturu:
	- proizvodID
	- kateg_naziv
	- jed_cijena
	- uk_cijena
	- kolicina - količnik ukupne i jedinične cijene
U pogledu trebaju biti samo oni zapisi kod kojih količina ima smisao (nije moguće da je na stanju 1,23 proizvoda).
Obavezno pregledati sadržaj pogleda.
*/
CREATE VIEW view_kolicina
AS
SELECT p.proizvodID, p.kateg_naziv, 
	   p.jed_cijena, np.uk_cijena, 
	   np.uk_cijena/p.jed_cijena AS kolicina
FROM narudzba_proizvod AS np INNER JOIN proizvod AS p
	 ON np.proizvodID = p.proizvodID
WHERE FLOOR (np.uk_cijena/p.jed_cijena) = np.uk_cijena/p.jed_cijena

SELECT * FROM view_kolicina



-------------------------------------------------------------------
/*
4. 
KORisteći pogled kreiran u 3. zadatku kreirati proceduru tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara 
(možemo ostaviti bilo koji parametar bez unijete vrijednosti). Proceduru pokrenuti za sljedeće nazive kategorija:
1. Produce
2. Beverages
*/
CREATE PROCEDURE proc_kolicina
(
	@proizvodID INT = NULL,
	@kateg_naziv NVARCHAR (15) = NULL,
	@jed_cijena DECIMAL (5,2) = null,
	@uk_cijena DECIMAL (5,2) = null,
	@kolicina DECIMAL (5,2) = null
)
AS
BEGIN
	SELECT proizvodID, kateg_naziv, jed_cijena, uk_cijena, kolicina
	FROM view_kolicina
	WHERE proizvodID = @proizvodID OR
		  kateg_naziv = @kateg_naziv OR
		  jed_cijena = @jed_cijena OR
		  uk_cijena = @uk_cijena OR
		  kolicina = @kolicina
END

EXEC proc_kolicina @kateg_naziv = 'Produce'


EXEC proc_kolicina @kateg_naziv = 'Beverages'


------------------------------------------------
/*
5.
KORisteći pogled kreiran u 3. zadatku kreirati proceduru proc_br_kat_naziv koja će vršiti prebrojavanja po nazivu kateGORije. Nakon kreiranja pokrenuti proceduru.
*/
CREATE PROCEDURE proc_br_kat_naziv
AS
BEGIN
	SELECT kateg_naziv, COUNT (kateg_naziv) AS broj_kateg_naziv
	FROM view_kolicina
	GROUP BY kateg_naziv
END

EXEC proc_br_kat_naziv

-------------------------------------------------------------------
/*
6.
a) Iz tabele narudzba_proizvod kreirati pogled view_suma sljedeće strukture:
	- narudzbaID
	- suma - sume ukupne cijene po ID narudžbe
Obavezno napisati naredbu za pregled sadržaja pogleda.
b) Napisati naredbu kojom će se prikazati srednja vrijednost sume zaokružena na dvije decimale.
c) Iz pogleda kreiranog pod a) dati pregled zapisa čija je suma veća od prosječne sume. Osim kolona iz pogleda, 
potrebno je prikazati razliku sume i srednje vrijednosti. Razliku zaokružiti na dvije decimale.
*/
CREATE VIEW view_suma
AS
SELECT narudzbaID, SUM (uk_cijena) AS suma
FROM narudzba_proizvod
GROUP BY narudzbaID

SELECT * FROM view_suma


SELECT ROUND (AVG (suma),2) FROM view_suma


SELECT narudzbaID, suma, suma - (SELECT ROUND(AVG (suma),2) FROM view_suma)
FROM view_suma
WHERE suma > (SELECT AVG (suma) FROM view_suma)



-------------------------------------------------------------------
/*
7.
a) U tabeli narudzba dodati kolonu evid_br, 30 unicode karaktera 
b) Kreirati proceduru kojom će se izvršiti punjenje kolone evid_br na sljedeći način:
	- ako u datumu ispORuke nije unijeta vrijednost, evid_br se dobija generisanjem slučajnog niza znakova
	- ako je u datumu ispORuke unijeta vrijednost, evid_br se dobija spajanjem datum narudžbe i datuma isprouke uz umetanje donje crte između datuma
Nakon kreiranja pokrenuti proceduru.
Obavezno provjeriti sadržaj tabele narudžba.
*/
--a
ALTER TABLE narudzba
ADD evid_br NVARCHAR (30)

--b
CREATE PROCEDURE proc_evid_br
AS
BEGIN
	UPDATE narudzba
	SET evid_br = LEFT (NEWID(),30)
	WHERE dtm_ispORuke IS NULL
	UPDATE narudzba
	SET evid_br = CONVERT (NVARCHAR(15), dtm_narudzbe) + '_' + CONVERT (NVARCHAR (15), dtm_ispORuke)
	WHERE dtm_ispORuke IS NOT NULL
END

EXEC proc_evid_br


SELECT * FROM narudzba



-------------------------------------------------------------------
/*
8. Kreirati proceduru kojom će se dobiti pregled sljedećih kolona:
	- narudzbaID,
	- klijent_naziv,
	- proizvodID,
	- kateg_naziv,
	- dobavljac_naziv
Uslov je da se dohvate samo oni zapisi u kojima naziv kateGORije sadrži samo 1 riječ.
Pokrenuti proceduru.
*/
CREATE PROCEDURE proc_kateg_rijec
AS
BEGIN
SELECT n.narudzbaID, n.klijent_naziv, 
	   p.proizvodID, p.kateg_naziv, p.dobavljac_naziv
FROM narudzba AS n INNER JOIN narudzba_proizvod AS np 
	 ON n.narudzbaID = np.narudzbaID INNER JOIN proizvod AS p
		ON np.proizvodID = p.proizvodID
WHERE CHARINDEX('/',p.kateg_naziv)=0 and CHARINDEX (' ', p.kateg_naziv) = 0
END

EXEC proc_kateg_rijec



-------------------------------------------------------------------
/*
9.
U tabeli proizvod izvršiti UPDATE kolone dobavljac_web tako da se iz kolone dobavljac_naziv uzme prva riječ, 
a zatim se fORmira web adresa u fORmi www.prva_rijec.com. UPDATE izvršiti pomoću dva upita, vodeći računa o broju riječi u nazivu. 
*/
--jedna riječ
UPDATE proizvod
SET dobavljac_web = 'www.'+ dobavljac_naziv +'.com'
WHERE (CHARINDEX (' ', dobavljac_naziv)-1) < 0


--više riječi
UPDATE proizvod
SET dobavljac_web = 'www.'+ LEFT (dobavljac_naziv, (CHARINDEX (' ', dobavljac_naziv)-1))+'.com'
WHERE (CHARINDEX (' ', dobavljac_naziv)-1) >=0


SELECT * FROM proizvod

-------------------------------------------------------------------
/*
10.
a) Kreirati backup baze na default lokaciju.
b) Kreirati proceduru kojom će se u jednom izvršavanju obrisati svi pogledi i procedure u bazi. Pokrenuti proceduru.
*/
--a
BACKUP DATABASE BP2_2019_09_05_A
TO DISK = 'BP2_2019_09_05_A.bak'


--b
CREATE PROCEDURE proc_delete
AS
BEGIN
	DROP VIEW view_kolicina, view_suma
	DROP PROCEDURE proc_br_kat_naziv, proc_evid_br, proc_kateg_rijec, proc_kolicina
END

EXEC proc_delete
