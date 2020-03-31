/*1.
Kreirati bazu podataka koju ćete imenovati Vašim brojem dosijea. Fajlove baze smjestiti na sljedeće lokacije:
- Data fajl -> D:\DBMS\Data
- Log fajl -> D:\DBMS\Log
*/
CREATE DATABASE BP2_2015_07_04 ON PRIMARY
(
    NAME = BP2_2015_07_04,
    FILENAME = 'C:\BP2\DATA\BP2_2015_07_04.mdf'
)
LOG ON
(
    NAME = BP2_2015_07_04,
    FILENAME = 'C:\BP2\LOG\BP2_2015_07_04.ldf'
)
GO

USE BP2_2015_07_04
GO
/*2.
U bazi podataka kreirati sljedeće tabele:
a. Klijenti
- JMBG, polje za unos 13 karaktera (obavezan unos i jedinstvena vrijednost),
- Ime, polje za unos 30 karaktera (obavezan unos),
- Prezime, polje za unos 30 karaktera (obavezan unos),
- Adresa, polje za unos 100 karaktera (obavezan unos),
- Telefon, polje za unos 20 karaktera (obavezan unos),
- Email, polje za unos 50 karaktera (jedinstvena vrijednost),
- Kompanija, polje za unos 50 karaktera.
b. Krediti
- Datum, polje za unos datuma (obavezan unos),
- Namjena, polje za unos 50 karaktera (obavezan unos),
- Iznos, polje za decimalnog broja (obavezan unos),
- BrojRata, polje za unos cijelog broja (obavezan unos),
- Osiguran, polje za unos bit vrijednosti (obavezan unos),
- Opis, polje za unos dužeg niza karaktera.
c. Otplate
- Datum, polje za unos datuma (obavezan unos)
- Iznos, polje za unos decimalnog broja (obavezan unos),
- Rata, polje za unos cijelog broja (obavezan unos),
- Opis, polje za unos dužeg niza karaktera.
Napomena: Klijent može uzeti više kredita, dok se kredit veže isključivo za jednog klijenta. Svaki kredit može imati
više otplata (otplata rata).
*/
CREATE TABLE Klijenti
(
    KlijentID INT CONSTRAINT PK_Klijenti PRIMARY KEY IDENTITY(1,1),
    JMBG NVARCHAR(13) CONSTRAINT UQ_JMBG UNIQUE NONCLUSTERED NOT NULL,
    Ime NVARCHAR(30) NOT NULL,
    Prezime NVARCHAR(30) NOT NULL,
    Adresa NVARCHAR(100) NOT NULL,
    TelefON NVARCHAR(20) NOT NULL,
    Email NVARCHAR(50) CONSTRAINT UQ_Email UNIQUE NONCLUSTERED,
    Kompanija NVARCHAR(50)
)

CREATE TABLE Krediti
(
    KreditID INT CONSTRAINT PK_Krediti PRIMARY KEY IDENTITY(1,1),
    KlijentID INT CONSTRAINT FK_Krediti_Klijenti FOREIGN KEY(KlijentID) REFERENCES Klijenti(KlijentID),
    Datum DATE NOT NULL,
    Namjena NVARCHAR(50) NOT NULL,
    Iznos DECIMAL(8,2) NOT NULL,
    BrojRata INT NOT NULL,
    Osiguran BIT NOT NULL,
    Opis TEXT
)

CREATE TABLE Otplate
(
    OtplataID INT CONSTRAINT PK_Otplate PRIMARY KEY identity(1,1),
    KreditID INT CONSTRAINT PK_Otplate_Krediti FOREIGN KEY(KreditID) REFERENCES Krediti(KreditID),
    Datum DATE NOT NULL,
    Iznos DECIMAL(8,2) NOT NULL,
    Rata INt NOT NULL,
    Opis TEXT
)

/*3.
Koristeći AdventureWorks2014 bazu podataka, imporTOvati 10 kupaca u tabelu Klijenti i TO sljedeće kolONe:
a. Zadnjih 13 karaktera kolONe rowguid (Crticu '-' zamijeniti brojem 1)-> JMBG,
b. FirstName (PersON) -> Ime,
c. LAStName (PersON) -> Prezime,
d. AddressLINe1 (Address) -> Adresa,
e. PhONeNumber (PersONPhONe) -> TelefON,
f. EmailAddress (EmailAddress) -> Email,
g. 'FIT' -> Kompanija
Također, u tabelu Krediti unijeti mINimalno tri zapisa sa proizvoljnim podacima
*/
INSERT INTO Klijenti
SELECT TOP 10 
    REPLACE(RIGHT(C.rowguid,13), '-', '1'),
	P.FirstName,
    P.LAStName,
    A.AddressLINe1,
    PP.PhONeNumber,
    EA.EmailAddress,
    'FIT'
FROM AdventureWorks2014.Sales.CusTOmer AS C 
    INNER JOIN AdventureWorks2014.PersON.PersON AS P ON C.PersONID = P.BusINessEntityID 
    INNER JOIN AdventureWorks2014.PersON.BusINessEntityAddress AS BEA ON P.BusINessEntityID = BEA.BusINessEntityID 
    INNER JOIN AdventureWorks2014.PersON.Address AS A ON BEA.AddressID = A.AddressID 
    INNER JOIN AdventureWorks2014.PersON.PersONPhONe AS PP ON P.BusINessEntityID =PP.BusINessEntityID 
    INNER JOIN AdventureWorks2014.PersON.EmailAddress AS EA ON P.BusINessEntityID = EA.BusINessEntityID

SELECT * FROM Klijenti


INSERT INTO Krediti (KlijentID, Datum, Namjena, Iznos, BrojRata, Osiguran) 
VALUES  (1,'20150704','Stambeni',70000,50,1),
		(2,'20150704','Stambeni',80000,55,1),
		(3,'20150704','Ne namjenski',7000,15,1)

