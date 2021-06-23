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

------------------------------------------------
--1
/*
Kreirati bazu podataka pod vlastitim brojem indeksa.
*/

create database BP2_2020_09_11
go

use BP2_2020_09_11
go


/*Prilikom kreiranja tabela voditi računa o međusobnom odnosu između tabela.
a) Kreirati tabelu radnik koja će imati sljedeću strukturu:
	- radnikID, cjelobrojna varijabla, primarni ključ
	- drzavaID, 15 unicode karaktera
	- loginID, 256 unicode karaktera
	- sati_god_odmora, cjelobrojna varijabla
	- sati_bolovanja, cjelobrojna varijabla
*/

create table radnik
(
	radnikID int,
	drzavaID nvarchar(15),
	loginID nvarchar(256),
	sati_god_odmora int,
	sati_bolovanja int
	constraint PK_radnikID primary key(radnikID)
)

/*
b) Kreirati tabelu nabavka koja će imati sljedeću strukturu:
	- nabavkaID, cjelobrojna varijabla, primarni ključ
	- status, cjelobrojna varijabla
	- nabavaljacID, cjelobrojna varijabla
	- br_racuna, 15 unicode karaktera
	- naziv_nabavljaca, 50 unicode karaktera
	- kred_rejting, cjelobrojna varijabla
*/

create table nabavka
(
	nabavkaID int,
	status int,
	nabavaljacID int,
	br_racuna nvarchar(15),
	naziv_nabavljaca nvarchar(50),
	kred_rejting int
	constraint PK_nabavkaID primary key(nabavkaID)
	constraint FK_radnikID foreign key(nabavaljacID) references radnik(radnikID)
)

/*
c) Kreirati tabelu prodaja koja će imati sljedeću strukturu:
	- prodavacID, cjelobrojna varijabla, primarni ključ
	- prod_kvota, novčana varijabla
	- bonus, novčana varijabla
	- proslogod_prodaja, novčana varijabla
	- naziv_terit, 50 unicode karaktera
*/
--10 bodova

create table prodaja
(
	prodavacID int,
	prod_kvota money,
	bonus money,
	proslogod_prodaja money,
	naziv_terit nvarchar(50),
	constraint PK_prodavacID primary key(prodavacID),
	constraint FK_prodavacID foreign key(prodavacID) references radnik(radnikID)
)


--------------------------------------------
--2. Import podataka
/*
a) Iz tabele HumanResources.Employee AdventureWorks2017 u tabelu radnik importovati podatke po sljedećem pravilu:
	- BusinessEntityID -> radnikID
	- NationalIDNumber -> drzavaID
	- LoginID -> loginID
	- VacationHours -> sati_god_odmora
	- SickLeaveHours -> sati_bolovanja
*/

insert into radnik
select	BusinessEntityID, NationalIDNumber, LoginID, VacationHours, SickLeaveHours
from	AdventureWorks2019.HumanResources.Employee

/*
b) Iz tabela Purchasing.PurchaseOrderHeader i Purchasing.Vendor baze AdventureWorks2017 u tabelu nabavka importovati podatke po sljedećem pravilu:
	- PurchaseOrderID -> nabavkaID
	- Status -> status
	- EmployeeID -> radnikID
	- AccountNumber -> br_racuna
	- Name -> naziv_nabavljaca
	- CreditRating -> kred_rejting
*/

insert into nabavka
select	poh.PurchaseOrderID, poh.Status, poh.EmployeeID, v.AccountNumber, v.Name, v.CreditRating
from	AdventureWorks2019.Purchasing.PurchaseOrderHeader poh join AdventureWorks2019.Purchasing.Vendor v
on		poh.VendorID = v.BusinessEntityID

/*
c) Iz tabela Sales.SalesPerson i Sales.SalesTerritory baze AdventureWorks2017 u tabelu prodaja importovati podatke po sljedećem pravilu:
	- BusinessEntityID -> prodavacID
	- SalesQuota -> prod_kvota
	- Bonus -> bonus
	- SalesLastYear iz Sales.SalesPerson -> proslogod_prodaja
	- Name -> naziv_terit
*/

