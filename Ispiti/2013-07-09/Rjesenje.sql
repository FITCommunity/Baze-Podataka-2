/* 1. Kreirati bazu podataka pod nazivom: BrojDosijea (npr. 2046) bez posebnog kreiranja data i log fajla.*/

CREATE DATABASE BP2_2013_07_09
GO

USE BP2_2013_07_09
GO
/*2.
U vašoj bazi podataka keirati tabele sa sljedećim parametrima:
- Kupci
	- KupacID, automatski generator vrijednosti i primarni ključ
 	- Ime, polje za unos 35 UNICODE karaktera (obavezan unos),
	- Prezime, polje za unos 35 UNICODE karaktera (obavezan unos),
	- Telefon, polje za unos 15 karaktera (nije obavezan),
	- Email, polje za unos 50 karaktera (nije obavezan),
	- KorisnickoIme, polje za unos 15 karaktera (obavezan unos) jedINstvena vrijednost,
	- LozINka, polje za unos 15 karaktera (obavezan unos)
- Proizvodi
	- ProizvodID, automatski generator vrijednosti i primarni ključ
	- Sifra, polje za unos 25 karaktera (obavezan unos)
	- Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
	- Cijena, polje za unos DECIMALnog broj (obavezan unos)
	- Zaliha, polje za unos cijelog broja (obavezan unos)

- Narudzbe 

 	- NarudzbaID, automatski generator vrijednosti i primarni ključ
 	- KupacID, spoljni ključ prema tabeli Kupci,
	- ProizvodID, spoljni ključ prema tabeli Proizvodi,
	- KolicINa, polje za unos cijelog broja (obavezan unos)
	- Popust, polje za unos DECIMALnog broj (obavezan unos), DEFAULT JE 0

*/

CREATE TABLE Kupci
(
	KupacID INT CONSTRAINT PK_Kupci PRIMARY KEY IDENTITY(1,1),
	Ime NVARCHAR(35) NOT NULL,
	Prezime  NVARCHAR(35) NOT NULL,
	Telefon NVARCHAR(15),
	Email NVARCHAR(50),
	KorisnickoIme NVARCHAR(15) CONSTRAINT uq_korisnickoime UNIQUE nonclustered NOT NULL,
	LozINka NVARCHAR(15) NOT NULL
)

CREATE TABLE Proizvodi
(
	ProizvodID INT CONSTRAINT PK_Proizvodi PRIMARY KEY IDENTITY(1,1),
	Sifra NVARCHAR(25) NOT NULL,
	Naziv NVARCHAR(50) NOT NULL,
	Cijena DECIMAL(8,2) NOT NULL,
	Zaliha INT NOT NULL,
)

CREATE TABLE Narudzbe
(
	NarudzbaID INT CONSTRAINT PK_Narudzbe PRIMARY KEY IDENTITY(1,1),
	KupacID INT CONSTRAINT FK_Narudzbe_Kupci FOREIGN KEY (KupacID) REFERENCES Kupci(KupacID),
	ProizvodID INT CONSTRAINT FK_Narudzbe_Proizvodi FOREIGN KEY (ProizvodID) REFERENCES Proizvodi(ProizvodID),
	KolicINa INT NOT NULL,
	Popust DECIMAL(8,2) DEFAULT(0) NOT NULL
)


/*3.

 Modifikovati tabele Proizvodi i Narudzbe i to sljedeća polja:
	- Zaliha (tabela Proizvodi) - omogućiti unos DECIMALnog broja
	- KolicINa (tabela Narudzbe) - omogućiti unos DECIMALnog broja

*/
ALTER TABLE Proizvodi
ALTER COLUMN Zaliha DECIMAL(8,2) NOT NULL

ALTER TABLE Narudzbe
ALTER COLUMN KolicINa DECIMAL(8,2) NOT NULL


/*4.
Koristeći bazu podataka AdventureWorksLT 2012 i tabelu SalesLT.Customer, preko INSERT I SELECT komande importovati 10 zapisa
u tabelu Kupci i to sljedeće kolone:
	- FirstName -> Ime
	- LAStName -> Prezime
	- Phone -> Telefon
	- EmailAddress -> Email
	- Sve do znaka '@' u koloni EmailAddress -> KorisnickoIme
	- Prvih 8 karaktera iz kolone PASswordHASh -> LozINka

*/
INSERT INTO Kupci
SELECT TOP 
	10 C.FirstName,
	C.LAStName,
	C.Phone,
	C.EmailAddress,
	SUBSTRING(C.EmailAddress, 1, CHARINDEX('@', C.EmailAddress) - 1),
	LEFT(C.PasswordHash, 8)
FROM AdventureWorksLT2014.SalesLT.Customer AS C

SELECT * FROM Kupci

