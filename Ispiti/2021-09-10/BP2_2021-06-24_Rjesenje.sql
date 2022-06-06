/*
Napomena:

A.
Prilikom  bodovanja rješenja prioritet ima rezultat 
koji upit treba da vrati (broj zapisa, vrijednosti agregatnih funkcija...).
U slu?aju da rezultat upita nije ta?an, a pogled, tabela... 
koji su rezultat tog upita se koriste u narednim zadacima, 
tada se rješenja narednih zadataka, bez obzira na ta?nost koda, 
ne boduju punim brojem bodova, jer ni ta rješenja ne mogu vratiti ta?an rezultat 
(broj zapisa, vrijednosti agregatnih funkcija...).

B.
Tokom pisanja koda obratiti pažnju na tekst zadatka 
i ono što se traži zadatkom. Prilikom pregleda rada pokre?e se 
kod koji se nalazi u sql skripti i sve ono što nije ura?eno prema zahtjevima zadatka 
ili je pogrešno ura?eno predstavlja grešku. 
Shodno navedenom, na uvidu se ne prihvata prigovor 
da je neki dio koda posljedica previda ("nisam vidio", "slu?ajno sam to napisao"...) 
*/

------------------------------------------------
--1.
/*
a) Kreirati bazu pod vlastitim brojem indeksa.
*/

create database IB190049_1
use IB190049_1
---------------------------------------------------------------------------
--Prilikom kreiranja tabela voditi ra?una o njihovom me?usobnom odnosu.
---------------------------------------------------------------------------
/*
b) Kreirati tabelu kreditna sljede?e strukture:
	- kreditnaID - cjelobrojni tip, primarni klju?
	- tip_kreditne - 50 unicode karaktera
	- br_kreditne - 25 unicode karatera, obavezan unos
	- dtm_evid - datumska varijabla za unos datuma
*/
create table kreditna(
    kreditnaID int,
	tip_kreditne nvarchar(50),
	br_kreditne nvarchar(25) not null,
	dtm_evid date,
	constraint PK_kreditna primary key (kreditnaID)
)
/*
c) Kreirati tabelu osoba sljede?e strukture:
	- osobaID - cjelobrojni tip, primarni klju?
	- kreditnaID - cjelobrojni tip, obavezan unos
	- mail_lozinka - 50 unicode karaktera
	- lozinka - 10 unicode karaktera 
	- br_tel - 25 unicode karaktera
Na koloni mail_lozinka postaviti ograni?enje 
kojim se omogu?uje unos podatka koji ima 
maksimalno 20 karaktera.
*/
create table osoba
(
    osobaID int,
	kreditnaID int not null,
	mail_lozinka nvarchar(50) constraint CK_osoba_mail_lozinka check (len(mail_lozinka) between 0 and 21),
	lozinka nvarchar(10),
	br_tel nvarchar(25),
	constraint PK_osoba primary key (osobaID),
	constraint FK_osoba_kreditna foreign key(kreditnaID) references kreditna(kreditnaID)
)

/*
d) Kreirati tabelu narudzba sljede?e strukture:
	- narudzbaID - cjelobrojni tip, primarni klju?
	- kreditnaID - cjelobrojni tip
	- br_narudzbe - 25 unicode karaktera
	- br_racuna - 15 unicode karaktera
	- prodavnicaID - cjelobrojni tip
*/

create table narudzba(
    narudzbaID int,
	kreditnaID int,
	br_narudzbe nvarchar(25),
	br_racuna nvarchar(15),
	prodavnicaID int,
	constraint PK_narudzba primary key(narudzbaID),
	constraint FK_narudzba_kreditna foreign key(kreditnaID) references kreditna(kreditnaID)
)
--2. 
/*
a) 
Iz tabele Sales.CreditCard baze AdventureWorks2017 
importovati podatke u tabelu kreditna na sljede?i na?in:
	- CreditCardID -> kreditnaID
	- CardNUmber -> br_kreditne
	- ModifiedDate -> dtm_evid

	- kreditnaID - cjelobrojni tip, primarni klju?
	- tip_kreditne - 50 unicode karaktera
	- br_kreditne - 25 unicode karatera, obavezan unos
	- dtm_evid - datumska varijabla za unos datuma

*/

insert into kreditna 
select CreditCardID as kreditnaID,
       CardType as tip_kreditne,
       CardNumber as br_kreditne,
	   ModifiedDate as dtm_evid
from AdventureWorks2019.Sales.CreditCard c 

select * from kreditna

/*
b) 
Iz tabela Person.Person, Person.Password, 
Sales.PersonCreditCard i Person.PersonPhone 
baze AdventureWorks2017 
importovati podatke u tabelu osoba na sljede?i na?in:
	- BussinesEntityID -> osobaID
	- CreditCardID -> kreditnaID
	- PasswordHash -> mail_lozinka
	- PasswordSalt -> lozinka
	- PhoneNumber -> br_tel
Prilikom importa voditi ra?una o ograni?enju
na koloni mail_lozinka.

- osobaID - cjelobrojni tip, primarni klju?
	- kreditnaID - cjelobrojni tip, obavezan unos
	- mail_lozinka - 50 unicode karaktera
	- lozinka - 10 unicode karaktera 
	- br_tel - 25 unicode karaktera
*/
insert into osoba 
select p.BusinessEntityID as osobaID,
       CreditCardID as kreditnaID,
	   left(PasswordHash,20) as mail_lozinka, --ne postoji nijedan zapis koji sadrži samo 20 karaktera pa moram ovako popunit
	   PasswordSalt as lozinka,
	   PhoneNumber as br_tel
