/*Napomena:


1. Prilikom  bodovanja rješenja prioritet ima razultat koji treba upit da vrati (broj zapisa, vrijednosti agregatnih funkcija...).
U slučaju da rezultat upita nije tačan, a pogled, tabela... koji su rezultat tog upita se koriste u narednim zadacima, 
tada se rješenja narednih zadataka, bez obzira na tačnost koda, ne boduju punim brojem bodova, jer ni ta rješenja ne mogu vratiti 
tačan rezultat (broj zapisa, vrijednosti agregatnih funkcija...).

2. Tokom pisanja koda obratiti posebnu pažnju na tekst zadatka i ono što se traži zadatkom. 
Prilikom pregleda rada pokreće se kod koji se nalazi u sql skripti i sve ono što nije urađeno prema zahtjevima zadatka ili 
je pogrešno urađeno predstavlja grešku. Shodno navedenom na uvidu se ne prihvata prigovor da je neki dio koda posljedica previda 
("nisam vidio", "slučajno sam to napisao"...) 
*/


/*
1.
a) Kreirati bazu pod vlastitim brojem indeksa.
*/


/* 
b) Kreiranje tabela.
Prilikom kreiranja tabela voditi računa o odnosima između tabela.
I. Kreirati tabelu produkt sljedeće strukture:
	- produktID, cjelobrojna varijabla, primarni ključ
	- jed_cijena, novčana varijabla
	- kateg_naziv, 15 unicode karaktera
	- mj_jedinica, 20 unicode karaktera
	- dobavljac_naziv, 40 unicode karaktera
	- dobavljac_post_br, 10 unicode karaktera
*/


/*
II. Kreirati tabelu narudzba sljedeće strukture:
	- narudzbaID, cjelobrojna varijabla, primarni ključ
	- dtm_narudzbe, datumska varijabla za unos samo datuma
	- dtm_isporuke, datumska varijabla za unos samo datuma
	- grad_isporuke, 15 unicode karaktera
	- klijentID, 5 unicode karaktera
	- klijent_naziv, 40 unicode karaktera
	- prevoznik_naziv, 40 unicode karaktera
*/


/*
III. Kreirati tabelu narudzba_produkt sljedeće strukture:
	- narudzbaID, cjelobrojna varijabla, obavezan unos
	- produktID, cjelobrojna varijabla, obavezan unos
	- uk_cijena, novčana varijabla
*/

--10 bodova



----------------------------------------------------------------------------------------------------------------------------
/*
2. Import podataka
a) Iz tabela Categories, Product i Suppliers baze Northwind u tabelu produkt importovati podatke prema pravilu:
	- ProductID -> produktID
	- QuantityPerUnit -> mj_jedinica
	- UnitPrice -> jed_cijena
	- CategoryName -> kateg_naziv
	- CompanyName -> dobavljac_naziv
	- PostalCode -> dobavljac_post_br
*/


/*
a) Iz tabela Customers, Orders i Shipers baze Northwind u tabelu narudzba importovati podatke prema pravilu:
	- OrderID -> narudzbaID
	- OrderDate -> dtm_narudzbe
	- ShippedDate -> dtm_isporuke
	- ShipCity -> grad_isporuke
	- CustomerID -> klijentID
	- CompanyName -> klijent_naziv
	- CompanyName -> prevoznik_naziv
*/


/*
c) Iz tabele Order Details baze Northwind u tabelu narudzba_produkt importovati podatke prema pravilu:
	- OrderID -> narudzbaID
	- ProductID -> produktID
	- uk_cijena <- produkt jedinične cijene i količine
uz uslov da je odobren popust 5% na produkt.
*/

--10 bodova


----------------------------------------------------------------------------------------------------------------------------
/*
3. 
a) Koristeći tabele narudzba i narudzba_produkt kreirati pogled view_uk_cijena koji će imati strukturu:
	- narudzbaID
	- klijentID
	- uk_cijena_cijeli_dio
	- uk_cijena_feninzi - prikazati kao cijeli broj  
Obavezno pregledati sadržaj pogleda.
b) Koristeći pogled view_uk_cijena kreirati tabelu nova_uk_cijena uz uslov da se preuzmu samo oni zapisi u kojima su feninzi veći od 49. 
U tabeli trebaju biti sve kolone iz pogleda, te nakon njih kolona uk_cijena_nova u kojoj će ukupna cijena biti zaokružena na veću vrijednost. 
Npr. uk_cijena = 10, feninzi = 90 -> uk_cijena_nova = 11
*/





