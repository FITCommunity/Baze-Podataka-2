--1. Kreiranje baze i tabela
/*
a) Kreirati bazu pod vlastitim brojem indeksa.
*/
CREATE DATABASE BP2_2019_09_19
GO

USE BP2_2019_09_19
GO


--b) Kreiranje tabela.
/*
Prilikom kreiranja tabela voditi računa o međusobnom odnosu između tabela.
I. Kreirati tabelu kreditna sljedeće strukture:
	- kreditnaID - cjelobrojna vrijednost, primarni ključ
	- br_kreditne - 25 unicode karatera, obavezan unos
	- dtm_evid - datumska varijabla za unos datuma
*/

CREATE TABLE kreditna
(
	kreditnaID INT CONSTRAINT PK_kreditna PRIMARY KEY (kreditnaID),
	br_kreditne NVARCHAR(25) NOT NULL,
	dtm_evid DATE NOT NULL
);
GO

/*
II. Kreirati tabelu osoba sljedeće strukture:
	osobaID - cjelobrojna vrijednost, primarni ključ
	kreditnaID - cjelobrojna vrijednost, obavezan unos
	mail_lozinka - 128 unicode karaktera
	lozinka - 10 unicode karaktera 
	br_tel - 25 unicode karaktera
*/

CREATE TABLE osoba
(
	osobaID INT CONSTRAINT PK_osoba PRIMARY KEY (osobaID),
	kreditnaID INT CONSTRAINT FK_osoba_kreditna FOREIGN KEY (kreditnaID) REFERENCES kreditna (kreditnaID) NOT NULL,
	mail_lozinka NVARCHAR(128) NOT NULL,
	lozinka NVARCHAR(10) NOT NULL,
	br_tel NVARCHAR(25) NOT NULL
);
GO

/*
III. Kreirati tabelu narudzba sljedeće strukture:
	narudzbaID - cjelobrojna vrijednost, primarni ključ
	kreditnaID - cjelobrojna vrijednost
	br_narudzbe - 25 unicode karaktera
	br_racuna - 15 unicode karaktera
	prodavnicaID - cjelobrojna varijabla
*/

CREATE TABLE narudzba
(
	narudzbaID INT CONSTRAINT PK_narudzba PRIMARY KEY (narudzbaID),
	kreditnaID INT CONSTRAINT FK_narudzba_kreditna FOREIGN KEY (kreditnaID) REFERENCES kreditna (kreditnaID),
	br_narudzbe NVARCHAR(25),
	br_racuna NVARCHAR(15),
	prodavnicaID INT
);
GO



-----------------------------------------------------------------------------------------------------------------------------
--2. Import podataka
/*
a) Iz tabele CreditCard baze AdventureWorks2017 importovati podatke u tabelu kreditna na sljedeći način:
	- CreditCardID -> kreditnaID
	- CardNUmber -> br_kreditne
	- ModifiedDate -> dtm_evid
*/

INSERT INTO kreditna
SELECT cc.CreditCardID, cc.CardNumber, cc.ModifiedDate
FROM AdventureWorks2017.Sales.CreditCard as cc

/*
b) Iz tabela Person, Password, PersonCreditCard i PersonPhone baze AdventureWorks2017 koje se nalaze u šemama Sales i Person 
importovati podatke u tabelu osoba na sljedeći način:
	- BussinesEntityID -> osobaID
	- CreditCardID -> kreditnaID
	- PasswordHash -> mail_lozinka
	- PasswordSalt -> lozinka
	- PhoneNumber -> br_tel
*/

INSERT INTO osoba
SELECT 
	p.BusinessEntityID, 
	pcc.CreditCardID, 
	pw.PasswordHash, 
	pw.PasswordSalt, 
	pp.PhoneNumber
FROM AdventureWorks2017.Person.Password AS pw 
	INNER JOIN AdventureWorks2017.Person.Person AS p ON pw.BusinessEntityID = p.BusinessEntityID 
	INNER JOIN AdventureWorks2017.Sales.PersonCreditCard AS pcc ON p.BusinessEntityID = pcc.BusinessEntityID 
	INNER JOIN AdventureWorks2017.Person.PersonPhone AS pp  ON p.BusinessEntityID = pp.BusinessEntityID