insert into prodaja
select	sp.BusinessEntityID, sp.SalesQuota, sp.Bonus, sp.SalesLastYear, st.Name
from	AdventureWorks2019.Sales.SalesPerson sp join AdventureWorks2019.Sales.SalesTerritory st
on		sp.TerritoryID = st.TerritoryID

select * from prodaja
select * from radnik

--10 bodova

------------------------------------------
/*
3.
a) Iz tabela radnik i nabavka kreirati pogled view_drzavaID koji će imati sljedeću strukturu: 
	- nabavkaID,
	- loginID,
	- status
	- naziv nabavljača,
	- kreditni rejting
Uslov je da u pogledu budu zapisi u kojima je kreditni rejting veći od 1.
b) Koristeći prethodno kreirani pogled prebrojati broj obavljenih nabavki prema kreditnom rejtingu. 
Npr. kreditni rejting 8 se pojavljuje 20 puta. Pregled treba da sadrži oznaku kreditnog rejtinga i ukupan broj obavljenih nabavki.
*/
--10 bodova

--a
go
create view view_drzavaID
as
select	n.nabavkaID, r.loginID, n.status, n.naziv_nabavljaca, n.kred_rejting
from	radnik r join nabavka n
on		r.radnikID = n.nabavaljacID
where	n.kred_rejting > 1

select * from view_drzavaID


--b
select	kred_rejting, COUNT(*)
from	view_drzavaID
group by kred_rejting

-----------------------------------------------
/*
4.
Kreirati proceduru koja će imati istu strukturu kao pogled kreiran u prethodnom zadatku. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti 
bilo koji broj parametara (možemo ostaviti bilo koji parametar bez unijete vrijednosti), uz uslov da je status veći od 2. Pokrenuti proceduru za kreditni rejting 3 i 5.
*/
--10 bodova

go
create procedure zad4
(
@nabavkaID int = null, 
@loginID nvarchar = null, 
@status int = null, 
@naziv_nabavljaca nvarchar = null, 
@kred_rejting int = null
)
as
begin
	select	n.nabavkaID, r.loginID, n.status, n.naziv_nabavljaca, n.kred_rejting
	from	radnik r join nabavka n
	on		r.radnikID = n.nabavaljacID
	where	(@nabavkaID = n.nabavkaID or @loginID = r.loginID or @status = n.status or @naziv_nabavljaca = n.naziv_nabavljaca or @kred_rejting = n.kred_rejting) and n.status > 2
end

exec zad4 @kred_rejting = 3
exec zad4 @kred_rejting = 5


-------------------------------------------
/*
5.
a) Kreirati pogled nabavljaci_radnici koji će se sastojati od kolona naziv dobavljača i prebrojani_broj radnika. prebrojani_broj je podatak kojim se prebrojava broj 
radnika s kojima je dobavljač poslovao. Obavezno napisati kod kojim će se izvršiti pregled sadržaja pogleda sortiran po ukupnom broju.
b) Kreirati proceduru kojom će se iz pogleda kreiranog pod a) preuzeti zapisi u kojima je prebrojani_broj manji od 50. Proceduru kreirati tako da je prilikom izvršavanja 
moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koji parametar bez unijete vrijednosti). Pokrenuti proceduru za vrijednosti prebrojani_broj = 1 i 2.	
*/
--15 bodova

--a
go
create view nabavljaci_radnici
as
select		n.naziv_nabavljaca, COUNT(r.radnikID) prebrojani_broj
from		radnik r join nabavka n
on			r.radnikID = n.nabavaljacID
group by	n.naziv_nabavljaca

select *
from	nabavljaci_radnici
order by 2

--b
create proc zad5b
(
@naziv_dobavljaca nvarchar = null,
@prebrojani_broj int = null
)
as
begin
	select	*
	from	nabavljaci_radnici
	where	(@naziv_dobavljaca = naziv_nabavljaca or @prebrojani_broj = prebrojani_broj) and prebrojani_broj < 50
end

exec zad5b @prebrojani_broj = 1
exec zad5b @prebrojani_broj = 2


