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


/*
d) Kreirati tabelu narudzba sljede?e strukture:
	- narudzbaID - cjelobrojni tip, primarni klju?
	- kreditnaID - cjelobrojni tip
	- br_narudzbe - 25 unicode karaktera
	- br_racuna - 15 unicode karaktera
	- prodavnicaID - cjelobrojni tip
*/


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
*/

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




