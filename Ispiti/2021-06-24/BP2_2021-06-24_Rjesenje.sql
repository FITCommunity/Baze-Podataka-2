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

create database ispit_24_06_2021
go

use ispit_24_06_2021
go



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

create table prodavac
(
	prodavac_id int constraint PK_prodavac_id primary key,
	naziv_posla nvarchar(50),
	dtm_rodj date,
	bracni_status char(1),
	prod_kvota money,
	bonus money
)



/*
b) 
Kreirati tabelu prodavnica koja će imati sljedeću strukturu:
	- prodavnica_id, cjelobrojni tip, primarni ključ
	- naziv_prodavnice, 50 unicode karaktera
	- prodavac_id, cjelobrojni tip
*/

create table prodavnica
(
	prodavnica_id int constraint PK_prodavnica primary key,
	naziv_prodavnice nvarchar(50),
	prodavac_id int constraint FK_prodavac_id foreign key(prodavac_id) references prodavac(prodavac_id)
)


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

create table kupac_detalji
(
	detalj_id int identity(1,1),
	kupac_id int,
	prodavnica_id int, 
	br_rac nvarchar(10),
	dtm_narudz date, 
	kolicina smallint, 
	cijena money, 
	popust real,
	constraint PK_detalj_kupac_id primary key(detalj_id,kupac_id),
	constraint FK_prodavnica_id foreign key(prodavnica_id) references prodavnica(prodavnica_id)
)

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

insert into prodavac
select sp.BusinessEntityID,
	   e.JobTitle,
	   e.BirthDate,
	   e.MaritalStatus,
	   sp.SalesQuota,
	   sp.Bonus
from AdventureWorks2017.HumanResources.Employee as e
inner join AdventureWorks2017.Sales.SalesPerson as sp on e.BusinessEntityID = sp.BusinessEntityID


/*
b)
Koristeći tabelu Sales.Store baze AdventureWorks2017 
izvršiti insert podataka u tabelu prodavnica 
prema sljedećem pravilu:
	- BusinessEntityID -> prodavnica_id
	- Name -> naziv_prodavnice
	- SalesPersonID -> prodavac_id
*/

insert into prodavnica
select s.BusinessEntityID,
	   s.Name,
	   s.SalesPersonID
from AdventureWorks2017.Sales.Store as s


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

insert into kupac_detalji
select c.CustomerID,
	   c.StoreID,
	   c.AccountNumber,
	   soh.OrderDate,
	   sod.OrderQty,
	   sod.UnitPrice,
	   sod.UnitPriceDiscount
from AdventureWorks2017.Sales.Customer as c
inner join AdventureWorks2017.Sales.SalesOrderHeader as soh on c.CustomerID = soh.CustomerID
inner join AdventureWorks2017.Sales.SalesOrderDetail as sod on soh.SalesOrderID = sod.SalesOrderID
where c.StoreID is not null and c.PersonID is not null
--10 bodova






--3.
/*
a)
U tabeli prodavac dodati izračunatu kolonu god_rodj
u koju će se smještati godina rođenja prodavca.
*/

alter table prodavac
add god_rodj as year(dtm_rodj)


select * from prodavac



/*
b)
U tabeli kupac_detalji promijeniti tip podatka
kolone cijena iz novčanog u decimalni tip oblika (8,2)
*/

alter table kupac_detalji
alter column cijena decimal(8,2)



/*
c)
U tabeli kupac_detalji dodati standardnu kolonu
lozinka tipa 20 unicode karaktera.
*/

alter table kupac_detalji
add lozinka nvarchar(20)

select * from kupac_detalji



/*
d) 
Kolonu lozinka popuniti tako da bude spojeno 
10 slučajno generisanih znakova i 
numerički dio (bez vodećih nula) iz kolone br_rac
*/
update kupac_detalji
set lozinka = left(newid(),10) + RIGHT(br_rac,5)

select *
from kupac_detalji

--10 bodova






--4.
/*
Koristeći tabele prodavnica i kupac_detalji
dati pregled sumiranih količina po 
nazivu prodavnice i godini naručivanja.
Sortirati po nazivu prodavnice.
*/

select p.naziv_prodavnice,
	   YEAR(kd.dtm_narudz) as godina,
	   SUM(kd.kolicina) as suma_kolicine
from prodavnica as p
inner join kupac_detalji as kd on p.prodavnica_id = kd.prodavnica_id
group by p.naziv_prodavnice,
	   YEAR(kd.dtm_narudz)
order by 1
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

