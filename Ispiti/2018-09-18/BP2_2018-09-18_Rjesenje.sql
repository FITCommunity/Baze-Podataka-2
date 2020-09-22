/*1.Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea sa default postavkama*/
CREATE DATABASE BP2_2018_09_18
GO

USE BP2_2018_09_18
GO

/*2.
Unutar svoje baze podataka kreirati tabele sa sljedećem strukturom:
Autori
• AutorID, 11 UNICODE karaktera i primarni ključ
• Prezime, 25 UNICODE karaktera (obavezan unos)
• Ime, 25 UNICODE karaktera (obavezan unos)
• ZipKod, 5 UNICODE karaktera, DEFAULT je NULL
• DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
• DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
Izdavaci
• IzdavacID, 4 UNICODE karaktera i primarni ključ
• Naziv, 100 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
• Biljeske, 1000 UNICODE karaktera, DEFAULT tekst je Lorem ipsum
• DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
• DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
Naslovi
• NaslovID, 6 UNICODE karaktera i primarni ključ
• IzdavacID, spoljni ključ prema tabeli „Izdavaci“
• Naslov, 100 UNICODE karaktera (obavezan unos)
• Cijena, monetarni tip podatka
• Biljeske, 200 UNICODE karaktera, DEFAULT tekst je The quick brown fox jumps over the lazy dog
• DatumIzdavanja, datum izdanja naslova (obavezan unos) DEFAULT je datum unosa zapisa
• DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
• DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
NasloviAutori (Više autora može raditi na istoj knjizi)
• AutorID, spoljni ključ prema tabeli „Autori“
• NaslovID, spoljni ključ prema tabeli „Naslovi“
• DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
• DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
*/
CREATE TABLE Autori
(
	 AutorID NVARCHAR(11) CONSTRAINT PK_Autori PRIMARY KEY,
	 Prezime NVARCHAR(25) NOT NULL,
	 Ime NVARCHAR(25) NOT NULL,
	 ZipKod NVARCHAR(5) DEFAULT NULL,
	 DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
	 DatumModifikovanjaZapisa DATE DEFAULT NULL
)

CREATE TABLE Izdavaci
(
	 IzdavacID NVARCHAR(4) CONSTRAINT PK_Izdavaci PRIMARY KEY,
	 Naziv NVARCHAR(100) CONSTRAINT UQ_naziv UNIQUE NOT NULL,
	 Biljeske NVARCHAR(1000) DEFAULT 'Lorem ipsum',
	 DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
	 DatumModifikovanjaZapisa DATE DEFAULT NULL
)

CREATE TABLE Naslovi
(
	 NaslovID NVARCHAR(6) CONSTRAINT pk_Naslovi PRIMARY KEY,
	 IzdavacID NVARCHAR(4) CONSTRAINT fk_Naslovi_Izdavaci FOREIGN KEY(IzdavacID) REFERENCES Izdavaci(IzdavacID),
	 Naslov NVARCHAR(100) NOT NULL,
	 Cijena MONEY,
	 Biljeske NVARCHAR(200) DEFAULT 'The quick brown fox jumps over the lazy dog',
	 DatumIzdavanja DATE DEFAULT GETDATE() NOT NULL,
	 DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
	 DatumModifikovanjaZapisa DATE DEFAULT NULL
)


CREATE TABLE NasloviAutori
(
	 AutorID NVARCHAR(11) CONSTRAINT FK_NaslovAutori_Autori foreign key(AutorID) references Autori(AutorID),
	 NaslovID NVARCHAR(6) CONSTRAINT FK_NaslovAutori_Naslovi foreign key(NaslovID) references Naslovi(NaslovID),
	 DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
	 DatumModifikovanjaZapisa DATE DEFAULT NULL
)


