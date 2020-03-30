/*1.
Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. U postupku kreiranja u obzir uzeti
samo DEFAULT postavke.
*/

CREATE DATABASE BP2_2016_09_05
GO

USE BP2_2016_09_05
GO


/*
Unutar svoje baze podataka kreirati tabele sa sljedećom strukturom:
a) Klijenti
i. KlijentID, auTOmatski generaTOr vrijednosti i primarni ključ
ii. Ime, polje za unos 30 UNICODE karaktera (obavezan unos)
iii. Prezime, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. TelefON, polje za unos 20 UNICODE karaktera (obavezan unos)
v. Mail, polje za unos 50 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
vi. BrojRacuna, polje za unos 15 UNICODE karaktera (obavezan unos)
vii. KorisnickoIme, polje za unos 20 UNICODE karaktera (obavezan unos)
viii. Lozinka, polje za unos 20 UNICODE karaktera (obavezan unos)
b) Transakcije
i. TransakcijaID, auTOmatski generaTOr vrijednosti i primarni ključ
ii. Datum, polje za unos datuma i vremena (obavezan unos)
iii. TipTransakcije, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. PosiljalacID, referenca na tabelu Klijenti (obavezan unos)
v. PrimalacID, referenca na tabelu Klijenti (obavezan unos)
vi. Svrha, polje za unos 50 UNICODE karaktera (obavezan unos)
vii. Iznos, polje za unos decimalnog broja (obavezan unos)
*/

CREATE TABLE Klijenti
(
    KlijentID INT CONSTRAINT PK_Klijenti PRIMARY KEY IDENTITY(1,1),
    Ime NVARCHAR(30) NOT NULL,
    Prezime NVARCHAR(30) NOT NULL,
    TelefON NVARCHAR(20) NOT NULL,
    Mail NVARCHAR(50) CONSTRAINT uq_email UNIQUE NOT NULL,
    BrojRacuna NVARCHAR(15) NOT NULL,
    KorisnickoIme NVARCHAR(20) NOT NULL,
    Lozinka NVARCHAR(20) NOT NULL
)

CREATE TABLE Transakcije
(
    TransakcijaID INT CONSTRAINT PK_Tranakcije PRIMARY KEY identity(1,1),
    Datum DATETIME NOT NULL,
    TipTransakcije NVARCHAR(30) NOT NULL,
    PosiljalacID INT CONSTRAINT FK_Transakcije_Posiljalac FOREIGN KEY(PosiljalacID) REFERENCES Klijenti(KlijentID) NOT NULL,
    PrimalacID INT CONSTRAINT FK_Transakcije_Primalac FOREIGN KEY(PrimalacID) REFERENCES Klijenti(KlijentID) NOT NULL,
    Svrha NVARCHAR(50) NOT NULL,
    Iznos DECIMAL(8,2) NOT NULL
)

/*2.
Popunjavanje tabela podacima:
a) Koristeći bazu podataka AdventureWorks2014, preko INSERT i SELECT komande imporTOvati 10 kupaca
u tabelu Klijenti. Ime, prezime, telefON, mail i broj računa (AccountNumber) preuzeti od kupca,
korisničko ime generisati na osnovu imena i prezimena u formatu ime.prezime, a lozinku generisati na
osnovu polja PASswordHASh, i TO uzeti samo zadnjih 8 karaktera.
b) Putem jedne INSERT komande u tabelu Transakcije dodati minimalno 10 transakcija
*/

INSERT INTO Klijenti
SELECT TOP 10 
    P.FirstName,
    P.LAStName,
    PP.PhONeNumber,
    EA.EmailAddress,
    C.AccountNumber,
	LOWER(P.FirstName + '.' + P.LAStName),
    RIGHT(PW.PasswordHash, 8)