--------------------------------------------
/*
6.
a) U tabeli radnik dodati kolonu razlika_sati kao cjelobrojnu varijablu sa obaveznom default vrijednošću 0.
b) U koloni razlika_sati ostaviti 0 ako su sati bolovanja veći od godišnjeg odmora, inače u kolonu smjestiti vrijednost razlike između sato_bolovanja i sati_god_odmora.
c) Kreirati pogled view_sati u kojem će biti poruka da li radnik ima više sati godišnjeg odmora ili bolovanja. 
Ako je više bolovanja daje se poruka "bolovanje", inače "godisnji". Pogled treba da sadrži ID radnika i poruku.
*/
--10 bodova

--a
alter table radnik
add	razlika_sati int default(0)

--b
update radnik
set razlika_sati =
	case
	when sati_bolovanja > sati_god_odmora then 0
	when sati_bolovanja <= sati_god_odmora then sati_bolovanja - sati_god_odmora
	end

select * from radnik

--c
create view view_sati
as
select	radnikID, 'bolovanje' bolovanje_godisnji
from	radnik
where	sati_bolovanja > sati_god_odmora
union
select	radnikID, 'godisnji' bolovanje_godisnji
from	radnik
where	sati_bolovanja < sati_god_odmora

select * from view_sati

-----------------------------------------------
/*
7.
Koristeći tabelu prodaja kreirati pogled view_prodaja sljedeće strukture:
	- prodavacID
	- naziv_terit
	- razlika prošlogodišnje prodaje i srednje vrijednosti prošlogodišnje prodaje.
Uslov je da se dohvate zapisi u kojima je bonus bar za 1000 veći od minimalne vrijednosti bonusa
*/
--10 bodova

create view view_prodaja
as
select	prodavacID, naziv_terit, proslogod_prodaja - (select AVG(proslogod_prodaja) from prodaja) as razlika
from	prodaja
where	(bonus - 1000) > (select MIN(bonus) from prodaja)

select * from view_prodaja

------------------------------------------
/*
8.
U koloni drzavaID tabele radnik izvršiti promjenu svih vrijednosti u kojima je broj cifara neparan broj. Promjenu izvršiti tako što će se u umjesto postojećih 
vrijednosti unijeti slučajno generisani niz znakova.
*/
--10 bodova

update radnik
set	drzavaID = cast(LEFT(NEWID() , 15)as nvarchar)
where	len(drzavaID)%2 != 0

---------------------------------------
/*
9.
Iz tabela nabavka i radnik kreirati pogled view_sifra_transakc koja će se sastojati od sljedećih kolona: 
	- naziv dobavljača,
	- sifra_transakc
Podaci u koloni sifra_transakc će se formirati spajanjem karaktera imena iz kolone loginID tabele radnik (ime je npr. ken, NE ken0) i riječi iz kolone 
br_racuna (npr. u LITWARE0001 riječ je LITWARE) tabele nabavka, između kojih je potrebno umetnuti donju crtu (_). 
Uslov je da se ne dohvataju duplikati (prikaz jedinstvenih vrijednosti) u koloni sifre_transaks.
Obavezno napisati kod za pregled sadržaja pogleda.
*/
--13 bodova

create view view_sifra_transakc
as
select distinct n.naziv_nabavljaca, SUBSTRING(loginID ,charindex('\', loginID) + 1, len(SUBSTRING(loginID ,charindex('\', loginID) + 1, len(loginID)) ) - 1) + '_' +
		left(n.br_racuna, CHARINDEX('0', br_racuna) - 1) sifra_transakc
from	radnik r join nabavka n
on		r.radnikID = n.nabavaljacID


-----------------------------------------------
--10.
/*
Kreirati backup baze na default lokaciju, obrisati bazu, a zatim izvršiti restore baze. 
Uslov prihvatanja koda je da se može izvršiti.
*/

BACKUP DATABASE BP2_2020_09_11
TO DISK = 'BP2_2020_09_11.bak'
GO

USE master
DROP DATABASE BP2_2020_09_11

RESTORE DATABASE BP2_2020_09_11 FROM DISK = 'BP2_2020_09_11.bak'
USE BP2_2020_09_11

--2 boda
