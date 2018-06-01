USE [Hangtime]
GO
/****** Object:  Schema [Hangtime]    Script Date: 5/31/2018 10:44:52 PM ******/
CREATE SCHEMA [Hangtime]
GO
/****** Object:  Table [Hangtime].[Activity]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[Activity](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](5) NOT NULL,
	[Label] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
	[UUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[Game]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hangtime].[Game](
	[GameID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityID] [int] NOT NULL,
	[Location] [geography] NOT NULL,
	[LastCheckinDateTimeUTC] [datetime2](3) NULL DEFAULT (sysutcdatetime()),
	[StartDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[EndDateTimeUTC] [datetime2](3) NULL,
	[UUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [Hangtime].[GameDetail]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[GameDetail](
	[GameDetailID] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [int] NOT NULL,
	[HostUserID] [int] NOT NULL,
	[PlaceID] [int] NULL,
	[Title] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[Tags] [varchar](255) NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL,
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL,
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[GameDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[Place]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[Place](
	[PlaceID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[Description] [varchar](max) NULL,
	[Address1] [varchar](255) NULL,
	[Address2] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[State] [varchar](2) NULL,
	[Zip5] [varchar](5) NULL,
	[Country] [varchar](255) NULL,
	[Location] [geography] NULL,
	[Perimeter] [geometry] NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL,
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL,
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[PlaceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[Rating]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[Rating](
	[RatingID] [int] IDENTITY(1,1) NOT NULL,
	[RatingSetID] [int] NOT NULL,
	[Code] [varchar](5) NOT NULL,
	[Label] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
	[TextValue] [varchar](255) NOT NULL,
	[NumericValue] [real] NOT NULL,
	[Ordinality] [int] NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL,
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL,
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[RatingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[RatingSet]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[RatingSet](
	[RatingSetID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](5) NOT NULL,
	[Label] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL,
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL,
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[RatingSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[RatingType]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[RatingType](
	[RatingTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](5) NOT NULL,
	[Label] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
	[UUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[RatingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[User]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](255) NOT NULL,
	[Quad]  AS (right(concat('0000',floor((9999)*rand(checksum(newid())))),(4))),
	[Password] [varchar](255) NOT NULL,
	[Email] [varchar](255) NULL,
	[LastLoginDateTimeUTC] [datetime2](3) NULL DEFAULT (sysutcdatetime()),
	[UUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[UserDetail]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[UserDetail](
	[UserDetailID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[FirstName] [varchar](255) NULL,
	[LastName] [varchar](255) NULL,
	[HomeLocation] [geography] NULL,
	[CurrentLocation] [geography] NULL,
	[CurrentLocationDateTimeUTC] [datetime2](3) NULL,
	[UTCOffset] [tinyint] NULL,
	[Facebook] [varchar](255) NULL,
	[Twitter] [varchar](255) NULL,
	[Instagram] [varchar](255) NULL,
	[Snapchat] [varchar](255) NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL,
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL,
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[UserRating]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[UserRating](
	[UserRating] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RatingTypeID] [int] NOT NULL,
	[FKID] [int] NOT NULL,
	[RatingID] [int] NOT NULL,
	[Comment] [varchar](255) NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL,
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL,
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserRating] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [Hangtime].[Explode]    Script Date: 5/31/2018 10:44:52 PM ******/
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
/****** Object:  UserDefinedFunction [Hangtime].[GetActivity]    Script Date: 5/31/2018 10:44:52 PM ******/
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
				AND a.Code = CAST(@Input AS VARCHAR(5))
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
/****** Object:  UserDefinedFunction [Hangtime].[GetProximateGames]    Script Date: 5/31/2018 10:44:52 PM ******/
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
			ON gd.HostUserID = u.UserID
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
/****** Object:  UserDefinedFunction [Hangtime].[GetGame]    Script Date: 5/31/2018 10:44:52 PM ******/
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
			ON gd.HostUserID = u.UserID
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
/****** Object:  UserDefinedFunction [Hangtime].[GetUser]    Script Date: 5/31/2018 10:44:52 PM ******/
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
				AND ud.UserDetailID = CAST(@Input AS INT)
			)
			OR (
				@InputType = 5
				AND CAST(ud.UUID AS VARCHAR(255)) = @Input
			)
		)
)


GO
ALTER TABLE [Hangtime].[GameDetail] ADD  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [Hangtime].[GameDetail] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[GameDetail] ADD  DEFAULT (sysutcdatetime()) FOR [ModifiedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[Place] ADD  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [Hangtime].[Place] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[Place] ADD  DEFAULT (sysutcdatetime()) FOR [ModifiedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[Rating] ADD  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [Hangtime].[Rating] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[Rating] ADD  DEFAULT (sysutcdatetime()) FOR [ModifiedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[RatingSet] ADD  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [Hangtime].[RatingSet] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[RatingSet] ADD  DEFAULT (sysutcdatetime()) FOR [ModifiedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[UserDetail] ADD  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [Hangtime].[UserDetail] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[UserDetail] ADD  DEFAULT (sysutcdatetime()) FOR [ModifiedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[UserRating] ADD  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [Hangtime].[UserRating] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[UserRating] ADD  DEFAULT (sysutcdatetime()) FOR [ModifiedDateTimeUTC]
GO
ALTER TABLE [Hangtime].[Game]  WITH CHECK ADD FOREIGN KEY([ActivityID])
REFERENCES [Hangtime].[Activity] ([ActivityID])
GO
ALTER TABLE [Hangtime].[GameDetail]  WITH CHECK ADD FOREIGN KEY([GameID])
REFERENCES [Hangtime].[Game] ([GameID])
GO
ALTER TABLE [Hangtime].[GameDetail]  WITH CHECK ADD FOREIGN KEY([HostUserID])
REFERENCES [Hangtime].[User] ([UserID])
GO
ALTER TABLE [Hangtime].[GameDetail]  WITH CHECK ADD FOREIGN KEY([PlaceID])
REFERENCES [Hangtime].[Place] ([PlaceID])
GO
ALTER TABLE [Hangtime].[Rating]  WITH CHECK ADD FOREIGN KEY([RatingSetID])
REFERENCES [Hangtime].[RatingSet] ([RatingSetID])
GO
ALTER TABLE [Hangtime].[UserDetail]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [Hangtime].[User] ([UserID])
GO
ALTER TABLE [Hangtime].[UserRating]  WITH CHECK ADD FOREIGN KEY([RatingTypeID])
REFERENCES [Hangtime].[RatingType] ([RatingTypeID])
GO
ALTER TABLE [Hangtime].[UserRating]  WITH CHECK ADD FOREIGN KEY([RatingID])
REFERENCES [Hangtime].[Rating] ([RatingID])
GO
ALTER TABLE [Hangtime].[UserRating]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [Hangtime].[User] ([UserID])
GO
/****** Object:  StoredProcedure [Hangtime].[CreateGame]    Script Date: 5/31/2018 10:44:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Nawrocki
-- Create date: 2018-05-26
-- =============================================
CREATE PROCEDURE [Hangtime].[CreateGame]
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
/****** Object:  StoredProcedure [Hangtime].[CreateUser]    Script Date: 5/31/2018 10:44:52 PM ******/
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