/*2b
Generisati testne podatake i obavezno testirati da li su podaci u tabelema za svaki korak zasebno :
• Iz baze podataka pubs tabela „authors“, a putem podupita u tabelu „Autori“ importovati sve slučajno sortirane
zapise. Vodite računa da mapirate odgovarajuće kolone.

• Iz baze podataka pubs i tabela („publishers“ i pub_info“), a putem podupita u tabelu „Izdavaci“ importovati sve
slučajno sortirane zapise. Kolonu pr_info mapirati kao bilješke i iste skratiti na 100 karaktera. Vodite računa da
mapirate odgovarajuće kolone i tipove podataka.

• Iz baze podataka pubs tabela „titles“, a putem podupita u tabelu „Naslovi“ importovati one naslove koji imaju
bilješke. Vodite računa da mapirate odgovarajuće kolone.

• Iz baze podataka pubs tabela „titleauthor“, a putem podupita u tabelu „NasloviAutori“ zapise. Vodite računa da
mapirate odgovarajuće kolone.
*/
INSERT INTO Autori(AutorID, Prezime, Ime, ZipKod)
SELECT a.au_id, a.au_lname, a.au_fname, a.zip
FROM 
(
	SELECT a.au_id, a.au_lname, a.au_fname, a.zip
	FROM pubs.dbo.authors as a
) AS a
ORDER BY NEWID()

SELECT * FROM Autori

INSERT INTO Izdavaci(IzdavacID, Naziv, Biljeske)
SELECT b.pub_id, b.pub_name, b.Biljeske
FROM
(
	SELECT P.pub_id, P.pub_name, CAST(PIN.pr_info AS NVARCHAR(100)) AS Biljeske
	FROM pubs.dbo.publishers AS P 
		INNER JOIN pubs.dbo.pub_info AS PIN ON P.pub_id = PIN.pub_id
) AS b
ORDER BY NEWID()

SELECT * FROM Izdavaci


INSERT INTO Naslovi(NaslovID, IzdavacID, Naslov, Cijena, Biljeske)
SELECT t.title_id, t.pub_id, t.title, t.price, t.notes
FROM 
(
	SELECT t.title_id,t.pub_id,t.title,t.price,t.notes
	FROM pubs.dbo.titles AS t
	WHERE t.notes IS NOT NULL
) AS t

SELECT * FROM Naslovi

INSERT INTO NasloviAutori(AutorID, NaslovID)
SELECT ta.au_id, ta.title_id
FROM
(
	SELECT ta.au_id,ta.title_id
	FROM pubs.dbo.titleauthor AS ta
) AS ta

SELECT * FROM NasloviAutori

/*2c
Kreiranje nove tabele, importovanje podataka i modifikovanje postojeće tabele:
Gradovi
• GradID, automatski generator vrijednosti koji generiše neparne brojeve, primarni ključ
• Naziv, 100 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
• DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
• DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
✓ Iz baze podataka pubs tabela „authors“, a putem podupita u tabelu „Gradovi“ importovati nazive gradove bez
duplikata.
✓ Modifikovati tabelu Autori i dodati spoljni ključ prema tabeli Gradovi:
*/
CREATE TABLE Gradovi
(
	GradID INT CONSTRAINT PK_Gradovi PRIMARY KEY IDENTITY(1,2),
	Naziv NVARCHAR(100) CONSTRAINT uq_grad UNIQUE NOT NULL,
	DatumKreiranjaZapisa DATE DEFAULT GETDATE() NOT NULL,
	DatumModifikovanjaZapisa DATE DEFAULT NULL
)

INSERT INTO Gradovi(Naziv)
SELECT g.city
FROM
(
	SELECT DISTINCT city
	FROM pubs.dbo.authors
) AS g

ALTER TABLE Autori
ADD GradID INT CONSTRAINT FK_Autori_Gradovi FOREIGN KEY(GradID) REFERENCES Gradovi(GradID)
GO


/*2d
Kreirati dvije uskladištene proceduru koja će modifikovati podataka u tabeli Autori:
• Prvih pet autora iz tabele postaviti da su iz grada: Salt Lake City
• Ostalim autorima podesiti grad na: Oakland

Vodite računa da se u tabeli modifikuju sve potrebne kolone i obavezno testirati da li su podaci u tabeli za svaku proceduru
posebno.
*/
CREATE PROCEDURE proc_Autori_mod_slc
AS
BEGIN
	UPDATE Autori
	SET 
		GradID = 
		(
			SELECT GradID
			FROM Gradovi
			WHERE Naziv = 'Salt Lake City'
		),
		DatumModifikovanjaZapisa = GETDATE()
	WHERE AutorID IN ( SELECT TOP 5 AutorID FROM Autori )
