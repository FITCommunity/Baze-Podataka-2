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
create database bp2_2020_9_25
go
use bp2_2020_9_25


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
CREATE TABLE osoba
(
	osoba_id int constraint PK_osoba primary key,
	ime nvarchar(50),
	prezime nvarchar(50),
	tip_osobe nvarchar (2),
	kreditna_id int,
	tip_kreditne nvarchar(50),
	broj_kartice nvarchar(25),
	dtm_izdav date
) 

/*
c) Kreirati tabelu kupac sljedeće strukture:
	- kupac_id		cjelobrojna varijabla, primarni ključ
	- osoba_id		cjelobrojna varijabla
	- prodavnica_id cjelobrojna varijabla
	- br_racuna		10 unicode karaktera 
*/

CREATE TABLE kupac
(
	kupac_id int constraint PK_kupac primary key,
	osoba_id int,
	prodavnica_id int,
	br_racuna varchar(10)
	constraint FK_osoba_kupac foreign key (osoba_id) references osoba (osoba_id)
)

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
CREATE TABLE kupovina
(
	kupovina_id int,
	detalj_id int,
	narudzba_id nvarchar(25),
	kreditna_id int,
	teritorija_id int,
	kupac_id int,
	kolicina int,
	cijena money,
	constraint PK_kupovina primary key (kupovina_id, detalj_id),
	constraint FK_prodaja_kupac foreign key (kupac_id) references kupac (kupac_id)
)
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
insert INTO	osoba
SELECT	p.BusinessEntityID AS osoba_id, p.FirstName as ime, 
		p.LastName as prezime, p.PersonType AS tip_osobe, 
		AdventureWorks2014.Sales.CreditCard.CreditCardID AS kreditna_id, AdventureWorks2014.Sales.CreditCard.CardType AS tip_kreditne,  
		AdventureWorks2014.Sales.CreditCard.CardNumber AS broj_kartice, pcc.ModifiedDate AS dtm_izdav
FROM	AdventureWorks2014.Person.Person p INNER JOIN AdventureWorks2014.Sales.PersonCreditCard pcc
ON		p.BusinessEntityID = pcc.BusinessEntityID 
		INNER JOIN AdventureWorks2014.Sales.CreditCard 
		ON pcc.CreditCardID = AdventureWorks2014.Sales.CreditCard.CreditCardID
--19118

/*
b) Koristeći tabelu Sales.Customer baze AdventureWorks2017 izvršiti insert podataka prema sljedećem pravilu:
	- CustomerID	-> kupac_id
	- PersonID		-> osoba_id
	- StoreID		-> prodavnica_id
	- AccountNumber -> br_racuna
uz uslov da PersonID bude veći od 300.
*/
insert into	kupac
SELECT	CustomerID as kupac_id, PersonID as osoba_id, StoreID as prodavnica_id, AccountNumber as br_racuna
FROM	AdventureWorks2014.Sales.Customer 
where	PersonID > 300
--19114

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
insert into kupovina
SELECT	soh.SalesOrderID AS kupovina_id, sod.SalesOrderDetailID as detalj_id,
		soh.PurchaseOrderNumber AS narudzba_id, soh.CreditCardID AS kreditna_id, 
		soh.TerritoryID AS teritorija_id, soh.CustomerID as kupac_id,
		sod.OrderQty AS kolicina, sod.UnitPrice AS cijena
FROM	AdventureWorks2014.Sales.SalesOrderHeader soh INNER JOIN AdventureWorks2014.Sales.SalesOrderDetail sod
ON		soh.SalesOrderID = sod.SalesOrderID
where	soh.CustomerID < 29000
--59297
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
go
create view view_ukupno
as
SELECT	osoba.osoba_id, sum (kupovina.kolicina * kupovina.cijena) as ukupno
FROM	kupac INNER JOIN kupovina 
ON		kupac.kupac_id = kupovina.kupac_id 
		INNER JOIN osoba 
		ON kupac.osoba_id = osoba.osoba_id
group by osoba.osoba_id
go
--18000

