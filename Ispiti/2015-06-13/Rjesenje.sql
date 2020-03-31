/*
1. Kreirati bazu podataka koju ćete imenovati Vašim brojem dosijea. Fajlove baze smjestiti na sljedeće lokacije:
- Data fajl -> D:\DBMS\Data
- Log fajl -> D:\DBMS\Log
*/
CREATE DATABASE BP2_2015_06_13 ON PRIMARY
(
    NAME = BP2_2015_06_13,
    FILENAME = 'C:\BP2\Data\BP2_2015_06_13.mdf'
)
LOG ON
(
    NAME = BP2_2015_06_13_LOG,
    FILENAME = 'C:\BP2\Log\BP2_2015_06_13.ldf'
)
GO

USE BP2_2015_06_13
GO

/*2.
. U bazi podataka kreirati sljedeće tabele:
a. Kandidati
- Ime, polje za unos 30 karaktera (obavezan unos),
- Prezime, polje za unos 30 karaktera (obavezan unos),
- JMBG, polje za unos 13 karaktera (obavezan unos i jedinstvena vrijednost),
- DatumRodjenja, polje za unos datuma (obavezan unos),
- MjestoRodjenja, polje za unos 30 karaktera,
- Telefon, polje za unos 20 karaktera,
- Email, polje za unos 50 karaktera (jedinstvena vrijednost).
b. Testovi
- Datum, polje za unos datuma i vremena (obavezan unos),
- Naziv, polje za unos 50 karaktera (obavezan unos),
- Oznaka, polje za unos 10 karaktera (obavezan unos i jedinstvena vrijednost),
- Oblast, polje za unos 50 karaktera (obavezan unos),
- MaxBrojBodova, polje za unos cijelog broja (obavezan unos),
- Opis, polje za unos 250 karaktera.
c. RezultatiTesta
- Polozio, polje za unos ishoda testiranja – DA/NE (obavezan unos)
- OsvojeniBodovi, polje za unos decimalnog broja (obavezan unos),
- Napomena, polje za unos dužeg niza karaktera.

Napomena: Kandidat može da polaže više testova i za svaki test ostvari određene rezultate, pri čemu kandidat ne
može dva puta polagati isti test. Također, isti test može polagati više kandidata
*/

CREATE TABLE Kandidati
(
    KandidatID INT CONSTRAINT PK_Kandidati PRIMARY KEY IDENTITY(1,1),
    Ime NVARCHAR(30) NOT NULL,
    Prezime NVARCHAR(30) NOT NULL,
    JMBG NVARCHAR(13) CONSTRAINT UQ_jmbg UNIQUE NOT NULL,
    DatumRodjenja DATE NOT NULL,
    MjestoRodjenja NVARCHAR(30),
    Telefon NVARCHAR(20),
    Email NVARCHAR(50) CONSTRAINT UQ_email UNIQUE
)

CREATE table TesTOvi
(
    TestID INT CONSTRAINT PK_TesTOvi PRIMARY KEY IDENTITY(1,1),
    Datum DATETIME NOT NULL,
    Naziv NVARCHAR(50) NOT NULL,
    Oznaka NVARCHAR(10) CONSTRAINT uq_oznaka UNIQUE NOT NULL,
    Oblast NVARCHAR(50) NOT NULLl,
    MaxBrojBodova INT NOT NULL,
    Opis NVARCHAR(250)
)

CREATE TABLE RezultatiTesta
(
    TestID INT CONSTRAINT FK_RezultatiTesta_TesTOvi FOREIGN KEY(TestID) REFERENCES TesTOvi(TestID),
    KandidatID INT CONSTRAINT FK_RezultatiTesta_Kandidati FOREIGN KEY(KandidatID) REFERENCES Kandidati(KandidatID),
    CONSTRAINT PK_RezultatiTesta PRIMARY KEY(TestID,KandidatID),
    Polozio BIT NOT NULL,
    OsvojeniBodovi DECIMAL(8,2) NOT NULL,
    Napomena TEXT
)


