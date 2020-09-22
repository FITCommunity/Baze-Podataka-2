/*
1. Kreirati bazu podataka koju ćete imenovati Vašim brojem dosijea. Fajlove baze smjestiti na sljedeće lokacije:
- Data fajl -> D:\DBMS\Data
- Log fajl -> D:\DBMS\Log
*/


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



/*3.
Koristeći AdventureWorks2014 bazu podataka, importovati 10 kupaca u tabelu Kandidati i to sljedeće
kolone:
a. FirstName (Person) -> Ime,
b. LastName (Person) -> Prezime,
c. Zadnjih 13 karaktera kolone rowguid iz tabele Customer (Crticu zamijeniti brojem 0) -> JMBG,
d. ModifiedDate (Customer) -> DatumRodjenja,
e. City (Address) -> MjestoRodjenja,
f. PhoneNumber (PersonPhone) -> Telefon,
g. EmailAddress (EmailAddress) -> Email.
Također, u tabelu Testovi unijeti minimalno tri testa sa proizvoljnim podacima.
*/


/*4.
Kreirati stored proceduru koja će na osnovu proslijeđenih parametara služiti za unos podataka u tabelu
RezultatiTesta. Proceduru pohraniti pod nazivom usp_RezultatiTesta_Insert. Obavezno testirati ispravnost
kreirane procedure (unijeti proizvoljno minimalno 10 rezultata za različite testove).
*/



/*5.
Kreirati view (pogled) nad podacima koji će sadržavati sljedeća polja: ime i prezime, jmbg, telefon i email
kandidata, zatim datum, naziv, oznaku, oblast i max. broj bodova na testu, te polje položio, osvojene bodove i
procentualni rezultat testa. View pohranite pod nazivom view_Rezultati_Testiranja
*/


/*6.
Kreirati stored proceduru koja će na osnovu proslijeđenih parametara @OznakaTesta i @Polozio prikazivati
rezultate testiranja. Kao izvor podataka koristiti prethodno kreirani view. Proceduru pohraniti pod nazivom
usp_RezultatiTesta_SelectByOznaka. Obavezno testirati ispravnost kreirane procedure
*/



/*7.
 Kreirati proceduru koja će služiti za izmjenu rezultata testiranja. Proceduru pohraniti pod nazivom
usp_RezultatiTesta_Update. Obavezno testirati ispravnost kreirane procedure
*/




/*8.
Kreirati stored proceduru koja će služiti za brisanje testova zajedno sa svim rezultatima testiranja. Proceduru
pohranite pod nazivom usp_Testovi_Delete. Obavezno testirati ispravnost kreirane procedure.
*/



/*9.
Kreirati trigger koji će spriječiti brisanje rezultata testiranja. Obavezno testirati ispravnost kreiranog triggera.
*/




/*10. Uraditi full backup Vaše baze podataka na lokaciju D:\DBMS\Backup*/

