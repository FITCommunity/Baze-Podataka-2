-------------------------------------------------------------
/*
Napomena:

A.
Prilikom  bodovanja rješenja prioritet ima rezultat koji upit treba da vrati (broj zapisa, vrijednosti agregatnih funkcija...).
U slučaju da rezultat upita nije tačan, a pogled, tabela... koji su rezultat tog upita se koriste u narednim zadacima, 
tada se rješenja narednih zadataka, bez obzira na tačnost koda, ne boduju punim brojem bodova, 
jer ni ta rješenja ne mogu vratiti tačan rezultat (broj zapisa, vrijednosti agregatnih funkcija...).

B.
Tokom pisanja koda obratiti posebnu pažnju na tekst zadatka i ono što se traži zadatkom. 
Prilikom pregleda rada pokreće se kod koji se nalazi u sql skripti i 
sve ono što nije urađeno prema zahtjevima zadatka ili je pogrešno urađeno predstavlja grešku. 
*/


--1.
/*
Kreirati bazu podataka pod vlastitim brojem indeksa.
*/

/*Prilikom kreiranja tabela voditi računa o međusobnom odnosu između tabela.
a) Kreirati tabelu osoba sljedeće strukture:
	- osoba_id		cjelobrojna varijabla, primarni ključ
	- ime			50 UNICODE karaktera
	- prezime		50 UNICODE karaktera
	- tip_osobe		2 UNICODE karaktera
	- kreditna_id	cjelobrojna varijabla
	- tip_kreditne	50 UNICODE karaktera
	- broj_kartice	50 UNICODE karaktera
	- dtm_izdav		datumska varijabla
*/

/*
c) Kreirati tabelu kupac sljedeće strukture:
	- kupac_id		cjelobrojna varijabla, primarni ključ
	- osoba_id		cjelobrojna varijabla
	- prodavnica_id cjelobrojna varijabla
	- br_racuna		10 unicode karaktera 
*/


/*
c) Kreirati tabelu kupovina sljedeće strukture:
	- kupovina_id	cjelobrojna varijabla, primarni ključ
	- detalj_id		cjelobrojna varijabla, primarni ključ
	- narudzba_id	25 UNICODE karaktera
	- kreditna_id	cjelobrojna varijabla
	- teritorija_id cjelobrojna varijabla
	- kupac_id		cjelobrojna varijabla
	- kolicina		cjelobrojna varijabla
	- cijena		novčana varijabla
*/

--10 bodova

-----------------------------------------------------------------------
--2.
/*
a) Koristeći tabele Person.Person, Sales.PersonCreditCard i Sales.CreditCard baze AdventureWorks2017 izvršiti insert podataka prema sljedećem pravilu:
	- BusinessEntityID	-> osoba_id
	- FirstName			-> ime
	- LastName			-> prezime
	- CardType			-> tip_kreditne 
	- PersonType		-> tip_osobe
	- CardNumber		-> broj_kartice
	- CreditCardID		-> kreditna_id
	- ModifiedDate		-> dtm_izdav
*/

/*
b) Koristeći tabelu Sales.Customer baze AdventureWorks2017 izvršiti insert podataka prema sljedećem pravilu:
	- CustomerID	-> kupac_id
	- PersonID		-> osoba_id
	- StoreID		-> prodavnica_id
	- AccountNumber -> br_racuna
uz uslov da PersonID bude veći od 300.
*/


/*
c) Koristeći tabele Sales.SalesOrderHeader i Sales.SalesOrderDetail baze AdventureWorks2017 izvršiti insert podataka u tabelu kupovina prema sljedećem pravilu:
	- SalesOrderID			-> kupovina_id
	- SalesOrderDetailID	-> detalj_id
	- PurchaseOrderNumber	-> narudzba_id
	- CreditCardID			-> kreditna_id
	- TerritoryID			-> teritorija_id
	- CustomerID			-> kupac_id
	- OrderQty				-> kolicina
	- UnitPrice				-> cijena
uz uslov da CustomerID bude manji od 29000.
*/

--10 bodova

