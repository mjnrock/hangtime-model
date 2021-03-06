USE Hangtime
GO

--CREATE SCHEMA Hangtime
--GO

--	==============================================
--		SMART DROP
--	==============================================
DECLARE @Schema VARCHAR(255) = 'Hangtime';
DECLARE @SQL NVARCHAR(MAX) = '';

SELECT
	@SQL = @SQL + 'ALTER TABLE ['+s.name+'].['+t.name+'] DROP CONSTRAINT ['+o.name+'];'
FROM
	sys.foreign_key_columns fkc
	INNER JOIN sys.objects o
		ON fkc.constraint_object_id = o.object_id
	INNER JOIN sys.tables t
		ON fkc.parent_object_id = t.object_id
	INNER JOIN sys.schemas s
		ON t.schema_id = s.schema_id
WHERE
	s.name = @Schema
EXEC(@SQL);

SET @SQL = '';
SELECT
	@SQL = @SQL + 'IF OBJECT_ID('''+s.name+'.['+t.name+']'') IS NOT NULL DROP TABLE '+s.name+'.['+t.name+'];'
FROM
	sys.tables t
	INNER JOIN sys.schemas s
		ON t.schema_id = s.schema_id
WHERE
	s.name = @Schema
EXEC(@SQL);

SET @SQL = '';
SELECT
	@SQL = @SQL + 'DROP PROCEDURE [' + routine_schema + '].[' + routine_name + ']'
FROM 
    information_schema.routines
WHERE
	routine_schema = @Schema
	AND routine_type = 'PROCEDURE'
EXEC(@SQL);

SET @SQL = '';
SELECT
	@SQL = @SQL + 'DROP FUNCTION [' + routine_schema + '].[' + routine_name + ']'
FROM 
    information_schema.routines
WHERE
	routine_schema = @Schema
	AND routine_type = 'FUNCTION'
EXEC(@SQL);


--	==============================================
--		TABLES
--	==============================================
CREATE TABLE Hangtime.Activity (
	ActivityID INT IDENTITY(1,1) PRIMARY KEY,

	Code VARCHAR(255) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.RatingType (
	RatingTypeID INT IDENTITY(1,1) PRIMARY KEY,

	Code VARCHAR(255) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.RatingSet (
	RatingSetID INT IDENTITY(1,1) PRIMARY KEY,

	Code VARCHAR(255) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.Rating (
	RatingID INT IDENTITY(1,1) PRIMARY KEY,
	RatingSetID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.RatingSet (RatingSetID),

	Code VARCHAR(255) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	TextValue VARCHAR(255) NOT NULL,
	NumericValue REAL NOT NULL,
	Ordinality INT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);



CREATE TABLE Hangtime.[User] (
	UserID INT IDENTITY(1,1) PRIMARY KEY,

	Username VARCHAR(255) NOT NULL,
	[Password] VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NULL,
	LastLoginDateTimeUTC DATETIME2(3) NULL DEFAULT SYSUTCDATETIME(),

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.UserDetail (
	UserDetailID INT IDENTITY(1,1) PRIMARY KEY,
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),

	FirstName VARCHAR(255) NULL,
	LastName VARCHAR(255) NULL,
	HomeLocation GEOGRAPHY NULL,
	CurrentLocation GEOGRAPHY NULL,
	CurrentLocationDateTimeUTC DATETIME2(3) NULL,
	UTCOffset TINYINT NULL,
	
	Facebook VARCHAR(255) NULL,
	Twitter VARCHAR(255) NULL,
	Instagram VARCHAR(255) NULL,
	Snapchat VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.UserRating (
	UserRating INT IDENTITY(1,1) PRIMARY KEY,
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	RatingTypeID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.RatingType (RatingTypeID),
	FKID INT NOT NULL,
	
	RatingID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Rating (RatingID),
	Comment VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.Place (
	PlaceID INT IDENTITY(1,1) PRIMARY KEY,

	Name VARCHAR(255) NULL,
	[Description] VARCHAR(MAX) NULL,
	Address1 VARCHAR(255) NULL,
	Address2 VARCHAR(255) NULL,
	City VARCHAR(255) NULL,
	[State] VARCHAR(255) NULL,
	Zip5 VARCHAR(255) NULL,
	Country VARCHAR(255) NULL,

	Location GEOGRAPHY,
	Perimeter GEOMETRY,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.Game (
	GameID INT IDENTITY(1,1) PRIMARY KEY,
	HostUserID INT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	ActivityID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Activity (ActivityID),

	Location GEOGRAPHY NOT NULL,
	LastCheckinDateTimeUTC DATETIME2(3) NULL DEFAULT SYSUTCDATETIME(),
	StartDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	EndDateTimeUTC DATETIME2(3) NULL,	

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.GameDetail (
	GameDetailID INT IDENTITY(1,1) PRIMARY KEY,
	GameID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Game (GameID),
	PlaceID INT NULL FOREIGN KEY REFERENCES Hangtime.Place (PlaceID),
	
	Title NVARCHAR(50) NULL,
	[Description] NVARCHAR(100) NULL,
	Tags VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);