/*
c) Iz tabela Customer i SalesOrderHeader baze AdventureWorks2017 koje se nalaze u šemi Sales importovati podatke u tabelu 
narudzba na sljedeći način:
	- SalesOrderID -> narudzbaID
	- CreditCardID -> kreditnaID
	- PurchaseOrderNumber -> br_narudzbe
	- AccountNumber -> br_racuna
	- StoreID -> prodavnicaID
*/

INSERT INTO narudzba
SELECT 
	soh.SalesOrderID, 
	soh.CreditCardID, 
	soh.PurchaseOrderNumber, 
	soh.AccountNumber, 
	c.StoreID
FROM AdventureWorks2017.Sales.Customer AS c 
	INNER JOIN AdventureWorks2017.Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID

-----------------------------------------------------------------------------------------------------------------------------
/*
3. Kreirati pogled view_kred_mail koji će se sastojati od kolona: 
	- br_kreditne, 
	- mail_lozinka, 
	- br_tel i 
	- br_cif_br_tel, 
	pri čemu će se kolone puniti na sljedeći način:
	- br_kreditne - odbaciti prve 4 cifre 
 	- mail_lozinka - preuzeti sve znakove od 10. znaka (uključiti i njega) uz odbacivanje znaka jednakosti koji se nalazi na kraju lozinke
	- br_tel - prenijeti cijelu kolonu
	- br_cif_br_tel - broj cifara u koloni br_tel
*/

CREATE VIEW view_kred_mail
AS
SELECT 
	SUBSTRING(k.br_kreditne, 5, LEN(k.br_kreditne)) AS br_kreditne, 
	SUBSTRING(o.mail_lozinka,10, LEN(o.mail_lozinka)-10) AS mail_lozinka,
	o.br_tel, 
	LEN(o.br_tel) as br_cifri_br_tel
FROM osoba as o inner join kreditna AS k ON o.kreditnaID = k.kreditnaID


SELECT * FROM view_kred_mail

GO

-----------------------------------------------------------------------------------------------------------------------------
/*
4. Koristeći tabelu osoba kreirati proceduru proc_kred_mail u kojoj će biti sve kolone iz tabele. 
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koji 
parametar bez unijete vrijednosti) uz uslov da se prenesu samo oni zapisi u kojima je unijet predbroj u koloni br_tel. 
Npr. (123) 456 789 je zapis u kojem je unijet predbroj. 
Nakon kreiranja pokrenuti proceduru za sljedeću vrijednost:
br_tel = 1 (11) 500 555-0132
*/

CREATE PROCEDURE proc_osoba
(
	@osobaID int = NULL,
	@kreditnaID int = NULL,
	@mail_lozinka nvarchar (128) = null,
	@lozinka nvarchar (10) = null,
	@br_tel nvarchar (25) = null
)
AS
BEGIN
	SELECT	osobaID, kreditnaID, mail_lozinka, lozinka, br_tel
	FROM	osoba
	WHERE	br_tel like '%(%' AND 
			(
				osobaID = @osobaID OR
				kreditnaID = @kreditnaID OR
				mail_lozinka = @mail_lozinka OR
				lozinka = @lozinka OR
				br_tel = @br_tel
			)
END

EXEC proc_osoba @br_tel = '1 (11) 500 555-0132'
GO
-----------------------------------------------------------------------------------------------------------------------------
/*
5. 
a) Kopirati tabelu kreditna u kreditna1, 
b) U tabeli kreditna1 dodati novu kolonu dtm_izmjene čija je default vrijednost aktivni datum sa vremenom. Kolona je sa obaveznim unosom.
*/
--a

SELECT * INTO kreditna1
FROM kreditna

--b
ALTER TABLE kreditna1 
ADD dtm_izmjene DATETIME not null DEFAULT GETDATE()

SELECT * FROM kreditna1
-----------------------------------------------------------------------------------------------------------------------------
/*
6.
a) U zapisima tabele kreditna1 kod kojih broj kreditne kartice počinje ciframa 1 ili 3 vrijednost broja kreditne kartice zamijeniti 
slučajno generisanim nizom znakova.
b) Dati ifnormaciju (prebrojati) broj zapisa u tabeli kreditna1 kod kojih se datum evidencije nalazi u intevalu do najviše 6 godina 
u odnosu na datum izmjene.
c) Napisati naredbu za brisanje tabele kreditna1
*/

