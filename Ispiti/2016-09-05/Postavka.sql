/*1.
Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. U postupku kreiranja u obzir uzeti
samo DEFAULT postavke.
Unutar svoje baze podataka kreirati tabele sa sljedeæom strukturom:
a) Klijenti
i. KlijentID, automatski generator vrijednosti i primarni kljuè
ii. Ime, polje za unos 30 UNICODE karaktera (obavezan unos)
iii. Prezime, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. Telefon, polje za unos 20 UNICODE karaktera (obavezan unos)
v. Mail, polje za unos 50 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
vi. BrojRacuna, polje za unos 15 UNICODE karaktera (obavezan unos)
vii. KorisnickoIme, polje za unos 20 UNICODE karaktera (obavezan unos)
viii. Lozinka, polje za unos 20 UNICODE karaktera (obavezan unos)
b) Transakcije
i. TransakcijaID, automatski generator vrijednosti i primarni kljuè
ii. Datum, polje za unos datuma i vremena (obavezan unos)
iii. TipTransakcije, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. PosiljalacID, referenca na tabelu Klijenti (obavezan unos)
v. PrimalacID, referenca na tabelu Klijenti (obavezan unos)
vi. Svrha, polje za unos 50 UNICODE karaktera (obavezan unos)
vii. Iznos, polje za unos decimalnog broja (obavezan unos)
*/


/*2.
Popunjavanje tabela podacima:
a) Koristeæi bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati 10 kupaca
u tabelu Klijenti. Ime, prezime, telefon, mail i broj raèuna (AccountNumber) preuzeti od kupca,
korisnièko ime generisati na osnovu imena i prezimena u formatu ime.prezime, a lozinku generisati na
osnovu polja PasswordHash, i to uzeti samo zadnjih 8 karaktera.
b) Putem jedne INSERT komande u tabelu Transakcije dodati minimalno 10 transakcija
*/

/*3.
Kreiranje indeksa u bazi podataka nada tabelama:
a) Non-clustered indeks nad tabelom Klijenti. Potrebno je indeksirati Ime i Prezime. Takoðer, potrebno je
ukljuèiti kolonu BrojRacuna.
b) Napisati proizvoljni upit nad tabelom Klijenti koji u potpunosti iskorištava indeks iz prethodnog koraka.
Upit obavezno mora imati filter.
c) Uraditi disable indeksa iz koraka a)
*/


/*4.
. Kreirati uskladištenu proceduru koja æe vršiti upis novih klijenata. Kao parametre proslijediti sva polja. Provjeriti
ispravnost kreirane procedure
*/


/*5.
 Kreirati view sa sljedeæom definicijom. Objekat treba da prikazuje datum transakcije, tip transakcije, ime i
prezime pošiljaoca (spojeno), broj raèuna pošiljaoca, ime i prezime primaoca (spojeno), broj raèuna primaoca,
svrhu i iznos transakcije
*/



/*6.
. Kreirati uskladištenu proceduru koja æe na osnovu unesenog broja raèuna pošiljaoca prikazivati sve transakcije
koje su provedene sa raèuna klijenta. U proceduri koristiti prethodno kreirani view. Provjeriti ispravnost kreirane
procedure
*/


/*7.
Kreirati upit koji prikazuje sumaran iznos svih transakcija po godinama, sortirano po godinama. U rezultatu upita
prikazati samo dvije kolone: kalendarska godina i ukupan iznos transakcija u godini
*/


/*8.
 Kreirati uskladištenu proceduru koje æe vršiti brisanje klijenta ukljuèujuæi sve njegove transakcije, bilo da je za
transakciju vezan kao pošiljalac ili kao primalac. Provjeriti ispravnost kreirane procedure.
*/


/*9.
 Kreirati uskladištenu proceduru koja æe na osnovu unesenog broja raèuna ili prezimena pošiljaoca vršiti pretragu
nad prethodno kreiranim view-om (zadatak 5). Testirati ispravnost procedure u sljedeæim situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vraæa sve zapise)
b) Postavljena je vrijednost parametra broj raèuna,
c) Postavljena je vrijednost parametra prezime,
d) Postavljene su vrijednosti oba parametra.
*/


/*10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera*/
