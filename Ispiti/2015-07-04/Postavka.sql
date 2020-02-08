/*1.
Kreirati bazu podataka koju ćete imenovati Vašim brojem dosijea. Fajlove baze smjestiti na sljedeće lokacije:
- Data fajl -> D:\DBMS\Data
- Log fajl -> D:\DBMS\Log
*/


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


/*3.
Koristeći AdventureWorks2014 bazu podataka, importovati 10 kupaca u tabelu Klijenti i to sljedeće kolone:
a. Zadnjih 13 karaktera kolone rowguid (Crticu '-' zamijeniti brojem 1)-> JMBG,
b. FirstName (Person) -> Ime,
c. LastName (Person) -> Prezime,
d. AddressLine1 (Address) -> Adresa,
e. PhoneNumber (PersonPhone) -> Telefon,
f. EmailAddress (EmailAddress) -> Email,
g. 'FIT' -> Kompanija
Također, u tabelu Krediti unijeti minimalno tri zapisa sa proizvoljnim podacima
*/

/*4.
. Kreirati stored proceduru koja će na osnovu proslijeđenih parametara služiti za unos podataka u tabelu
Otplate. Proceduru pohraniti pod nazivom usp_Otplate_Insert. Obavezno testirati ispravnost kreirane
procedure (unijeti minimalno 5 zapisa sa proizvoljnim podacima).
*/


/*5.
Kreirati view (pogled) nad podacima koji će prikazivati sljedeća polja: jmbg, ime i prezime, adresa, telefon i
email klijenta, zatim datum, namjenu i iznos kredita, te ukupan broj otplaćenih rata i ukupan otplaćeni iznos.
View pohranite pod nazivom view_Krediti_Otplate
*/


/*6.
Kreirati stored proceduru koja će na osnovu proslijeđenog parametra @JMBG prikazivati podatke o otplati
kredita. Kao izvor podataka koristiti prethodno kreirani view. Proceduru pohraniti pod nazivom
usp_Krediti_Otplate_SelectByJMBG. Obavezno testirati ispravnost kreirane procedure
*/


/*7.
. Kreirati proceduru koja će služiti za izmjenu podataka o otplati kredita. Proceduru pohraniti pod nazivom
usp_Otplate_Update. Obavezno testirati ispravnost kreirane procedure
*/


/*8.
Kreirati stored proceduru koja će služiti za brisanje kredita zajedno sa svim otplatama. Proceduru pohranite
pod nazivom usp_Krediti_Delete. Obavezno testirati ispravnost kreirane procedure.
*/




/*9.
Kreirati trigger koji će spriječiti brisanje zapisa u tabeli Otplate. Trigger pohranite pod nazivom
tr_Otplate_IO_Delete. Obavezno testirati ispravnost kreiranog triggera
*/


/*10. Uraditi full backup Vaše baze podataka na lokaciju D:\DBMS\Backup*/