END

EXEC proc_Autori_mod_slc

SELECT * FROM Autori
GO

CREATE PROCEDURE proc_Autori_mod_oak
AS
BEGIN
	UPDATE Autori
	SET GradID = 
	(
		SELECT GradID
		FROM Gradovi
		WHERE Naziv = 'Oakland'
	),
	DatumModifikovanjaZapisa = GETDATE()
	WHERE GradID IS NULL
END

EXEC proc_Autori_mod_oak

SELECT * FROM Autori
GO

/*3.
Kreirati pogled sa sljedećom definicijom: Prezime i ime autora (spojeno), grad, naslov, cijena, bilješke o naslovu i naziv
izdavača, ali samo za one autore čije knjige imaju određenu cijenu i gdje je cijena veća od 5. Također, naziv izdavača u sredini
imena ne smije imati slovo „&“ i da su iz autori grada Salt Lake City 
*/

CREATE VIEW view_Autori_Naslovi
AS
SELECT
	A.Prezime + ' ' + A.Ime AS [Ime i prezime],
	G.Naziv AS Grad,
	N.Naslov,
	N.Cijena,
	N.Biljeske,
	I.Naziv AS Izdavac
FROM Autori as A 
	INNER JOIN NasloviAutori AS NA ON A.AutorID = NA.AutorID 
	INNER JOIN Naslovi AS N ON NA.NaslovID = N.NaslovID 
	INNER JOIN Izdavaci AS I ON N.IzdavacID = I.IzdavacID 
	INNER JOIN Gradovi AS G ON A.GradID = G.GradID
WHERE 
	N.Cijena IS NOT NULL AND 
	N.Cijena > 5 AND 
	I.Naziv NOT LIKE '%&%' AND 
	G.Naziv = 'Salt Lake City'

SELECT * FROM  view_Autori_Naslovi


/*4.
Modifikovati tabelu Autori i dodati jednu kolonu:
• Email, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
*/
ALTER TABLE Autori
ADD Email NVARCHAR(100) DEFAULT NULL
GO

/*5.
Kreirati dvije uskladištene proceduru koje će modifikovati podatke u tabelu Autori i svim autorima generisati novu email
adresu:
• Prva procedura: u formatu: Ime.Prezime@fit.ba svim autorima iz grada Salt Lake City
• Druga procedura: u formatu: Prezime.Ime@fit.ba svim autorima iz grada Oakland
*/
CREATE PROCEDURE proc_Autori_Email_slc
AS
BEGIN
	UPDATE Autori
	SET 
		Email = Ime + '.' + Prezime + '@fit.ba', 
		DatumModifikovanjaZapisa = GETDATE()
	WHERE GradID IN 
	(
		SELECT GradID
		FROM Gradovi
		WHERE Naziv = 'Salt Lake City'
	)
END

EXEC proc_Autori_Email_slc

SELECT * FROM Autori
GO

CREATE PROCEDURE proc_Autori_Email_oak
AS
BEGIN
	UPDATE Autori
	SET
		Email = Prezime + '.' + Ime + '@fit.ba',
		DatumModifikovanjaZapisa = GETDATE()
	WHERE GradID IN 
	(
		SELECT GradID
		FROM Gradovi
		WHERE Naziv = 'Oakland'
	)
END

EXEC proc_Autori_Email_oak

SELECT * FROM Autori

/*6.
z baze podataka AdventureWorks2014 u lokalnu, privremenu, tabelu u vašu bazi podataka importovati zapise o osobama, a
putem podupita. Lista kolona je: Title, LastName, FirstName, EmailAddress, PhoneNumber i CardNumber. Kreirate
dvije dodatne kolone: UserName koja se sastoji od spojenog imena i prezimena (tačka se nalazi između) i kolonu Password
za lozinku sa malim slovima dugačku 24 karaktera. Lozinka se generiše putem SQL funkciju za slučajne i jedinstvene ID
vrijednosti. Iz lozinke trebaju biti uklonjene sve crtice „-“ i zamijenjene brojem „7“. Uslovi su da podaci uključuju osobe koje
imaju i nemaju kreditnu karticu, a NULL vrijednost u koloni Titula zamjeniti sa podatkom 'N/A'. Sortirati prema prezimenu i
imenu istovremeno. Testirati da li je tabela sa podacima kreirana.
*/