SELECT * FROM Krediti
/*4.
. Kreirati sTOred proceduru koja će na osnovu proslijeđenih parametara služiti za unos podataka u tabelu
Otplate. Proceduru pohraniti pod nazivom usp_Otplate_INSERT. Obavezno testirati ispravnost kreirane
procedure (unijeti mINimalno 5 zapisa sa proizvoljnim podacima).
*/
CREATE PROCEDURE usp_Otplate_INSERT
(
    @KreditID INT,
    @Datum date,
    @Iznos DECIMAL(8,2),
    @Rata INt
)
AS
BEGIN
    INSERT INTO Otplate (KreditID, Datum, Iznos, Rata)
    VALUES (@KreditID, @Datum, @Iznos, @Rata)
END

EXEC usp_Otplate_INSERT 1,'20150704',500,1
EXEC usp_Otplate_INSERT 1,'20150704',500,2
EXEC usp_Otplate_INSERT 1,'20150704',500,3
EXEC usp_Otplate_INSERT 2,'20150704',450,1
EXEC usp_Otplate_INSERT 2,'20150704',450,2
EXEC usp_Otplate_INSERT 2,'20150704',450,3
EXEC usp_Otplate_INSERT 3,'20150704',300,1

SELECT * FROM Otplate
GO

/*5.
Kreirati view (pogled) nad podacima koji će prikazivati sljedeća polja: jmbg, ime i prezime, adresa, telefon i
email klijenta, zatim datum, namjenu i iznos kredita, te ukupan broj otplaćenih rata i ukupan otplaćeni iznos.
View pohranite pod nazivom view_Krediti_Otplate
*/
CREATE VIEW view_Klijenti_Otplate
AS
SELECT 
    K.JMBG,
    K.Ime + ' ' + K.Prezime AS [Ime i prezime],
	K.Adresa,
    K.Telefon,
    K.Email,
	KR.Datum,
    KR.Namjena,
    KR.Iznos,
	COUNT(O.KreditID) AS [Broj otplacenih rata],
	SUM(O.Iznos) AS [Ukupan otplacen iznos]
FROM Klijenti AS K 
    INNER JOIN Krediti AS KR ON K.KlijentID = KR.KlijentID 
    INNER JOIN Otplate AS O ON KR.KreditID = O.KreditID
GROUP BY 
    K.JMBG,
    K.Ime,
    K.Prezime,
    K.Adresa,
    K.Telefon,
    K.Email,
    KR.Datum,
    R.Namjena,
    KR.Iznos

SELECT * FROM view_Klijenti_Otplate

/*6.
Kreirati sTOred proceduru koja će na osnovu proslijeđenog parametra @JMBG prikazivati podatke o otplati
kredita. Kao izvor podataka koristiti prethodno kreirani view. Proceduru pohraniti pod nazivom
usp_Krediti_Otplate_SELECTByJMBG. Obavezno testirati ispravnost kreirane procedure
*/
CREATE PROCEDURE usp_Krediti_Otplate_SELECTByJMBG
(
    @JMBG NVARCHAR(13)
)
AS
BEGIN
    SELECT *
    FROM view_Klijenti_Otplate
    WHERE JMBG = @JMBG
END

EXEC usp_Krediti_Otplate_SelectByJMBG '1E7E0B0FDD67A'
GO
/*7.
. Kreirati proceduru koja će služiti za izmjenu podataka o otplati kredita. Proceduru pohraniti pod nazivom
usp_Otplate_UPDATE. Obavezno testirati ispravnost kreirane procedure
*/
CREATE PROCEDURE usp_Otplate_UPDATE
(
    @OtplataID INT,
    @KreditID INT,
    @Datum DATE,
    @Iznos DECIMAL(8,2),
    @Rata INT,
    @Opis TEXT
)
AS
BEGIN
    UPDATE Otplate
    SET 
        KreditID = @KreditID,
        Datum = @Datum,
        Iznos = @Iznos,
        Rata = @Rata,
        Opis = @Opis
    WHERE OtplataID = @OtplataID AND
          KreditID = @KreditID
END

SELECT * FROM Otplate

EXEC usp_Otplate_UPDATE 1,1,'20150704',550,1,'Izmjena'
GO
/*8.
Kreirati sTOred proceduru koja će služiti za brisanje kredita zajedno sa svim otplatama. Proceduru pohranite
pod nazivom usp_Krediti_DELETE. Obavezno testirati ispravnost kreirane procedure.
*/

CREATE PROCEDURE usp_Krediti_DELETE
(
    @KreditID INT
)
AS
BEGIN
    DELETE FROM Otplate
    WHERE KreditID IN 
    (
        SELECT KreditID
        FROM Krediti
        WHERE KreditID = @KreditID
    )
    DELETE FROM Krediti
    WHERE KreditID = @KreditID
END

EXEC usp_Krediti_DELETE 2
GO

/*9.
Kreirati TRIGGER koji će spriječiti brisanje zapisa u tabeli Otplate. TRIGGER pohranite pod nazivom
tr_Otplate_IO_DELETE. Obavezno testirati ispravnost kreiranog TRIGGERa
*/
CREATE TRIGGER tr_Otplate_IO_DELETE
ON Otplate INSTEAD OF DELETE
AS
PRINT 'Nije dozvoljeno brisati podatke'
ROLLBACK

DELETE FROM Otplate
WHERE KreditID = 3

/*Uraditi full BACKUP Vaše baze podataka na lokaciju D:\DBMS\BACKUP*/

BACKUP DATABASE BP2_2015_07_04 TO
DISK = 'BP2_2015_07_04.bak'