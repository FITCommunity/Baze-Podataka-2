/*
1. Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. U postupku kreiranja u
obzir uzeti samo DEFAULT postavke.
Unutar svoje baze podataka kreirati tabelu sa sljedećom strukturom:
a) Proizvodi:
I. ProizvodID, automatski generatpr vrijednosti i primarni ključ
II. Sifra, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
III. Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
IV. Cijena, polje za unos decimalnog broja (obavezan unos)
b) Skladista
I. SkladisteID, automatski generator vrijednosti i primarni ključ
II. Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
III. Oznaka, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
IV. Lokacija, polje za unos 50 UNICODE karaktera (obavezan unos)
c) SkladisteProizvodi
I) Stanje, polje za unos decimalnih brojeva (obavezan unos)

Napomena: Na jednom skladištu može biti uskladišteno više proizvoda, dok isti proizvod može biti
uskladišten na više različitih skladišta. Onemogućiti da se isti proizvod na skladištu može pojaviti više
puta
*/


/*
2. Popunjavanje tabela podacima
a) Putem INSERT komande u tabelu Skladista dodati minimalno 3 skladišta.
b) Koristeći bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati
10 najprodavanijih bicikala (kategorija proizvoda 'Bikes' i to sljedeće kolone:
I. Broj proizvoda (ProductNumber) - > Sifra,
II. Naziv bicikla (Name) -> Naziv,
III. Cijena po komadu (ListPrice) -> Cijena,
c) Putem INSERT i SELECT komandi u tabelu SkladisteProizvodi za sva dodana skladista
importovati sve proizvode tako da stanje bude 100
*/


/*3.
Kreirati uskladištenu proceduru koja će vršiti povečanje stanja skladišta za određeni proizvod na
odabranom skladištu. Provjeriti ispravnost procedure.
*/



/*4.
 Kreiranje indeksa u bazi podataka nad tabelama
a) Non-clustered indeks nad tabelom Proizvodi. Potrebno je indeksirati Sifru i Naziv. Također,
potrebno je uključiti kolonu Cijena
b) Napisati proizvoljni upit nad tabelom Proizvodi koji u potpunosti iskorištava indeks iz
prethodnog koraka
c) Uradite disable indeksa iz koraka a)
*/

/*
5. Kreirati view sa sljedećom definicijom. Objekat treba da prikazuje sifru, naziv i cijenu proizvoda,
oznaku, naziv i lokaciju skladišta, te stanje na skladištu.
*/


/*6.
 Kreirati uskladištenu proceduru koja će na osnovu unesene šifre proizvoda prikazati ukupno stanje
zaliha na svim skladištima. U rezultatu prikazati sifru, naziv i cijenu proizvoda te ukupno stanje zaliha.
U proceduri koristiti prethodno kreirani view. Provjeriti ispravnost kreirane procedure.
*/

/*7.
. Kreirati uskladištenu proceduru koja će vršiti upis novih proizvoda, te kao stanje zaliha za uneseni
proizvod postaviti na 0 za sva skladišta. Provjeriti ispravnost kreirane procedure.
*/

/*8.
 Kreirati uskladištenu proceduru koja će za unesenu šifru proizvoda vršiti brisanje proizvoda
uključuju�i stanje na svim skladištima. Provjeriti ispravnost procedure.
*/


/*9.
 Kreirati uskladištenu proceduru koja će za unesenu šifru proizvoda, oznaku skladišta ili lokaciju
skladišta vršiti pretragu prethodno kreiranim view-om (zadatak 5). Procedura obavezno treba da
vraća rezultate bez obrzira da li su vrijednosti parametara postavljene. Testirati ispravnost procedure
u sljedećim situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vraća sve zapise)
b) Postavljena je vrijednost parametra šifra proizvoda, a ostala dva parametra nisu
c) Postavljene su vrijednosti parametra šifra proizvoda i oznaka skladišta, a lokacija
nije
d) Postavljene su vrijednosti parametara šifre proizvoda i lokacije, a oznaka skladišta
nije
e) Postavljene su vrijednosti sva tri parametra
*/



/*10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera:*/