SELECT
	T.Titula,
	T.LastName,
	T.FirstName,
	T.EmailAddress,
	T.PhoneNumber,
	T.CardNumber,
	T.UserName,
	T.Lozinka
INTO #temp
FROM
(
	SELECT 
		ISNULL(P.Title,'N/A') AS Titula,
		P.LastName,
		P.FirstName,
		EA.EmailAddress,
		PP.PhoneNumber,
		CC.CardNumber,
		LOWER(P.FirstName+'.'+P.LastName) AS UserName,
		LOWER(REPLACE(LEFT(NEWID(),24),'-','7')) as Lozinka
	FROM AdventureWorks2014.Person.Person AS P 
		INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA ON P.BusinessEntityID = EA.BusinessEntityID 
		INNER JOIN AdventureWorks2014.Person.PersonPhone AS PP ON P.BusinessEntityID = PP.BusinessEntityID 
		LEFT JOIN AdventureWorks2014.Sales.PersonCreditCard AS PCC ON P.BusinessEntityID = PCC.BusinessEntityID 
		LEFT JOIN AdventureWorks2014.Sales.CreditCard AS CC ON PCC.CreditCardID = CC.CreditCardID
) AS T
ORDER BY T.LastName, T.FirstName

SELECT * FROM #temp

/*7.
Kreirati indeks koji će nad privremenom tabelom iz prethodnog koraka, primarno, maksimalno ubrzati upite koje koriste
kolone LastName i FirstName, a sekundarno nad kolonam UserName. Napisati testni upit.
*/

CREATE NONCLUSTERED INDEX IX_Privremena_LastName_FirstName
ON #temp (LastName, FirstName)
INCLUDE (UserName)

SELECT LastName, FirstName
FROM #temp
WHERE UserName like '%d'
GO
/*8.
Kreirati uskladištenu proceduru koja briše sve zapise iz privremene tabele koji imaju kreditnu karticu Obavezno testirati
funkcionalnost procedure.
*/

CREATE PROCEDURE proc_Privremena_delete_notnull
AS
BEGIN
	DELETE FROM #temp
	WHERE CardNumber IS NOT NULL
END

exec proc_Privremena_delete_notnull

SELECT * FROM #temp


/*9. Kreirati backup vaše baze na default lokaciju servera i nakon toga obrisati privremenu tabelu*/

BACKUP DATABASE BP2_2018_09_18 TO
DISK = 'BP2_2018_09_18.bak'

DROP TABLE #temp
GO
/*10a Kreirati proceduru koja briše sve zapise iz svih tabela unutar jednog izvršenja. Testirati da li su podaci obrisani*/

CREATE PROCEDURE proc_Delete_zapise
AS
BEGIN
	ALTER TABLE NasloviAutori
	DROP CONSTRAINT fk_NaslovAutori_Naslovi

	ALTER TABLE NasloviAutori
	DROP CONSTRAINT fk_NaslovAutori_Autori

	ALTER TABLE Autori
	DROP CONSTRAINT FK_Autori_Gradovi

	ALTER TABLE Naslovi
	DROP CONSTRAINT fk_Naslovi_Izdavaci

	DELETE FROM NasloviAutori
	DELETE FROM Autori
	DELETE FROM Gradovi
	DELETE FROM Naslovi
	DELETE FROM Izdavaci
END

EXEC proc_Delete_zapise

/*10b Uraditi restore rezervene kopije baze podataka i provjeriti da li su svi podaci u izvornom obliku*/
RESTORE DATABASE BP2_2018_09_18 FROM
DISK = 'BP2_2018_09_18.bak'

SELECT * FROM Autori
SELECT * FROM Naslovi
SELECT * FROM Izdavaci
SELECT * FROM NasloviAutori
SELECT * FROM Gradovi