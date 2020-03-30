/*
1. Primjer se radi na bazi Northwind. Marketing odjel zahtjeva izvještaj o proizvodima iz kojeg se vidi: naziv dobavljaca u 
sljedecem formatu: CompanyName(Grad,Adresa) - u izlaz uključiti zagrade, telefon dobavljaca, cijena po komadu, 
stanje zaliha, razlika stanja zaliha i naručenih proizvoda. Uslovi su sljedeći:
- Da se prikažu samo one razlike stanja zaliha gdje ima više naručenih nego što imamo na stanju 
- Proizvod ima minimalno jednu narudžbu
- U obzir ulaze samo oni proizvodi gdje je cijena veća od 20

*/

/*
2. Primjer se radi na bazi Northwind. Vaša kompanija želi provjeriti neke podatke o isporukama prodate robe kupcima. 
Prvi korak jeste kreiranje spiska kupaca sa: imenom kompanije, kontakt imenom, i brojem telefona.
Potrebno je sljedece:
- Broj potrebnih dana za isporuku u odnosu na datum narudžbe
- Broj utrošenih dana na isporuku u odnosu na datum narudžbe
- Broj dana koji prikazuje razliku izmedu potrebnih i utrošenih dana
- Uslov je da broj utrošenih dana bude veci od potrebnog broja dana

*/


/*
. Koristeci bazu AdventureWorksLT2012 kreirati upit koji prikazuje podatke o proizvodima. 
Izlaz treba da sadrži sljedece kolone: kategoriju proizvoda, model proizvoda, broj proizvoda, cijenu, boju, 
te ukupnu količinu prodatih proizvoda. Uslovi su sljedeci:

- u listu uključiti i one proizvode koji nisu prodani niti jednom,
- ukoliko se pojavi kolona sa NULL vrijednostima iste je potrebno zamijeniti brojem 0 (nula),
- prikazati samo proizvode koji pripadaju kategoriji "Mountain Bikes", crne su boje i imaju cijenu veću od 2000
- Takoder, u listu uključiti i one proizvode ciji se broj završava slovom 'L' i bijele su boje,
- Izlaz je potrebno sortirati po kolicini prodatih proizvoda opadajucim redoslijedom

*/



/* 1. Kreirati bazu podataka pod nazivom: BrojDosijea (npr. 2046) bez posebnog kreiranja data i log fajla.*/


/*2.
U vašoj bazi podataka keirati tabele sa sljede�im parametrima:
- Kupci
	- KupacID, automatski generator vrijednosti i primarni ključ
 	- Ime, polje za unos 35 UNICODE karaktera (obavezan unos),
	- Prezime, polje za unos 35 UNICODE karaktera (obavezan unos),
	- Telefon, polje za unos 15 karaktera (nije obavezan),
	- Email, polje za unos 50 karaktera (nije obavezan),
	- KorisnickoIme, polje za unos 15 karaktera (obavezan unos) jedinstvena vrijednost,
	- Lozinka, polje za unos 15 karaktera (obavezan unos)
- Proizvodi
	- ProizvodID, automatski generator vrijednosti i primarni ključ
	- Sifra, polje za unos 25 karaktera (obavezan unos)
	- Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
	- Cijena, polje za unos decimalnog broj (obavezan unos)
	- Zaliha, polje za unos cijelog broja (obavezan unos)

- Narudzbe 

 	- NarudzbaID, automatski generator vrijednosti i primarni ključ
 	- KupacID, spoljni ključ prema tabeli Kupci,
	- ProizvodID, spoljni ključ prema tabeli Proizvodi,
	- Kolicina, polje za unos cijelog broja (obavezan unos)
	- Popust, polje za unos decimalnog broj (obavezan unos), DEFAULT JE 0

*/



/*3.

 Modifikovati tabele Proizvodi i Narudzbe i to sljedeca polja:
	- Zaliha (tabela Proizvodi) - omoguciti unos decimalnog broja
	- Kolicina (tabela Narudzbe) - omoguciti unos decimalnog broja

*/



/*4.
Koristeci bazu podataka AdventureWorksLT 2012 i tabelu SalesLT.Customer, preko INSERT I SELECT komande importovati 10 zapisa
u tabelu Kupci i to sljedece kolone:
	- FirstName -> Ime
	- LastName -> Prezime
	- Phone -> Telefon
	- EmailAddress -> Email
	- Sve do znaka '@' u koloni EmailAddress -> KorisnickoIme
	- Prvih 8 karaktera iz kolone PasswordHash -> Lozinka

*/


/*5.
Koristeci bazu podataka AdventureWorksLT2012 i tabelu SalesLT.Product importovati u temp tabelu po
nazivom tempBrojDosijea (npr. temp2046) 5 proizvoda i to sljedece kolone:
	
	- ProductName -> Sifra
	- Name -> Naziv
	- StandardCost -> Cijena

*/

/*6.
. U vašoj bazi podataka kreirajte stored proceduru koja ce raditi INSERT podataka u tabelu Narudzbe. 
Podaci se moraju unijeti preko parametara. Takoder , u proceduru dodati ažuriranje (UPDATE) polja 'Zaliha' (tabela Proizvodi) u 
zavisnosti od prosljeđene količine. Proceduru pohranite pod nazivom usp_Narudzbe_Insert.
*/


/*7.
 Koristeći proceduru koju ste kreirali u prethodnom zadatku kreirati 5 narudžbi.
*/




/*8.
 U vašoj bazi podataka kreirajte view koji će sadržavati sljedeca polja: ime kupca, prezime kupca, telefon, 
 šifra proizvoda, naziv proizvoda, cijena, kolicina, te ukupno. View pohranite pod nazivom view_Kupci_Narudzbe.
*/


/*9.
. U vašoj bazi podataka kreirajte stored proceduru koja ce na osnovu proslijedenog imena ili 
prezimena kupca (jedan parametar) kao rezultat vratiti sve njegove narudžbe. 
Kao izvor podataka koristite view kreiran u zadatku 8. Proceduru pohranite pod nazivom usp_Kupci_Narudzbe.
*/


/*10.
. U vašoj bazi podataka kreirajte stored proceduru koja ce raditi DELETE zapisa iz tabele Proizvodi.
Proceduru pohranite pod nazivom usp_Proizvodi_Delete. Pokušajte obrisati jedan od proizvoda kojeg ste dodatli u zadatku 5.
Modifikujte proceduru tako da obriše proizvod i svu njegovu historiju prodaje (Narudzbe).
*/