-----------------------------------------------------------------------
--3.
/*
a)
Kreirati pogled view_ukupno kojim će se dati ukupna vrijednost svih kupovina koje je osoba ostvarila.
Pogled treba sadržavati kolone:
	- osoba_id
	- ukupno - ukupna svota svih kupovina 
Napomena: 
Vrijednost jedne kupovine predstavlja umnožak količine i cijene.
b)
Odrediti koliko je zapisa veće, koliko jednako, a koliko manje od srednje vrijednosti kolone ukupno iz view_ukupno.
Rezultat upita treba da vrati prebrojane brojeve sa pripadajućim oznakama (veće, jednako, manje).
Ne prihvata se rješenje koje ne vraća oznake.
*/

--10 bodova


-----------------------------------------------------------------------
--4.
/*
a)
U tabeli osoba dodati izračunatu kolonu lozinka. 
Podatak u koloni lozinka će se sastojati od sljedećih dijelova:
	-	2 znaka slučajno generisani karakteri
	-	bilo koja 3 karaktera iz kolona ime u obrnutom redoslijedu
	-	bilo koja 3 karaktera iz kolone prezime u obrnutom redoslijedu
	-	godina iz datuma izdavanja
	-	dan iz datuma izdavanja
	-	mjesec iz datuma izdavanja
Između svih dijelova lozinke OBAVEZNO treba biti donja crta.
b)
U tabeli kupac u koloni prodavnica_id umjesto NULL vrijednosti ubaciti vrijednost podatka iz kolone osoba_id uvećan za 1.
*/

--10 bodova




-----------------------------------------------------------------------
--5.
/*
a)
Kreirati proceduru proc_narudzba kojom će se smještati podaci u kolonu narudzba_id tabele kupovina.
Podatak u koloni narudzba_id će se sastoji od sljedećih dijelova:
	- 1. karakter je slovo n
	- kupovina_id
	- detalj_id
Između svih dijelova narudzba_id OBAVEZNO treba biti srednja crta.
OBAVEZNO pokrenuti proceduru.
b)
Nad kolonom narudzba_id kreirati ograničenje kojim će biti moguće unijeti podatak koji ima najviše 20 karaktera.
*/

--10 bodova



-----------------------------------------------------------------------
--6.
/*
Neka su za cijene definirane sljedeće 4 klase:
	- 0-999,99		=> klasa 1 
	- 1000-1999,99	=> klasa 2
	- 2000-2999,99	=> klasa 3
	- 3000-3999,99	=> klasa 4
Kreirati proceduru proc_klasa kojom će se izvršiti klasificiranje cijena prema navedenim klasama.
Procedura treba da vrati cijenu (njenu vrijednost) i oznaku klase kojoj pripada,
uz uslov da procedura ne vraća duplikate cijena.
*/

--10 bodova




-----------------------------------------------------------------------
--7.
/*
a)
Koristeći tabele baze kreirati pogled view_tip sljedeće strukture:
	- tip kreditne kartice
	- ID prodavnice
	- prebrojano - prebrojani broj kupovina po tipu kreditne kartice i ID prodavnice
b)
Koristeći pogled view_tip kreirati proceduru proc_tip koja će imati parametar za kolonu prebrojano. Pokrenuti proceduru za vrijednosti paramtera 3 i 30.
*/

--10 bodova


-----------------------------------------------------------------------
--8.
/*
Na osnovu tabele osoba kreirati proceduru nakon čijeg pokretanja će se dobiti ukupan broj osoba čije prezime je jedinstveno.
*/

--10 bodova


-----------------------------------------------------------------------
--9.
/*
a)
Koristeći tabele baze kreirati globalnu privremenu tabelu temp sljedeće strukture:
	- ID osobe 
	- tip kreditne kartice
	- klasa - prve 4 cifre iz kolone broj_kartice
	- datum izdavanja
	- ID narudzbe
i u nju povući podatke iz odgovarajućih tabela.
b) 
Provjeriti da li je jednom tipu kreditne kartice u privremenoj tabeli pridružena jedna ili više klasa.
*/


--10 bodova


-----------------------------------------------------------------------
--10.
/*
a)
Prebrojati broj pojavljivanja dužina podatka u koloni narudzba_id,  
uz uslov da se prikažu samo one vrijednosti dužina koja se pojavljaju više od 1000 puta.
b) 
Svim zapisima čija dužina podatka se pojavljuje manje od 1000 puta promijeniti sadržaj 
kolone narudzba_id tako što će se na postojeći podatak dodati tekući datum.
*/



--10 bodova