--SELECT * FROM kreditna1
--WHERE br_kreditne LIKE '[13]%'

--a
UPDATE kreditna1
SET br_kreditne = LEFT (NEWID(), LEN(br_kreditne))
WHERE br_kreditne LIKE '[13]%'


--b
SELECT COUNT(*)
FROM kreditna1
WHERE DATEDIFF (YEAR, dtm_evid, dtm_izmjene) <= 6


--c
DROP TABLE kreditna1

-----------------------------------------------------------------------------------------------------------------------------
/*
7.
a) U tabeli narudzba izvršiti izmjenu svih null vrijednosti u koloni br_narudzbe slučajno generisanim nizom znakova.
b) U tabeli narudzba izvršiti izmjenu svih null vrijednosti u koloni prodavnicaID po sljedećem pravilu.
	- ako narudzbaID počinje ciframa 4 ili 5 u kolonu prodavnicaID preuzeti posljednje 3 cifre iz kolone narudzbaID  
	- ako narudzbaID počinje ciframa 6 ili 7 u kolonu prodavnicaID preuzeti posljednje 4 cifre iz kolone narudzbaID  
*/

UPDATE narudzba
SET br_narudzbe = LEFT (NEWID(), (SELECT MAX(LEN(br_narudzbe)) FROM narudzba))
WHERE br_narudzbe IS NULL

--b

UPDATE narudzba
SET prodavnicaID =  RIGHT(narudzbaID, 3)
WHERE prodavnicaID IS NULL AND narudzbaID LIKE '[45]%'

UPDATE narudzba
SET prodavnicaID = RIGHT(narudzbaID, 4)
WHERE prodavnicaID IS NULL AND narudzbaID LIKE '[67]%' 
GO
-----------------------------------------------------------------------------------------------------------------------------
/*
8.
Kreirati proceduru kojom će se u tabeli narudzba izvršiti izmjena svih vrijednosti u koloni br_narudzbe u kojima se ne nalazi 
slučajno generirani niz znakova tako da se iz podatka izvrši uklanjanje prva dva znaka. 
*/

--ovo je Fudino rjesenje (nisam siguran kako uopste detektovati nesta sto je nasumicno)
CREATE PROCEDURE proc_skracivanje
AS
BEGIN
	UPDATE narudzba
	SET br_narudzbe = SUBSTRING(br_narudzbe, 3, LEN(br_narudzbe) - 3)
	WHERE LEN(br_narudzbe) < 25
END

EXEC proc_skracivanje

SELECT * FROM narudzba


-----------------------------------------------------------------------------------------------------------------------------
/*
9.
a) Iz tabele narudzba kreirati pogled koji će imati sljedeću strukturu:
	- duz_br_nar 
	- prebrojano - prebrojati broj zapisa prema dužini podatka u koloni br_narudzbe 
	  (npr. 1000 zapisa kod kojih je dužina podatka u koloni br_narudzbe 10)
Uslov je da se ne prebrojavaju zapisi u kojima je smješten slučajno generirani niz znakova. 
Provjeriti sadržaj pogleda.
b) Prikazati minimalnu i maksimalnu vrijednost kolone prebrojano
c) Dati pregled zapisa u kreiranom pogledu u kojima su vrijednosti u koloni prebrojano veće od srednje vrijednosti kolone prebrojano 
*/

--a
--ovo je Fudino rjesenje (nisam siguran kako uopste detektovati nesta sto je nasumicno)
CREATE VIEW view_9a
AS
	SELECT 
		LEN(br_narudzbe) AS duz_br_nar, 
		COUNT(LEN(br_narudzbe)) AS prebrojano
	FROM narudzba
	WHERE LEN(br_narudzbe) < 25
	GROUP BY LEN(br_narudzbe)

SELECT * FROM view_9a


--b
SELECT MIN (prebrojano), MAX (prebrojano)
FROM view_9a

--c
SELECT duz_br_nar, prebrojano
FROM view_9a
WHERE prebrojano > (SELECT avg (prebrojano) FROM view_9a) 

-----------------------------------------------------------------------------------------------------------------------------
/*
10.
a) Kreirati backup baze na default lokaciju.
b) Obrisati bazu.
*/

--a
BACKUP DATABASE BP2_2019_09_19
TO DISK = 'BP2_2019_09_19.bak'


--b
USE master
DROP DATABASE BP2_2019_09_19