FROM AdventureWorks2014.Sales.CusTOmer AS C 
    INNER JOIN AdventureWorks2014.PersON.PersON AS P ON C.PersONID = P.BusinessEntityID 
    INNER JOIN AdventureWorks2014.PersON.EmailAddress AS EA ON P.BusinessEntityID = EA.BusinessEntityID 
    INNER JOIN AdventureWorks2014.PersON.PASsword AS PW ON P.BusinessEntityID = PW.BusinessEntityID 
    INNER JOIN AdventureWorks2014.PersON.PersONPhONe AS PP ON P.BusinessEntityID = PP.BusinessEntityID

SELECT * FROM Klijenti
--B
INSERT INTO Transakcije
VALUES ('20160905','TIP1',2,5,'dug',350),
	   ('20160905','TIP1',4,9,'dug',150),
	   ('20160905','TIP2',9,6,'kazna',50),
	   ('20160905','TIP2',1,3,'kazna',100),
	   ('20160905','TIP1',2,9,'dug',100),
	   ('20160905','TIP2',7,8,'kazna',100),
	   ('20160905','TIP1',5,10,'dug',500),
	   ('20160905','TIP2',7,1,'kazna',100),
	   ('20160905','TIP1',10,6,'duf',250),
	   ('20160905','TIP2',2,3,'kazna',100)


SELECT * FROM Transakcije



/*3.
Kreiranje indeksa u bazi podataka nada tabelama:
a) NON-clustered indeks nad tabelom Klijenti. Potrebno je indeksirati Ime i Prezime. Također, potrebno je
uključiti kolONu BrojRacuna.
b) Napisati proizvoljni upit nad tabelom Klijenti koji u potpunosti iskorištava indeks iz prethodnog koraka.
Upit obavezno mora imati filter.
c) Uraditi disable indeksa iz koraka a)
*/
CREATE NONCLUSTERED INDEX IX_Klijenti_Ime_Prezime
ON Klijenti(Ime, Prezime)
include(BrojRacuna)

SELECT Ime,Prezime,BrojRacuna
FROM Klijenti
WHERE BrojRacuna LIKE '%[^123]'

ALTER INDEX IX_Klijenti_Ime_Prezime ON Klijenti
DISABLE
GO

/*4.
. Kreirati uskladištenu proceduru koja će vršiti upis novih klijenata. Kao parametre proslijediti sva polja. Provjeriti
ispravnost kreirane procedure
*/
CREATE PROCEDURE proc_Klijenti_INSERT
(
    @Ime NVARCHAR(30),
    @Prezime NVARCHAR(30),
    @TelefON NVARCHAR(20),
    @Mail NVARCHAR(50),
    @BrojRacuna NVARCHAR(15),
    @KorisnickoIme NVARCHAR(20),
    @Lozinka NVARCHAR(20)
)
AS
BEGIN
    INSERT INTO Klijenti
    VALUES (@Ime, @Prezime, @Telefon, @Mail, @BrojRacuna, @KorisnickoIme, @Lozinka)
END

EXEC proc_Klijenti_INSERT 'test','test','000-000-000','test@test.com','111111111111111','test.test','passwrod1'

SELECT * FROM Klijenti
GO
/*5.
 Kreirati VIEW sa sljedećom definicijom. Objekat treba da prikazuje datum transakcije, tip transakcije, ime i
prezime pošiljaoca (spojeno), broj računa pošiljaoca, ime i prezime primaoca (spojeno), broj računa primaoca,
svrhu i iznos transakcije
*/
CREATE VIEW VIEW_Klijenti_Transakcije
AS
SELECT 
    T.Datum,
    T.TipTransakcije,
    K.Ime + ' ' + K.Prezime AS [Ime i prezime posiljaoca],
	K.BrojRacuna AS [Broj racuna posiljaoca],
	(SELECT KL.Ime + ' ' + KL.Prezime FROM Klijenti AS KL WHERE KL.KlijentID = T.PrimalacID) AS [Ime i prezime primaoca],
	(SELECT  KL.BrojRacuna FROM Klijenti AS KL WHERE KL.KlijentID = T.PrimalacID) AS [Broj racuna primaoca],
	T.Svrha,
    T.Iznos