from AdventureWorks2019.Person.Person p inner join AdventureWorks2019.Person.Password pw 
on p.BusinessEntityID=pw.BusinessEntityID inner join AdventureWorks2019.Sales.PersonCreditCard spc
on pw.BusinessEntityID=spc.BusinessEntityID inner join AdventureWorks2019.Person.PersonPhone pph
on spc.BusinessEntityID=pph.BusinessEntityID

select * from osoba



/*
c) 
Iz tabela Sales.Customer i Sales.SalesOrderHeader baze AdventureWorks2017
importovati podatke u tabelu narudzba na sljede?i na?in:
	- SalesOrderID -> narudzbaID
	- CreditCardID -> kreditnaID
	- PurchaseOrderNumber -> br_narudzbe
	- AccountNumber -> br_racuna
	- StoreID -> prodavnicaID

	- narudzbaID - cjelobrojni tip, primarni klju?
	- kreditnaID - cjelobrojni tip
	- br_narudzbe - 25 unicode karaktera
	- br_racuna - 15 unicode karaktera
	- prodavnicaID - cjelobrojni tip
*/
insert into narudzba
select SalesOrderID as narudzbaID,
       CreditCardID as kreditnaID,
	   PurchaseOrderNumber as br_narudzbe,
	   c.AccountNumber as br_racuna,
	   StoreID as prodavnicaID
from AdventureWorks2019.Sales.Customer c inner join AdventureWorks2019.Sales.SalesOrderHeader soh
on c.CustomerID=soh.CustomerID



/*
3---
a)
U tabeli kreditna dodati novu izra?unatu kolonu
god_evid u koju ?e se smještati godina iz kolone dtm_evid
b)
U tabeli kreditna izvršiti update kolone tip_kreditne
tako što ?e se Vista zamijeniti sa Visa
c)
U tabeli osoba izvršiti update kolone
mail_lozinka u svim zapisima u kojima 
se podatak u mail_lozinka završava bilo kojom cifrom.
Update izvršiti tako da se umjesto cifre postavi znak @.
*/
alter table kreditna
add god_evid as year(dtm_evid)

select * from kreditna
update kreditna
set tip_kreditne='Visa' where tip_kreditne = 'Vista'

select * from kreditna

select * from osoba

update osoba 
set mail_lozinka = LEFT(mail_lozinka, 19) + '@' where not RIGHT(mail_lozinka, 1)  like '%[^0-9]%'

--4.
/*
Koriste?i tabele kreditna i osoba kreirati 
pogled view_kred_mail koji ?e se sastojati od kolona: 
	- br_kreditne, 
	- mail_lozinka, 
	- br_tel i 
	- br_cif_br_tel, 
pri ?emu ?e se kolone puniti na sljede?i na?in:
	- br_kreditne - odbaciti prve 4 cifre 
 	- mail_lozinka - preuzeti sve znakove od znaka na 10. mjestu (uklju?iti i njega)
	- br_tel - prenijeti cijelu kolonu
	- br_cif_br_tel - broj znakova (cifara) u koloni br_tel
*/

select COunt(kreditnaID) as br_kreditnih, len(br_kreditne) as duzina
from kreditna 
group by len(br_kreditne) 
--ovdje vidim koliko je dug broj kreditne kartice da bih poslije mogao znati koliko cifara ?e da mi ostane

create view view_kred_mail
as
select right(br_kreditne, 10) as br_kreditne, right(mail_lozinka, 10) as mail_lozinka, br_tel, len(br_tel) as br_cif_br_tel
from kreditna k inner join osoba o
on k.kreditnaID=o.kreditnaID


select * from view_kred_mail
--5.
/*
a)
Iz pogleda view_kred_mail kreirati tabelu kred_mail
b)
Nad tabelom kred_mail kreirati proceduru p_del_kred_mail 
tako da se obrišu svi zapisi u kojima se 
broj kreditne kartice završava neparnom cifrom.
Nakon kreiranja pokrenuti proceduru.
c) 
U tabeli kred_mail kreirati izra?unatu kolonu indikator
koja ?e puniti prema pravilu: 
	- br_cif_br_tel = 12, indikator = 0
	- br_cif_br_tel = 19, indikator = 1
*/


select * into kred_mail from view_kred_mail

select * from kred_mail

create procedure p_del_kred_mail
as
begin
     delete from kred_mail where RIGHT(br_kreditne, 1)%2=1 
end 

exec p_del_kred_mail

select * from kred_mail


