/* This do-file is to check out the number of problematic records */
/* in the CANS, FAST, and ASQ (and also FES) */

/* do-file first lists the individual table results */
/* then lists the Union All */
/* where the order by commands have been removed */
/* and the which dataset column added */

/* to run the union all */
/* rather than a "with" */
/* will number all the data tables */
/* used in the append */

/* Number and Dataset */
/* 1 ASQ */
/* 2 ASQ:SE */
/* 3 CANS */
/* 4 FAST: Child */
/* 5 FES: Baseline */
/* 6 FES: Faciltator */
/* 7 FES: Follow-Up */
/* 8 FES: Survey */

/* #1 */
/* CANS records without MCI */
/* checking by month submitted */


SELECT [COUNTY_ID], year(cast([Date] as datetime)) as YearSubmitted, month(cast([Date] as datetime)) as MonthSubmitted
      ,count([Row]) as NoforCANS
  FROM [Demo_Processing].[dbo].[CANS_Screen]
 (	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' ) 
 group by [COUNTY_ID], year(cast([Date] as datetime)), month(cast([Date] as datetime)) 
 order by [COUNTY_ID], year(cast([Date] as datetime)), month(cast([Date] as datetime)) 
 
 
/* #2 */ 
/* FAST */

SELECT CountyNum as COUNTY_ID, YearSubmitted, MonthSubmitted, count(ConcattedMCI) as NoforFAST 
from
(
/* uses county number and a concatenated MCI number from the Child Functioning table */
SELECT tbl_child.[COUNTY_ID] as CountyNum, 
		CAST(CONCAT(ltrim(rtrim([child_a_mci])), 
				ltrim(rtrim([child_B_mci])), 
				ltrim(rtrim([child_c_mci])), 
				ltrim(rtrim([child_D_mci])), 
				ltrim(rtrim([child_E_mci])), 
				ltrim(rtrim([child_f_mci])), 
				ltrim(rtrim([child_G_mci])), 
				ltrim(rtrim([child_H_mci])), 
				ltrim(rtrim([child_I_mci])), 
				ltrim(rtrim([child_J_mci]))) AS nvarchar(max))
						as ConcattedMCI,
						/* pulling in the date from the Family Together table */
						/* uses the submission date, not the assessment date */
		year(cast(tbl_child.[DATE] as datetime)) as YearSubmitted,   
		month(cast(tbl_child.[DATE] as datetime)) as MonthSubmitted   
 from [Demo_Processing].[dbo].[FAST_CHILD_Screen] as tbl_child
  /* the join to the Family Together table */
   LEFT JOIN 
      [Demo_Processing].[dbo].[FAST_Family_Screen] AS tbl_family
  ON tbl_family.[ASMT_ID]=tbl_child.[ASMT_ID] AND
		tbl_family.[FAMILY_ID]=tbl_child.[FAMILY_ID] and 
		tbl_family.[COUNTY_ID]=tbl_child.[COUNTY_ID] and 
		tbl_family.[DATE]=tbl_child.[DATE]
 ) as TableLayer1
 where
 /* the concatenated MCI does not have */
 /* a string of at least eight numbers */
 ConcattedMCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
 /* group by the county code to get a total number for the county */
 group by CountyNum, YearSubmitted, MonthSubmitted
 /* sort by the county code */
 order by CountyNum, YearSubmitted, MonthSubmitted

 
 
 /* #3 */
 /* ASQ */
 /* FOR COUNT of records with missing MCI's */
 
 /* UNION ALL */
 /* DOES NOT remove duplicates */
 
 /* results from import table */
 /* and then results from local table */

 /* removed the ordering clause from the command  */
 /* was getting errors from the server about it */
 
 (SELECT  [CountyID], Year(cast([SubmittedDate] as datetime)) as YearSubmitted,
	month(cast([SubmittedDate] as datetime)) as MonthSubmitted
      , count([SubmittedDate]) as NoforASQ
  FROM [Demo_Processing].[dbo].[ASQ_Import]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
		AND ASQScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
	)
/* ending of code for import results */
/* THE union all is coming */
UNION  ALL	
/* THE union all is finished */
/* ending of code for local results */	
(	SELECT  [CountyID], Year(cast([SubmittedDate] as datetime)) as YearSubmitted,
	month(cast([SubmittedDate] as datetime)) as MonthSubmitted
      , count([SubmittedDate]) as NoforASQ
  FROM [Demo_Processing].[dbo].[ASQ_Local]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
		AND ASQScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
)




 /* #4 */
 /* ASQ:SE */
 /* FOR COUNT of records with missing MCI's */
 
 /* UNION ALL */
 /* DOES NOT remove duplicates */
 
 /* results from import table */
 /* and then results from local table */

 /* removed the ordering clause from the command  */
 /* was getting errors from the server about it */
 
 (SELECT  [CountyID], Year(cast([SubmittedDate] as datetime)) as YearSubmitted,
	month(cast([SubmittedDate] as datetime)) as MonthSubmitted
      , count([SubmittedDate]) as NoforASQSE
  FROM [Demo_Processing].[dbo].[ASQ_Import]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
	AND ASQSEScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
	)
/* ending of code for import results */
/* THE union all is coming */
UNION  ALL	
/* THE union all is finished */
/* ending of code for local results */	
(	SELECT  [CountyID], Year(cast([SubmittedDate] as datetime)) as YearSubmitted,
	month(cast([SubmittedDate] as datetime)) as MonthSubmitted
      , count([SubmittedDate]) as NoforASQSE
  FROM [Demo_Processing].[dbo].[ASQ_Local]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
		AND ASQSEScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
)

********************.
/* Hopefully all the FES counts */
/* are redundant and there are not any */
/* records that are missing MCI's */
/* #5 */
/* Baseline */

SELECT [CountyCode], 
	Year(cast([Family_Conference_Date] as datetime)) as YearSubmitted,
	month(cast([Family_Conference_Date] as datetime)) as MonthSubmitted,
      count([Family_Conference_Date]) as NoforFESBL
  FROM [FGDM].[dbo].[Baseline] 
where 	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by CountyCode, Year(cast([Family_Conference_Date] as datetime)), 
	month(cast([Family_Conference_Date] as datetime))
 order by CountyCode, Year(cast([Family_Conference_Date] as datetime)), 
	month(cast([Family_Conference_Date] as datetime))



/* #6 */
/* [Facilitator] */
SELECT [CountyCode], 
	Year(cast([Mtg_Dt] as datetime)) as YearSubmitted,
	month(cast([Mtg_Dt] as datetime)) as MonthSubmitted,
      count([Mtg_Dt]) as NoforFESFFS
  FROM [FGDM].[dbo].[Facilitator]
where 	Childs_MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by CountyCode, Year(cast([Mtg_Dt] as datetime)), 
	month(cast([Mtg_Dt] as datetime))
 order by CountyCode, Year(cast([Mtg_Dt] as datetime)), 
	month(cast([Mtg_Dt] as datetime))


/* #7 */	
/* [FE_Survey] */
SELECT [CountyCode], 
	Year(cast([Conf_Date] as datetime)) as YearSubmitted,
	month(cast([Conf_Date] as datetime)) as MonthSubmitted,
      count([Conf_Date]) as NoforFESSurvey
  FROM [FGDM].[dbo].[FE_Survey]
where 	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by CountyCode, Year(cast([Conf_Date] as datetime)), 
	month(cast([Conf_Date] as datetime))
 order by CountyCode, Year(cast([Conf_Date] as datetime)), 
	month(cast([Conf_Date] as datetime))

	
/* #8 */	
/* [Outcome] */
SELECT [County_Code], 
	Year(cast([Family_Conference_Date] as datetime)) as YearSubmitted,
	month(cast([Family_Conference_Date] as datetime)) as MonthSubmitted,
      count([Family_Conference_Date]) as NoforFESFL
  FROM [FGDM].[dbo].[Outcome]
where 	Childs_MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by County_Code, Year(cast([Family_Conference_Date] as datetime)), 
	month(cast([Family_Conference_Date] as datetime))
 order by County_Code, Year(cast([Family_Conference_Date] as datetime)), 
	month(cast([Family_Conference_Date] as datetime))
	
	
	
	
	
	
	
	
	
	
/* for the combined version */	
	
	
	
	
/* Combined version of the table */	
/* CANS */	
/* for the combined version */	
	
SELECT [COUNTY_ID], year(cast([Date] as datetime)) as SubYear, month(cast([Date] as datetime)) as SubMonth
      ,count([Row]) as NoforCANS, 3 AS WhichDataset
  FROM [Demo_Processing].[dbo].[CANS_Screen]
  where 
  /* what gets included as a record missing MCI */
 (	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' ) 
 group by [COUNTY_ID], year(cast([Date] as datetime)), month(cast([Date] as datetime)) 

 /* the union all ! */
union all 
 
/* #2 */ 
/* FAST */
/* for the combined version */	

SELECT CountyNum as COUNTY_ID, SubYear, SubMonth, count(ConcattedMCI) as NoforFAST, 4 AS WhichDataset 
from
(
/* uses county number and a concatenated MCI number from the Child Functioning table */
SELECT tbl_child.[COUNTY_ID] as CountyNum, 
		CAST(CONCAT(ltrim(rtrim([child_a_mci])), 
				ltrim(rtrim([child_B_mci])), 
				ltrim(rtrim([child_c_mci])), 
				ltrim(rtrim([child_D_mci])), 
				ltrim(rtrim([child_E_mci])), 
				ltrim(rtrim([child_f_mci])), 
				ltrim(rtrim([child_G_mci])), 
				ltrim(rtrim([child_H_mci])), 
				ltrim(rtrim([child_I_mci])), 
				ltrim(rtrim([child_J_mci]))) AS nvarchar(max))
						as ConcattedMCI,
						/* pulling in the date from the Family Together table */
						/* uses the submission date, not the assessment date */
		year(cast(tbl_child.[DATE] as datetime)) as SubYear,   
		month(cast(tbl_child.[DATE] as datetime)) as SubMonth   
 from [Demo_Processing].[dbo].[FAST_CHILD_Screen] as tbl_child
  /* the join to the Family Together table */
   LEFT JOIN 
      [Demo_Processing].[dbo].[FAST_Family_Screen] AS tbl_family
  ON tbl_family.[ASMT_ID]=tbl_child.[ASMT_ID] AND
		tbl_family.[FAMILY_ID]=tbl_child.[FAMILY_ID] and 
		tbl_family.[COUNTY_ID]=tbl_child.[COUNTY_ID] and 
		tbl_family.[DATE]=tbl_child.[DATE]
 ) as TableLayer1
 where
 /* the concatenated MCI does not have */
 /* a string of at least eight numbers */
 ConcattedMCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
 /* group by the county code to get a total number for the county */
 group by CountyNum, SubYear, SubMonth
 /* sort by the county code */


 /* the union all ! */
union all 
 
 
 
 /* #3 */
/* for the combined version */	
 /* ASQ */
 /* FOR COUNT of records with missing MCI's */
 
 /* UNION ALL */
 /* DOES NOT remove duplicates */
 
 /* results from import table */
 /* and then results from local table */

 /* removed the ordering clause from the command  */
 /* was getting errors from the server about it */
 
 (SELECT  [CountyID] as COUNTY_ID, Year(cast([SubmittedDate] as datetime)) as SubYear,
	month(cast([SubmittedDate] as datetime)) as SubMonth
      , count([SubmittedDate]) as NoforASQ, 1 AS WhichDataset
  FROM [Demo_Processing].[dbo].[ASQ_Import]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
		AND ASQScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
	)
/* ending of code for import results */
/* THE union all is coming */
UNION  ALL	
/* THE union all is finished */
/* ending of code for local results */	
(	SELECT  [CountyID] as COUNTY_ID, Year(cast([SubmittedDate] as datetime)) as SubYear,
	month(cast([SubmittedDate] as datetime)) as SubMonth
      , count([SubmittedDate]) as NoforASQ, 1 AS WhichDataset
  FROM [Demo_Processing].[dbo].[ASQ_Local]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
		AND ASQScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
)


 /* the union all ! */
union all 
 



 /* #4 */
/* for the combined version */	
 /* ASQ:SE */
 /* FOR COUNT of records with missing MCI's */
 
 /* UNION ALL */
 /* DOES NOT remove duplicates */
 
 /* results from import table */
 /* and then results from local table */

 /* removed the ordering clause from the command  */
 /* was getting errors from the server about it */
 
 (SELECT  [CountyID] as COUNTY_ID, Year(cast([SubmittedDate] as datetime)) as SubYear,
	month(cast([SubmittedDate] as datetime)) as SubMonth
      , count([SubmittedDate]) as NoforASQSE, 2 AS WhichDataset
  FROM [Demo_Processing].[dbo].[ASQ_Import]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
	AND ASQSEScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
	)
/* ending of code for import results */
/* THE union all is coming */
UNION  ALL	
/* THE union all is finished */
/* ending of code for local results */	
(	SELECT  [CountyID] as COUNTY_ID, Year(cast([SubmittedDate] as datetime)) as SubYear,
	month(cast([SubmittedDate] as datetime)) as SubMonth
      , count([SubmittedDate]) as NoforASQSE, 2 AS WhichDataset
  FROM [Demo_Processing].[dbo].[ASQ_Local]
    where 
	/* MCI is not at least a sequence of eight numbers */
	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
		AND ASQSEScreeningDate is NOT NULL
group by countyid, Year(cast([SubmittedDate] as datetime)), 
	month(cast([SubmittedDate] as datetime))
)


 /* the union all ! */
union all 
 

--******************.
/* Hopefully all the FES counts */
/* are redundant and there are not any */
/* records that are missing MCI's */
/* #5 */
/* for the combined version */	
/* Baseline */

SELECT [CountyCode] as COUNTY_ID, 
	Year(cast([Family_Conference_Date] as datetime)) as SubYear,
	month(cast([Family_Conference_Date] as datetime)) as SubMonth,
      count([Family_Conference_Date]) as NoforFESBL, 5 AS WhichDataset
  FROM [FGDM].[dbo].[Baseline] 
where 	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by CountyCode, Year(cast([Family_Conference_Date] as datetime)), 
	month(cast([Family_Conference_Date] as datetime))


 /* the union all ! */
union all 
 


/* #6 */
/* for the combined version */	
/* [Facilitator] */
SELECT [CountyCode] as COUNTY_ID, 
	Year(cast([Mtg_Dt] as datetime)) as SubYear,
	month(cast([Mtg_Dt] as datetime)) as SubMonth,
      count([Mtg_Dt]) as NoforFESFFS, 6 AS WhichDataset
  FROM [FGDM].[dbo].[Facilitator]
where 	Childs_MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by CountyCode, Year(cast([Mtg_Dt] as datetime)), 
	month(cast([Mtg_Dt] as datetime))

	
 /* the union all ! */
union all 
 


/* #7 */	
/* for the combined version */	
/* [FE_Survey] */
SELECT [CountyCode] as COUNTY_ID, 
	Year(cast([Conf_Date] as datetime)) as SubYear,
	month(cast([Conf_Date] as datetime)) as SubMonth,
      count([Conf_Date]) as NoforFESSurvey, 8 AS WhichDataset
  FROM [FGDM].[dbo].[FE_Survey]
where 	MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by CountyCode, Year(cast([Conf_Date] as datetime)), 
	month(cast([Conf_Date] as datetime))

	
 /* the union all ! */
union all 
 

	
/* #8 */	
/* for the combined version */	
/* [Outcome] */
SELECT [County_Code] as COUNTY_ID, 
	Year(cast([Family_Conference_Date] as datetime)) as SubYear,
	month(cast([Family_Conference_Date] as datetime)) as SubMonth,
      count([Family_Conference_Date]) as NoforFESFL, 7 AS WhichDataset
  FROM [FGDM].[dbo].[Outcome]
where 	Childs_MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
group by County_Code, Year(cast([Family_Conference_Date] as datetime)), 
	month(cast([Family_Conference_Date] as datetime))
