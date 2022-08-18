use BazaHotel
--sprawdzanie czy email jest poprawny
IF OBJECt_ID('Klienci','U') IS NOT NULL
begin 
	ALTER TABLE Klienci DROP CONSTRAINT IF EXISTS SprawdzEmail;
	ALTER TABLE Klienci
	ADD CONSTRAINT SprawdzEmail CHECK (Email like '%@%');
end
go
--sprawdzanie czy koszt nie jest warto�ci� ujemn�
IF OBJECt_ID('Rezerwacje','U') IS NOT NULL
begin 
	ALTER TABLE Rezerwacje DROP CONSTRAINT IF EXISTS SprawdzKoszt;
	ALTER TABLE Rezerwacje
	ADD CONSTRAINT SprawdzKoszt CHECK (Koszt >=0);
end
go
--sprawdzanie czy koszt rezygnacji nie jest warto�ci� ujemn�
IF OBJECt_ID('Rezerwacje','U') IS NOT NULL
begin 
	ALTER TABLE Rezerwacje DROP CONSTRAINT IF EXISTS SprawdzKosztRezygnacji;
	ALTER TABLE Rezerwacje
	ADD CONSTRAINT SprawdzKosztRezygnacji CHECK (KosztRezygnacji >=0);
end
go
--sprawdzenie czy Spos�bP�atno�ci ma poprawn� warto��
IF OBJECt_ID('Rezerwacje','U') IS NOT NULL
begin 
	ALTER TABLE Rezerwacje DROP CONSTRAINT IF EXISTS SprawdzSpos�bP�atno�ci;
	ALTER TABLE Rezerwacje
	ADD CONSTRAINT SprawdzSpos�bP�atno�ci CHECK (Spos�bP�atno�ci in ('przelew','na miejscu'));
end
go
--sprawdzanie czy nr pokoju nie warto�ci� ujemn� lub zerem
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzNrPokoju;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzNrPokoju CHECK (NrPokoju >0);
end
go
--sprawdzanie czy liczba os�b nie warto�ci� ujemn�
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzLiczbaOs�b;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzLiczbaOs�b CHECK (LiczbaOs�b >= 0);
end
go
--sprawdzanie czy liczba ��ek nie warto�ci� ujemn�
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzLiczba��ek;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzLiczba��ek CHECK (Liczba��ek >= 0);
end
go
--sprawdzanie czy koszt za dobe nie warto�ci� ujemn�
IF OBJECt_ID('Pokoje','U') IS NOT NULL
begin 
	ALTER TABLE Pokoje DROP CONSTRAINT IF EXISTS SprawdzKosztDoba;
	ALTER TABLE Pokoje
	ADD CONSTRAINT SprawdzKosztDoba CHECK (KosztDoba >= 0);
end
go
--TWORZENIE WYZWALACZA KTORY SPRAWDZA CZY DATA WA�NO�CI KARTY NIE JEST STARSZA NI� DATA DODANIA przy update
DROP TRIGGER IF EXISTS SprawdzKartaDataWa�no�ciUpdate;
go
CREATE TRIGGER SprawdzKartaDataWa�no�ciUpdate ON dbo.Karty
FOR UPDATE
AS
BEGIN
	IF UPDATE(DataWa�no�ci)
	BEGIN
	DECLARE @DataDodania DATE;
	SET @DataDodania = GETDATE();
	IF((SELECT DataWa�no�ci FROM INSERTED)<@DataDodania)
		BEGIN
		PRINT 'PRZETERMINOWANA DATA'
		UPDATE Karty
		SET DataWa�no�ci = (SELECT DataWa�no�ci FROM deleted)
		WHERE NrKarty = (SELECT NrKarty FROM inserted)
		END
	END
END
go
--TWORZENIE WYZWALACZA KTORY SPRAWDZA CZY DATA WA�NO�CI KARTY NIE JEST STARSZA NI� DATA DODANIA przy insert
DROP TRIGGER IF EXISTS dbo.SprawdzKartaDataWa�no�ciInsert;
go
CREATE TRIGGER SprawdzKartaDataWa�no�ciInsert ON dbo.Karty
instead of insert
AS
	begin
	DECLARE @DataDodania DATE;
	SET @DataDodania = GETDATE();
	IF((SELECT DataWa�no�ci FROM INSERTED)>@DataDodania)
		BEGIN 
		insert into Karty
		values((select NrKarty from inserted),(select CVC from inserted),(select DataWa�no�ci from inserted));
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
	(SELECT Spos�bP�atno�ci FROM inserted),
	0);
	END
END
Go





