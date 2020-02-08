/*1.
Kroz SQL kod napraviti bazu podataka koja nosi ime vašeg broja dosijea, a zatim u svojoj bazi podataka kreirati
tabele sa sljedeæom strukturom:
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
ii. Primatelj polje za unos 50 karaktera – (obavezan unos)
iii. BrojRacunaPrimatelja, polje za unos 16 karaktera (obavezan unos)
iv. MjestoPrimatelja, polje za unos 50 karaktera (obavezan unos)
v. AdresaPrimatelja, polje za unos 50 karaktera (nije obavezan unos)
vi. Svrha, polje za unos 200 karaktera (nije obavezan unos)
vii. Iznos, polje za unos decimalnog broja (obavezan unos)

Napomena: Klijent može imati više otvorenih raèuna, dok se svaki raèun veže iskljuèivo za jednog klijenta. Sa
raèuna klijenta se provode transakcije, dok se svaka pojedinaèna transakcija provodi sa jednog raèuna
*/


/*2.Nad poljem Email u tabeli Klijenti, te BrojRacuna u tabeli Racuni kreirati unique index.*/




/*3.Kreirati uskladištenu proceduru za unos novog raèuna. Obavezno provjeriti ispravnost kreirane procedure.*/



/*4.
 Iz baze podataka Northwind u svoju bazu podataka prebaciti sljedeæe podatke:
a) U tabelu Klijenti prebaciti sve kupce koji su obavljali narudžbe u 1996. godini
i. ContactName (do razmaka) -> Ime
ii. ContactName (poslije razmaka) -> Prezime
iii. City -> Grad
iv. ContactName@northwind.ba -> Email (Izmeðu imena i prezime staviti taèku)
v. Phone -> Telefon
b) Koristeæi prethodno kreiranu proceduru u tabelu Racuni dodati 10 raèuna za razlièite kupce
(proizvoljno). Odreðenim kupcima pridružiti više raèuna.

c) Za svaki prethodno dodani raèun u tabelu Transakcije dodati po 10 transakcija. Podatke za tabelu
Transakcije preuzeti RANDOM iz Northwind baze podataka i to poštujuæi sljedeæa pravila:
i. OrderDate (Orders) -> Datum
ii. ShipName (Orders) - > Primatelj
iii. OrderID + '00000123456' (Orders) -> BrojRacunaPrimatelja
iv. ShipCity (Orders) -> MjestoPrimatelja,
v. ShipAddress (Orders) -> AdresaPrimatelja,
vi. NULL -> Svrha,
vii. Ukupan iznos narudžbe (Order Details) -> Iznos
Napomena (c): ID raèuna ruèno izmijeniti u podupitu prilikom inserta podataka
*/





/*5.
 Svim raèunima èiji vlasnik dolazi iz Londona, a koji su otvoreni u 8. mjesecu, stanje uveæati za 500. Grad i mjesec
se mogu proizvoljno mijenjati kako bi se rezultat komande prilagodio vlastitim podacima
*/


/*6.
Kreirati view (pogled) koji prikazuje ime i prezime (spojeno), grad, email i telefon klijenta, zatim tip raèuna, broj
raèuna i stanje, te za svaku transakciju primatelja, broj raèuna primatelja i iznos. Voditi raèuna da se u rezultat
ukljuèe i klijenti koji nemaju otvoren niti jedan raèun
*/



/*7.
Kreirati uskladištenu proceduru koja æe na osnovu proslijeðenog broja raèuna klijenta prikazati podatke o
vlasniku raèuna (ime i prezime, grad i telefon), broj i stanje raèuna te ukupan iznos transakcija provedenih sa
raèuna. Ukoliko se ne proslijedi broj raèuna, potrebno je prikazati podatke za sve raèune. Sve kolone koje
prikazuju NULL vrijednost formatirati u 'N/A'. U proceduri koristiti prethodno kreirani view. Obavezno provjeriti
ispravnost kreirane procedure
*/


/*8.
Kreirati uskladištenu proceduru koja æe na osnovu unesenog identifikatora klijenta vršiti brisanje klijenta
ukljuèujuæi sve njegove raèune zajedno sa transakcijama. Obavezno provjeriti ispravnost kreirane procedure
*/



/*9.
Komandu iz zadatka 5. pohraniti kao proceduru a kao parametre proceduri proslijediti naziv grada, mjesec i iznos
uveæanja raèuna. Obavezno provjeriti ispravnost kreirane procedure
*/


/*10. Kreirati full i diferencijalni backup baze podataka na lokaciju servera D:\BP2\Backup*/

