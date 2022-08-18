use BazaHotel
go

drop procedure if exists p_szukaj_wolnego_pokoju;
go
--procedura znajdujaca nie zarezerwowane pokoje w danym miescie,
--w  danym przedziale czasu  o danej liczbie osob i ³ó¿ek.
--Posegreguje po cenie rosn¹co
create procedure p_szukaj_wolnego_pokoju
@data_od as Datetime,
@data_do as Datetime,
@Miasto as nvarchar(30),
@Liczba_Osob as int,
@liczba_Lozek as tinyint
as
begin 
select Distinct w.Hotel,w.[Nr Pokoju],w.[koszt za dobe]
from (select r.IdPokoju,p.NrPokoju[Nr Pokoju],h.Nazwa[Hotel],p.KosztDoba[koszt za dobe]
from Rezerwacje r 
join Pokoje p on r.IdPokoju = p.IdPokoju
join Hotele h on p.IdHotelu = h.IdHotelu 
where p.Liczba£ó¿ek = @liczba_Lozek and p.LiczbaOsób =@Liczba_Osob and h.Miasto = @Miasto 
and p.Status=0
) as w
left join 
(
select r.IdPokoju from Rezerwacje r join Pokoje p on r.IdPokoju = p.IdPokoju 
join Hotele h on p.IdHotelu = h.IdHotelu
where  (DataStop>=@data_od) and (DataStart <= @data_do) and  (r.Status = 0) 
and (h.Miasto = @Miasto) and (p.Liczba£ó¿ek = @liczba_Lozek) and
(p.LiczbaOsób =@Liczba_Osob)
)as wn
on w.IdPokoju = wn.IdPokoju
where wn.IdPokoju is  null
order by w.[koszt za dobe]
end
go
--procedura wyswietlajaca wyposazenie pokoju 
drop procedure if exists p_pokaz_wyposazenie_pokoju;
go
create procedure p_pokaz_wyposazenie_pokoju
@hotel as nvarchar(30),
@nr_pokoju as int
as
begin 
select w.Nazwa[Wyposazenie pokoju],h.Nazwa[hotel] 
from Pokoje p join Hotele h on h.IdHotelu = p.IdHotelu
join Wyposa¿enia w on w.IdPokoju = p.IdPokoju
where h.Nazwa = @hotel and NrPokoju = @nr_pokoju
end
-- procedura wyswietlajaca wyposazenie hotelu
go
drop procedure if exists p_pokaz_wyposazenie_hotelu;
go
create procedure p_pokaz_wyposazenie_hotelu
@hotel as nvarchar(30) 
as
begin 
select u.Nazwa[Udogodnienia hotelu] 
from Hotele h join Udogodnienia u on h.IdHotelu = u.IdHotelu
where h.Nazwa = @hotel;
end
go
--wyzwalacz który sprawdza czy nie zrezygnowana za póŸno z rezerwacji,
--w razie rezygnacji od 2 dni przed terminem naliczane s¹ koszta 1 doby pokoju
drop trigger if exists Rezygnacja;
go
create trigger Rezygnacja
on Rezerwacje
for update
as 
begin
	if UPDATE(Status)
	begin 
		DECLARE @DATA AS DATE= GETDATE();
		IF  DATEDIFF(DAY,@DATA,(SELECT DataStart FROM INSERTED))<=2
		begin 
		update Rezerwacje
		set KosztRezygnacji = 
		(select p.KosztDoba 
		from inserted i join Pokoje p on p.IdPokoju = i.IdPokoju)
		where IdRezerwacji in (select IdRezerwacji from inserted)
		end
	end
