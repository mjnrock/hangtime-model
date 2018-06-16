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
--		ENUMS
--	==============================================
CREATE TABLE Hangtime.[E:Activity] (
	ActivityID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[E:ParticipantStatus] (
	ParticipantStatusID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		USER
--	==============================================
CREATE TABLE Hangtime.[User] (
	UserID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Username VARCHAR(255) NOT NULL,
	[Password] BINARY NULL,	-- Use SHA2_256	-- HASHBYTES('SHA2_256', 'Testing')

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[User.Facebook] (
	FacebookID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		EVENTS
--	==============================================
CREATE TABLE Hangtime.[Event] (
	EventID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ActivityID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[E:Activity] (ActivityID),
	HostUserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),	-- In a group setting, make this the group leader
	
	Title NVARCHAR(100) NULL,
	Tags VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[Event.Location] (
	LocationID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	EventID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Event (EventID),

	Location GEOGRAPHY NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[Event.Participant] (
	ParticipantID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	EventID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Event (EventID),
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	ParticipantStatusID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[E:ParticipantStatus] (ParticipantStatusID),

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		MESSAGING
--	==============================================
CREATE TABLE Hangtime.Channel (
	ChannelID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Title NVARCHAR(255) NULL,
	[Description] NVARCHAR(MAX) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Channel.Member] (
	MemberID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ChannelID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Channel (ChannelID),
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	IsLeader BIT NOT NULL DEFAULT 0,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.Post (
	PostID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	PostTypeID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[E:PostType] (PostTypeID),
	AuthorUserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	Comment NVARCHAR(MAX) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.PostReaction (
	PostReactionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	PostID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Post (PostID),
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	Emoji NCHAR(1) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);



--	==============================================
--		SEEDING
--	==============================================	
--	---------------------
--		ENUMS
--	---------------------
INSERT INTO Hangtime.[E:Activity] (Code, Label)
VALUES
	('BASKETBALL', 'Basketball'),
	('HOCKEY', 'Hockey'),
	('TENNIS', 'Tennis');

INSERT INTO Hangtime.[E:ParticipantStatus] (Code, Label)
VALUES
	('ACCEPTED', 'Accepted'),
	('MAYBE', 'Maybe'),
	('DECLINED', 'Declined'),
	('PENDING', 'Pending');