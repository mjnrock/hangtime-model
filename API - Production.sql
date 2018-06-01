USE [Hangtime]
GO
/****** Object:  Schema [API]    Script Date: 5/31/2018 10:44:17 PM ******/
CREATE SCHEMA [API]
GO
/****** Object:  UserDefinedFunction [API].[GET.ProximateGames]    Script Date: 5/31/2018 10:44:17 PM ******/
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
	@ActivityUUID UNIQUEIDENTIFIER,
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
		gd.Title,
		gd.[Description],
		gd.Tags,
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
		CROSS APPLY Hangtime.GetActivity(@ActivityUUID, 3, 1) ga
		INNER JOIN Hangtime.Activity a WITH (NOLOCK)
			ON g.ActivityID = a.ActivityID
		LEFT JOIN Hangtime.GameDetail gd WITH (NOLOCK)
			ON g.GameID = gd.GameID
		LEFT JOIN Hangtime.[User] u WITH (NOLOCK)
			ON gd.HostUserID = u.UserID
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
/****** Object:  UserDefinedFunction [API].[GET.UserBasic]    Script Date: 5/31/2018 10:44:17 PM ******/
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
/****** Object:  UserDefinedFunction [API].[GET.UserExtended]    Script Date: 5/31/2018 10:44:17 PM ******/
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
		u.Quad,

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
/****** Object:  StoredProcedure [API].[POST.NewGame]    Script Date: 5/31/2018 10:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE PROCEDURE [API].[POST.NewGame]
	@ActivityUUID UNIQUEIDENTIFIER,
	@Latitude REAL,
	@Longitude REAL,
	@StartDateTimeUTC DATETIME2(3) = NULL,
	@EndDateTimeUTC DATETIME2(3) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ActivityID INT = (SELECT ActivityID FROM Hangtime.GetActivity(@ActivityUUID, 3, 1));
	DECLARE @Location GEOGRAPHY = GEOGRAPHY::Point(@Latitude, @Longitude , 4326);

	IF @ActivityID IS NOT NULL AND @Location IS NOT NULL
		BEGIN
			INSERT INTO Hangtime.Game (ActivityID, Location, StartDateTimeUTC, EndDateTimeUTC)
			OUTPUT
				Inserted.UUID,
				Inserted.Location.Lat AS Latitude,
				Inserted.Location.Long AS Longitude,
				Inserted.StartDateTimeUTC
			SELECT
				@ActivityID,
				@Location,
				COALESCE(@StartDateTimeUTC, SYSUTCDATETIME()),
				@EndDateTimeUTC
		END
	ELSE
		BEGIN
			SELECT
				NULL AS UUID,
				NULL AS Location
		END
END



GO
/****** Object:  StoredProcedure [API].[POST.NewUser]    Script Date: 5/31/2018 10:44:17 PM ******/
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
