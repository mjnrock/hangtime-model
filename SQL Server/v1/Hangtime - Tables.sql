USE [Hangtime]
GO
/****** Object:  Schema [Hangtime]    Script Date: 6/13/2018 10:23:18 AM ******/
CREATE SCHEMA [Hangtime]
GO
/****** Object:  Table [Hangtime].[Activity]    Script Date: 6/13/2018 10:23:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[Activity](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](255) NOT NULL,
	[Label] [varchar](255) NOT NULL,
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
/****** Object:  Table [Hangtime].[Game]    Script Date: 6/13/2018 10:23:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hangtime].[Game](
	[GameID] [int] IDENTITY(1,1) NOT NULL,
	[HostUserID] [int] NULL,
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
/****** Object:  Table [Hangtime].[GameDetail]    Script Date: 6/13/2018 10:23:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[GameDetail](
	[GameDetailID] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [int] NOT NULL,
	[PlaceID] [int] NULL,
	[Title] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[Tags] [varchar](255) NULL,
	[UUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[ModifiedDateTimeUTC] [datetime2](3) NOT NULL DEFAULT (sysutcdatetime()),
	[DeactivatedDateTimeUTC] [datetime2](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[GameDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Hangtime].[Place]    Script Date: 6/13/2018 10:23:18 AM ******/
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
	[State] [varchar](255) NULL,
	[Zip5] [varchar](255) NULL,
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
/****** Object:  Table [Hangtime].[Rating]    Script Date: 6/13/2018 10:23:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[Rating](
	[RatingID] [int] IDENTITY(1,1) NOT NULL,
	[RatingSetID] [int] NOT NULL,
	[Code] [varchar](255) NOT NULL,
	[Label] [varchar](255) NOT NULL,
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
/****** Object:  Table [Hangtime].[RatingSet]    Script Date: 6/13/2018 10:23:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[RatingSet](
	[RatingSetID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](255) NOT NULL,
	[Label] [varchar](255) NOT NULL,
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
/****** Object:  Table [Hangtime].[RatingType]    Script Date: 6/13/2018 10:23:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[RatingType](
	[RatingTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](255) NOT NULL,
	[Label] [varchar](255) NOT NULL,
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
/****** Object:  Table [Hangtime].[User]    Script Date: 6/13/2018 10:23:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Hangtime].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](255) NOT NULL,
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
/****** Object:  Table [Hangtime].[UserDetail]    Script Date: 6/13/2018 10:23:18 AM ******/
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
/****** Object:  Table [Hangtime].[UserRating]    Script Date: 6/13/2018 10:23:18 AM ******/
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
ALTER TABLE [Hangtime].[Game]  WITH CHECK ADD FOREIGN KEY([HostUserID])
REFERENCES [Hangtime].[User] ([UserID])
GO
ALTER TABLE [Hangtime].[GameDetail]  WITH CHECK ADD FOREIGN KEY([GameID])
REFERENCES [Hangtime].[Game] ([GameID])
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
