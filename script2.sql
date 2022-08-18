use BazaHotel
--sprawdzanie czy email jest poprawny
IF OBJECt_ID('Klienci','U') IS NOT NULL
begin 
	ALTER TABLE Klienci DROP CONSTRAINT IF EXISTS SprawdzEmail;
	ALTER TABLE Klienci
	ADD CONSTRAINT SprawdzEmail CHECK (Email like '%@%');
end
go
--sprawdzanie czy koszt nie jest wartoœci¹ ujemn¹
IF OBJECt_ID('Rezerwacje','U') IS NOT NULL
begin 
	ALTER TABLE Rezerwacje DROP CONSTRAINT IF EXISTS SprawdzKoszt;
	ALTER TABLE Rezerwacje
	ADD CONSTRAINT SprawdzKoszt CHECK (Koszt >=0);
end
go
--sprawdzanie czy koszt rezygnacji nie jest wartoœci¹ ujemn¹
IF OBJECt_ID('Rezerwacje','U') IS NOT NULL
begin 
	ALTER TABLE Rezerwacje DROP CONSTRAINT IF EXISTS SprawdzKosztRezygnacji;
	ALTER TABLE Rezerwacje
	ADD CONSTRAINT SprawdzKosztRezygnacji CHECK (KosztRezygnacji >=0);
end
go
--sprawdzenie czy SposóbP³atnoœci ma poprawn¹ wartoœæ
IF OBJECt_ID('Rezerwacje','U') IS NOT NULL
begin 
	ALTER TABLE Rezerwacje DROP CONSTRAINT IF EXISTS SprawdzSposóbP³atnoœci;
	ALTER TABLE Rezerwacje
	ADD CONSTRAINT SprawdzSposóbP³atnoœci CHECK (SposóbP³atnoœci in ('przelew','na miejscu'));
end
go
--sprawdzanie czy nr pokoju nie wartoœci¹ ujemn¹ lub zerem
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzNrPokoju;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzNrPokoju CHECK (NrPokoju >0);
end
go
--sprawdzanie czy liczba osób nie wartoœci¹ ujemn¹
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzLiczbaOsób;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzLiczbaOsób CHECK (LiczbaOsób >= 0);
end
go
--sprawdzanie czy liczba ³ó¿ek nie wartoœci¹ ujemn¹
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzLiczba£ó¿ek;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzLiczba£ó¿ek CHECK (Liczba£ó¿ek >= 0);
end
go
--sprawdzanie czy koszt za dobe nie wartoœci¹ ujemn¹
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzKosztDoba;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzKosztDoba CHECK (KosztDoba >= 0);
end
go
--TWORZENIE WYZWALACZA KTORY SPRAWDZA CZY DATA WA¯NOŒCI KARTY NIE JEST STARSZA NI¯ DATA DODANIA przy update
DROP TRIGGER IF EXISTS SprawdzKartaDataWa¿noœciUpdate;
go
CREATE TRIGGER SprawdzKartaDataWa¿noœciUpdate ON dbo.Karty
FOR UPDATE
AS
BEGIN
	IF UPDATE(DataWa¿noœci)
	BEGIN
	DECLARE @DataDodania DATE;
	SET @DataDodania = GETDATE();
	IF((SELECT DataWa¿noœci FROM INSERTED)<@DataDodania)
		BEGIN
		PRINT 'PRZETERMINOWANA DATA'
		UPDATE Karty
		SET DataWa¿noœci = (SELECT DataWa¿noœci FROM deleted)
		WHERE NrKarty = (SELECT NrKarty FROM inserted)
		END
	END
END
go
--TWORZENIE WYZWALACZA KTORY SPRAWDZA CZY DATA WA¯NOŒCI KARTY NIE JEST STARSZA NI¯ DATA DODANIA przy insert
DROP TRIGGER IF EXISTS dbo.SprawdzKartaDataWa¿noœciInsert;
go
CREATE TRIGGER SprawdzKartaDataWa¿noœciInsert ON dbo.Karty
instead of insert
AS
	begin
	DECLARE @DataDodania DATE;
	SET @DataDodania = GETDATE();
	IF((SELECT DataWa¿noœci FROM INSERTED)>@DataDodania)
		BEGIN 
		insert into Karty
		values((select NrKarty from inserted),(select CVC from inserted),(select DataWa¿noœci from inserted));
		END
	end
go
--sprawdza czy data start jest pozniejsza niz data dodania oraz czy data stop jest pozniejsza od data start przy insert
--oblicza koszt rezerwacji
drop trigger if exists dbo.SprawdzDataStartStopInsert;
go
CREATE TRIGGER SprawdzDataStartStopInsert ON dbo.Rezerwacje
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @DataDodania DATE;
	SET @DataDodania = GETDATE();
	IF(((SELECT DataStart FROM INSERTED)>@DataDodania )AND ((SELECT DataStop FROM inserted)  > (SELECT DataStart FROM inserted)        ) )
	BEGIN
	INSERT INTO Rezerwacje
	VALUES((SELECT IdKlienta FROM inserted),(SELECT IdPokoju FROM inserted),
	(SELECT DataStart FROM inserted),(SELECT DataStop FROM inserted)
	,(SELECT (KosztDoba*(DATEDIFF(day,DataStart,DataStop))) FROM inserted i join Pokoje p on i.IdPokoju = p.IdPokoju
	),0,
	(SELECT SposóbP³atnoœci FROM inserted),
	0);
	END
END
Go





