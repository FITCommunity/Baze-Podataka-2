/*
Napomena:

A.
Prilikom  bodovanja rješenja prioritet ima rezultat 
koji upit treba da vrati (broj zapisa, vrijednosti agregatnih funkcija...).
U slučaju da rezultat upita nije tačan, a rezultat tog upita se koristi
u narednim zadacima, tada se rješenja narednih zadataka, 
bez obzira na tačnost koda, ne boduju punim brojem bodova, 
jer ni ta rješenja ne mogu vratiti tačan rezultat 
(broj zapisa, vrijednosti agregatnih funkcija...).

B.
Tokom pisanja koda obratiti pažnju na tekst zadatka 
i ono što se traži zadatkom. Prilikom pregleda rada pokreće se 
kod koji se nalazi u sql skripti i 
sve ono što nije urađeno prema zahtjevima zadatka 
ili je pogrešno urađeno predstavlja grešku. 
*/

------------------------------------------------
/*
BODOVANJE
	Maksimalni broj bodova:		80
	Prag prolaznosti:			44

RASPON OCJENA
	bodovi			ocjena
	0	-	43		5
	44	-	58		6
	59	-	73		7
	74	-	80		8
*/
------------------------------------------------



------------------------------------------------
--1. 
/*
Kreirati bazu podataka pod vlastitim brojem indeksa
i aktivirati je.
*/

---------------------------------------------------------------------------
--Prilikom kreiranja tabela voditi računa o njihovom međusobnom odnosu.
---------------------------------------------------------------------------
/*
a) 
Kreirati tabelu prodavac koja će imati sljedeću strukturu:
	- prodavac_id, cjelobrojni tip, primarni ključ
	- naziv_posla, 50 unicode karaktera
	- dtm_rodj, datumski tip
	- bracni_status, 1 karakter
	- prod_kvota, novčani tip
	- bonus, novčani tip
*/

/*
b) 
Kreirati tabelu prodavnica koja će imati sljedeću strukturu:
	- prodavnica_id, cjelobrojni tip, primarni ključ
	- naziv_prodavnice, 50 unicode karaktera
	- prodavac_id, cjelobrojni tip
*/

/*
c) 
Kreirati tabelu kupac_detalji koja će imati sljedeću strukturu:
	- detalj_id, cjelobrojni tip, primarni ključ, automatsko punjenje sa početnom vrijednošću 1 i inkrementom 1
	- kupac_id, cjelobrojni tip, primarni ključ
	- prodavnica_id, cjelobrojni tip
	- br_rac, 10 karaktera
	- dtm_narudz, datumski tip
	- kolicina, skraćeni cjelobrojni tip
	- cijena, novčani tip
	- popust, realni tip
*/
--10 bodova





--2.
/*
a)
Koristeći tabele HumanResources.Employee i Sales.SalesPerson
baze AdventureWorks2017 zvršiti insert podataka u 
tabelu prodavac prema sljedećem pravilu:
	- BusinessEntityID -> prodavac_id
	- JobTitle -> naziv_posla
	- BirthDate -> dtm_rodj
	- MaritalStatus -> bracni_status
	- SalesQuota -> prod_kvota
	- Bonus -> nžbonus
*/

/*
b)
Koristeći tabelu Sales.Store baze AdventureWorks2017 
izvršiti insert podataka u tabelu prodavnica 
prema sljedećem pravilu:
	- BusinessEntityID -> prodavnica_id
	- Name -> naziv_prodavnice
	- SalesPersonID -> prodavac_id
*/

/*
b)
Koristeći tabele Sales.Customer, Sales.SalesOrderHeader i SalesOrderDetail
baze AdventureWorks2017 izvršiti insert podataka u tabelu kupac_detalji
prema sljedećem pravilu:
	- CustomerID -> kupac_id
	- StoreID -> prodavnica_id
	- AccountNumber -> br_rac
	- OrderDate -> dtm_narudz
	- OrderQty -> kolicina
	- UnitPrice -> cijena
	- UnitPriceDiscount -> popust
Uslov je da se ne dohvataju zapisi u kojima su 
StoreID i PersonID NULL vrijednost
*/
--10 bodova