go
create view v_prodavac_cijena
as
select p.prodavac_id,
	   p.bracni_status,
	   SUM(kd.cijena) as sum_cijena
from prodavac as p
inner join prodavnica as pr on p.prodavac_id = pr.prodavac_id
inner join kupac_detalji as kd on pr.prodavnica_id = kd.prodavnica_id
group by p.prodavac_id,
	   p.bracni_status
having SUM(kd.cijena) > 1000000

select * from v_prodavac_cijena
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

go
create procedure p_prodavac_cijena 
(
	@bracni_status char(1) = 'M'
)
as
begin
	select * 
	from v_prodavac_cijena
	where bracni_status = @bracni_status and
		  sum_cijena > (select AVG(sum_cijena) from v_prodavac_cijena)
end

exec p_prodavac_cijena;
--8 bodova






--7.
/*
Iz tabele kupac_detalji prikazati zapise u kojima je 
vrijednost u koloni cijena jednaka 
minimalnoj, odnosno, maksimalnoj vrijednosti u ovoj koloni.
Upit treba da vraća kolone kupac_id, prodavnica_id i cijena.
Sortirati u rastućem redoslijedu prema koloni cijena.
*/

select kupac_id,
	   prodavnica_id,
	   cijena
from kupac_detalji
where cijena = (select MIN(cijena) from kupac_detalji) or cijena = (select MAX(cijena) from kupac_detalji)
--8 bodova






--8.
/*
a)
U tabeli kupac_detalji kreirati kolonu
cijena_sa_popustom tipa decimal (8,2).
*/
alter table kupac_detalji 
add cijena_sa_popustom decimal(8,2)

select * from kupac_detalji

/*
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

go
alter procedure p_popust
(
	@godina int
)
as
begin
	begin transaction
		update kupac_detalji
		set cijena_sa_popustom = cijena * (1 - popust)
		where YEAR(dtm_narudz) = @godina 
		if (@godina > 2013)
			begin
				commit transaction
				print('Transakcija uspjesna!')
			end
		else
			begin
				print('Transakcija nije izvrsena!')
				rollback transaction
			end
end



--testiranje
exec p_popust @godina = 2014;
exec p_popust @godina = 2010;

select * from kupac_detalji
--8 bodova






--9.
/*
a)
U tabeli prodavac kreirati kolonu min_kvota tipa decimal (8,2).
i na njoj postaviti ograničenje da se
ne može unijeti negativna vrijednost.
*/

alter table prodavac
add min_kvota decimal(8,2) constraint CK_min_kvota check(min_kvota >=0)

select * from prodavac
/*
b)
Kreirati skalarnu funkciju f_kvota sa parametrom prod_kvota.
Funkcija će vraćati rezultat tipa decimal (8,2)
koji će se računati po pravilu:
	10% od prod_kvota
*/

go
create function f_kvota(@prod_kvota money)
returns decimal(8,2)
as
begin
	return @prod_kvota * 0.10
end

--testiranje
select dbo.f_kvota(50)


/*
c) 
Koristeći funkciju f_kvota izvršiti update
kolone min_kvota u tabeli prodavac
*/
update prodavac
set min_kvota = dbo.f_kvota(prod_kvota)

select * from prodavac
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
*/

create table prodavac_log
(
	log_id int constraint PK_log_id primary key identity(1,1),
	prodavac_id int,
	min_kvota decimal (8,2),
	dogadjaj varchar (3),
	mod_date datetime
)

/*
b)
Nad tabelom prodavac kreirati okidač t_ins_prod
kojim će se prilikom inserta podataka u 
tabelu prodavac izvršiti insert podataka u 
tabelu prodavac_log sa naznakom aktivnosti 
(insert, update ili delete).
*/

go
create trigger t_ins_prod
on prodavac
after insert
as
begin
	insert into prodavac_log
	select i.prodavac_id,
		   i.min_kvota,
		   'ins',
		   getdate()
	from inserted as i 
end




/*
c)
U tabelu prodavac insertovati zapis
291, Sales Manager, 1985-09-30, M, 250000.00, 985.00, -20000.00
Ako je potrebno izvršiti podešavanja 
koja će omogućiti insrt zapisa. 
*/

--da bi mogli izvrsiti insert potrebno je dropati constraint
alter table prodavac
drop constraint CK_min_kvota

insert into prodavac
values(291, 'Sales Manager', '1985-09-30','M', 250000.00, 985.00, -20000.00)

/*
d)
Obavezno napisati kod za pregled sadržaja 
tabela prodavac i prodavac_log.
*/
select * from prodavac
select * from prodavac_log
--4 boda