alter table kred_mail
add indikator as (
                  case 
				      when br_cif_br_tel=12 then 0
					  when br_cif_br_tel=19 then 1
				  end
				  )
 select * from kred_mail
--6.
/*
a)
Kopirati tabelu kreditna u kreditna1, 
b)
U tabeli kreditna1 dodati novu kolonu dtm_aktivni 
?ija je default vrijednost aktivni datum sa vremenom. 
Kolona je sa obaveznim unosom.
c) 
U tabeli kreditna1 dodati novu kolonu br_mjeseci 
koja ?e broj mjeseci izme?u aktivnog datuma i datuma evidencije.
d) 
Prebrojati broj zapisa u tabeli kreditna1 
kod kojih se datum evidencije nalazi u intevalu 
do najviše 84 mjeseca u odnosu na aktivni datum.
*/
select * into kreditna1 from kreditna
select * from kreditna1

alter table kreditna1
add aktivni date not null default(getdate())

alter table kreditna1
add br_mjeseci int

update kreditna1
set br_mjeseci = datediff(month, dtm_evid, aktivni)

select * from kreditna1

select count(kreditnaID) as br_kreditnih, br_mjeseci 
from kreditna1
where br_mjeseci < 90   --u zadatku se traži 84, me?utim tada ne vra?a nijedan zapis
group by  br_mjeseci


--7.
/*
Iz tabele narudzba jednim upitom:
	-	prebrojati broj zapisa u kojima je u koloni
		br_narudzbe NULL vrijednost
	-	prebrojati broj zapisa u kojima je u koloni
		prodavnicaID NULL vrijednost
Upit treba da vrati rezultat u obliku:
	broj NULL u br_narudzbe	je	(navesti broj zapisa)
	broj NULL u prodavnicaID je	(navesti broj zapisa)

	 narudzbaID int,
	kreditnaID int,
	br_narudzbe nvarchar(25),
	br_racuna nvarchar(15),
	prodavnicaID int,

*/


select ('broj NULL u br_narudzbe je:  ' + CONVERT(nvarchar(10), (count(narudzbaID))))
from narudzba
where br_narudzbe is null
union 
select ('broj NULL u prodavnicaID je: ' + CONVERT(nvarchar(10), (count(narudzbaID))))
from narudzba
where prodavnicaID is null


select * from narudzba


--8.
/*
a)
Koriste?i tabelu narudzba kreirati 
pogled v_duz_br_nar strukture:
	- broj karaktera u koloni br_narudzbe
	- prebrojani broj zapisa prema broju karaktera
b)
Koriste?i pogled v_duz_br_nar dati pregled
zapisa u kojima se prebrojani broj nalazi u rasponu 
do maksimalno 1800 u odnosu na minimalnu vrijednost u koloni prebrojano, 
uz uslov da se ne prikazuje minimalna vrijednost
*/

create view v_duz_br_nar
as
select count(narudzbaID) br_narudzbi, len(br_narudzbe) as br_karaktera
from narudzba
group by len(br_narudzbe)

select * from v_duz_br_nar

select br_narudzbi, br_karaktera
from v_duz_br_nar
where br_narudzbi<=1800 and br_narudzbi > (select min(br_narudzbi) from v_duz_br_nar)
group by br_narudzbi, br_karaktera

--9.
/*
Koriste?i tabelu narudzba 
kreirati funkciju f_pocetak koja vra?a podatke
u formi tabele sa parametrima:
	- poc_br_rac, 7 karaktera
	- kreditnaID, cjelobrojni tip
Parametar poc_br_rac se referira na 
prvih 7 karaktera kolone br_racuna,
pri ?emu je njegova zadana (default) vrijednost 10-4020.
kreditnaID se referira na kolonu kreditnaID.
Funkcija vra?a kolone kreditnaID, br_narudzbe i br_racuna.
uz uslov da se vra?aju samo zapisi kod kojih je 
kreditnaID ve?i od 10000.

Provjeriti funkcioniranje funkcije za kreditnaID = 1200.
Rezultat sortirati prema kreditnaID.
*/
--10.


/*
a)
Kreirati tabelu kreditna1_log strukture:
	- log_id, primarni klju?, automatsko punjenje sa po?etnom vrijednoš?u 1 i inkrementom 1 
	- kreditnaID int
	- br_kreditne nvarchar (25)
	- br_mjeseci int
	- dogadjaj varchar (3)
	- mod_date datetime
b)
Nad tabelom kreditna1 kreirati okida? t_upd_kred
kojim ?e se prilikom update podataka u 
tabelu prodavac izvršiti insert podataka u 
tabelu prodavac_log.
c)
U tabelu autori updatovati zapise tako da se
u svim zapisima u koloni br_kreditne 
po?etne niz cifara 1111 promijeni u 2222.
d)
Obavezno napisati kod za pregled sadržaja 
tabela kreditna1 i kreditna1_log.
*/

create table kreditna1_log
(
   log_id int identity(1,1),
   kreditnaID int,
   br_kreditne nvarchar(25),
   br_mjeseci int,
   dogadjaj varchar(3),
   mod_date datetime,
   constraint PK_kreditna1_log primary key (log_id),
)




