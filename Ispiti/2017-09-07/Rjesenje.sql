/*1.
Kroz SQL kod napraviti bazu podataka koja nosi ime vašeg broja dosijea, 
a zatim u svojoj bazi podataka kreirati
tabele sa sljedećom strukturom:
*/

CREATE DATABASE BP2_2017_09_07
GO
USE BP2_2017_09_07
GO

/*
a) Klijenti
i. Ime, polje za unos 50 karaktera (obavezan unos)
ii. Prezime, polje za unos 50 karaktera (obavezan unos)
iii. Grad, polje za unos 50 karaktera (obavezan unos)
iv. Email, polje za unos 50 karaktera (obavezan unos)
v. Telefon, polje za unos 50 karaktera (obavezan unos)

b) Racuni
i. DatumOtvaranja, polje za unos datuma (obavezan unos)
ii. TipRacuna, polje za unos 50 karaktera (obavezan unos)
iii. BrojRacuna, polje za unos 16 karaktera (obavezan unos)
iv. Stanje, polje za unos decimalnog broja (obavezan unos)

c) Transakcije
i. Datum, polje za unos datuma i vremena (obavezan unos)
ii. Primatelj polje za unos 50 karaktera - (obavezan unos)
iii. BrojRacunaPrimatelja, polje za unos 16 karaktera (obavezan unos)
iv. MjestoPrimatelja, polje za unos 50 karaktera (obavezan unos)
v. AdresaPrimatelja, polje za unos 50 karaktera (nije obavezan unos)
vi. Svrha, polje za unos 200 karaktera (nije obavezan unos)
vii. Iznos, polje za unos decimalnog broja (obavezan unos)

Napomena: Klijent može imati više otvorenih računa, dok se svaki račun veže isključivo za jednog klijenta. Sa
računa klijenta se provode transakcije, dok se svaka pojedinačna transakcija provodi sa jednog računa
*/

CREATE TABLE Klijenti
(
    KlijentID INT CONSTRAINT PK_Klijenti PRIMARY KEY IDENTITY(1,1),
    Ime NVARCHAR(50) NOT NULL,
    Prezime NVARCHAR(50) NOT NULL,
    Grad NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    Telefon NVARCHAR(50) NOT NULL,
)

CREATE TABLE Racuni
(
    RacunID INT CONSTRAINT PK_Racuni PRIMARY KEY IDENTITY(1,1),
    KlijentID INT CONSTRAINT FK_Racuni_Klijenti FOREIGN KEY(KlijentID) REFERENCES Klijenti(KlijentID),
    DatumOtvaranja date NOT NULL,
    TipRacuna NVARCHAR(50) NOT NULL,
    BrojRacuna NVARCHAR(16) NOT NULL,
    Stanje DECIMAL(8,2) NOT NULL
)

CREATE TABLE Transakcije
(
    TransakcijaID INT CONSTRAINT PK_Transakcije PRIMARY KEY IDENTITY(1,1),
    RacunID INT CONSTRAINT FK_Tranakcije_Racuni FOREIGN KEY(RacunID) REFERENCES Racuni(RacunID),
    Datum DATETIME NOT NULL,
    Primatelj NVARCHAR(50) NOT NULL,
    BrojRacunaPrimatelja NVARCHAR(16) NOT NULL,
    MjestoPrimatelja NVARCHAR(50) NOT NULL,
    AdresaPrimatelja NVARCHAR(50),
    Svrha NVARCHAR(200),
    Iznos DECIMAL(8,2) NOT NULL
)

/*2.Nad poljem Email u tabeli Klijenti, te BrojRacuna u tabeli Racuni kreirati unique index.*/
CREATE UNIQUE nonclustered INDEX IX_Klijenti_Email
ON Klijenti(Email)

CREATE UNIQUE nonclustered INDEX UQ_Racuni_BrojRacuna
ON Racuni(BrojRacuna)
GO


/*3.Kreirati uskladištenu proceduru za unos novog računa. Obavezno provjeriti ispravnost kreirane procedure.*/
CREATE PROCEDURE proc_Racuni_INSERT
(
    @KlijentID INT,
    @DatumOtvaranja DATE,
    @TipRacuna NVARCHAR(50),
    @BrojRacuna NVARCHAR(16),
    @Stanje DECIMAL(8,2)
)
AS
BEGIN
    INSERT INTO Racuni
    VALUES (@KlijentID, @DatumOtvaranja, @TipRacuna, @BrojRacuna, @Stanje)
END

INSERT INTO Klijenti
VALUES ('test','test','test','test@test.com','000-000-000')

