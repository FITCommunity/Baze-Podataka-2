/*
1.	Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. 
Fajlove baze podataka smjestiti na sljedeće lokacije:
a)	Data fajl: D:\BP2\Data
b)	Log fajl: D:\BP2\Log

*/


/*
2.	U svojoj bazi podataka kreirati tabele sa sljedećom strukturom:
a)	Proizvodi
i.	ProizvodID, cjelobrojna vrijednost i primarni ključ
ii.	Sifra, polje za unos 25 UNICODE karaktera (jedinstvena vrijednost i obavezan unos)
iii.	Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
iv.	Kategorija, polje za unos 50 UNICODE karaktera (obavezan unos)
v.	Cijena, polje za unos decimalnog broja (obavezan unos)
b)	Narudzbe
i.	NarudzbaID, cjelobrojna vrijednost i primarni ključ,
ii.	BrojNarudzbe, polje za unos 25 UNICODE karaktera (jedinstvena vrijednost i obavezan unos)
iii.	Datum, polje za unos datuma (obavezan unos),
iv.	Ukupno, polje za unos decimalnog broja (obavezan unos)
c)	StavkeNarudzbe
i.	ProizvodID, cjelobrojna vrijednost i dio primarnog ključa,
ii.	NarudzbaID, cjelobrojna vrijednost i dio primarnog ključa,
iii.	Kolicina, cjelobrojna vrijednost (obavezan unos)
iv.	Cijena, polje za unos decimalnog broja (obavezan unos)
v.	Popust, polje za unos decimalnog broja (obavezan unos)

*/


/*
3.	Iz baze podataka AdventureWorks2014 u svoju bazu podataka prebaciti sljedeće podatke:
a)	U tabelu Proizvodi dodati sve proizvode koji su prodavani u 2014. godini
i.	ProductNumber -> Sifra
ii.	Name -> Naziv
iii.	ProductCategory (Name) -> Kategorija
iv.	ListPrice -> Cijena
b)	U tabelu Narudzbe dodati sve narudžbe obavljene u 2014. godini
i.	SalesOrderNumber -> BrojNarudzbe
ii.	OrderDate - > Datum
iii.	TotalDue -> Ukupno
c)	U tabelu StavkeNarudzbe prebaciti sve podatke o detaljima narudžbi urađenih u 2014. godini
i.	OrderQty -> Kolicina
ii.	UnitPrice -> Cijena
iii.	UnitPriceDiscount -> Popust
iv.	LineTotal -> Iznos 
	Napomena: Zadržati identifikatore zapisa!	

*/



/*
4.	U svojoj bazi podataka kreirati novu tabelu Skladista sa poljima SkladisteID i Naziv, 
a zatim je povezati sa tabelom Proizvodi u relaciji više prema više. 
Za svaki proizvod na skladištu je potrebno čuvati količinu (cjelobrojna vrijednost).
*/


/*
5.	U tabelu Skladista  dodati tri skladišta proizvoljno, a zatim za sve proizvode na svim skladištima postaviti količinu na 0 komada.
*/

/*
6.	Kreirati uskladištenu proceduru koja vrši izmjenu stanja skladišta (količina).
Kao parametre proceduri proslijediti identifikatore proizvoda i skladišta, te količinu.	
*/



/*
7.	Nad tabelom Proizvodi kreirati non-clustered indeks nad poljima Sifra i Naziv, 
a zatim napisati proizvoljni upit koji u potpunosti iskorištava kreirani indeks. 
Upit obavezno mora sadržavati filtriranje podataka.
*/


/*8.	Kreirati trigger koji će spriječiti brisanje zapisa u tabeli Proizvodi.*/


/*
9.	Kreirati view koji prikazuje sljedeće kolone: šifru, naziv i cijenu proizvoda, ukupnu prodanu količinu i ukupnu zaradu od prodaje.
*/


/*
10.	Kreirati uskladištenu proceduru koja će za unesenu šifru proizvoda prikazivati ukupnu prodanu količinu i ukupnu zaradu.
Ukoliko se ne unese šifra proizvoda procedura treba da prikaže prodaju svih proizovda. U proceduri koristiti prethodno kreirani view.	
*/

/*
11.	U svojoj bazi podataka kreirati novog korisnika za login student te mu dodijeliti odgovarajuću permisiju
kako bi mogao izvršavati prethodno kreiranu proceduru.
*/


/*12.	Napraviti full i diferencijalni backup baze podataka na lokaciji D:\BP2\Backup	 */

