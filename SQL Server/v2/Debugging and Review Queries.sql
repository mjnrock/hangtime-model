--	---------------------
--		RESPONSES
--	---------------------
IF OBJECT_ID('tempdb..#Responses') IS NOT NULL DROP TABLE tempdb..#Responses;
SELECT
	c.CategoryID, c.Code AS CategoryCode, c.Label AS CategoryLabel, c.[Description] AS CategoryDescription,
	t.TypeID, t.CategoryID AS TypeCategoryID, t.Code AS TypeCode, t.Label AS TypeLabel, t.[Description] AS TypeDescription,
	v.ValueID, v.TypeID AS ValueType, v.Label AS ValueLabel, v.TextValue AS ValueTextValue, v.NumericValue AS ValueNumericValue, v.Ordinality AS ValueOrdinality, v.IsCorrect AS ValueIsCorrect
INTO #Responses
FROM
	Hangtime.[Response.Category] c
	INNER JOIN Hangtime.[Response.Type] t
		ON c.CategoryID = t.CategoryID
	INNER JOIN Hangtime.[Response.Value] v
		ON t.TypeID = v.TypeID

--	---------------------
--		PROFILES
--	---------------------
IF OBJECT_ID('tempdb..#Profiles') IS NOT NULL DROP TABLE tempdb..#Profiles;
SELECT
	p.ProfileID, p.Title AS ProfileTitle, p.[Description] AS ProfileDescription,
	s.SectionID, s.ProfileID AS SectionProfileID, s.Header AS SectionHeader, s.SubHeader AS SectionSubHeader, s.[Description] AS SectionDescription, s.Ordinality AS SectionOrdinality,
	i.ItemID, i.SectionID AS ItemSectionID, i.ResponseTypeID AS ItemResponseTypeID, i.Label AS ItemLabel, i.Ordinality AS ItemOrdinality
INTO #Profiles
FROM
	Hangtime.[Profile] p
	INNER JOIN Hangtime.[Profile.Section] s
		ON p.ProfileID = s.ProfileID
	INNER JOIN Hangtime.[Profile.Item] i
		ON s.SectionID = i.SectionID

--	---------------------
--		PROMPTS
--	---------------------
IF OBJECT_ID('tempdb..#Prompts') IS NOT NULL DROP TABLE tempdb..#Prompts;
SELECT
	p.PromptID, p.Title AS PromptTitle, p.[Description] AS PromptDescription,
	s.SectionID, s.PromptID AS SectionPromptID, s.Header AS SectionHeader, s.SubHeader AS SectionSubHeader, s.[Description] AS SectionDescription, s.Ordinality AS SectionOrdinality,
	q.QuestionID, q.SectionID AS QuestionSectionID, q.ResponseTypeID AS QuestionResponseTypeID, q.[Text] AS QuestionText, q.Ordinality AS QuestionOrdinality
INTO #Prompts
FROM
	Hangtime.[Prompt] p
	INNER JOIN Hangtime.[Prompt.Section] s
		ON p.PromptID = s.PromptID
	INNER JOIN Hangtime.[Prompt.Question] q
		ON s.SectionID = q.SectionID
		
		
--	==============================================
--		QUERIES
--	==============================================
SELECT * FROM #Responses;
SELECT * FROM #Profiles;
SELECT * FROM #Prompts;