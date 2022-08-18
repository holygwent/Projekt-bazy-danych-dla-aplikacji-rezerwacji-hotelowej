USE BazaHotel
--usuniecie POWI¥ZAÑ jesli istnieja
GO
IF EXISTS (
	SELECT *
	FROM sys.foreign_keys
	WHERE object_id = OBJECT_ID('dbo.FK_Klienci_Karty')
	AND parent_object_id=OBJECT_ID('dbo.Klienci')
)

ALTER TABLE dbo.Klienci
DROP CONSTRAINT FK_Klienci_Karty
GO
IF EXISTS (
	SELECT *
	FROM sys.foreign_keys
	WHERE object_id = OBJECT_ID('dbo.FK_Udogodnienia_Hotele')
	AND parent_object_id=OBJECT_ID('dbo.Udogodnienia')
)
ALTER TABLE Udogodnienia
DROP CONSTRAINT FK_Udogodnienia_Hotele
GO
IF EXISTS (
	SELECT *
	FROM sys.foreign_keys
	WHERE object_id = OBJECT_ID('dbo.FK_Pokoje_Hotele')
	AND parent_object_id=OBJECT_ID('dbo.Pokoje')
)
ALTER TABLE dbo.Pokoje
DROP CONSTRAINT FK_Pokoje_Hotele
GO
IF EXISTS (
	SELECT *
	FROM sys.foreign_keys
	WHERE object_id = OBJECT_ID('dbo.FK_Wyposa¿enia_Pokoje')
	AND parent_object_id=OBJECT_ID('dbo.Wyposa¿enia')
)


ALTER TABLE dbo.Wyposa¿enia
DROP CONSTRAINT FK_Wyposa¿enia_Pokoje
GO
IF EXISTS (
	SELECT *
	FROM sys.foreign_keys
	WHERE object_id = OBJECT_ID('dbo.FK_Rezerwacje_Pokoje')
	AND parent_object_id=OBJECT_ID('dbo.Rezerwacje')
)

ALTER TABLE dbo.Rezerwacje
DROP CONSTRAINT FK_Rezerwacje_Pokoje
GO
IF EXISTS (
	SELECT *
	FROM sys.foreign_keys
	WHERE object_id = OBJECT_ID('dbo.FK_Rezerwacje_Klienci')
	AND parent_object_id=OBJECT_ID('dbo.Rezerwacje')
)


ALTER TABLE dbo.Rezerwacje
DROP CONSTRAINT FK_Rezerwacje_Klienci
GO
--DODANIE POWI¥ZAÑ
ALTER TABLE Klienci
ADD CONSTRAINT FK_Klienci_Karty
	FOREIGN KEY(NrKarty) REFERENCES Karty(NrKarty)
GO

ALTER TABLE Rezerwacje
ADD CONSTRAINT FK_Rezerwacje_Klienci
	FOREIGN KEY (IdKlienta) REFERENCES Klienci(IdKlienta)
GO

ALTER TABLE Rezerwacje
ADD CONSTRAINT FK_Rezerwacje_Pokoje
	FOREIGN KEY (IdPokoju) REFERENCES Pokoje(IdPokoju)
GO

ALTER TABLE Wyposa¿enia
ADD CONSTRAINT FK_Wyposa¿enia_Pokoje
FOREIGN KEY (IdPokoju) REFERENCES Pokoje(IdPokoju)
GO

ALTER TABLE Pokoje
ADD CONSTRAINT FK_Pokoje_Hotele
FOREIGN KEY (IdHotelu) REFERENCES Hotele(IdHotelu)
GO

ALTER TABLE Udogodnienia
ADD CONSTRAINT FK_Udogodnienia_Hotele
FOREIGN KEY (IdHotelu) REFERENCES Hotele(IdHotelu)
GO