EXEC proc_Racuni_INSERT 1, '20160907', 'tip1','0000000000000001', 100

SELECT * FROM Racuni


/*4.
 Iz baze podataka Northwind u svoju bazu podataka prebaciti sljedeće podatke:
a) U tabelu Klijenti prebaciti sve kupce koji su obavljali narudžbe u 1996. godini
i. ContactName (do razmaka) -> Ime
ii. ContactName (poslije razmaka) -> Prezime
iii. City -> Grad
iv. ContactName@northwind.ba -> Email (Između imena i prezime staviti tačku)
v. Phone -> Telefon
b) Koristeći prethodno kreiranu proceduru u tabelu Racuni dodati 10 računa za različite kupce
(proizvoljno). Određenim kupcima pridružiti više računa.

c) Za svaki prethodno dodani račun u tabelu Transakcije dodati po 10 transakcija. Podatke za tabelu
Transakcije preuzeti RANDOM iz Northwind baze podataka i to poštujući sljedeća pravila:
i. OrderDate (Orders) -> Datum
ii. ShipName (Orders) - > Primatelj
iii. OrderID + '00000123456' (Orders) -> BrojRacunaPrimatelja
iv. ShipCity (Orders) -> MjestoPrimatelja,
v. ShipAddress (Orders) -> AdresaPrimatelja,
vi. NULL -> Svrha,
vii. Ukupan iznos narudžbe (Order Details) -> Iznos
Napomena (c): ID računa ručno izmijeniti u podupitu prilikom inserta podataka
*/

--a
INSERT INTO Klijenti
SELECT DISTINCT 
    SUBSTRING(C.ContactName, 1, CHARINDEX(' ', C.ContactName) - 1),
	SUBSTRING(C.ContactName, CHARINDEX(' ', C.ContactName) + 1, 20),
	C.City,
	SUBSTRING(C.ContactName, 1, CHARINDEX(' ',C.ContactName)-1) + '.' + SUBSTRING(C.ContactName, CHARINDEX(' ', C.ContactName) + 1, 20) + '@northwINd.ba',
	C.Phone
FROM NORTHWND.dbo.Customers AS C 
    INNER JOIN NORTHWND.dbo.Orders AS O ON C.CustomerID = O.CustomerID
WHERE DATEPART(YEAR, O.OrderDate) = 1996

SELECT * FROM Klijenti

--B
EXEC proc_Racuni_INSERT 3,'20171201','TIP2','1111111111111111',1500
EXEC proc_Racuni_INSERT 10,'20170601','TIP2','1111111111411111',1900
EXEC proc_Racuni_INSERT 3,'20190101','TIP1','1111131111111111',850
EXEC proc_Racuni_INSERT 7,'20180901','TIP2','1114111111111111',1200
EXEC proc_Racuni_INSERT 18,'20171201','TIP1','5111111111111111',2300
EXEC proc_Racuni_INSERT 10,'20181001','TIP1','1111111111111161',1000
EXEC proc_Racuni_INSERT 23,'20180301','TIP2','1111711111111111',1500
EXEC proc_Racuni_INSERT 40,'20190511','TIP1','1111111181111111',500
EXEC proc_Racuni_INSERT 40,'20180111','TIP2','1111111181114111',2500
EXEC proc_Racuni_INSERT 45,'20190611','TIP1','5111311181151111',570

SELECT * FROM Racuni

--C

INSERT INTO Transakcije
SELECT TOP 10 
(
    SELECT RacunID 
    FROM Racuni 
    WHERE RacunID = 11
), 
    O.OrderDate,
	O.ShipName,
    CAST(O.OrderID AS NVARCHAR) + '00000123456',
	O.ShipCity,
    O.ShipAddress,
    NULL,
    SUM((OD.UnitPrice - (OD.UnitPrice * OD.Discount)) * OD.Quantity)
