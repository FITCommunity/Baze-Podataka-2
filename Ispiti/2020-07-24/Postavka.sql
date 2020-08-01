--1
/*
a) Kreirati bazu podataka pod vlastitim brojem indeksa.

--Prilikom kreiranja tabela voditi racuna o medjusobnom odnosu izmedju tabela.

b) Kreirati tabelu radnik koja ce imati sljedecu strukturu:
	-radnikID, cjelobrojna varijabla, primarni kljuc
	-drzavaID, 15 unicode karaktera
	-loginID, 256 unicode karaktera
	-god_rod, cjelobrojna varijabla
	-spol, 1 unicode karakter

c) Kreirati tabelu nabavka koja ce imati sljedecu strukturu:
	-nabavkaID, cjelobrojna varijabla, primarni kljuc
	-status, cjelobrojna varijabla
	-radnikID, cjelobrojna varijabla
	-br_racuna, 15 unicode karaktera
	-naziv_dobavljaca, 50 unicode karaktera
	-kred_rejting, cjelobrojna varijabla

c) Kreirati tabelu prodaja koja ce imati sljedecu strukturu:
	-prodajaID, cjelobrojna varijabla, primarni kljuc, inkrementalno punjenje sa pocetnom vrijednoscu 1, samo neparni brojevi
	-prodavacID, cjelobrojna varijabla
	-dtm_isporuke, datumsko-vremenska varijabla
	-vrij_poreza, novcana varijabla
	-ukup_vrij, novcana varijabla
	-online_narudzba, bit varijabla sa ogranicenjem kojim se mogu unijeti samo cifre 0 i 1

--2
Import podataka

a) Iz tabele Employee iz šeme HumanResources baze AdventureWorks2017 u tabelu radnik importovati podatke po sljedecem pravilu:
	-BusinessEntityID -> radnikID
	-NationalIDNumber -> drzavaID
	-LoginID -> loginID
	-godina iz kolone BirthDate -> god_rod
	-Gender -> spol

b) Iz tabela PurchaseOrderHeader i Vendor šeme Purchasing baze AdventureWorks2017 u tabelu nabavka importovati podatke po sljedecem pravilu:
	-PurchaseOrderID -> dobavljanjeID
	-Status -> status
	-EmployeeID -> radnikID
	-AccountNumber -> br_racuna
	-Name -> naziv_dobavljaca
	-CreditRating -> kred_rejting

c) Iz tabele SalesOrderHeader šeme Sales baze AdventureWorks2017 u tabelu prodaja importovati podatke po sljedecem pravilu:
	-SalesPersonID -> prodavacID
	-ShipDate -> dtm_isporuke
	-TaxAmt -> vrij_poreza
	-TotalDue -> ukup_vrij
	-OnlineOrderFlag -> online_narudzba

--3
a) U tabelu radnik dodati kolonu st_kat (starosna kategorija), tipa 3 karaktera.

b) Prethodno kreiranu kolonu popuniti po principu:
	starosna kategorija			uslov
	I							osobe do 30 godina starosti (ukljucuje se i 30)
	II							osobe od 31 do 49 godina starosti
	III							osobe preko 50 godina starosti

c) Neka osoba sa navrsenih 65 godina odlazi u penziju.
Prebrojati koliko radnika ima 10 ili manje godina do penzije.
Rezultat upita iskljucivo treba biti poruka:
'Broj radnika koji imaju 10 ili manje godina do penzije je' nakon cega slijedi prebrojani broj.
Nece se priznati rjesenje koje kao rezultat upita vraca vise kolona.

--4
a) U tabeli prodaja kreirati kolonu stopa_poreza (10 unicode karaktera)

b) Prethodno kreiranu kolonu popuniti kao kolicnik vrij_poreza i ukup_vrij.
Stopu poreza izraziti kao cijeli broj s oznakom %, pri cemu je potrebno da izmedju brojcane vrijednosti i znaka % bude prazno mjesto.
(Npr: 14.00 %)

--5
a) Koristeci tabelu nabavka kreirati pogled view_slova sljedece strukture:
	-slova
	-prebrojano, prebrojani broj pojavljivanja slovnih dijelova podatka u koloni br_racuna.

b) Koristeci pogled view_slova odrediti razliku vrijednosti izmedju prebrojanih i srednje vrijednosti kolone.
Rezultat treba da sadrzi kolone slova, prebrojano i razliku.
Sortirati u rastucem redoslijedu prema razlici.

--6
a) Koristeci tabelu prodaja kreirati pogled view_stopa sljedece strukture:
	-prodajaID
	-stopa_poreza
	-stopa_num, u kojoj ce biti numericka vrijednost stope poreza

b) Koristeci pogled view_stopa, a na osnovu razlike izmedju vrijednosti u koloni stopa_num i srednje vrijednosti stopa poreza
za svaki proizvodID navesti poruku 'manji', odnosno, 'veci'.

--7 
Koristeci pogled view_stopa_poreza kreirati proceduru proc_stopa_poreza tako da je prilikom izvrsavanja moguce unijeti bilo koji broj
parametara (mozemo ostaviti bilo koji parametar bez unijete vrijednosti), pri cemu ce se prebrojati broj zapisa po stopi poreza uz 
uslov da se dohvate samo oni zapisi u kojima je stopa poreza veca od 10%.
Proceduru pokrenuti za sljedece vrijednosti:
	-stopa poreza = 12, 15 i 21

--8
Kreirati proceduru proc_prodaja kojom ce se izvrsiti promjena vrijednosti u koloni online_narudzba tabele prodaja.
Promjena ce se vrsiti tako sto ce se 0 zamijeniti sa NO, a 1 sa YES.
Pokrenuti proceduru kako bi se izvrsile promjene, a nakon toga onemoguciti da se u koloni unosi bilo kakva druga vrijednost osim NO ili
YES.

--9
a) Nad kolonom god_rod tabele radnik kreirati ogranicenje kojim ce se onemoguciti unos bilo koje godine iz buducnosti kao godina rodjenja.
Testirati funkcionalnost kreiranog ogranicenja navodjenjem koda za insert podataka kojim ce se kao godina rodjenja pokusati unijeti
bilo koja godina iz buducnosti.

b) Nad kolonom drzavaID tabele radnik kreirati ogranicenje kojim ce se ograniciti duzina podatka na 7 znakova.
Ako je prethodno potrebno, izvrsiti prilagodbu kolone, pri cemu nije dozvoljeno prilagodjavati podatke cija duzina iznosi 7 ili manje znakova.
Testirati funkcionalnost kreiranog ogranicenja navodjenjem koda za insert podataka kojim ce se u drzavaID pokusati unijeti podatak duzi 
od 7 znakova bilo koja godina iz buducnosti.

--10
Kreirati backup baze na default lokaciju, obrisati bazu a zatim izvrsiti restore baze. 
Uslov prihvatanja koda je da se moze izvrsiti.