end
go
--tworzy widok dla histori odbytych rezerwacji z szczegó³owymi danymi 
drop view if exists v_Rezerwacje;
go 
create view v_Rezerwacje as
select r.IdRezerwacji,h.Nazwa[Nazwa hotelu],
NrPokoju,DataStart,DataStop,r.Koszt,Imie,Nazwisko,Telefon 
from Rezerwacje r join Klienci k 
on k.IdKlienta = r.IdKlienta
join Pokoje p on r.IdPokoju = p.IdPokoju
join Hotele h on h.IdHotelu = p.IdHotelu
where r.Status = 0;
go
--tworzy widok histori rezerwacji gdzie osoby zrezygnowa³y z rezerwacji
drop view if exists v_RezerwacjeZrezygnowane
go 
create view v_RezerwacjeZrezygnowane as
select r.IdRezerwacji,h.Nazwa[Nazwa hotelu],NrPokoju,DataStart[Data Start],
DataStop[Data Stop],
r.KosztRezygnacji[Koszt Rezygnacji],Imie,Nazwisko,Telefon 
from Rezerwacje r join Klienci k 
on k.IdKlienta = r.IdKlienta
join Pokoje p on r.IdPokoju = p.IdPokoju
join Hotele h on h.IdHotelu = p.IdHotelu
where r.Status = 1
go 
--procedura pomagaj¹ca znaleœæ liste hoteli z danymi udogodnieniami
drop procedure if exists p_SearchHotel;
go
create procedure p_SearchHotel
@Miejscowosc as nvarchar(30),
@Udogodnienie1 as nvarchar(30)=null,
@Udogodnienie2 as nvarchar(30) =null,
@Udogodnienie3 as nvarchar(30)=null,
@Udogodnienie4 as nvarchar(30)=null,
@Udogodnienie5 as nvarchar(30)=null,
@Udogodnienie6 as nvarchar(30)=null,
@Udogodnienie7 as nvarchar(30)=null,
@Udogodnienie8 as nvarchar(30)=null
as
begin
select h.Nazwa[nazwa hotelu],h.Miasto,
count(u.Nazwa)[Liczba posiadaj¹cych szukanych udogodnieñ]
from Hotele h join Udogodnienia u 
on h.IdHotelu = u.IdHotelu
where h.Miasto = @Miejscowosc  and 
u.Nazwa in (@Udogodnienie1,@Udogodnienie2,@Udogodnienie3,@Udogodnienie4,@Udogodnienie5,
@Udogodnienie6,@Udogodnienie7,@Udogodnienie8)
group by h.Nazwa,h.Miasto
end
go
--tworzenie funkcji zwracajace dane dla faktur
drop function if exists f_faktura
go
create function f_faktura(@idRezerwacji int)
returns table 
as 
	return(select k.Imie,k.Nazwisko,k.Adres,k.Miasto,k.KodPocztowy,
	k.Kraj,k.NrKarty,r.Koszt,r.SposóbP³atnoœci,
	r.DataStart[data zameldowania],h.Nazwa[hotel],
	h.Adres[adres hotelu],h.Miasto[miasto hotelu]
	from Rezerwacje r join Klienci k 
	on r.IdKlienta = k.IdKlienta
	join Pokoje p on p.IdPokoju = r.IdPokoju
	join Hotele h on h.IdHotelu = p.IdHotelu
	where IdRezerwacji = @idRezerwacji
	)