FROM NORTHWND.dbo.Orders AS O 
    INNER JOIN NORTHWND.dbo.[Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate, O.ShipName, O.OrderID, O.ShipCity, O.ShipAddress
ORDER BY NEWID()

SELECT * FROM Transakcije



/*5.
 Svim računima čiji vlasnik dolazi iz Londona, a koji su otvoreni u 8. mjesecu, stanje uve�ati za 500. Grad i mjesec
se mogu proizvoljno mijenjati kako bi se rezultat komande prilagodio vlastitim podacima
*/
UPDATE Racuni
SET Stanje = Stanje + 500
WHERE KlijentID IN 
(
    SELECT KlijentID
    FROM Klijenti
    WHERE Grad = 'Lander'
) AND DATEPART(MONTH,DatumOtvaranja) = 6

SELECT * FROM Racuni

SELECT * FROM Klijenti
GO
/*6.
Kreirati view (pogled) koji prikazuje ime i prezime (spojeno), grad, email i telefon klijenta, zatim tip računa, broj
računa i stanje, te za svaku transakciju primatelja, broj računa primatelja i iznos. Voditi računa da se u rezultat
uključe i klijenti koji nemaju otvoren niti jedan račun
*/


CREATE VIEW view_Klijenti_Transkacije
AS
SELECT 
    K.Ime + ' ' + K.Prezime AS [Ime i prezime],
	K.Grad,
    K.Email,
    K.Telefon,
	R.TipRacuna,
    R.BrojRacuna,
    R.Stanje,
	T.BrojRacunaPrimatelja,
    T.Iznos
FROM Klijenti AS K 
    LEFT JOIN Racuni AS R ON K.KlijentID = R.KlijentID 
    LEFT JOIN Transakcije AS T ON R.RacunID = T.RacunID

SELECT * FROM view_Klijenti_Transkacije
GO
/*7.
Kreirati uskladištenu proceduru koja će na osnovu proslijeđenog broja računa klijenta prikazati podatke o
vlasniku računa (ime i prezime, grad i telefon), broj i stanje računa te ukupan iznos transakcija provedenih sa
računa. Ukoliko se ne proslijedi broj računa, potrebno je prikazati podatke za sve račune. Sve kolone koje
prikazuju NULL vrijednost formatirati u 'N/A'. U proceduri koristiti prethodno kreirani view. Obavezno provjeriti
ispravnost kreirane procedure
*/

CREATE PROCEDURE proc_view_Klijenti_Transkacije_SelectByBrojRacuna
(
    @BrojRacuna nvarchar(16) = null
)
AS
BEGIN
SELECT 
    [Ime i prezime],
    Grad,Telefon,
    ISNULL(BrojRacuna,'N/A') AS BrojRacuna,
    ISNULL(CAST(Stanje AS nvarchar),'N/A') AS Stanje,
	ISNULL(CAST(SUM(Iznos) AS nvarchar),'N/A') AS Ukupno
FROM view_Klijenti_Transkacije
WHERE BrojRacuna = @BrojRacuna OR @BrojRacuna IS NULL
GROUP BY [Ime i prezime], Grad,Telefon, BrojRacuna, Stanje
END

EXEC proc_view_Klijenti_Transkacije_SelectByBrojRacuna '1111111111111111'

EXEC proc_view_Klijenti_Transkacije_SelectByBrojRacuna
GO
/*8.
Kreirati uskladištenu proceduru koja će na osnovu unesenog identifikatora klijenta vršiti brisanje klijenta
uključujući sve njegove račune zajedno sa transakcijama. Obavezno provjeriti ispravnost kreirane procedure
*/

CREATE PROCEDURE proc_Klijenti_delete
(
    @KlijentiD INT
)
AS
BEGIN
    DELETE FROM Transakcije
    WHERE RacunID IN 
    (
        SELECT R.RacunID
        FROM Racuni AS R
        WHERE R.KlijentID = @KlijentiD
    )
    DELETE FROM Racuni
    WHERE KlijentID IN 
    (
        SELECT KlijentID
        FROM Klijenti
        WHERE KlijentID = @KlijentiD
    )
    DELETE FROM Klijenti
    WHERE KlijentID = @KlijentiD
END

EXEC proc_Klijenti_delete 23
GO
/*9.
Komandu iz zadatka 5. pohraniti kao proceduru a kao parametre proceduri proslijediti naziv grada, mjesec i iznos
uvečanja računa. Obavezno provjeriti ispravnost kreirane procedure
*/

CREATE PROCEDURE proc_zad_5
(
    @Grad NVARCHAR(50),
    @Mjesec INT,
    @Iznos DECIMAL(8,2)
)
AS
BEGIN
    UPDATE Racuni
    SET Stanje = Stanje + @Iznos
    WHERE KlijentID IN 
    (
        SELECT KlijentID
        FROM Klijenti
        WHERE Grad = @Grad
    ) AND DATEPART(MONTH,DatumOtvaranja) = @Mjesec
END
exec proc_zad_5 'Lander',6,100
/*10. Kreirati full i diferencijalni backup baze podataka na lokaciju servera D:\BP2\Backup*/

BACKUP DATABASE iBP2_2017_09_07 TO
DISK ='C:\BP2\Backup\BP2_2017_09_07.bak'

BACKUP DATABASE BP2_2017_09_07 TO
DISK ='C:\BP2\Backup\BP2_2017_09_07_dif.bak'
WITH DIFFERENTIAL