/*3.
Koristeći AdventureWorks2014 bazu podataka, imporTOvati 10 kupaca u tabelu Kandidati i TO sljedeće
kolONe:
a. FirstName (PersON) -> Ime,
b. LastName (PersON) -> Prezime,
c. Zadnjih 13 karaktera kolONe rowguid iz tabele CusTOmer (Crticu zamijeniti brojem 0) -> JMBG,
d. ModifiedDate (CusTOmer) -> DatumRodjenja,
e. City (Address) -> MjestoRodjenja,
f. PhONeNumber (PersONPhONe) -> Telefon,
g. EmailAddress (EmailAddress) -> Email.
Također, u tabelu TesTOvi unijeti minimalno tri testa sa proizvoljnim podacima.
*/
INSERT INTO Kandidati
SELECT TOP 10 
    P.FirstName,
    P.LastName,
    REPLACE(RIGHT(C.rowguid,13), '-', '0'),
	C.ModifiedDate,
    A.City,
    PP.PhONeNumber,
    EA.EmailAddress
FROM AdventureWorks2014.Sales.CusTOmer AS C 
    INNER JOIN AdventureWorks2014.PersON.PersON AS P ON C.PersONID = P.BusinessEntityID 
    INNER JOIN AdventureWorks2014.PersON.BusinessEntityAddress AS BEA ON P.BusinessEntityID = BEA.BusinessEntityID I
    INNER JOIN AdventureWorks2014.PersON.Address AS A ON BEA.AddressID = A.AddressID 
    INNER JOIN AdventureWorks2014.PersON.PersONPhONe AS PP ON P.BusinessEntityID = PP.BusinessEntityID 
    INNER JOIN AdventureWorks2014.PersON.EmailAddress AS EA ON P.BusinessEntityID = EA.BusinessEntityID

INSERT INTO Testovi(Datum, Naziv, Oznaka, Oblast, MaxBrojBodova)
VALUES ('20150613','Programiranje I','PRI','Programiranje',100),
	   ('20150613','Programiranje II','PRII','Programiranje',100),
	   ('20150613','Programiranje III','PRIII','Programiranje',100)
GO
/*4.
Kreirati sTOred proceduru koja će na osnovu proslijeđenih parametara služiti za unos podataka u tabelu
RezultatiTesta. Proceduru pohraniti pod nazivom usp_RezultatiTesta_Insert. Obavezno testirati ispravnost
kreirane procedure (unijeti proizvoljno minimalno 10 rezultata za različite tesTOve).
*/
CREATE PROCEDURE usp_RezultatiTesta_Insert
(
    @TestID INT,
    @KandidatID INT,
    @Polozio BIT,
    @OsvBodovi DECIMAL(8,2)
)
AS
BEGIN
INSERT INTO RezultatiTesta(TestID, KandidatID, Polozio, OsvojeniBodovi)
VALUES (@TestID,@KandidatID,@Polozio,@OsvBodovi)
END

EXEC usp_RezultatiTesta_Insert 1,3,1,88
EXEC usp_RezultatiTesta_Insert 1,5,1,77
EXEC usp_RezultatiTesta_Insert 1,9,0,45
EXEC usp_RezultatiTesta_Insert 2,1,1,65
EXEC usp_RezultatiTesta_Insert 2,6,1,70
EXEC usp_RezultatiTesta_Insert 2,5,1,74
EXEC usp_RezultatiTesta_Insert 3,1,0,50
EXEC usp_RezultatiTesta_Insert 3,8,1,65
EXEC usp_RezultatiTesta_Insert 3,4,1,80
EXEC usp_RezultatiTesta_Insert 3,10,1,100

SELECT * FROM RezultatiTesta


