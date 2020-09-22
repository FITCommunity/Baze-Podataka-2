/*1. Kreirati bazu podataka pod nazivom: BrojDosijea (npr. 2046) bez posebnog kreiranja data i log fajla*/
CREATE DATABASE BP2_2014_06_10
GO

USE BP2_2014_06_10
GO
/*2.
 U Vašoj bazi podataka kreirati tabele sa sljedećim parametrima:
- Studenti
- StudentID, automatski generator vrijednosti i primarni ključ
- BrojDosijea, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
- Ime, polje za unos 35 UNICODE karaktera (obavezan unos)
- Prezime, polje za unos 35 UNICODE karaktera (obavezan unos)
- Godina studija, polje za unos cijelog broja (obavezan unos)
- NacinStudiranja, polje za unos 10 UNICODE karaktera (obavezan unos) DEFAULT je Redovan
- Email, polje za unos 50 karaktera (nije obavezan)
- Nastava
- NastavaID, automatski generator vrijednosti i primarni ključ
- Datum, polje za unos datuma i vremana (obavezan unos)
- Predmet, polje za unos 20 UNICODE karaktera (obavezan unos)
- Nastavnik, polje za unos 50 UNICODE karaktera (obavezan unos)
- Ucionica, polje za unos 20 UNICODE karaktera (obavezan unos)
- Prisustvo
- PrisustvoID, automatski generator vrijednosti i primarni ključ
- StudentID, spoljni ključ prema tabeli Studenti
- NastavaID, spoljni ključ prema tabeli Nastava
*/

CREATE TABLE Studenti
(
    StudentID INT CONSTRAINT PK_Studenti PRIMARY KEY IDENTITY(1,1),
    BrojDosijea NVARCHAR(10) CONSTRAINT uq_brojdosijea UNIQUE NOT NULL,
    Ime NVARCHAR(35) NOT NULL,
    Prezime NVARCHAR(35) NOT NULL,
    GodinaStudija INT NOT NULL,
    NacinStudiranja NVARCHAR(10) default('Redovan') NOT NULL,
    Email NVARCHAR(50)
)

CREATE TABLE Nastava
(
    NastavaID INT CONSTRAINT PK_Nastava PRIMARY KEY IDENTITY(1,1),
    Datum DATETIME NOT NULL,
    Predmet NVARCHAR(20) NOT NULL,
    Nastavnik NVARCHAR(50) NOT NULL,
    Ucionica NVARCHAR(20) NOT NULL
)

CREATE TABLE Prisustvo
(
    PrisustvoID INT CONSTRAINT PK_Prisustvo PRIMARY KEY IDENTITY(1,1),
    StudentID INT CONSTRAINT FK_Prisustvo_Studenti FOREIGN KEY(StudentID) REFERENCES Studenti(StudentID),
    NastavaID INT CONSTRAINT FK_Prisustvo_Nastava FOREIGN KEY(NastavaID) REFERENCES Nastava(NastavaID),
)

/*3.
Kreirati tabelu Predmeti sa sljedećim parametrima:
- PredmetID, automatski generator vrijednosti i primarni ključ
- Naziv, polje za unos 30 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
Modifikovati tabelu Nastava (ukloniti kolonu Predmet) i povezati je sa tabelom Predmeti. Koristeći INSERT
komandu u tabelu Predmeti unijeti tri zapisa
*/
CREATE TABLE Predmeti
(
    PredmetID INT CONSTRAINT PK_Predmeti PRIMARY KEY IDENTITY(1,1),
    Naziv NVARCHAR(30) CONSTRAINT UQ_Naziv UNIQUE NOT NULL
)

ALTER TABLE Nastava
DROP COLUMN Predmet

ALTER TABLE Nastava
ADD PredmetID INT CONSTRAINT FK_Nastava_Predmeti FOREIGN KEY(PredmetID) REFERENCES Predmeti(PredmetID)

INSERT INTO Predmeti
VALUES ('Programiranje I'),
	   ('Programiranje II'),
	   ('Programiranje III')

SELECT * FROM Predmeti

/*4.
Koristeći bazu podataka AdventureWorksLT2012 i tabelu SalesLT.Customer, preko INSERT i SELECT komande
importovati 10 zapisa u tabelu Studenti i to sljedeće kolone:
- Prva tri karaktera kolone Phone -> BrojDosijea
- FirstName -> Ime
- LastName -> Prezime
- 2 -> GodinaStudija
- DEFAULT -> NacinStudiranja
- EmailAddress -> Email
*/
INSERT INTO Studenti(BrojDosijea, Ime, Prezime, GodinaStudija, Email)
SELECT TOP 10 
    LEFT(C.Phone,3),
    C.FirstName,
    C.LastName,
    2,
	C.EmailAddress