FROM Klijenti AS K 
    INNER JOIN Transakcije AS T ON K.KlijentID = T.PosiljalacID

SELECT * FROM VIEW_Klijenti_Transakcije
GO

/*6.
. Kreirati uskladištenu proceduru koja će na osnovu unesenog broja računa pošiljaoca prikazivati sve transakcije
koje su provedene sa računa klijenta. U proceduri koristiti prethodno kreirani VIEW. Provjeriti ispravnost kreirane
procedure
*/
CREATE PROCEDURE proc_VIEW_Klijenti_Transakcije_SelectByBrojRacuna
(
    @BrojRacuna nvarchar(15)
)
AS
BEGIN
SELECT *
    FROM VIEW_Klijenti_Transakcije
    WHERE [Broj racuna posiljaoca] = @BrojRacuna
END

EXEC proc_VIEW_Klijenti_Transakcije_SelectByBrojRacuna 'AW00011008'

/*7.
Kreirati upit koji prikazuje sumaran iznos svih transakcija po godinama, sortirano po godinama. U rezultatu upita
prikazati samo dvije kolONe: kalENDarska godina i ukupan iznos transakcija u godini
*/
SELECT DATEPART(YEAR, Datum) AS Godina,SUM(Iznos) AS Ukupno
FROM Transakcije
GROUP BY DATEPART(YEAR,Datum) 
ORDER BY Godina

/*8.
 Kreirati uskladištenu proceduru koje će vršiti brisanje klijenta uključujući sve njegove transakcije, bilo da je za
transakciju vezan kao pošiljalac ili kao primalac. Provjeriti ispravnost kreirane procedure.
*/
CREATE PROCEDURE proc_Klijenti_DELETE
(
    @KlijentID INT
)
AS
BEGIN
DELETE FROM Transakcije
WHERE PosiljalacID IN 
(
	SELECT KlijentID
	FROM Klijenti
	WHERE KlijentID = @KlijentID
) OR PrimalacID IN 
     (
         SELECT KlijentID
         FROM Klijenti
         WHERE KlijentID = @KlijentID
     )
DELETE FROM Klijenti
WHERE KlijentID = @KlijentID
END

SELECT * FROM Transakcije

EXEC proc_Klijenti_DELETE 5
GO

/*9.
 Kreirati uskladištenu proceduru koja će na osnovu unesenog broja računa ili prezimena pošiljaoca vršiti pretragu
nad prethodno kreiranim VIEW-om (zadatak 5). Testirati ispravnost procedure u sljedećim situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vraća sve zapise)
b) Postavljena je vrijednost parametra broj računa,
c) Postavljena je vrijednost parametra prezime,
d) Postavljene su vrijednosti oba parametra.
*/

CREATE procedure proc_VIEW_Klijenti_Transakcije_2
(
    @BrojRacuna NVARCHAR(15) = NULL,
    @Prezime NVARCHAR(30) = NULL
)
AS
BEGIN
    SELECT *
    FROM VIEW_Klijenti_Transakcije
    WHERE ([Broj racuna posiljaoca] = @BrojRacuna OR @BrojRacuna IS NULL) AND 
        ([Ime i prezime posiljaoca] LIKE '%' + @Prezime OR @Prezime IS NULL)
END

EXEC proc_VIEW_Klijenti_Transakcije_2
EXEC proc_VIEW_Klijenti_Transakcije_2 'AW00011001'
EXEC proc_VIEW_Klijenti_Transakcije_2 @Prezime = 'Huang'
EXEC proc_VIEW_Klijenti_Transakcije_2

/*10. Napraviti full i diferencijalni BACKUP baze podataka na default lokaciju servera*/
BACKUP DATABASE BP2_2016_09_05 TO
DISK = 'BP2_2016_09_05.bak'

BACKUP DATABASE BP2_2016_09_05 TO
DISK = 'BP2_2016_09_05_dif.bak'