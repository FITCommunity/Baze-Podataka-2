/*
1.	Kroz SQL kod,naparaviti bazu podataka koja nosi ime vaseg broja dosijea sa default postavkama
*/
CREATE DATABASE BP2_2018_09_04
GO

USE BP2_2018_09_04
GO
/*
2.	Unutar svoje baze kreirati tabele sa sljedecom strukutrom
Autori
-	AutorID 11 UNICODE karaltera i primarni kljuc
-	Prezime 25 UNICODE karaktera (obavezan unos)
-	Ime 25 UNICODE karaktera (obavezan unos)
-	Telefon 20 UNICODE karaktera DEFAULT je NULL
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
Izdavaci 
-	IzdavacID 4 UNICODE karaktera i primarni kljuc
-	Naziv 100 UNICODE karaktera(obavezan unos),jedinstvena vrijednost
-	Biljeske 1000 UNICODE karaktera DEFAULT tekst je Lorem ipsum
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
Naslovi
-	NaslovID 6 UNICODE karaktera i primarni kljuc
-	IzdavacID ,spoljni kljuc prema tabeli Izdavaci
-	Naslov 100 UNICODE karaktera (obavezan unos)
-	Cijena monetarni tip
-	DatumIzdavanja datumska vraijabla (obavezan unos) DEFAULT datum unosa zapisa
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
NasloviAutori
-	AutorID ,spoljni kljuc prema tabeli Autori
-	NaslovID ,spoljni kljuc prema tabeli Naslovi
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL

*/

CREATE TABLE Autori
(
     AutorID NVARCHAR(11) CONSTRAINT PK_Autori PRIMARY KEY,
     Prezime NVARCHAR(25) NOT NULL,
     Ime NVARCHAR(25) NOT NULL,
     Telefon NVARCHAR(20) DEFAULT(NULL),
     DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
     DatumModifikovanjaZapisa DATE DEFAULT GETDATE() NOT NULL
)

CREATE TABLE Izdavaci
(
     IzdavacID NVARCHAR(4) CONSTRAINT PK_Izdavaci PRIMARY KEY,
     Naziv NVARCHAR(100) CONSTRAINT uq_naziv UNIQUE NOT NULL,
     Biljeske NVARCHAR(100) DEFAULT('Lorem ipsum'),
     DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
     DatumModifikovanjaZapisa DATE DEFAULT GETDATE() NOT NULL
)

CREATE TABLE Naslovi
(
     NaslovID NVARCHAR(6) CONSTRAINT PK_Naslovi PRIMARY KEY,
     IzdavacID NVARCHAR(4) CONSTRAINT FK_Naslovi_Izdavaci FOREIGN KEY(IzdavacID) REFERENCES Izdavaci(IzdavacID),
     Naslov NVARCHAR(100) NOT NULL,
     Cijena MONEY,
     DatumIzdavanja DATE DEFAULT GETDATE() NOT NULL,
     DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
     DatumModifikovanjaZapisa DATE DEFAULT GETDATE() NOT NULL
)

CREATE TABLE NasloviAutori
(
     AutorID NVARCHAR(11) CONSTRAINT FK_NasloviAutori_Autori FOREIGN KEY(AutorID) REFERENCES Autori(AutorID),
     NaslovID NVARCHAR(6) CONSTRAINT FK_NasloviAutori_Naslovi FOREIGN KEY(NaslovID) REFERENCES Naslovi(NaslovID),
     CONSTRAINT PK_NasloviAutori PRIMARY KEY(AutorID,NaslovID),
     DatumKreiranjaZapisaDATE DEFAULT GETDATE() NOT NULL,
     DatumModifikovanjaZapisa DATE DEFAULT GETDATE() NOT NULL
)

