/*
1.	Kroz SQL kod napraviti bazu podataka koja nosi ime vašeg broja dosijea, 
a zatim u svojoj bazi podataka kreirati tabele sa sljedećom strukturom:
*/

CREATE DATABASE BP2_2017_09_25
GO
USE BP2_2017_09_25
GO

/*
a)	Klijenti
i.	Ime, polje za unos 50 karaktera (obavezan unos)
ii.	Prezime, polje za unos 50 karaktera (obavezan unos)
iii.	Drzava, polje za unos 50 karaktera (obavezan unos)
iv.	Grad, polje za  unos 50 karaktera (obavezan unos)
v.	Email, polje za unos 50 karaktera (obavezan unos)
vi.	Telefon, polje za unos 50 karaktera (obavezan unos)

b)	Izleti
i.	Sifra, polje za unos 10 karaktera (obavezan unos)
ii.	Naziv, polje za unos 100 karaktera (obavezan unos)
iii.	DatumPolaska, polje za unos datuma (obavezan unos)
iv.	DatumPovratka, polje za unos datuma (obavezan unos)
v.	Cijena, polje za unos decimalnog broja (obavezan unos)
vi.	Opis, polje za unos dužeg teksta (nije obavezan unos)

c)	Prijave
i.	Datum, polje za unos datuma i vremena (obavezan unos)
ii.	BrojOdraslih polje za unos cijelog broja (obavezan unos)
iii.	BrojDjece polje za unos cijelog broja (obavezan unos)

Napomena: Na izlet se može prijaviti više klijenata, dok svaki klijent može prijaviti više izleta. 
Prilikom prijave klijent je obavezan unijeti broj odraslih i broj djece koji putuju u sklopu izleta.

*/

CREATE TABLE Klijenti
(
    KlijentID INT CONSTRAINT PK_Klijenti PRIMARY KEY IDENTITY(1,1),
    Ime NVARCHAR(50) NOT NULL,
    Prezime NVARCHAR(50) NOT NULL,
    Drzava NVARCHAR(50) NOT NULL,
    Grad NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    Telefon NVARCHAR(50) NOT NULL,
)

CREATE TABLE Izleti
(
    IzletID INT CONSTRAINT PK_Izleti PRIMARY KEY IDENTITY(1,1),
    Sifra NVARCHAR(10) NOT NULL,
    Naziv NVARCHAR(100) NOT NULL,
    DatumPolASka DATE NOT NULL,
    DatumPovratka DATE NOT NULL,
    Cijena DECIMAL(8,2) NOT NULL,
    Opis TEXT
)

CREATE TABLE Prijave
(
    IzletID INT CONSTRAINT FK_Prijave_Izleti FOREIGN KEY(IzletID) REFERENCES Izleti(IzletID),
    KlijentID INT CONSTRAINT FK_Prijave_Klijenti FOREIGN KEY(KlijentID) REFERENCES Klijenti(KlijentID),
    CONSTRAINT PK_Prijave PRIMARY KEY(IzletID, KlijentID),
    Datum DATETIME NOT NULL,
    BrojOdrASlih INT NOT NULL,
    BrojDjece INT NOT NULL
)
/*
2.	Iz baze podataka AdventureWorks2014 u svoju bazu podataka prebaciti sljedeće podatke:
a)	U tabelu Klijenti prebaciti sve uposlenike koji su radili u odjelu prodaje (Sales) 
i.	FirstName -> Ime
ii.	LastName -> Prezime
iii.	CountryRegion (Name) -> Drzava
iv.	Addresss (City) -> Grad
v.	EmailAddress (EmailAddress)  -> Email (Izme�u imena i prezime staviti ta�ku)
vi.	PersonPhone (PhoneNumber) -> Telefon
b)	U tabelu Izleti dodati 3 izleta (proizvoljno)	
*/


INSERT INTO Klijenti
SELECT 
    P.FirstName,
    P.LAStName,
    CR.Name,
    A.City,
    P.FirstName + '.' + P.LAStName + SUBSTRING(EA.EmailAddress, CHARINDEX('@', EA.EmailAddress), 25),
	PP.PhoneNumber