FROM AdventureWorksLT2014.SalesLT.Customer AS C

SELECT * FROM Studenti
GO
/*5.
U Vašoj bazi podataka kreirajte stored proceduru koja će na osnovu proslijeđenih parametara raditi izmjenu
(UPDATE) podataka u tabeli Studenti. Proceduru pohranite pod nazivom usp_Studenti_Update. Koristeći
prethodno kreiranu proceduru izmijenite jedan zapis sa Vašim podacima.
*/
CREATE PROCEDURE usp_Studenti_Update
(
    @StudentID INT,
    @BrojDosijea NVARCHAR(10),
    @Ime NVARCHAR(35),
    @Prezime NVARCHAR(35),
    @GodinaStudija INT,
    @NacinStudiranja NVARCHAR(10),
    @Email NVARCHAR(50)
)
AS
BEGIN
    UPDATE Studenti
    SET BrojDosijea = @BrojDosijea,
        Ime = @Ime,
        Prezime = @Prezime,
        GodinaStudija = @GodinaStudija,
        NacinStudiranja = @NacinStudiranja,
        Email = @Email
    WHERE StudentID = @StudentID
END

EXEC usp_Studenti_Update 6,'IB000000','Ime','Prezime', 2, 'DL','ime.prezime@edu.fit.ba'

SELECT * FROM Studenti
GO
/*6.
U Vašoj bazi podataka kreirajte stored proceduru koja će raditi INSERT podataka u tabelu Nastava. Podaci se
moraju unijeti preko parametara. Također, u istoj proceduri dodati prisustvo na nastavi (koristeći INSERT
SELECT komandu dodati prisustvo sve studente za prethodno dodanu nastavu). Proceduru pohranite pod
nazivom usp_Nastava_Insert
*/
CREATE PROCEDURE usp_Nastava_Insert
(
    @Datum DATETIME,
    @Nastavnik NVARCHAR(50),
    @Ucionica NVARCHAR(20),
    @PredmetID INT
)
AS
BEGIN
    INSERT INTO Nastava
    VALUES (@Datum, @Nastavnik, @Ucionica, @PredmetID)

    INSERT INTO Prisustvo
    SELECT StudentID, (SELECT NastavaID FROM Nastava WHERE Datum = @Datum AND PredmetID = @PredmetID)
    FROM Studenti
END

EXEC usp_Nastava_Insert '20140610','Ime Prezime','UC7',1

/*7.
Koristeći proceduru koju ste kreirali u prethodnom zadatku dodati novu nastavu. Za parametar @Datum
proslijediti trenutni datum i vrijeme, a ostale parametre upisati ručno
*/
DECLARE @datum DATETIME = SYSDATETIME()
EXEC usp_Nastava_Insert @datum, 'Ime Prezime','AKS',2

SELECT * FROM Prisustvo

SELECT * FROM Nastava
GO

/*8.
U Vašoj bazi podataka kreirajte stored proceduru koja ća na osnovu proslijeđenih parametara (@NastavaID i
@StudentID) brisati prisustvo na nastavi. Proceduru pohranite pod nazivom usp_Prisustvo_Delete
*/
CREATE PROCEDURE usp_Prisustvo_Delete
(
    @NastavaID INT,
    @StudentID INT
)
AS
BEGIN
    DELETE FROM Prisustvo
    WHERE NastavaID = @NastavaID AND 
          StudentID = @StudentID
END

SELECT * FROM Prisustvo

EXEC usp_Prisustvo_Delete 1, 1
GO
/*9.
U Vašoj bazi podataka kreirajte view koji će sadržavati sljedeća polja: broj dosijea, ime i prezime studenta,
datum nastave, učionicu, nastavnika i predmet. View pohranite pod nazivom view_Studenti_Nastava.
*/

CREATE VIEW view_Studenti_Nastava
AS
SELECT 
    S.BrojDosijea,
    S.Ime + ' ' + S.Prezime AS [Ime i prezime],
	N.Datum,
    N.Ucionica,
    N.Nastavnik,
    PR.Naziv
FROM Studenti AS S 
    INNER JOIN Prisustvo AS P ON S.StudentID =P.StudentID 
    INNER JOIN Nastava AS N ON P.NastavaID = N.NastavaID 
    INNER JOIN Predmeti AS PR ON N.PredmetID = PR.PredmetID

SELECT * FROM view_Studenti_Nastava

/*BACKUP bez navodenja putanje na default lokaciju*/

BACKUP DATABASE BP2_2014_06_10 TO
DISK = 'BP2_2014_06_10.bak'