/*
2b. Generisati testne podatke i obavezno testirati da li su podaci u tabeli za svaki korak posebno:
-	Iz baze podataka pubs tabela authors,  putem podupita u tabelu Autori importovati sve slucajno sortirane zapise.
Vodite racuna da mapirate odgovarajuce kolone.

-	Iz baze podataka pubs i tabela publishers i pub_info , a putem podupita u tabelu Izdavaci importovati
sve slucajno sortirane zapise.Kolonu pr_info mapirati kao biljeske i iste skratiti na 100 karaktera.
Vodte racuna da mapirate odgovarajuce kolone

-	Iz baze podataka pubs tabela titles ,a putem podupita u tablu Naslovi importovati sve zapise.
Vodite racuna da mapirate odgvarajuce kolone

-	Iz baze podataka pubs tabela titleauthor, a putem podupita u tabelu NasloviAutori importovati zapise.
Vodite racuna da mapirate odgovrajuce koloone

*/

INSERT INTO Autori(AutorID, Prezime, Ime, Telefon)
SELECT a.au_id, a.au_lname, a.au_fname, a.phone
FROM 
(
	SELECT au_id,au_lname,au_fname,phone
	FROM pubs.dbo.authors
) AS a
ORDER BY newid()

SELECT * FROM Autori

INSERT INTO Izdavaci(IzdavacID, Naziv, Biljeske)
SELECT p.pub_id, p.pub_name, p.Biljeske
FROM 
(
	SELECT P.pub_id,P.pub_name, CAST(PIN.pr_info AS nvarchar(100)) AS Biljeske
	FROM pubs.dbo.publishers AS P 
          INNER JOIN pubs.dbo.pub_info AS PIN ON P.pub_id = PIN.pub_id
) AS p
ORDER BY NEWID()

SELECT * FROM Izdavaci

INSERT INTO Naslovi(NaslovID, IzdavacID, Naslov, Cijena)
SELECT t.title_id, t.pub_id, t.title, t.price
FROM 
(
	SELECT title_id, pub_id,title, price
	FROM pubs.dbo.titles
) AS t

SELECT * FROM Naslovi

INSERT INTO NasloviAutori(AutorID, NaslovID)
SELECT ta.au_id, ta.title_id
FROM 
(
	SELECT au_id,title_id
	FROM pubs.dbo.titleauthor
) AS ta

SELECT * FROM NasloviAutori

/*
2c. Kreiranje nove tabele,importovanje podataka i modifikovanje postojece tabele:
     Gradovi
-	GradID ,automatski generator vrijednosti cija je pocetna vrijednost je 5 i uvrcava se za 5,primarni kljuc
-	Naziv 100 UNICODE karaktera (obavezan unos),jedinstvena vrijednost
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
-	Iz baze podataka pubs tebela authors a putem podupita u tablelu Gradovi imprtovati nazive gradova bez duplikata
-	Modifikovati tabelu Autori i dodati spoljni kljuc prema tabeli Gradovi

*/
CREATE TABLE Gradovi
(
     GradID INT CONSTRAINT PK_Gradovi PRIMARY KEY identity(5,5),
     Naziv nvarchar(100) CONSTRAINT uq_grad UNIQUE NOT NULL,
     DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
     DatumModifikovanjaZapisa DATE DEFAULT NULL
)

INSERT INTO Gradovi(Naziv)
SELECT a.city
FROM 
(
	SELECT DISTINCT city
	FROM pubs.dbo.authors
) AS a

ALTER TABLE Autori
ADD  GradID INT CONSTRAINT FK_Autori_Gradovi FOREIGN KEY(GradID) REFERENCES Gradovi(GradID)
GO
/*
2d. Kreirati dvije uskladistene procedure koja ce modifikovati podatke u tabelu Autori
-	Prvih deset autora iz tabele postaviti da su iz grada : San Francisco
-	Ostalim autorima podesiti grad na : Berkeley

*/
CREATE PROCEDURE proc_Autori_grad_sf
AS
BEGIN
     UPDATE Autori
     SET GradID = 
     (
          SELECT GradID
          FROM Gradovi
          WHERE Naziv = 'San Francisco'
     )
     WHERE AutorID IN 
     (
          SELECT top 10 AutorID
          FROM Autori
     )