FROM AdventureWorks2014.HumanResources.Employee AS E 
    INNER JOIN AdventureWorks2014.Person.Person AS P ON E.BusinessEntityID = P.BusinessEntityID 
    INNER JOIN AdventureWorks2014.Person.BusinessEntityAddress AS BEA ON P.BusinessEntityID = BEA.BusinessEntityID 
    INNER JOIN AdventureWorks2014.Person.Address AS A ON BEA.AddressID = A.AddressID 
    INNER JOIN AdventureWorks2014.Person.StateProvince AS SP ON A.StateProvinceID = SP.StateProvinceID 
    INNER JOIN AdventureWorks2014.Person.CountryRegion AS CR ON SP.CountryRegionCode = CR.CountryRegionCode 
    INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA ON P.BusinessEntityID = EA.BusinessEntityID 
    INNER JOIN AdventureWorks2014.Person.PersonPhone AS PP ON P.BusinessEntityID = PP.BusinessEntityID
WHERE E.JobTitle LIKE '%Sales%'

SELECT * FROM Klijenti

--b
INSERT INTO Izleti (Sifra, Naziv, DatumPolaska, DatumPovratka, Cijena)
VALUES ('AB-100-10','Putovanje u Grad 1','20170925','20171025', 1000),
	   ('AB-100-20','Putovanje u Grad 2','20170925','20171025', 2000),
	   ('AB-100-30','Putovanje u Grad 3','20170925','20171025', 3000)

GO
/*
3.	Kreirati uskladištenu proceduru za unos nove prijave. Proceduri nije potrebno proslijediti parametar Datum.
Datum se uvijek postavlja na trenutni. Koristeći kreiranu proceduru u tabelu Prijave dodati 10 prijava.
*/
CREATE PROCEDURE proc_Prijave_insert
(
    @IzletID INT,
    @KlijentID INT,
    @BrojOdrASlih int,
    @BrojDjece INT
)
AS
BEGIN
    INSERT INTO Prijave
    VALUES (@IzletID, @KlijentID, SYSDATETIME(), @BrojOdrASlih, @BrojDjece)
END

SELECT * FROM Klijenti

EXEC proc_Prijave_insert 1,5,2,2 
EXEC proc_Prijave_insert 1,3,2,2 
EXEC proc_Prijave_insert 1,9,2,3 
EXEC proc_Prijave_insert 2,1,2,3
EXEC proc_Prijave_insert 2,6,2,2
EXEC proc_Prijave_insert 2,7,2,1
EXEC proc_Prijave_insert 2,2,2,3
EXEC proc_Prijave_insert 3,8,2,2
EXEC proc_Prijave_insert 3,2,2,3
EXEC proc_Prijave_insert 3,6,2,2

SELECT * FROM Prijave

/*
4.	Kreirati index koji će spriječiti dupliciranje polja Email u tabeli Klijenti. Obavezno testirati ispravnost kreiranog indexa.
*/
CREATE UNIQUE NONCLUSTERED INDEX UQ_Klijenti_Email
ON Klijenti(Email)

SELECT * FROM Klijenti

INSERT INTO Klijenti
VALUES ('Test', 'Test', 'Test', 'Test', 'test@test.com','Test')

/*
5.	Svim izletima koji imaju više od 3 prijave cijenu umanjiti za 10%.
*/
UPDATE Izleti
SET Cijena = Cijena - (Cijena * 0.10)
WHERE IzletID IN 
(
	SELECT P.IzletID
	FROM Prijave AS P
	GROUP BY P.IzletID
	HAVING COUNT(P.IzletID) > 3
)

SELECT * FROM Izleti
GO

/*
6.	Kreirati view (pogled) koji prikazuje podatke o izletu: šifra, naziv, datum polaska, datum povratka i cijena, 
te ukupan broj prijava na izletu, 
ukupan broj putnika, ukupan broj odraslih i ukupan broj djece. Obavezno prilagoditi format datuma (dd.mm.yyyy).
*/

CREATE VIEW view_Izleti_Prijave
AS
SELECT 
    I.Sifra,I.Naziv,
    CONVERT(NVARCHAR, I.DatumPolaska, 104) AS DatumPolASka,
    CONVERT(NVARCHAR, I.DatumPovratka, 104) AS DatumPovratka,
    I.Cijena,
	COUNT(P.IzletID) AS [Broj prijava],
	SUM(P.BrojOdrASlih + P.BrojDjece) AS BrojPutnika,
	SUM(P.BrojOdrASlih) AS [Broj odraslih],
	SUM(P.BrojDjece) AS [Broj djece]
FROM Izleti AS I 
    INNER JOIN Prijave AS P ON I.IzletID = P.IzletID