--3.
/*
a)
U tabeli prodavac dodati izračunatu kolonu god_rodj
u koju će se smještati godina rođenja prodavca.
b)
U tabeli kupac_detalji promijeniti tip podatka
kolone cijena iz novčanog u decimalni tip oblika (8,2)
c)
U tabeli kupac_detalji dodati standardnu kolonu
lozinka tipa 20 unicode karaktera.
d) 
Kolonu lozinka popuniti tako da bude spojeno 
10 slučajno generisanih znakova i 
numerički dio (bez vodećih nula) iz kolone br_rac
*/
--10 bodova






--4.
/*
Koristeći tabele prodavnica i kupac_detalji
dati pregled sumiranih količina po 
nazivu prodavnice i godini naručivanja.
Sortirati po nazivu prodavnice.
*/
--6 bodova






--5.
/*
Kreirati pogled v_prodavac_cijena sljedeće strukture:
	- prodavac_id
	- bracni_status
	- sum_cijena
Uslov je da se u pogled dohvate samo oni zapisi u 
kojima je sumirana vrijednost veća od 1000000.
*/
--8 bodova






--6.
/*
Koristeći pogled v_prodavac_cijena
kreirati proceduru p_prodavac_cijena sa parametrom
bracni_status čija je zadata (default) vrijednost M.
Uslov je da se procedurom dohvataju zapisi u kojima je 
vrijednost u koloni sum_cijena veća od srednje vrijednosti kolone sum_cijena.
Obavezno napisati kod za pokretanje procedure.
*/
--8 bodova






--7.
/*
Iz tabele kupac_detalji prikazati zapise u kojima je 
vrijednost u koloni cijena jednaka 
minimalnoj, odnosno, maksimalnoj vrijednosti u ovoj koloni.
Upit treba da vraća kolone kupac_id, prodavnica_id i cijena.
Sortirati u rastućem redoslijedu prema koloni cijena.
*/
--8 bodova






--8.
/*
a)
U tabeli kupac_detalji kreirati kolonu
cijena_sa_popustom tipa decimal (8,2).
b) 
Koristeći tabelu kupac_detalji
kreirati proceduru p_popust sa parametrom 
godina koji će odgovarati godini iz datum naručivanja.
Procedura će vršiti update kolone cijena_sa_popustom
ako je vrijednost parametra veća od 2013, 
inače se daje poruka 'transakcija nije izvršena'.
Testirati funkcionisanje procedure za vrijednost 
parametra godina 2014.

Obavezno napisati kod za provjeru sadržaja tabele 
nakon što se pokrene procedura.
*/
--8 bodova






--9.
/*
a)
U tabeli prodavac kreirati kolonu min_kvota tipa decimal (8,2).
i na njoj postaviti ograničenje da se
ne može unijeti negativna vrijednost.
b)
Kreirati skalarnu funkciju f_kvota sa parametrom prod_kvota.
Funkcija će vraćati rezultat tipa decimal (8,2)
koji će se računati po pravilu:
	10% od prod_kvota
c) 
Koristeći funkciju f_kvota izvršiti update
kolone min_kvota u tabeli prodavac
*/
--8 bodova






--10.
/*
a)
Kreirati tabelu prodavac_log strukture:
	- log_id, primarni ključ, automatsko punjenje sa početnom vrijednošću 1 i inkrementom 1 
	- prodavac_id int
	- min_kvota decimal (8,2)
	- dogadjaj varchar (3)
	- mod_date datetime
b)
Nad tabelom prodavac kreirati okidač t_ins_prod
kojim će se prilikom inserta podataka u 
tabelu prodavac izvršiti insert podataka u 
tabelu prodavac_log sa naznakom aktivnosti 
(insert, update ili delete).
c)
U tabelu autori insertovati zapis
291, Sales Manager, 1985-09-30, M, 250000.00, 985.00, -20000.00
Ako je potrebno izvršiti podešavanja 
koja će omogućiti insrt zapisa. 
d)
Obavezno napisati kod za pregled sadržaja 
tabela prodavac i prodavac_log.
*/
--4 boda