END

EXEC proc_Autori_grad_sf
GO

CREATE PROCEDURE proc_Autori_grad_b
AS
BEGIN
     UPDATE Autori
     SET GradID = 
     (
          SELECT GradID
          FROM Gradovi
          WHERE Naziv = 'Berkeley'
     )
     WHERE GradID IS NULL
END

EXEC proc_Autori_grad_b

SELECT * FROM Autori
GO
/*
3.	Kreirati pogled sa seljdeceom definicijom: Prezime i ime autora (spojeno),grad,Naslov,cijena,izdavac i
biljeske ali samo one autore cije knjige imaju odredjenu cijenu i gdje je cijena veca od 10.
Takodjer naziv izdavaca u sredini imena treba ima ti slovo & i da su iz grada San Francisco.Obavezno testirati funkcijonalnost
*/

CREATE VIEW VIEW_Autori_Naslovi
AS
SELECT 
     A.Prezime + ' ' + A.Ime AS [Prezime i ime],
	G.Naziv AS Grad,
     N.Naslov,
     N.Cijena,
	I.Naziv AS Izdavac,
     I.Biljeske
FROM Autori AS A 
     INNER JOIN NasloviAutori AS NA ON A.AutorID = NA.AutorID 
     INNER JOIN Naslovi AS N ON NA.NaslovID = N.NaslovID 
     INNER JOIN Izdavaci AS I ON N.IzdavacID = I.IzdavacID 
     INNER JOIN Gradovi AS G ON A.GradID = G.GradID
WHERE N.Cijena IS NOT NULL AND 
      N.Cijena > 10 AND 
      I.Naziv LIKE '%&%' AND 
      G.Naziv = 'San Francisco'

SELECT * FROM VIEW_Autori_Naslovi
/*
4.	Modifikovati tabelu autori i dodati jednu kolonu:

-	Email,polje za unos 100 UNICODE kakraktera ,DEFAULT je NULL

*/

ALTER TABLE Autori
ADD Email NVARCHAR(100) DEFAULT NULL
GO
/*
5.	Kreirati dvije uskladistene procedure koje ce modifikovati podatke u tabeli Autori i svim autorima generisati novu email adresu:
-	Prva procedura u formatu Ime.Prezime@fit.ba svim autorima iz grada San Francisco
-	Druga procedura u formatu Prezime.ime@fit.ba svim autorima iz grada Berkeley

*/
ALTER PROCEDURE proc_Autori_Email_sf
AS
BEGIN
     UPDATE Autori
     SET Email = Ime + '.' + Prezime + '@fit.ba',
         DatumModifikovanjaZapisa = GETDATE()
     WHERE GradID IN 
     (
          SELECT GradID
          FROM Gradovi
          WHERE Naziv = 'San Francisco'
     )
END

EXEC proc_Autori_Email_sf
GO

ALTER PROCEDURE proc_Autori_Email_b
AS
BEGIN
     UPDATE Autori
     SET Email = Prezime + '.' + Ime + '@fit.ba',
         DatumModifikovanjaZapisa = GETDATE()
     WHERE GradID IN 
     (
          SELECT GradID
          FROM Gradovi
          WHERE Naziv = 'Berkeley'
     )
END

EXEC proc_Autori_Email_b

SELECT * FROM Autori