/*5.
Koristeći bazu podataka AdventureWorksLT2012 i tabelu SalesLT.Product importovati u temp tabelu po
nazivom tempBrojDosijea (npr. temp2046) 5 proizvoda i to sljedeće kolone:
	
	- ProductName -> Sifra
	- Name -> Naziv
	- StandardCost -> Cijena

*/
SELECT TOP 5 
	P.ProductNumber AS Sifra,
	P.Name AS Naziv,
	P.StandardCost AS Cijena
INTO #temp
FROM AdventureWorksLT2014.SalesLT.Product AS P

SELECT * FROM #temp
GO
/*6.
. U vašoj bazi podataka kreirajte stored proceduru koja će raditi INSERT podataka u tabelu Narudzbe. 
Podaci se moraju unijeti preko parametara. Također , u proceduru dodati ažuriranje (UPDATE) polja 'Zaliha' (tabela Proizvodi) u 
zavisnosti od prosljeđene količINe. Proceduru pohranite pod nazivom usp_Narudzbe_INSERT.
*/
CREATE PROCEDURE proc_Narudzbe_INSERT
(
	@KupacID INT,
	@ProizvodID INT,
	@KolicINa DECIMAL(8,2),
	@Popust DECIMAL(8,2)
)
AS
BEGIN
	INSERT INTO Narudzbe
	VALUES (@KupacID, @ProizvodID, @KolicINa, @Popust)

	UPDATE Proizvodi
	SET Zaliha = Zaliha - @KolicINa
	WHERE ProizvodID = @ProizvodID
END

SELECT * FROM Proizvodi

INSERT INTO Proizvodi
SELECT Sifra, Naziv, Cijena, 100
FROM #temp

/*7.
 Koristeći proceduru koju ste kreirali u prethodnom zadatku kreirati 5 narudžbi.
*/

SELECT * FROM Kupci

EXEC proc_Narudzbe_INSERT 1,1,5,0.1
EXEC proc_Narudzbe_INSERT 4,2,5,0.15
EXEC proc_Narudzbe_INSERT 6,4,20,0.2
EXEC proc_Narudzbe_INSERT 6,3,20,0.2
EXEC proc_Narudzbe_INSERT 9,5,30,0.3

SELECT * FROM Narudzbe

SELECT * FROM Proizvodi

GO



/*8.
 U vašoj bazi podataka kreirajte view koji će sadržavati sljedeća polja: ime kupca, prezime kupca, telefon, 
 šifra proizvoda, naziv proizvoda, cijena, količina, te ukupno. View pohranite pod nazivom view_Kupci_Narudzbe.
*/

CREATE VIEW view_Kupci_Narudzbe
AS
SELECT 
	K.Ime,
	K.Prezime,
	K.Telefon,
	P.Sifra,
	P.Naziv,
	P.Cijena,
	N.KolicINa,
	SUM((P.Cijena - (P.Cijena * N.Popust)) * N.KolicINa) AS Ukupno
FROM Kupci AS K 
	INNER JOIN Narudzbe AS N ON K.KupacID = N.KupacID 
	INNER JOIN Proizvodi AS P ON N.ProizvodID = P.ProizvodID
GROUP BY 
	K.Ime,
	K.Prezime,
	K.Telefon,
	P.Sifra,
	P.Naziv,
	P.Cijena,
	N.KolicINa

SELECT * FROM view_Kupci_Narudzbe

/*9.
. U vašoj bazi podataka kreirajte stored proceduru koja će na osnovu proslijeđenog imena ili 
prezimena kupca (jedan parametar) kao rezultat vratiti sve njegove narudžbe. 
Kao izvor podataka koristite view kreiran u zadatku 8. Proceduru pohranite pod nazivom usp_Kupci_Narudzbe.
*/
CREATE PROCEDURE usp_Kupci_Narudzbe
(
	@Ime NVARCHAR(35) = NULL,
	@Prezime NVARCHAR(35) = NULL
)
AS
BEGIN
	SELECT *
	FROM view_Kupci_Narudzbe
	WHERE (Ime = @Ime OR @Ime IS NULL) AND 
		  (Prezime  = @Prezime OR @Prezime IS NULL)
END

EXEC usp_Kupci_Narudzbe 'Rosmarie'
GO
/*10.
. U vašoj bazi podataka kreirajte stored proceduru koja će raditi DELETE zapisa iz tabele Proizvodi.
Proceduru pohranite pod nazivom usp_Proizvodi_DELETE. Pokušajte obrisati jedan od proizvoda kojeg ste dodatli u zadatku 5.
Modifikujte proceduru tako da obriše proizvod i svu njegovu historiju prodaje (Narudzbe).
*/

CREATE PROCEDURE usp_Proizvodi_DELETE
(
	@ProizvodID INT
)
AS
BEGIN
	DELETE FROM Narudzbe
	WHERE ProizvodID IN 
	(
		SELECT ProizvodID
		FROM Proizvodi
		WHERE ProizvodID = @ProizvodID
	)
	DELETE FROM Proizvodi
	WHERE ProizvodID = @ProizvodID
END

SELECT * FROM Narudzbe

EXEC usp_Proizvodi_DELETE 3