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
CREATE TABLE Hangtime.[User.Google] (
	GoogleID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[User.Twitter] (
	TwitterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[User.Instagram] (
	InstagramID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	Username VARCHAR(255) NOT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		RESPONSES
--	==============================================
CREATE TABLE Hangtime.[Response.Category] (
	CategoryID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Response.Type] (
	TypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	CategoryID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Response.Category] (CategoryID),
	
	Code VARCHAR(25) NOT NULL,
	Label VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Response.Value] (
	ValueID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	TypeID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Response.Type] (TypeID),
	
	Label VARCHAR(255) NOT NULL,
	TextValue VARCHAR(255) NULL,
	NumericValue REAL NULL,
	Ordinality INT NULL,

	IsCorrect BIT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		PROFILES
--	==============================================
CREATE TABLE Hangtime.[Profile] (
	ProfileID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,

	Title VARCHAR(255) NOT NULL,
	[Description] VARCHAR(MAX) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Profile.Section] (
	SectionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ProfileID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Profile] (ProfileID),
	
	Header VARCHAR(255) NULL,
	SubHeader VARCHAR(255) NULL,
	[Description] VARCHAR(MAX) NULL,
	Ordinality INT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Profile.Item] (
	ItemID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	SectionID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Profile.Section] (SectionID),
	ResponseTypeID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Response.Type] (TypeID),
	
	Label VARCHAR(255) NOT NULL,
	Ordinality INT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);

CREATE TABLE Hangtime.[Profile.Response] (
	ResponseID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ItemID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Profile.Item] (ItemID),
	UserID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[User] (UserID),
	
	ProfileID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Profile] (ProfileID),	-- Redundant from normalization, but for convenience
	ResponseValueID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Response.Value] (ValueID),

	Comment VARCHAR(255) NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);


--	==============================================
--		PROMPTS
--	==============================================
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

	Header VARCHAR(255) NULL,
	SubHeader VARCHAR(255) NULL,
	[Description] VARCHAR(MAX) NULL,
	Ordinality INT NULL,

	UUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CreatedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	ModifiedDateTimeUTC DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	DeactivatedDateTimeUTC DATETIME2(3) NULL
);
CREATE TABLE Hangtime.[Prompt.Question] (
	QuestionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	SectionID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Prompt.Section] (SectionID),
	ResponseTypeID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Response.Type] (TypeID),

	[Text] VARCHAR(MAX) NOT NULL,
	Ordinality INT NULL,

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
	ResponseValueID INT NOT NULL FOREIGN KEY REFERENCES Hangtime.[Response.Value] (ValueID),

	Comment VARCHAR(255) NULL,

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
--		Prompts
--	---------------------
INSERT INTO Hangtime.[Response.Category] (Code, Label)
VALUES
	('TEXT', 'Free Response'),
	('XOR', 'Dichotomous'),
	('QNTSCALE', 'Quantitative Scale'),
	('QLTSCALE', 'Qualitative Scale');

INSERT INTO Hangtime.[Response.Type] (CategoryID, Code, Label)
VALUES
	(1, 'COMMENT', 'Comment'),
	(1, 'INPUT', 'Input Text'),

	(2, 'TF', 'True or False'),
	(2, 'YN', 'Yes or No'),

	(3, 'S0103', 'Scale: 1 - 3'),
	(3, 'S0104', 'Scale: 1 - 4'),
	(3, 'S0105', 'Scale: 1 - 5'),
	(3, 'S0110', 'Scale: 1 - 10'),
	
	(4, 'SSASD', 'Scale: Strongly Disagree to Strongly Agree (4)'),
	(4, 'SSANSD', 'Scale: Strongly Disagree to Strongly (5)'),
	(4, 'SFREQ', 'Scale: Never to Always (4)'),
	(4, 'SFREQS', 'Scale: Never to Always (5)');

INSERT INTO Hangtime.[Response.Value] (TypeID, Label, TextValue, NumericValue)
VALUES
	(1, 'Comment', NULL, NULL),
	(2, 'Input Text', NULL, NULL),

	(3, 'True', 'T', 1),
	(3, 'False', 'F', 0),
	(4, 'Yes', 'Y', 1),
	(4, 'No', 'N', 0),

	(5, '1', '1', 1),
	(5, '2', '2', 2),
	(5, '3', '3', 3),
	(6, '1', '1', 1),
	(6, '2', '2', 2),
	(6, '3', '3', 3),
	(6, '4', '4', 4),
	(7, '1', '1', 1),
	(7, '2', '2', 2),
	(7, '3', '3', 3),
	(7, '4', '4', 4),
	(7, '5', '5', 5),	
	(8, '1', '1', 1),
	(8, '2', '2', 2),
	(8, '3', '3', 3),
	(8, '4', '4', 4),
	(8, '5', '5', 5),
	(8, '6', '6', 6),
	(8, '7', '7', 7),
	(8, '8', '8', 8),
	(8, '9', '9', 9),
	(8, '10', '10', 10),
	
	(9, 'Strongly Disagree', 'SD', 1),
	(9, 'Disagree', 'D', 2),
	(9, 'Agree', 'A', 3),
	(9, 'Strongly Agree', 'SA', 4),
	(10, 'Strongly Disagree', 'SD', 1),
	(10, 'Disagree', 'D', 2),
	(10, 'Neutral', 'N', 3),
	(10, 'Agree', 'A', 4),
	(10, 'Strongly Agree', 'SA', 5),
	(11, 'Never', 'N', 1),
	(11, 'Rarely', 'R', 2),
	(11, 'Often', 'O', 3),
	(11, 'Always', 'A', 4),
	(12, 'Never', 'N', 1),
	(12, 'Rarely', 'R', 2),
	(12, 'Sometimes', 'S', 3),
	(12, 'Often', 'O', 4),
	(12, 'Always', 'A', 5);
	
INSERT INTO Hangtime.Prompt (Title, [Description])
VALUES
	('Change Group Name', 'Suggestion to Change Group Name by ${USERNAME}');	-- Templatize insertions with ${}
	
INSERT INTO Hangtime.[Prompt.Section] (PromptID, Header)
VALUES
	(1, 'Main');
	
INSERT INTO Hangtime.[Prompt.Question] (ResponseTypeID, SectionID, [Text], Ordinality)
VALUES
	(4, 1, 'Would you like to change group''s name to "${GROUP_NAME}"?', 1);