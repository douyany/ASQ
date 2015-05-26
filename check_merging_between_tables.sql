

/* creates "with" tables for the ASQ and ASQ:SE assessment results */
/* #1--merges ASQ and ASQ:SE together using MCI and row number */
/* #2--merge results of #1 with ASQ Child demographics using MCI */
/* has pushed the first merge into the WITH statement */
/* rather than after the with statement closes */

/* for merge with raw db tables, will use ChildID rather than MCI and the fields here */


						
						
/* tried creating list of ChildID's but the list didn't help */
/* in the full outer join, that row, */
/* in not having a row number */
/* gets preserved as a demographic info row */
/* but without any assessment information */						
						
						
						
	With
	/* listing of ASQ results */
	/* possibly multiple per person */
ASQinfo (ChildCaseNo, MCI, CountyID, ASQScreeningDate, 				  /* fields from ASQ asmt */
	ASQScreeningTool, ASQScreeningAdministrator, ASQConcernTypes, 
	DS_communication, DS_FineMotor, DS_GrossMotor, DS_PersonalSocial, 
	DS_ProblemSolving, ASQEarlyInterventionReferralDate, dateASQ,
	RowASQ) 
	as  (
		SELECT *, ROW_NUMBER() 
        OVER (partition by CountyID, ChildCaseNo, MCI ORDER BY ASQScreeningDate) AS RowASQ
    	from [Demo_Processing].[dbo].[ASQAllCounty]  /* ASQ Asmt table */
		)
		/* to only get assessment information submitted during a particular month, */
		/* can add restriction using timestamp of when changed */
		,
	/* listing of ASQ:SE results */
	/* possibly multiple per person */
		ASQSEinfo (ChildCaseNo, MCI, CountyID, ASQSEScreeningDate, ASQSEScreeningTool, 
	ASQSEScreeningAdministrator, ASQSEConcernTypes, DS_ASQSE,   /* fields from ASQ:SE asmt */
	ASQSEEarlyInterventionReferralDate, dateASQSE, RowASQSE)
	AS (
		SELECT *, 	ROW_NUMBER() 
        OVER (partition by CountyID, ChildCaseNo, MCI ORDER BY ASQSEScreeningDate) AS RowASQSE
		from [Demo_Processing].[dbo].[ASQSEAllCounty] )  /* ASQ:SE Asmt table */
		/* to only get assessment information submitted during a particular month, */
		/* can add restriction using timestamp of when changed */
		
		,
	/* combined listing of ASQ and ASQ:SE results */
	/* possibly multiple per person */
	/* full join */
		AsmtInfo (ChildCaseNo, MCI, CountyID, ASQScreeningDate, 
	ASQScreeningTool, ASQScreeningAdministrator, ASQConcernTypes,   /* fields from ASQ asmt */
	DS_communication, DS_FineMotor, DS_GrossMotor, DS_PersonalSocial, 
	DS_ProblemSolving, ASQEarlyInterventionReferralDate, dateASQ,
	RowASQ,
	ASQSEScreeningDate, ASQSEScreeningTool, 
	ASQSEScreeningAdministrator, ASQSEConcernTypes, DS_ASQSE, 		   /* fields from ASQ:SE asmt */
	ASQSEEarlyInterventionReferralDate, dateASQSE, RowASQSE)
	as (
		select ISNULL(ASQinfo.ChildCaseNo, ASQSEinfo.ChildCaseNo) as ChCaseNum, 
		ISNULL(ASQinfo.MCI, ASQSEinfo.MCI) as ChMCI,
		ISNULL(ASQinfo.CountyID, ASQSEinfo.CountyID) as ChCounty,
	ASQScreeningDate, 												  /* fields from ASQ asmt */
	ASQScreeningTool, ASQScreeningAdministrator, ASQConcernTypes, 
	DS_communication, DS_FineMotor, DS_GrossMotor, DS_PersonalSocial, 
	DS_ProblemSolving, ASQEarlyInterventionReferralDate, dateASQ,
	RowASQ, 
	ASQSEScreeningDate, ASQSEScreeningTool, 						   /* fields from ASQ:SE asmt */
	ASQSEScreeningAdministrator, ASQSEConcernTypes, DS_ASQSE, 
	ASQSEEarlyInterventionReferralDate, dateASQSE, RowASQSE 
	from ASQinfo full join ASQSEinfo on ASQinfo.MCI = ASQSEinfo.MCI and
							ASQinfo.ChildCaseNo = ASQSEinfo.ChildCaseNo and
							ASQinfo.CountyID = ASQSEinfo.CountyID and
										 ASQinfo.RowASQ = ASQSEinfo.RowASQSE)
			/* match assessment results to demog info about child */
			/* child will only have one set of demog info */
			/* no demo history is kept for the ChildID */
			/* left join of assessment results and demog info */
SELECT AsmtInfo.ChildCaseNo, AsmtInfo.MCI, AsmtInfo.CountyID, 			/* fields from Demog */
	DoB, GenderID, MostRecentCaseDate, RaceID, NICU, ReferredToCW, 
	ReportSubstantiated, MaltreatmentID, demo.date as dateChildTbl,
	ASQScreeningDate, 													  /* fields from ASQ asmt */
	ASQScreeningTool, ASQScreeningAdministrator, ASQConcernTypes, 
	DS_communication, DS_FineMotor, DS_GrossMotor, DS_PersonalSocial, 
	DS_ProblemSolving, ASQEarlyInterventionReferralDate, dateASQ, 
	RowASQ,
	ASQSEScreeningDate, ASQSEScreeningTool, 							   /* fields from ASQ:SE asmt */
	ASQSEScreeningAdministrator, ASQSEConcernTypes, DS_ASQSE, 
	ASQSEEarlyInterventionReferralDate, dateASQSE, RowASQSE 
	FROM AsmtInfo left join [Demo_Processing].[dbo].[ASQChildAll] as demo  /* Demographics table */
	on AsmtInfo.MCI = demo.MCI and
	AsmtInfo.ChildCaseNo = demo.ChildCaseNo and
	AsmtInfo.CountyID = demo.CountyID

/* there are currently multiple rows per MCI in the [ASQChildAll] table */
/* once it is matched using the ChildID (rather than the current match using MCI, ChCaseNum, and Cnty,  */
/* the asmt records should be able to only find one match in the ASQChildAll table */
/* then the match won't "balloon" the table */
/* into having many more observations */

/* currently the uniquely identifying information is */
/* county, MCI, ChildCaseNo */
/* once info is reset to match using ChildID */
/* uniquely identifying information */
/* will be ChildID */