--b
select	'veće', count (*) 
from	view_ukupno
where	ukupno > (select AVG (ukupno) from view_ukupno)
union
select	'jednako', count (*) 
from	view_ukupno
where	ukupno = (select AVG (ukupno) from view_ukupno)
union
select	'manje', count (*) 
from	view_ukupno
where	ukupno < (select AVG (ukupno) from view_ukupno)
/*
veće	6509
jednako	0
manje	11491
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
alter table osoba
add lozinka as LEFT (newid(),2) + '_' + reverse (left (ime, 3)) + '_' + reverse (left (prezime, 3)) + '_' + cast(year (getdate()) as nvarchar) + '_' +	cast(day (getdate()) as nvarchar) + '_' + cast(month (getdate()) as nvarchar) 

update kupac
set prodavnica_id = osoba_id + 1
where prodavnica_id is null
--18484
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
--a
go
create procedure proc_narudzba
as
begin
update kupovina
set narudzba_id = 'n' + '-' + CAST (kupovina_id as nvarchar) + '-' + CAST (detalj_id as nvarchar)
end

exec proc_narudzba
--59297

--b
alter table kupovina
add constraint CK_narudzba_id check (len (narudzba_id) <= 20)
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
go
create procedure proc_klasa
as
begin
select	distinct cijena, 'klasa 1' as klasa
from	kupovina
where	cijena between 0 and 999.99
union
select	distinct cijena, 'klasa 2' as klasa
from	kupovina
where	cijena between 1000 and 1999.99
union
select	distinct cijena, 'klasa 3' as klasa
from	kupovina
where	cijena between 2000 and 2999.99
union
select	distinct cijena, 'klasa 4' as klasa
from	kupovina
where	cijena between 3000 and 3999.99
order by 1
end

exec proc_klasa
--42
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
go
create view view_tip
as
SELECT	osoba.tip_kreditne, kupac.prodavnica_id, COUNT(kupovina.kupovina_id) AS prebrojano
FROM	kupac INNER JOIN kupovina 
ON		kupac.kupac_id = kupovina.kupac_id 
		INNER JOIN osoba ON kupac.osoba_id = osoba.osoba_id
GROUP BY osoba.tip_kreditne, kupac.prodavnica_id
go
--18000

--b
go
create procedure proc_prebrojano
(
	@prebrojano int = null
)
as
begin
select prebrojano, count (*)
from view_tip
where	prebrojano = @prebrojano
group by prebrojano
end

exec proc_prebrojano 3
exec proc_prebrojano 30
/*
3	4505
30	3
*/
--10 bodova


-----------------------------------------------------------------------
--8.
/*
Na osnovu tabele osoba kreirati proceduru nakon čijeg pokretanja će se dobiti ukupan broj osoba čije prezime je jedinstveno.
*/
go
create view view_jedinstveno
as
select prezime, count(*) indikator
from osoba
group by prezime
having COUNT (*) = 1
go

go
create procedure proc_jedinstveno
as
begin
select count (*)
from view_jedinstveno
end

exec proc_jedinstveno
--585
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
SELECT	osoba.osoba_id, osoba.tip_kreditne, left (osoba.broj_kartice,4) klasa, osoba.dtm_izdav, kupovina.narudzba_id
into	temp
FROM	kupac INNER JOIN kupovina 
ON		kupac.kupac_id = kupovina.kupac_id 
		INNER JOIN osoba 
		ON kupac.osoba_id = osoba.osoba_id
--52297

--b
select	distinct tip_kreditne, klasa
from	##temp
order by 1
--jedna

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
--a
select LEN (narudzba_id), COUNT (*)
from kupovina
group by LEN (narudzba_id)
having COUNT (*) > 1000
/*
12	1747
13	42192
14	15213
*/

--b
alter table kupovina
drop constraint [CK_narudzba_id]

alter table kupovina
alter column narudzba_id nvarchar (50)

update kupovina
set narudzba_id = narudzba_id + cast (getdate () as nvarchar)
where LEN (narudzba_id) = 11
--145
--10 bodova
