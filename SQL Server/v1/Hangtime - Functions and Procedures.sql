USE [Hangtime]
GO

--	==============================================
--		SMART DROP
--	==============================================
DECLARE @Schema VARCHAR(255) = 'Hangtime';
DECLARE @SQL NVARCHAR(MAX) = '';
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
--		ROUTINES
--	==============================================

USE [Hangtime]
GO
/****** Object:  UserDefinedFunction [Hangtime].[Explode]    Script Date: 6/13/2018 10:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Hangtime].[Explode]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos, endpos) AS (
        SELECT
			0 AS stpos,
			CHARINDEX(@Delimiter, @String) AS endpos

        UNION ALL

        SELECT
			endpos + 1,
			CHARINDEX(@Delimiter, @String, endpos + 1)
        FROM
			Split
        WHERE
			endpos > 0
    )

    SELECT
		'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Data' = SUBSTRING(@String, stpos, COALESCE(NULLIF(endpos, 0), LEN(@String) + 1) - stpos)
    FROM
		Split
)





GO
/****** Object:  UserDefinedFunction [Hangtime].[GetActivity]    Script Date: 6/13/2018 10:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE FUNCTION [Hangtime].[GetActivity]
(	
	@Input VARCHAR(100),
	@InputType INT = 1,
	@ActiveOnly BIT = 1
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		ActivityID,
		Code,
		Label,
		[Description],
		UUID
	FROM
		Hangtime.Activity a WITH (NOLOCK)
	WHERE
		(
			(
				@ActiveOnly = 1
				AND a.DeactivatedDateTimeUTC IS NULL
			)
			OR (
				@ActiveOnly = 0		
			)
		)
		AND (
			(
				@InputType = 0
				AND CAST(a.ActivityID AS VARCHAR(255)) = @Input
			)
			OR (
				@InputType = 1
				AND a.Code = CAST(@Input AS VARCHAR(255))
			)
			OR (
				@InputType = 2
				AND a.Label = CAST(@Input AS VARCHAR(100))
			)
			OR (
				@InputType = 3
				AND CAST(a.UUID AS VARCHAR(255)) = @Input
			)
		)
)




GO
/****** Object:  UserDefinedFunction [Hangtime].[GetProximateGames]    Script Date: 6/13/2018 10:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE FUNCTION [Hangtime].[GetProximateGames]
(	
	@Activity VARCHAR(100),
	@ActivityInputType INT = 1,
	@Latitude REAL,
	@Longitude REAL,
	@Distance REAL,
	@Tags VARCHAR(255) = NULL,
	@ActiveOnly BIT = 1
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		g.GameID,
		g.Location AS Location,
		g.Location.Lat AS Latitude,
		g.Location.Long AS Longitude,
		g.StartDateTimeUTC,
		g.EndDateTimeUTC,
		CASE
			WHEN DATEDIFF(MINUTE, g.LastCheckinDateTimeUTC, SYSUTCDATETIME()) >= 240 THEN 0
			WHEN g.EndDateTimeUTC IS NULL THEN 1
			WHEN DATEDIFF(SECOND, g.EndDateTimeUTC, SYSUTCDATETIME()) < 0 THEN 1
			ELSE 0
		END AS IsActive,
		DATEDIFF(MINUTE, g.LastCheckinDateTimeUTC, SYSUTCDATETIME()) AS TimeSinceLastCheckin,
		g.LastCheckinDateTimeUTC,

		gd.GameDetailID,
		gd.Title,
		gd.[Description],
		gd.Tags,

		u.Username AS HostUsername,

		p.Name AS Place,
		p.Location.Lat AS PlaceLatitude,
		p.Location.Long AS PlaceLongitude,
		p.Perimeter AS PlacePerimeter,
		p.Address1,
		p.Address2,
		p.City,
		p.[State],
		p.Zip5,
		p.Country,

		a.UUID AS ActivityUUID,
		g.UUID AS GameUUID,
		gd.UUID AS GameDetailUUID,
		u.UUID AS HostUserUUID,
		p.UUID AS PlaceUUID
	FROM
		Hangtime.Game g WITH (NOLOCK)
		CROSS APPLY Hangtime.GetActivity(@Activity, @ActivityInputType, 1) ga
		INNER JOIN Hangtime.Activity a WITH (NOLOCK)
			ON g.ActivityID = a.ActivityID
		LEFT JOIN Hangtime.GameDetail gd WITH (NOLOCK)
			ON g.GameID = gd.GameID
		LEFT JOIN Hangtime.[User] u WITH (NOLOCK)
			ON g.HostUserID = u.UserID
		LEFT JOIN Hangtime.Place p WITH (NOLOCK)
			ON gd.PlaceID = p.PlaceID
	WHERE
		ga.ActivityID = g.ActivityID
		AND (
			(
				@ActiveOnly = 1
				AND g.DeactivatedDateTimeUTC IS NULL
				AND CASE
						WHEN DATEDIFF(MINUTE, g.LastCheckinDateTimeUTC, SYSUTCDATETIME()) >= 240 THEN 0
						WHEN g.EndDateTimeUTC IS NULL THEN 1
						WHEN DATEDIFF(SECOND, g.EndDateTimeUTC, SYSUTCDATETIME()) < 0 THEN 1
						ELSE 0
					END = 1
			) OR (
				@ActiveOnly = 0		
			)
		)
		AND GEOGRAPHY::Point(@Latitude, @Longitude , 4326).STDistance(g.Location) <= @Distance
		AND (
			(
				@Tags IS NOT NULL
				AND EXISTS (
					SELECT
						*
					FROM
						Hangtime.Explode(gd.Tags, ',') t,
						Hangtime.Explode(@Tags, ',') f
					WHERE
						t.Data = f.Data
				)
			) OR (
				@Tags IS NULL
			)
		)
)





GO
/****** Object:  UserDefinedFunction [Hangtime].[GetGame]    Script Date: 6/13/2018 10:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE FUNCTION [Hangtime].[GetGame]
(	
	@Input VARCHAR(255),
	@InputType INT = 1,
	@ActiveOnly BIT = 1
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		g.GameID,
		g.Location AS Location,
		g.Location.Lat AS Latitude,
		g.Location.Long AS Longitude,
		g.StartDateTimeUTC,
		g.EndDateTimeUTC,
		CASE
			WHEN g.EndDateTimeUTC IS NULL THEN 1
			WHEN DATEDIFF(SECOND, g.EndDateTimeUTC, SYSUTCDATETIME()) < 0 THEN 1
			ELSE 0
		END AS IsActive,
		DATEDIFF(MINUTE, g.LastCheckinDateTimeUTC, SYSUTCDATETIME()) AS TimeSinceLastCheckin,
		g.LastCheckinDateTimeUTC,

		gd.GameDetailID,
		gd.Title,
		gd.[Description],
		gd.Tags,

		u.Username AS HostUsername,

		p.Name AS Place,
		p.Location.Lat AS PlaceLatitude,
		p.Location.Long AS PlaceLongitude,
		p.Perimeter AS PlacePerimeter,
		p.Address1,
		p.Address2,
		p.City,
		p.[State],
		p.Zip5,
		p.Country,

		a.UUID AS ActivityUUID,
		g.UUID AS GameUUID,
		gd.UUID AS GameDetailUUID,
		u.UUID AS HostUserUUID,
		p.UUID AS PlaceUUID
	FROM
		Hangtime.Game g WITH (NOLOCK)
		INNER JOIN Hangtime.Activity a WITH (NOLOCK)
			ON g.ActivityID = a.ActivityID
		LEFT JOIN Hangtime.GameDetail gd WITH (NOLOCK)
			ON g.GameID = gd.GameID
		LEFT JOIN Hangtime.[User] u WITH (NOLOCK)
			ON g.HostUserID = u.UserID
		LEFT JOIN Hangtime.Place p WITH (NOLOCK)
			ON gd.PlaceID = p.PlaceID
	WHERE
		(
			(
				@ActiveOnly = 1
				AND g.DeactivatedDateTimeUTC IS NULL
			)
			OR (
				@ActiveOnly = 0		
			)
		)
		AND (
			(
				@InputType = 0
				AND CAST(g.GameID AS VARCHAR(255)) = @Input
			)
			OR (
				@InputType = 3
				AND CAST(g.UUID AS VARCHAR(255)) = @Input
			)
			OR (
				@InputType = 4
				AND gd.GameDetailID = CAST(@Input AS INT)
			)
			OR (
				@InputType = 5
				AND CAST(gd.UUID AS VARCHAR(255)) = @Input
			)
		)
)





GO
/****** Object:  UserDefinedFunction [Hangtime].[GetUser]    Script Date: 6/13/2018 10:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE FUNCTION [Hangtime].[GetUser]
(	
	@Input VARCHAR(255),
	@InputType INT = 1,
	@ActiveOnly BIT = 1
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		u.UserID,
		ud.UserDetailID,
		u.Username,
		u.Email,
		ud.FirstName,
		ud.LastName,
		ud.CurrentLocation,
		ud.CurrentLocationDateTimeUTC,
		u.LastLoginDateTimeUTC,
		ud.UTCOffset,
		u.UUID AS UserUUID,
		ud.UUID AS UserDetailUUID
	FROM
		Hangtime.[User] u WITH (NOLOCK)
		LEFT JOIN Hangtime.UserDetail ud WITH (NOLOCK)
			ON u.UserID = ud.UserID
	WHERE
		(
			(
				@ActiveOnly = 1
				AND u.DeactivatedDateTimeUTC IS NULL
			)
			OR (
				@ActiveOnly = 0		
			)
		)
		AND (
			(
				@InputType = 0
				AND CAST(u.UserID AS VARCHAR(255)) = @Input
			)
			OR (
				@InputType = 1
				AND u.Username = CAST(@Input AS VARCHAR(255))
			)
			OR (
				@InputType = 2
				AND u.Email = CAST(@Input AS VARCHAR(255))
			)
			OR (
				@InputType = 3
				AND CAST(u.UUID AS VARCHAR(255)) = @Input
			)
			OR (
				@InputType = 4
				AND CAST(ud.UserDetailID AS VARCHAR(255)) = @Input
			)
			OR (
				@InputType = 5
				AND CAST(ud.UUID AS VARCHAR(255)) = @Input
			)
		)
)




GO
/****** Object:  StoredProcedure [Hangtime].[CreateGame]    Script Date: 6/13/2018 10:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE PROCEDURE [Hangtime].[CreateGame]
	@User VARCHAR(255),
	@UserInputType INT = 1,
	@Activity VARCHAR(100),
	@ActivityInputType INT = 1,
	@Latitude REAL,
	@Longitude REAL,
	@StartDateTimeUTC DATETIME2(3) = NULL,
	@EndDateTimeUTC DATETIME2(3) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ActivityID INT = (SELECT ActivityID FROM Hangtime.GetActivity(@Activity, @ActivityInputType, 1));
	DECLARE @UserID INT = (SELECT UserID FROM Hangtime.GetUser(@User, @UserInputType, 1));
	DECLARE @Location GEOGRAPHY = GEOGRAPHY::Point(@Latitude, @Longitude , 4326);

	IF @ActivityID IS NOT NULL AND @Location IS NOT NULL
		BEGIN
			INSERT INTO Hangtime.Game (ActivityID, HostUserID, Location, StartDateTimeUTC, EndDateTimeUTC)
			OUTPUT
				Inserted.UUID,
				Inserted.Location.Lat AS Latitude,
				Inserted.Location.Long AS Longitude,
				Inserted.StartDateTimeUTC,
				Inserted.EndDateTimeUTC
			SELECT
				@ActivityID,
				@UserID,
				@Location,
				COALESCE(@StartDateTimeUTC, SYSUTCDATETIME()),
				COALESCE(@EndDateTimeUTC, DATEADD(HOUR, 2, SYSUTCDATETIME()))
		END
	ELSE
		BEGIN
			SELECT
				NULL AS UUID,
				NULL AS Location
		END
END




GO
/****** Object:  StoredProcedure [Hangtime].[CreateUser]    Script Date: 6/13/2018 10:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE PROCEDURE [Hangtime].[CreateUser]
	@Username VARCHAR(255),
	@Password VARCHAR(255),
	@Email VARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Hangtime.[User] (Username, [Password], Email)
	OUTPUT
		Inserted.Username,
		Inserted.UUID
	SELECT
		@Username,
		HASHBYTES('SHA2_256', @Password),
		@Email
	WHERE
		NOT EXISTS (
			SELECT
				*
			FROM
				Hangtime.[User] u WITH (NOLOCK)
			WHERE
				u.Username = @Username
				OR u.Email = @Email
				OR @Password IS NULL
		)
END




GO









--	==============================================
--		SEEDING
--	==============================================
INSERT INTO Hangtime.Activity (Code, Label)
VALUES
	('basketball', 'Basketball'),
	('hockey', 'Hockey'),
	('tennis', 'Tennis');
	
INSERT INTO Hangtime.RatingType (Code, Label)
VALUES
	('user', 'User'),
	('place', 'Place'),
	('game', 'Game');

SELECT * FROM Hangtime.Activity;
EXEC Hangtime.CreateUser
	'MrFancypants',
	'Cat',
	'matt@kiszka.cat'

EXEC Hangtime.CreateUser
	'ahainen',
	'Cat',
	'andrew@butters.cat'

DECLARE @StartDateTimeUTC DATETIME2(3) = SYSUTCDATETIME()
--	Lake Orion, MI 48362
EXEC Hangtime.CreateGame
	'mrfancypants',
	1,
	'basketball',
	1,
	42.778010042,
	-83.2666570,
	@StartDateTimeUTC,
	DEFAULT
	
--	Lake Orion, MI 48362
EXEC Hangtime.CreateGame
	'mrfancypants',
	1,
	'hockey',
	1,
	42.778010042,
	-83.2666570,
	@StartDateTimeUTC,
	DEFAULT
	
--	Ypsilanti, MI 48197
EXEC Hangtime.CreateGame
	'ahainen',
	1,
	'basketball',
	1,
	42.1966290,
	-83.6135570,
	@StartDateTimeUTC,
	DEFAULT
	
--	Ypsilanti, MI 48197
EXEC Hangtime.CreateGame
	'ahainen',
	1,
	'basketball',
	1,
	42.1966290,
	-83.6135570,
	@StartDateTimeUTC,
	DEFAULT
	
--	Ypsilanti, MI 48197
EXEC Hangtime.CreateGame
	'ahainen',
	1,
	'hockey',
	1,
	42.1966290,
	-83.6135570,
	@StartDateTimeUTC,
	DEFAULT

SELECT
	*
FROM
	Hangtime.Game

UPDATE Hangtime.Game
SET
	StartDateTimeUTC = SYSUTCDATETIME(),
	LastCheckinDateTimeUTC = SYSUTCDATETIME()

DELETE FROM Hangtime.GameDetail
INSERT INTO Hangtime.GameDetail (GameID)
SELECT
	GameID
FROM
	Hangtime.Game

UPDATE Hangtime.GameDetail
SET
	Title = 'Shooty Hoops',
	[Description] = 'Shootin'' some scrud, ya'' heard? #Perdverts',
	Tags = '3v3,beer-league,mens,fatties'