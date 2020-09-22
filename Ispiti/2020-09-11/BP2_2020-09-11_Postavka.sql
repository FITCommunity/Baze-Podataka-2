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


/*Prilikom kreiranja tabela voditi računa o međusobnom odnosu između tabela.
a) Kreirati tabelu radnik koja će imati sljedeću strukturu:
	- radnikID, cjelobrojna varijabla, primarni ključ
	- drzavaID, 15 unicode karaktera
	- loginID, 256 unicode karaktera
	- sati_god_odmora, cjelobrojna varijabla
	- sati_bolovanja, cjelobrojna varijabla
*/

/*
b) Kreirati tabelu nabavka koja će imati sljedeću strukturu:
	- nabavkaID, cjelobrojna varijabla, primarni ključ
	- status, cjelobrojna varijabla
	- nabavaljacID, cjelobrojna varijabla
	- br_racuna, 15 unicode karaktera
	- naziv_nabavljaca, 50 unicode karaktera
	- kred_rejting, cjelobrojna varijabla
*/

/*
c) Kreirati tabelu prodaja koja će imati sljedeću strukturu:
	- prodavacID, cjelobrojna varijabla, primarni ključ
	- prod_kvota, novčana varijabla
	- bonus, novčana varijabla
	- proslogod_prodaja, novčana varijabla
	- naziv_terit, 50 unicode karaktera
*/
--10 bodova



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

/*
b) Iz tabela Purchasing.PurchaseOrderHeader i Purchasing.Vendor baze AdventureWorks2017 u tabelu nabavka importovati podatke po sljedećem pravilu:
	- PurchaseOrderID -> nabavkaID
	- Status -> status
	- EmployeeID -> radnikID
	- AccountNumber -> br_racuna
	- Name -> naziv_nabavljaca
	- CreditRating -> kred_rejting
*/

/*
c) Iz tabela Sales.SalesPerson i Sales.SalesTerritory baze AdventureWorks2017 u tabelu prodaja importovati podatke po sljedećem pravilu:
	- BusinessEntityID -> prodavacID
	- SalesQuota -> prod_kvota
	- Bonus -> bonus
	- SalesLastYear iz Sales.SalesPerson -> proslogod_prodaja
	- Name -> naziv_terit
*/
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
b) Koristeći prethodno kreirani pogled prebrojati broj obavljenih nabavki prema kreditnom rejtingu. Npr. kreditni rejting 8 se pojavljuje 20 puta. Pregled treba da sadrži oznaku kreditnog rejtinga i ukupan broj obavljenih nabavki.
*/
--10 bodova


-----------------------------------------------
/*
4.
Kreirati proceduru koja će imati istu strukturu kao pogled kreiran u prethodnom zadatku. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koji parametar bez unijete vrijednosti), uz uslov da je status veći od 2. Pokrenuti proceduru za kreditni rejting 3 i 5.
*/
--10 bodova



-------------------------------------------
/*
5.
a) Kreirati pogled nabavljaci_radnici koji će se sastojati od kolona naziv dobavljača i prebrojani_broj radnika. prebrojani_broj je podatak kojim se prebrojava broj radnika s kojima je dobavljač poslovao. Obavezno napisati kod kojim će se izvršiti pregled sadržaja pogleda sortiran po ukupnom broju.
b) Kreirati proceduru kojom će se iz pogleda kreiranog pod a) preuzeti zapisi u kojima je prebrojani_broj manji od 50. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koji parametar bez unijete vrijednosti). Pokrenuti proceduru za vrijednosti prebrojani_broj = 1 i 2.	
*/
--15 bodova



--------------------------------------------
/*
6.
a) U tabeli radnik dodati kolonu razlika_sati kao cjelobrojnu varijablu sa obaveznom default vrijednošću 0.
b) U koloni razlika_sati ostaviti 0 ako su sati bolovanja veći od godišnjeg odmora, inače u kolonu smjestiti vrijednost razlike između sato_bolovanja i sati_god_odmora.
c) Kreirati pogled view_sati u kojem će biti poruka da li radnik ima više sati godišnjeg odmora ili bolovanja. Ako je više bolovanja daje se poruka "bolovanje", inače "godisnji". Pogled treba da sadrži ID radnika i poruku.
*/
--10 bodova


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



------------------------------------------
/*
8.
U koloni drzavaID tabele radnik izvršiti promjenu svih vrijednosti u kojima je broj cifara neparan broj. Promjenu izvršiti tako što će se u umjesto postojećih vrijednosti unijeti slučajno generisani niz znakova.
*/
--10 bodova


---------------------------------------
/*
9.
Iz tabela nabavka i radnik kreirati pogled view_sifra_transakc koja će se sastojati od sljedećih kolona: 
	- naziv dobavljača,
	- sifra_transakc
Podaci u koloni sifra_transakc će se formirati spajanjem karaktera imena iz kolone loginID tabele radnik (ime je npr. ken, NE ken0) i riječi iz kolone br_racuna (npr. u LITWARE0001 riječ je LITWARE) tabele nabavka, između kojih je potrebno umetnuti donju crtu (_). 
Uslov je da se ne dohvataju duplikati (prikaz jedinstvenih vrijednosti) u koloni sifre_transaks.
Obavezno napisati kod za pregled sadržaja pogleda.
*/
--13 bodova



-----------------------------------------------
--10.
/*
Kreirati backup baze na default lokaciju, obrisati bazu, a zatim izvršiti restore baze. 
Uslov prihvatanja koda je da se može izvršiti.
*/
--2 boda