----------------------------------------------------------------------------------------------------------------------------
/*
4. 
Koristeći tabelu uk_cijena_nova kreiranu u 3. zadatku kreirati proceduru tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara 
(možemo ostaviti bilo koji parametar bez unijete vrijednosti). Proceduru pokrenuti za sljedeće vrijednosti varijabli:
1. narudzbaID - 10730
2. klijentID  - ERNSH
*/


--10 bodova



----------------------------------------------------------------------------------------------------------------------------
/*
5.
Koristeći tabelu produkt kreirati proceduru proc_post_br koja će prebrojati zapise u kojima poštanski broj dobavljača počinje cifrom. 
Potrebno je dati prikaz poštanskog broja i ukupnog broja zapisa po poštanskom broju. Nakon kreiranja pokrenuti proceduru.
*/

--5 bodova


-------------------------------------------------------------------
/*
6.
a) Iz tabele narudzba kreirati pogled view_prebrojano sljedeće strukture:
	- klijent_naziv
	- prebrojano - ukupan broj narudžbi po nazivu klijent
Obavezno napisati naredbu za pregled sadržaja pogleda.
b) Napisati naredbu kojom će se prikazati maksimalna vrijednost kolone prebrojano.
c) Iz pogleda kreiranog pod a) dati pregled zapisa u kojem će osim kolona iz pogleda prikazati razlika maksimalne vrijednosti i kolone prebrojano 
uz uslov da se ne prikazuje zapis u kojem se nalazi maksimlana vrijednost.
*/

--12 bodova


-------------------------------------------------------------------
/*
7.
a) U tabeli produkt dodati kolonu lozinka, 20 unicode karaktera 
b) Kreirati proceduru kojom će se izvršiti punjenje kolone lozinka na sljedeći način:
	- ako je u dobavljac_post_br podatak sačinjen samo od cifara, lozinka se kreira obrtanjem niza znakova koji se dobiju spajanjem zadnja četiri 
	znaka kolone mj_jedinica i kolone dobavljac_post_br
	- ako podatak u dobavljac_post_br podatak sadrži jedno ili više slova na bilo kojem mjestu, 
	lozinka se kreira obrtanjem slučajno generisanog niza znakova
Nakon kreiranja pokrenuti proceduru.
Obavezno provjeriti sadržaj tabele narudžba.
*/

--10 bodova


-------------------------------------------------------------------
/*
8. 
a) Kreirati pogled kojim sljedeće strukture:
	- produktID,
	- dobavljac_naziv,
	- grad_isporuke
	- period_do_isporuke koji predstavlja vremenski period od datuma narudžbe do datuma isporuke
Uslov je da se dohvate samo oni zapisi u kojima je narudzba realizirana u okviru 4 sedmice.
Obavezno pregledati sadržaj pogleda.

b) Koristeći pogled view_isporuka kreirati tabelu isporuka u koju će biti smještene sve kolone iz pogleda. 
*/


-------------------------------------------------------------------
/*
9.
a) U tabeli isporuka dodati kolonu red_br_sedmice, 10 unicode karaktera.
b) U tabeli isporuka izvršiti update kolone red_br_sedmice ( prva, druga, treca, cetvrta) u zavisnosti od vrijednosti u koloni period_do_isporuke. 
Pokrenuti proceduru
c) Kreirati pregled kojim će se prebrojati broj zapisa po rednom broju sedmice. 
Pregled treba da sadrži redni broj sedmice i ukupan broj zapisa po rednom broju.
*/

--15 bodova

-------------------------------------------------------------------
/*
10.
a) Kreirati backup baze na default lokaciju.
b) Kreirati proceduru kojom će se u jednom izvršavanju obrisati svi pogledi i procedure u bazi. Pokrenuti proceduru.
*/

--5 BODOVA