go
drop procedure if exists p_szukaj_wolnego_pokoju_w_hotelu;
go
--procedura znajdujaca nie zarezerwowane pokoje w danym hotelu 
--,w  danym przedziale czasu  o danej liczbie osob i ³ó¿ek.
--Posegreguje po cenie rosn¹co
create procedure p_szukaj_wolnego_pokoju_w_hotelu
@data_od as Datetime,
@data_do as Datetime,
@hotel as nvarchar(30),
@Liczba_Osob as int,
@liczba_Lozek as tinyint
as
begin 
select Distinct w.Hotel,w.[Nr Pokoju],w.[koszt za dobe]
from (select r.IdPokoju,p.NrPokoju[Nr Pokoju],h.Nazwa[Hotel],p.KosztDoba[koszt za dobe]
from Rezerwacje r 
join Pokoje p on r.IdPokoju = p.IdPokoju join Hotele h on p.IdHotelu = h.IdHotelu 
where p.Liczba£ó¿ek = @liczba_Lozek and p.LiczbaOsób =@Liczba_Osob
and h.Nazwa = @hotel and p.Status=0
) as w
left join 
(
select r.IdPokoju from Rezerwacje r join Pokoje p on r.IdPokoju = p.IdPokoju 
join Hotele h on p.IdHotelu = h.IdHotelu
where  (DataStop>=@data_od) and (DataStart <= @data_do) and  (r.Status = 0) 
and (h.Nazwa = @hotel) and (p.Liczba£ó¿ek = @liczba_Lozek) 
and (p.LiczbaOsób =@Liczba_Osob)
)as wn
on w.IdPokoju = wn.IdPokoju
where wn.IdPokoju is  null
order by w.[koszt za dobe]
end
go
drop procedure if exists p_szukaj_wolnego_pokoju_w_hotelu_z_wyposazeniem;
go
--procedura znajdujaca nie zarezerwowane pokoje w danym hotelu,
--w  danym przedziale czasu  o danej liczbie osob i ³ó¿ek oraz wyposazeniu.
--Posegreguje po cenie rosn¹co
create procedure p_szukaj_wolnego_pokoju_w_hotelu_z_wyposazeniem
@data_od as Datetime,
@data_do as Datetime,
@hotel as nvarchar(30),
@Liczba_Osob as int,
@liczba_Lozek as tinyint,
@wyposazenie1 as nvarchar(30)
as
begin 
select Distinct w.Hotel,w.[Nr Pokoju],w.[koszt za dobe]
from (select r.IdPokoju,p.NrPokoju[Nr Pokoju],h.Nazwa[Hotel],p.KosztDoba[koszt za dobe]
from Rezerwacje r 
join Pokoje p on r.IdPokoju = p.IdPokoju 
join Hotele h on p.IdHotelu = h.IdHotelu 
join Wyposa¿enia w on p.IdPokoju = w.IdPokoju
where p.Liczba£ó¿ek = @liczba_Lozek and p.LiczbaOsób =@Liczba_Osob and h.Nazwa = @hotel 
and p.Status=0 and w.Nazwa in(@wyposazenie1)
) as w
left join 
(
select r.IdPokoju from Rezerwacje r join Pokoje p on r.IdPokoju = p.IdPokoju 
join Hotele h on p.IdHotelu = h.IdHotelu
join Wyposa¿enia w on p.IdPokoju = w.IdPokoju
where  (DataStop>=@data_od ) and (DataStart <= @data_do ) and  (r.Status = 0) 
and (h.Nazwa = @hotel) and (p.Liczba£ó¿ek = @liczba_Lozek) and (p.LiczbaOsób =@Liczba_Osob)
 and (w.Nazwa in(@wyposazenie1))
)as wn
on w.IdPokoju = wn.IdPokoju
where wn.IdPokoju is  null
group by w.Hotel,w.[Nr Pokoju],w.[koszt za dobe]
order by w.[koszt za dobe]
end
go
drop procedure if exists p_szukaj_wolnego_pokoju_w_miescie_z_wyposazeniem;
go
--procedura znajdujaca nie zarezerwowane pokoje w danym miescie,
--w  danym przedziale czasu  o danej liczbie osob i ³ó¿ek oraz wyposazeniu.
--Posegreguje po cenie rosn¹co
create procedure p_szukaj_wolnego_pokoju_w_miescie_z_wyposazeniem
@data_od as Datetime,
@data_do as Datetime,
@miasto as nvarchar(30),
@Liczba_Osob as int,
@liczba_Lozek as tinyint,
@wyposazenie1 as nvarchar(30)
as
begin 
select Distinct w.Hotel,w.[Nr Pokoju],w.[koszt za dobe]
from (select r.IdPokoju,p.NrPokoju[Nr Pokoju],h.Nazwa[Hotel],p.KosztDoba[koszt za dobe]
from Rezerwacje r 
join Pokoje p on r.IdPokoju = p.IdPokoju 
join Hotele h on p.IdHotelu = h.IdHotelu 
join Wyposa¿enia w on p.IdPokoju = w.IdPokoju
where p.Liczba£ó¿ek = @liczba_Lozek and p.LiczbaOsób =@Liczba_Osob and h.Miasto = @miasto
and p.Status=0 and w.Nazwa in(@wyposazenie1)
) as w
left join 
(
select r.IdPokoju from Rezerwacje r join Pokoje p on r.IdPokoju = p.IdPokoju 
join Hotele h on p.IdHotelu = h.IdHotelu
join Wyposa¿enia w on p.IdPokoju = w.IdPokoju
where  (DataStop>=@data_od ) and (DataStart <= @data_do ) and  (r.Status = 0) 
and (h.Miasto = @miasto) and (p.Liczba£ó¿ek = @liczba_Lozek) and (p.LiczbaOsób =@Liczba_Osob)
 and (w.Nazwa in(@wyposazenie1))
)as wn
on w.IdPokoju = wn.IdPokoju
where wn.IdPokoju is  null
group by w.Hotel,w.[Nr Pokoju],w.[koszt za dobe]
order by w.[koszt za dobe]
end
go
--procedura dodajaca nowego klienta do bazy danych
drop procedure if exists p_dodaj_klienta;
go
create procedure p_dodaj_klienta
@Imie as nvarchar(30),
@Nazwisko as nvarchar(30),
@Email as nvarchar(50),
@Kraj as nvarchar(30),
@Adres as nvarchar(50),
@KodPocztowy as nvarchar(15),
@Miasto as nvarchar(30),
@Telefon as nvarchar(30),
@NrKart as nchar(16),
@CVC as nvarchar(4),
@DataWa¿nosci as date
as
begin 
insert into Karty
values(@NrKart,@CVC,@DataWa¿nosci);
insert into Klienci
values(@Imie,@Nazwisko,@Email,@Kraj,@Adres,@KodPocztowy,@Miasto,@Telefon,@NrKart);
end
go

