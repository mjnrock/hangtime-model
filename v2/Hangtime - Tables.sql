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

CREATE TABLE Hangtime.[E:PostType] (
	PostTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[E:UserStatus] (
	StatusID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
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
	Password BINARY NULL,	-- Use SHA2_256	-- HASHBYTES('SHA2_256', 'Testing')

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[User.Facebook] (
	FacebookID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[User.Google] (
	GoogleID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[User.Twitter] (
	TwitterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[User.Instagram] (
	InstagramID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		PromptS
--	==============================================
CREATE TABLE Hangtime.[Prompt.QuestionType] (
	QuestionTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Prompt.QuestionTypeResponse] (
	QuestionTypeResponseID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	QuestionTypeID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Prompt.QuestionType] (QuestionTypeID),
	
	Label VARCHAR(255) NOT NULL,
	TextValue VARCHAR(255) NULL,
	NumericValue REAL NOT NULL,

	IsCorrect BIT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.Prompt (
	PromptID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,

	Title VARCHAR(255) NOT NULL,
	[Description] VARCHAR(MAX) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Prompt.Section] (
	SectionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	PromptID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Prompt (PromptID),

	Header VARCHAR(255) NULL DEFAULT 'Main',
	SubHeader VARCHAR(255) NULL,
	[Description] VARCHAR(MAX) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Prompt.Question] (
	QuestionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	SectionID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Prompt.Section] (SectionID),
	QuestionTypeID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Prompt.QuestionType] (QuestionTypeID),

	Text VARCHAR(MAX) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[Prompt.Response] (
	ResponseID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	QuestionID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Prompt.Question] (QuestionID),
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	PromptID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Prompt (PromptID),	-- Redundant from normalization, but for convenience
	QuestionTypeResponseID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Prompt.QuestionTypeResponse] (QuestionTypeResponseID),

	Comment VARCHAR(MAX) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		EVENTS
--	==============================================
CREATE TABLE Hangtime.[Activity.Domain] (
	DomainID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ActivityID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[E:Activity] (ActivityID),
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(100) NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Activity.DomainValue] (
	DomainValueID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	DomainID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Activity.Domain] (DomainID),
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(100) NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.Event (
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

CREATE TABLE Hangtime.[MD:PostVote] (
	PostVoteID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	PostID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Post (PostID),
	PromptResponseID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Prompt.Response] (ResponseID),

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[MT:ChannelEvent] (
	ChannelEventID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ChannelID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Channel (ChannelID),
	EventID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.Event (EventID),

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

INSERT INTO Hangtime.[E:PostType] (Code, Label)
VALUES
	('COMMENT', 'Comment'),
	('REACTION', 'Reaction'),
	('VOTE', 'Vote');

INSERT INTO Hangtime.[E:UserStatus] (Code, Label)
VALUES
	('ONLINE', 'Online'),
	('IDLE', 'Idle'),
	('DND', 'Do Not Disturb'),
	('INVISIBLE', 'Invisible'),
	('OFFLINE', 'Offline');

INSERT INTO Hangtime.[E:ParticipantStatus] (Code, Label)
VALUES
	('ACCEPTED', 'Accepted'),
	('MAYBE', 'Maybe'),
	('DECLINED', 'Declined'),
	('INVITED', 'Invited'),
	('NONE', 'No Response');

--	---------------------
--		PromptS
--	---------------------
INSERT INTO Hangtime.[Prompt.QuestionType] (Code, Label)
VALUES
	('YN', 'Yes or No');

INSERT INTO Hangtime.[Prompt.QuestionTypeResponse] (QuestionTypeID, Label, TextValue, NumericValue)
VALUES
	(1, 'Yes', 'Y', 1),
	(1, 'No', 'N', 0);
	
INSERT INTO Hangtime.Prompt (Title, [Description])
VALUES
	('Change Group Name', 'Suggestion to Change Group Name by ${USERNAME}');	-- Templatize insertions with ${}
	
INSERT INTO Hangtime.[Prompt.Section] (PromptID, Header)
VALUES
	(1, 'Main');
	
INSERT INTO Hangtime.[Prompt.Question] (QuestionTypeID, SectionID, Text)
VALUES
	(1, 1, 'Would you like to change group''s name to "${GROUP_NAME}"?');