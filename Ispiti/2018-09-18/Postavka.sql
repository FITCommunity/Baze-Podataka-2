/*1.Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea sa default postavkama*/


/*2.
Unutar svoje baze podataka kreirati tabele sa sljedećem strukturom:
Autori
- AutorID, 11 UNICODE karaktera i primarni ključ
- Prezime, 25 UNICODE karaktera (obavezan unos)
- Ime, 25 UNICODE karaktera (obavezan unos)
- ZipKod, 5 UNICODE karaktera, DEFAULT je NULL
- DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
- DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
Izdavaci
- IzdavacID, 4 UNICODE karaktera i primarni ključ
- Naziv, 100 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
- Biljeske, 1000 UNICODE karaktera, DEFAULT tekst je Lorem ipsum
- DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
- DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
Naslovi
- NaslovID, 6 UNICODE karaktera i primarni ključ
- IzdavacID, spoljni ključ prema tabeli „Izdavaci“
- Naslov, 100 UNICODE karaktera (obavezan unos)
- Cijena, monetarni tip podatka
- Biljeske, 200 UNICODE karaktera, DEFAULT tekst je The quick brown fox jumps over the lazy dog
- DatumIzdavanja, datum izdanja naslova (obavezan unos) DEFAULT je datum unosa zapisa
- DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
- DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
NasloviAutori (Više autora može raditi na istoj knjizi)
- AutorID, spoljni ključ prema tabeli „Autori“
- NaslovID, spoljni ključ prema tabeli „Naslovi“
- DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
- DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
*/



/*2b
Generisati testne podatake i obavezno testirati da li su podaci u tabelema za svaki korak zasebno :
- Iz baze podataka pubs tabela „authors“, a putem podupita u tabelu „Autori“ importovati sve slučajno sortirane
zapise. Vodite računa da mapirate odgovarajuće kolone.

- Iz baze podataka pubs i tabela („publishers“ i pub_info“), a putem podupita u tabelu „Izdavaci“ importovati sve
slučajno sortirane zapise. Kolonu pr_info mapirati kao bilješke i iste skratiti na 100 karaktera. Vodite računa da
mapirate odgovarajuće kolone i tipove podataka.

- Iz baze podataka pubs tabela „titles“, a putem podupita u tabelu „Naslovi“ importovati one naslove koji imaju
bilješke. Vodite računa da mapirate odgovarajuće kolone.

- Iz baze podataka pubs tabela „titleauthor“, a putem podupita u tabelu „NasloviAutori“ zapise. Vodite računa da
mapirate odgovarajuće kolone.
*/


/*2c
Kreiranje nove tabele, importovanje podataka i modifikovanje postojeće tabele:
Gradovi
- GradID, automatski generator vrijednosti koji generiše neparne brojeve, primarni ključ
- Naziv, 100 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
- DatumKreiranjaZapisa, datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
- DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa , DEFAULT je NULL
- Iz baze podataka pubs tabela „authors“, a putem podupita u tabelu „Gradovi“ importovati nazive gradove bez
duplikata.
- Modifikovati tabelu Autori i dodati spoljni ključ prema tabeli Gradovi:
*/



/*2d
Kreirati dvije uskladištene proceduru koja će modifikovati podataka u tabeli Autori:
- Prvih pet autora iz tabele postaviti da su iz grada: Salt Lake City
- Ostalim autorima podesiti grad na: Oakland

Vodite računa da se u tabeli modifikuju sve potrebne kolone i obavezno testirati da li su podaci u tabeli za svaku proceduru
posebno.
*/


/*3.
Kreirati pogled sa sljedećom definicijom: Prezime i ime autora (spojeno), grad, naslov, cijena, bilješke o naslovu i naziv
izdavača, ali samo za one autore čije knjige imaju određenu cijenu i gdje je cijena veća od 5. Također, naziv izdavača u sredini
imena ne smije imati slovo „&“ i da su iz autori grada Salt Lake City 
*/


/*4.
Modifikovati tabelu Autori i dodati jednu kolonu:
- Email, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
*/


/*5.
Kreirati dvije uskladištene proceduru koje će modifikovati podatke u tabelu Autori i svim autorima generisati novu email
adresu:
- Prva procedura: u formatu: Ime.Prezime@fit.ba svim autorima iz grada Salt Lake City
- Druga procedura: u formatu: Prezime.Ime@fit.ba svim autorima iz grada Oakland
*/

/*6.
z baze podataka AdventureWorks2014 u lokalnu, privremenu, tabelu u vašu bazi podataka importovati zapise o osobama, a
putem podupita. Lista kolona je: Title, LastName, FirstName, EmailAddress, PhoneNumber i CardNumber. Kreirate
dvije dodatne kolone: UserName koja se sastoji od spojenog imena i prezimena (tačka se nalazi između) i kolonu Password
za lozinku sa malim slovima dugačku 24 karaktera. Lozinka se generiše putem SQL funkciju za slučajne i jedinstvene ID
vrijednosti. Iz lozinke trebaju biti uklonjene sve crtice „-“ i zamijenjene brojem „7“. Uslovi su da podaci uključuju osobe koje
imaju i nemaju kreditnu karticu, a NULL vrijednost u koloni Titula zamjeniti sa podatkom 'N/A'. Sortirati prema prezimenu i
imenu istovremeno. Testirati da li je tabela sa podacima kreirana.
*/



/*7.
Kreirati indeks koji će nad privremenom tabelom iz prethodnog koraka, primarno, maksimalno ubrzati upite koje koriste
kolone LastName i FirstName, a sekundarno nad kolonam UserName. Napisati testni upit.
*/

/*8.
Kreirati uskladištenu proceduru koja briše sve zapise iz privremene tabele koji imaju kreditnu karticu Obavezno testirati
funkcionalnost procedure.
*/



/*9. Kreirati backup vaše baze na default lokaciju servera i nakon toga obrisati privremenu tabelu*/

/*10a Kreirati proceduru koja briše sve zapise iz svih tabela unutar jednog izvršenja. Testirati da li su podaci obrisani*/


/*10b Uraditi restore rezervene kopije baze podataka i provjeriti da li su svi podaci u izvornom obliku*/