GROUP BY I.Sifra,I.Naziv,I.DatumPolASka,I.DatumPovratka,I.Cijena

SELECT * FROM view_Izleti_Prijave
GO
/*
7.	Kreirati uskladištenu proceduru koja će na osnovu unesene šifre izleta prikazivati zaradu od izleta i 
to sljedeće kolone: naziv izleta, zarada od odraslih, zarada od djece, ukupna zarada. 
Popust za djecu se obračunava 50% na ukupnu cijenu za djecu. Obavezno testirati ispravnost kreirane procedure.
*/

CREATE PROCEDURE proc_prikazi_zaradu
(
    @Sifra nvarchar(10)
)
AS
BEGIN
    SELECT 
        I.Naziv,SUM(P.BrojOdrASlih) * I.Cijena AS [Zarada od odrASlih],
        SUM(P.BrojDjece)*I.Cijena*0.5 AS [Zarada od djece],
        (SUM(P.BrojOdrASlih) * I.Cijena + SUM(P.BrojDjece) * I.Cijena * 0.5 ) AS Ukupno
    FROM Izleti AS I 
        INNER JOIN Prijave AS P ON I.IzletID = P.IzletID
    WHERE I.Sifra = @Sifra
    GROUP BY I.Naziv,I.Cijena
END

EXEC proc_prikazi_zaradu 'AB-100-20'

/*
8.	a) Kreirati tabelu IzletiHistorijaCijena u koju je potrebno pohraniti identifikator izleta kojem je cijena izmijenjena, 
datum izmjene cijene, staru i novu cijenu. Voditi računa o tome da se jednom izletu može više puta mijenjati
cijena te svaku izmjenu treba zapisati u ovu tabelu.

b) Kreirati trigger koji će pratiti izmjenu cijene u tabeli Izleti te za svaku izmjenu u prethodno
kreiranu tabelu pohraniti podatke izmijeni.

c) Za određeni izlet (proizvoljno) ispisati sljdedeće podatke: naziv izleta, datum polaska, datum povratka, 
trenutnu cijenu te kompletnu historiju izmjene cijena tj. datum izmjene, staru i novu cijenu.

*/
CREATE TABLE IzletiHistorijaCijena
(
    IzletiHistorijaCijenaID INT CONSTRAINT PK_IzletiHistorijaCijena PRIMARY KEY IDENTITY(1,1),
    IzletID INT CONSTRAINT FK_IzletiHistorijaCijena_Izleti FOREIGN KEY(IzletID) REFERENCES Izleti(IzletID),
    DatumIzmjene datetime,
    StaraCijena DECIMAL(8,2),
    NovaCijena DECIMAL(8,2)
)

CREATE TRIGGER tr_Izleti_promjene
ON Izleti AFTER UPDATE
AS
BEGIN
    INSERT INTO IzletiHisTOrijaCijena
    SELECT d.IzletID, SYSDATETIME(), d.Cijena, I.Cijena
    FROM deleted AS d 
        INNER JOIN Izleti AS I ON d.IzletID = I.IzletID
END

UPDATE Izleti
SET Cijena = Cijena+ 22
WHERE IzletID = 2

--c

SELECT 
    I.Naziv,
    I.DatumPolASka,
    I.DatumPovratka,
    I.Cijena,
	IHC.DatumIzmjene,
    IHC.StaraCijena
FROM Izleti AS I 
    INNER JOIN IzletiHisTOrijaCijena AS IHC ON I.IzletID = IHC.IzletID


/*9. Obrisati sve klijente koji nisu imali niti jednu prijavu na izlet. */

DELETE FROM Klijenti
WHERE KlijentID IN 
(
	SELECT K.KlijentID
	FROM Klijenti AS K 
        LEFT JOIN Prijave AS P ON K.KlijentID = P.KlijentID
	GROUP BY K.KlijentID
	HAVING COUNT(P.KlijentID) = 0					
)

/*10. Kreirati full i diferencijalni backup baze podataka na lokaciju servera D:\BP2\Backup*/
BACKUP DATABASE BP2_2017_09_25 TO 
disk = 'C:\BP2\Backup\BP2_2017_09_25.bak'

BACKUP DATABASE BP2_2017_09_25 TO 
disk = 'C:\BP2\Backup\BP2_2017_09_25_dif.bak'
WITH DIFFERENTIAL
