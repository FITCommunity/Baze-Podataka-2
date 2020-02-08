/*
1.	Kroz SQL kod,naparaviti bazu podataka koja nosi ime vaseg broja dosijea sa default postavkama
*/


/*
2.	Unutar svoje baze kreirati tabele sa sljedecom strukutrom
Autori
-	AutorID 11 UNICODE karaltera i primarni kljuc
-	Prezime 25 UNICODE karaktera (obavezan unos)
-	Ime 25 UNICODE karaktera (obavezan unos)
-	Telefon 20 UNICODE karaktera DEFAULT je NULL
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
Izdavaci 
-	IzdavacID 4 UNICODE karaktera i primarni kljuc
-	Naziv 100 UNICODE karaktera(obavezan unos),jedinstvena vrijednost
-	Biljeske 1000 UNICODE karaktera DEFAULT tekst je Lorem ipsum
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
Naslovi
-	NaslovID 6 UNICODE karaktera i primarni kljuc
-	IzdavacID ,spoljni kljuc prema tabeli Izdavaci
-	Naslov 100 UNICODE karaktera (obavezan unos)
-	Cijena monetarni tip
-	DatumIzdavanja datumska vraijabla (obavezan unos) DEFAULT datum unosa zapisa
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
NasloviAutori
-	AutorID ,spoljni kljuc prema tabeli Autori
-	NaslovID ,spoljni kljuc prema tabeli Naslovi
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL

*/



/*
2b. Generisati testne podatke i obavezno testirati da li su podaci u tabeli za svaki korak posebno:
-	Iz baze podataka pubs tabela authors,  putem podupita u tabelu Autori importovati sve slucajno sortirane zapise.
Vodite racuna da mapirate odgovarajuce kolone.

-	Iz baze podataka pubs i tabela publishers i pub_info , a putem podupita u tabelu Izdavaci importovati
sve slucajno sortirane zapise.Kolonu pr_info mapirati kao biljeske i iste skratiti na 100 karaktera.
Vodte racuna da mapirate odgovarajuce kolone

-	Iz baze podataka pubs tabela titles ,a putem podupita u tablu Naslovi importovati sve zapise.
Vodite racuna da mapirate odgvarajuce kolone

-	Iz baze podataka pubs tabela titleauthor, a putem podupita u tabelu NasloviAutori importovati zapise.
Vodite racuna da mapirate odgovrajuce koloone

*/

/*
2c. Kreiranje nove tabele,importovanje podataka i modifikovanje postojece tabele:
     Gradovi
-	GradID ,automatski generator vrijednosti cija je pocetna vrijednost je 5 i uvrcava se za 5,primarni kljuc
-	Naziv 100 UNICODE karaktera (obavezan unos),jedinstvena vrijednost
-	DatumKreiranjaZapisa datumska varijabla (obavezan unos) DEFAULT je datum unosa zapisa
-	DatumModifikovanjaZapisa datumska varijabla,DEFAULT je NULL
-	Iz baze podataka pubs tebela authors a putem podupita u tablelu Gradovi imprtovati nazive gradova bez duplikata
-	Modifikovati tabelu Autori i dodati spoljni kljuc prema tabeli Gradovi

*/


/*
2d. Kreirati dvije uskladistene procedure koja ce modifikovati podatke u tabelu Autori
-	Prvih deset autora iz tabele postaviti da su iz grada : San Francisco
-	Ostalim autorima podesiti grad na : Berkeley

*/


/*
3.	Kreirati pogled sa seljdeceom definicijom: Prezime i ime autora (spojeno),grad,naslov,cijena,izdavac i
biljeske ali samo one autore cije knjige imaju odredjenu cijenu i gdje je cijena veca od 10.
Takodjer naziv izdavaca u sredini imena treba ima ti slovo & i da su iz grada San Francisco.Obavezno testirati funkcijonalnost
*/


/*
4.	Modifikovati tabelu autori i dodati jednu kolonu:

-	Email,polje za unos 100 UNICODE kakraktera ,DEFAULT je NULL

*/


/*
5.	Kreirati dvije uskladistene procedure koje ce modifikovati podatke u tabeli Autori i svim autorima generisati novu email adresu:
-	Prva procedura u formatu Ime.Prezime@fit.ba svim autorima iz grada San Francisco
-	Druga procedura u formatu Prezime.ime@fit.ba svim autorima iz grada Berkeley

*/


/*
6.	Iz baze podataka AdventureWorks2014 u lokalnu,privremenu,tabelu u vasu bazu podataka imoportovati zapise o osobama ,
a putem podupita. Lista kolona je Title,LastName,FirstName,
EmailAddress,PhoneNumber,CardNumber.
Kreirati dvije dodatne kolone UserName koja se sastoji od spojenog imena i prezimena(tacka izmedju) i
kolona Password za lozinku sa malim slovima dugacku 16 karaktera.Lozinka se generise putem SQL funkcije za
slucajne i jednistvene ID vrijednosti.Iz lozinke trebaju biti uklonjene sve crtice '-' i zamjenjene brojem '7'.
Uslovi su da podaci ukljucuju osobe koje imaju i nemaju kreditanu karticu, a 
NULL vrijesnot u koloni Titula treba zamjenuti sa 'N/A'.Sortirati prema prezimenu i imenu.
Testirati da li je tabela sa podacima kreirana

*/


/*
7.	Kreirati indeks koji ce nad privremenom tabelom iz prethodnog koraka,primarno,maksimalno 
ubrzati upite koje koriste kolonu UserName,a sekundarno nad kolonama LastName i FirstName.Napisati testni upit
*/


/*
8.	Kreirati uskladistenu proceduru koja brise sve zapise iz privremen tabele koje nemaju kreditnu karticu.
Obavezno testirati funkcjionalnost
*/

/*
9.	Kreirati backup vase baze na default lokaciju servera i nakon toga obrisati privremenu tabelu
*/

/*
10.	Kreirati proceduru koja brise sve zapise i svih tabela unutar jednog izvrsenja.Testirati da li su podaci obrisani
*/