/*
6.	Iz baze podataka AdventureWorks2014 u lokalnu,privremenu,tabelu u vasu bazu podataka imoportovati zapise o osobama ,
a putem podupita. Lista kolona je Title,LastName,FirstName,
EmailAddress,PhoneNumber,CardNumber.
Kreirati dvije dodatne kolone UserName koja se sastoji od spojenog imena i prezimena(tacka izmedju) i
kolona Password za lozinku sa malim slovima dugacku 16 karaktera.Lozinka se generise putem SQL funkcije za
slucajne i jednistvene ID vrijednosti.Iz lozinke trebaju biti uklonjene sve crtice '-' i zamjenjene brojem '7'.
Uslovi su da podaci ukljucuju osobe koje imaju i nemaju kreditanu karticu, a 
NULL vrijesnot u koloni Titula treba zamjenuti sa 'N/A'.Sortirati prema prezimenu i imenu.
Testirati da li je tabela sa podacima kreirana

*/

SELECT 
     p.Titula,
     p.FirstName,
     p.LAStName,
     p.EmailAddress,
     p.PhoneNumber,
     p.CardNumber,
     p.UserName,
     p.Lozinka
INTO #temp
FROM 
(
	SELECT 
          ISNULL(P.Title,'N/A') AS Titula,
          P.FirstName,
          P.LAStName,
          EA.EmailAddress,
          PP.PhoneNumber
          ,CC.CardNumber,
		LOWER(P.FirstName + '.' + P.LAStName) AS UserName,
		LOWER(REPLACE(LEFT(NEWID(),16), '-', '7')) AS Lozinka
	FROM AdventureWorks2014.Person.Person AS P 
          INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA ON P.BusinessEntityID = EA.BusinessEntityID 
          INNER JOIN AdventureWorks2014.Person.PersonPhone AS PP ON P.BusinessEntityID = PP.BusinessEntityID 
          LEFT JOIN AdventureWorks2014.Sales.PersonCreditCard AS PCC ON P.BusinessEntityID = PCC.BusinessEntityID 
          LEFT JOIN AdventureWorks2014.Sales.CreditCard AS CC ON PCC.CreditCardID = CC.CreditCardID
) AS p
ORDER BY p.LastName,p.FirstName

SELECT * FROM #temp
/*
7.	Kreirati indeks koji ce nad privremenom tabelom iz prethodnog koraka,primarno,maksimalno 
ubrzati upite koje koriste kolonu UserName,a sekundarno nad kolonama LastName i FirstName.Napisati testni upit
*/
CREATE NONCLUSTERED INDEX IX_Privremena_UserName
ON #temp (UserName)
INCLUDE(LAStName,FirstName)

SELECT LAStName, FirstName
FROM #temp
WHERE UserName LIKE '%s'
GO
/*
8.	Kreirati uskladistenu proceduru koja brise sve zapise iz privremen tabele koje nemaju kreditnu karticu.
Obavezno testirati funkcjionalnost
*/
CREATE procedure proc_Privremena_DELETE_NULL
AS
BEGIN
DELETE FROM #temp
WHERE CardNumber IS NULL
END

EXEC proc_Privremena_DELETE_NULL

SELECT * FROM #temp
/*
9.	Kreirati backup vase baze na default lokaciju servera i nakon toga obrisati privremenu tabelu
*/
BACKUP DATABASE BP2_2018_09_04 TO
disk = 'BP2_2018_09_04.bak'

DROP TABLE #temp
GO
/*
10.	Kreirati proceduru koja brise sve zapise i svih tabela unutar jednog izvrsenja.Testirati da li su podaci obrisani
*/
CREATE PROCEDURE proc_svizapisi_DELETE
AS
BEGIN
     ALTER TABLE NasloviAutori
     DROP CONSTRAINT FK_NasloviAutori_Autori
     ALTER TABLE NasloviAutori
     DROP CONSTRAINT FK_NasloviAutori_Naslovi
     ALTER TABLE Autori
     DROP CONSTRAINT FK_Autori_Gradovi
     ALTER TABLE Naslovi
     DROP CONSTRAINT FK_Naslovi_Izdavaci
     DELETE FROM NasloviAutori
     DELETE FROM Autori
     DELETE FROM Gradovi
     DELETE FROM Naslovi
     DELETE FROM Izdavaci
END

EXEC proc_svizapisi_DELETE
