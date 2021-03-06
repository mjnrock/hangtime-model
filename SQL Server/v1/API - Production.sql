USE [Hangtime]
GO
/****** Object:  User [hangtime]    Script Date: 6/13/2018 10:22:37 AM ******/
CREATE USER [hangtime] FOR LOGIN [hangtime] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [hangtime]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [hangtime]
GO
/****** Object:  Schema [API]    Script Date: 6/13/2018 10:22:38 AM ******/
CREATE SCHEMA [API]
GO
/****** Object:  UserDefinedFunction [API].[GET.ProximateGames]    Script Date: 6/13/2018 10:22:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE FUNCTION [API].[GET.ProximateGames]
(	
	@ActivityCode VARCHAR(255),
	@Latitude REAL,
	@Longitude REAL,
	@Distance REAL = 16000,	-- 16000m ~= 10mi
	@Tags VARCHAR(255) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		COALESCE(gd.Title, a.Label) AS Title,
		gd.[Description],
		a.Label,
		gd.Tags,
		g.Location.Lat AS Latitude,
		g.Location.Long AS Longitude,
		CAST(GEOGRAPHY::Point(@Latitude, @Longitude, 4326).STDistance(g.Location) * 0.000621371 AS DECIMAL(10,1))AS DistanceMiles,
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

		u.Username AS HostUsername,

		p.Name AS Place,
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
		CROSS APPLY Hangtime.GetActivity(@ActivityCode, 1, 1) ga
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
			g.DeactivatedDateTimeUTC IS NULL
			AND CASE
					WHEN DATEDIFF(MINUTE, g.LastCheckinDateTimeUTC, SYSUTCDATETIME()) >= 240 THEN 0
					WHEN g.EndDateTimeUTC IS NULL THEN 1
					WHEN DATEDIFF(SECOND, g.EndDateTimeUTC, SYSUTCDATETIME()) < 0 THEN 1
					ELSE 0
				END = 1
		)
		AND GEOGRAPHY::Point(@Latitude, @Longitude, 4326).STDistance(g.Location) <= @Distance
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
/****** Object:  UserDefinedFunction [API].[GET.UserBasic]    Script Date: 6/13/2018 10:22:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE FUNCTION [API].[GET.UserBasic]
(	
	@Input VARCHAR(255),
	@InputType INT = 1
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		u.Username,

		ud.FirstName,
		ud.LastName,
		u.Email,

		u.LastLoginDateTimeUTC,

		u.UUID AS UserUUID
	FROM
		Hangtime.[User] u WITH (NOLOCK)
		LEFT JOIN Hangtime.UserDetail ud WITH (NOLOCK)
			ON u.UserID = ud.UserID
	WHERE
		u.DeactivatedDateTimeUTC IS NULL
		AND ud.DeactivatedDateTimeUTC IS NULL
		AND (
			(
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
		)
)




GO
/****** Object:  UserDefinedFunction [API].[GET.UserExtended]    Script Date: 6/13/2018 10:22:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE FUNCTION [API].[GET.UserExtended]
(	
	@Input VARCHAR(255),
	@InputType INT = 1
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		u.Username,

		ud.FirstName,
		ud.LastName,
		u.Email,

		ud.Facebook,
		ud.Twitter,
		ud.Instagram,
		ud.Snapchat,

		ud.HomeLocation.Lat AS HomeLatitude,
		ud.HomeLocation.Long AS HomeLongitude,
		ud.CurrentLocation.Lat AS Latitude,
		ud.CurrentLocation.Long AS Longitude,
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
		u.DeactivatedDateTimeUTC IS NULL
		AND ud.DeactivatedDateTimeUTC IS NULL
		AND (
			(
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
		)
)




GO
/****** Object:  StoredProcedure [API].[POST.MergeGame]    Script Date: 6/13/2018 10:22:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE PROCEDURE [API].[POST.MergeGame]
	@HostUUID UNIQUEIDENTIFIER,
	@ActivityCode VARCHAR(255),
	@Latitude REAL,
	@Longitude REAL,
	@StartDateTimeUTC DATETIME2(3) = NULL,
	@EndDateTimeUTC DATETIME2(3) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ActivityID INT = (SELECT ActivityID FROM Hangtime.GetActivity(@ActivityCode, 1, 1));
	DECLARE @UserID INT = (SELECT UserID FROM Hangtime.GetUser(@HostUUID, 3, 1));
	DECLARE @Location GEOGRAPHY = GEOGRAPHY::Point(@Latitude, @Longitude , 4326);

	IF @ActivityID IS NOT NULL AND @Location IS NOT NULL
		BEGIN
			MERGE INTO Hangtime.Game t
			USING (
				SELECT
					@UserID AS UserID,
					@ActivityID AS ActivityID,
					@Location AS Location,
					COALESCE(@StartDateTimeUTC, SYSUTCDATETIME()) AS StartDateTimeUTC,
					COALESCE(@EndDateTimeUTC, DATEADD(HOUR, 1, SYSUTCDATETIME())) AS EndDateTimeUTC
			) s
				ON t.HostUserID = s.UserID
			WHEN MATCHED THEN UPDATE
				SET ActivityID = s.ActivityID,
					Location = s.Location,
					StartDateTimeUTC = s.StartDateTimeUTC,
					EndDateTimeUTC = s.EndDateTimeUTC
			WHEN NOT MATCHED THEN INSERT (
					ActivityID,
					HostUserID,
					Location,
					StartDateTimeUTC,
					EndDateTimeUTC
				)
				VALUES (
					s.ActivityID,
					s.UserID,
					s.Location,
					s.StartDateTimeUTC,
					s.EndDateTimeUTC
				)
			OUTPUT
				Inserted.UUID,
				Inserted.Location.Lat AS Latitude,
				Inserted.Location.Long AS Longitude,
				Inserted.StartDateTimeUTC,
				Inserted.EndDateTimeUTC;
		END
END






GO
/****** Object:  StoredProcedure [API].[POST.NewGame]    Script Date: 6/13/2018 10:22:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE PROCEDURE [API].[POST.NewGame]
	@ActivityCode VARCHAR(255),
	@Latitude REAL,
	@Longitude REAL,
	@StartDateTimeUTC DATETIME2(3) = NULL,
	@EndDateTimeUTC DATETIME2(3) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ActivityID INT = (SELECT ActivityID FROM Hangtime.GetActivity(@ActivityCode, 1, 1));
	DECLARE @Location GEOGRAPHY = GEOGRAPHY::Point(@Latitude, @Longitude , 4326);

	IF @ActivityID IS NOT NULL AND @Location IS NOT NULL
		BEGIN
			INSERT INTO Hangtime.Game (ActivityID, Location, StartDateTimeUTC, EndDateTimeUTC)
			OUTPUT
				Inserted.UUID,
				Inserted.Location.Lat AS Latitude,
				Inserted.Location.Long AS Longitude,
				Inserted.StartDateTimeUTC,
				Inserted.EndDateTimeUTC
			SELECT
				@ActivityID,
				@Location,
				COALESCE(@StartDateTimeUTC, SYSUTCDATETIME()),
				COALESCE(@EndDateTimeUTC, DATEADD(HOUR, 1, SYSUTCDATETIME()))
		END
	ELSE
		BEGIN
			SELECT
				NULL AS UUID,
				NULL AS Location
		END
END





GO
/****** Object:  StoredProcedure [API].[POST.NewUser]    Script Date: 6/13/2018 10:22:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE PROCEDURE [API].[POST.NewUser]
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
