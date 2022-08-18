use BazaHotel
go
--wprowadzanie danych do tabeli Hotele
insert into Hotele(Nazwa,Miasto,Adres,Kraj,Opis)
values('Dêbnica','Kraków','ul. Koœciuszki 24','Polska','Wypocznij w cichej okolicy i zrelaksuj siê korzystaj¹c z Hotelu Debnica.'),
('Pod Jeleniem','Kraków','ul. W³adys³awa 14','Polska','Uroczy Hotel z jeszcze bardziej urocz¹ okolic¹.'),
('Nad Jeziorem','Kraków','ul. M³yñska 24','Polska','Obiecujemy nie zapomniane prze¿ycia.'),
('Blisko','Gdañsk','ul. Czerwonych maków 23','Polska','Zawsze jesteœmy Blisko!')
go
--wprowadzanie danych do tabeli Karty
insert into Karty
values('1234567890123456','12IO','2022-05-05');
insert into Karty
values('0987654321123456','3E1','2021-12-12');
insert into Karty
values('1087654321123456','3A1','2023-12-12');
go
--wprowadzanie danych Klientów
insert into Klienci
values('Adrian','Karpicki','adam@gmail.com','Polska','ul. Magórka 22 ','22-321','Kraków','123456789','1234567890123456'),
('Marek','Kowalski','maro@o2.pl','Polska','ul. Kwiatowa 21 ','20-321','Zakopane','213456119','0987654321123456'),
('Alex','White','whiteALex@gmail.com','USA','802 Terminal St','CA 92123','San Diego','212256119','1087654321123456')
go
--wprowadzanie danych do tabeli Pokoje
insert into Pokoje(IdHotelu,NrPokoju,LiczbaOsób,Liczba£ó¿ek,KosztDoba,Opis)
values(1,1,1,1,20,'wygodny pokój z widokiem na Rynek oraz wawel'),
(1,2,1,1,20,'wygodny pokój z widokiem na Rynek'),
(1,3,2,1,30,'wygodny pokój z widokiem na Rynek dla par'),
(1,4,3,2,45,'wygodny pokój z widokiem na Wawel,który pomieœci ca³¹ rodzinê'),
(1,5,5,4,45,'Przestrony pokój z dwoma ³azienkami dla du¿ych rodzin'),
(1,6,5,5,45,'Przestrony pokój z trzema ³azienkami stworzony z myœl¹ o wycieczkach szkolnych'),
(1,7,5,5,70,'Przestrony pokój z trzema ³azienkami stworzony z myœl¹ o wycieczkach szkolnych'),
(1,8,5,5,70,'Przestrony pokój z trzema ³azienkami stworzony z myœl¹ o wycieczkach szkolnych'),
(2,1,1,1,22,'wygodny pokój z widokiem na Rynek oraz wawel'),
(2,2,1,1,25,'wygodny pokój z widokiem na Rynek'),
(2,3,2,1,33,'wygodny pokój z widokiem na Rynek dla par'),
(2,4,2,1,44,'wygodny pokój z widokiem na Wawel,dla nowo¿eñców'),
(2,5,3,2,45,'Przestrony pokój'),
(3,1,1,1,30,'wygodny pokój z widokiem na Rynek oraz wawel'),
(3,2,1,1,20,'Pokój idealny do postoju podczas zwiedzania'),
(3,3,3,2,33,'wygodny pokój z widokiem na Rynek dla rodziny'),
(3,4,4,3,45,'wygodny pokój z widokiem na Wawel'),
(3,5,5,5,50,'Przestrony pokój'),
(4,1,2,1,55,'wygodny pokój z widokie na morze'),
(4,2,1,1,20,'Pokój idealny do postoju podczas wyjazdów s³u¿bowych'),
(4,3,3,2,39,'wygodny pokój z widokiem na Rynek dla rodziny'),
(4,4,4,3,45,'wygodny pokój z widokiem na morze'),
(4,5,2,1,70,'Przestrony apartament z widokiem na ca³¹ okolice')
go
insert into Pokoje(IdHotelu,NrPokoju,LiczbaOsób,Liczba£ó¿ek,KosztDoba,Status,Opis)
values(1,9,1,1,50,1,'Pokój dla palaczy');
--24 pokoje
--wprowadzenie danych do tabeli Udogodnienia
go
insert into Udogodnienia(IdHotelu,Nazwa)
values(1,'Parking'),(2,'Parking'),(3,'Parking'),
(1,'Basen'),(3,'Basen'),(1,'Sauna'),(2,'Sauna'),
(1,'Si³ownia'),(2,'Si³ownia'),(3,'Si³ownia'),(4,'Si³ownia'),
(1,'Bar'),(4,'Bar');
go
--wprowadzanie danych do tabeli wyposa¿enia
insert into Wyposa¿enia(IdPokoju,Nazwa)
values(1,'Sejf'),(2,'Sejf'),(3,'Sejf'),(4,'Sejf'),
(5,'Sejf'),(6,'Sejf'),(7,'Sejf'),(8,'Sejf'),(20,'Sejf'),
(21,'Sejf'),(22,'Sejf'),(23,'Sejf'),(24,'Sejf'),
(24,'jacuzzi'),(11,'Dla palaczy'),(21,'Dla palaczy'),
(22,'Dla palaczy'),(21,'Dla palaczy'),(16,'Dla palaczy'),
(13,'Dla palaczy'),(21,'Dla niepe³nosprawnych'),(22,'Dla niepe³nosprawnych'),
(17,'Dla niepe³nosprawnych'),(1,'Mini Barek'),(24,'Mini Barek'),(3,'Mini Barek'),
(9,'Telewizor'),(10,'Telewizor'),(11,'Telewizor'),(12,'Telewizor'),(13,'Telewizor'),
(24,'Telewizor'),(14,'Telewizor'),(15,'Telewizor'),(16,'Telewizor'),
(24,'Lodówka'),(24,'Sauna'),(16,'Sejf'),(16,'Sejf'),(18,'Sejf'),(17,'Telewizor'),
(3,'Telewizor'),(4,'Telewizor'),(19,'Jacuzzi');
go
--wprowadzanie danych do tabeli rezerwacje

insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,1,'2021-07-06 7:00','2021-07-11 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,2,'2021-07-11 7:00','2021-07-13 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,3,'2021-07-01 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,4,'2021-07-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,5,'2021-06-21 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,6,'2021-07-11 7:00','2021-07-26 8:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,7,'2021-07-01 7:00','2021-07-03 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,8,'2021-08-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,9,'2021-06-11 7:00','2021-07-01 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,10,'2021-07-01 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,10,'2021-07-09 7:00','2021-07-16 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,11,'2021-07-11 7:00','2021-07-19 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,11,'2021-08-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,12,'2021-07-01 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,12,'2021-07-11 7:00','2021-07-26 8:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,13,'2021-07-14 12:00','2021-07-28 18:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,13,'2021-07-01 17:00','2021-07-16 8:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,14,'2021-06-21 7:00','2021-06-26 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,14,'2021-08-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,15,'2021-07-01 7:00','2021-07-06 8:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,15,'2021-07-09 7:00','2021-07-16 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,15,'2021-07-18 7:00','2021-07-23 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,16,'2021-08-01 7:00','2021-08-06 8:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,16,'2021-07-01 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,17,'2021-07-11 7:00','2021-07-13 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,17,'2021-07-01 7:00','2021-07-06 8:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,18,'2021-07-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,19,'2021-06-21 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,19,'2021-07-21 7:00','2021-07-26 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,20,'2021-08-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,20,'2021-07-01 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,21,'2021-07-09 7:00','2021-07-16 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,21,'2021-06-18 7:00','2021-06-23 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,21,'2021-08-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,22,'2021-07-19 7:00','2021-07-26 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,22,'2021-06-18 7:00','2021-06-23 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,22,'2021-07-01 7:00','2021-07-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,23,'2021-07-14 12:00','2021-07-28 18:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,23,'2021-07-01 17:00','2021-07-12 8:00','Na miejscu');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,23,'2021-06-21 7:00','2021-06-26 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,24,'2021-08-01 7:00','2021-08-06 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(1,24,'2021-07-19 7:00','2021-07-26 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(3,24,'2021-06-18 7:00','2021-06-23 8:00','Przelew');
insert into Rezerwacje(IdKlienta,IdPokoju,DataStart,DataStop,SposóbP³atnoœci)
values(2,24,'2021-07-01 7:00','2021-07-11 8:00','Przelew');