/*5.
Kreirati view (pogled) nad podacima koji će sadržavati sljedeća polja: ime i prezime, jmbg, Telefon i email
kandidata, zatim datum, naziv, oznaku, oblast i max. broj bodova na testu, te polje položio, osvojene bodove i
procentualni rezultat testa. View pohranite pod nazivom view_Rezultati_Testiranja
*/
CREATE VIEW view_Rezultati_Testiranja
AS
SELECT 
    K.Ime + ' ' + K.Prezime AS [Ime i prezime],
	K.JMBG,
    K.Telefon,
    K.Email,
    T.Datum,
	T.Naziv,
    T.Oznaka,
    T.Oblast,
    T.MaxBrojBodova,
	RT.Polozio,
    RT.OsvojeniBodovi,
	FLOOR((RT.OsvojeniBodovi/T.MaxBrojBodova)* 100) AS Procenat
FROM Kandidati as K 
    INNER JOIN RezultatiTesta AS RT ON K.KandidatID = RT.KandidatID 
    INNER JOIN TesTOvi AS T ON RT.TestID = T.TestID

SELECT * FROM view_Rezultati_Testiranja


/*6.
Kreirati sTOred proceduru koja će na osnovu proslijeđenih parametara @OznakaTesta i @Polozio prikazivati
rezultate testiranja. Kao izvor podataka koristiti prethodno kreirani view. Proceduru pohraniti pod nazivom
usp_RezultatiTesta_SELECTByOznaka. Obavezno testirati ispravnost kreirane procedure
*/

CREATE PROCEDURE usp_RezultatiTesta_SELECTByOznaka
(
    @OznakaTesta NVARCHAR(10),
    @Polozio BIT
)
AS
BEGIN
    SELECT *
    FROM view_Rezultati_Testiranja
    WHERE Oznaka = @OznakaTesta AND 
          Polozio = @Polozio
END

EXEC usp_RezultatiTesta_SELECTByOznaka 'PRI', 0

GO


/*7.
 Kreirati proceduru koja će služiti za izmjenu rezultata testiranja. Proceduru pohraniti pod nazivom
usp_RezultatiTesta_Update. Obavezno testirati ispravnost kreirane procedure
*/

CREATE PROCEDURE usp_RezultatiTesta_Update
(
    @TestID INT,
    @kandidatID INT,
    @Polozio BIT,
    @OsvBodovi DECIMAL(8,2),
    @Napomena TEXT
)
AS
BEGIN
    UPDATE RezultatiTesta
    SET 
        Polozio = @Polozio,
        OsvojeniBodovi = @OsvBodovi,
        Napomena = @Napomena
    WHERE TestID = @TestID AND 
          KandidatID = @kandidatID
END

SELECT * FROM RezultatiTesta

EXEC usp_RezultatiTesta_Update 1, 9, 1, 55, 'X'
GO

/*8.
Kreirati sTOred proceduru koja će služiti za brisanje tesTOva zajedno sa svim rezultatima testiranja. Proceduru
pohranite pod nazivom usp_TesTOvi_DELETE. Obavezno testirati ispravnost kreirane procedure.
*/

CREATE PROCEDURE usp_Testovi_DELETE
(
    @TestID INT
)
AS
BEGIN
    DELETE FROM RezultatiTesta
    WHERE TestID IN 
    (
        SELECT TestID
        FROM Testovi
        WHERE TestID = @TestID
    )
    DELETE FROM Testovi
    WHERE TestID = @TestID
END

EXEC usp_TesTOvi_DELETE 2


/*9.
Kreirati TRIGGER koji će spriječiti brisanje rezultata testiranja. Obavezno testirati ispravnost kreiranog TRIGGERa.
*/

CREATE TRIGGER tr_RezultatiTestiranja_DELETE
ON RezultatiTesta INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Nije dozvoljeno brisanje zapisa'
    ROLLBACK
END

DELETE FROM RezultatiTesta
WHERE TestID = 3


/*10. Uraditi full BACKUP Vaše baze podataka na lokaciju D:\DBMS\BACKUP*/

BACKUP DATABASE BP2_2015_06_13 TO
DISK = 'C:\BP2\BACKUP\BP2_2015_06_13.bak'