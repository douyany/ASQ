/* want to check for both number of forms */
/* and for MCI being present */
/* and for min std dataset being present */

/* will also need to add commands for counties in the import database */
SELECT  [CountyID], year(cast([SubmittedDate] as datetime)) as SubYear,
      month(cast([SubmittedDate] as datetime)) as SubMonth,
       count(case when [ASQScreeningDate] is not null
			then 1 else null end) as NumFormsASQ, 
       count(case when [ASQSEScreeningDate] is not null
			then 1 else null end) as NumFormsSE, 
	  count(case when MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'
	  then 1 else null end) as nonnineMCI, 
		count(case when 
		(	(	([ChildCaseNo] IS NULL) 
      OR ([MCI] not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%') 
      OR ([DoB] IS NULL) 
      OR ([GenderID] IS NULL) 
      OR ([MostRecentCaseDate] IS NULL) 
      OR ([RaceID] IS NULL) 
      OR ([NICU] IS NULL) 
      OR ([ReferredToCW] IS NULL) 
      OR ([ReportSubstantiated] IS NULL) 
      OR ([MaltreatmentID] IS NULL) )
	  or   /* referring to ASQ specific vars */
      (		(
		([ASQScreeningDate] IS not NULL) 
      and (
	  ([ASQScreeningTool] IS NULL) 
      OR ([ASQScreeningAdministrator] IS NULL) 
      OR ([ASQConcernTypes] IS NULL) 
      OR ([DS_communication] IS NULL) 
      OR ([DS_FineMotor] IS NULL) 
      OR ([DS_GrossMotor] IS NULL) 
      OR ([DS_PersonalSocial] IS NULL) 
      OR ([DS_ProblemSolving] IS NULL) 
	  )
	  )
      /* OR ([ASQEarlyInterventionReferralDate] IS NULL) */
	  /* referral date can be null if not referred */
	  or 
	  		(	/* the ASQ:SE specific variables */
       ([ASQSEScreeningDate] IS not NULL) 
      and (
	  ([ASQSEScreeningTool] IS NULL) 
      OR ([ASQSEScreeningAdministrator] IS NULL) 
      OR ([ASQSEConcernTypes] IS NULL) 
      OR ([DS_ASQSE] IS NULL) 
	  )
	  /* OR ([ASQSEEarlyInterventionReferralDate] IS NULL) */
	  /* referral date can be null if not referred */
      
	  
      )			/* close out ASQ:SE specific variables */
				) /* close out the "either ASQ" or "either SE" clause */
				) /* close out the rest of list of demographics */
		then 1 else null end) as nonminstd

    FROM [Demo_Processing].[dbo].[ASQ_Local]
   where 
   year(cast([SubmittedDate] as datetime))>2013
group by countyid, year(cast([SubmittedDate] as datetime)) ,
	month(cast([SubmittedDate] as datetime))
	
/* join results to results from import table */
/* Allegheny and Philly results */
union all	


SELECT  [CountyID], year(cast([SubmittedDate] as datetime)) as SubYear,
      month(cast([SubmittedDate] as datetime)) as SubMonth,
       count(case when [ASQScreeningDate] is not null
			then 1 else null end) as NumFormsASQ, 
       count(case when [ASQSEScreeningDate] is not null
			then 1 else null end) as NumFormsSE, 
	  count(case when MCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'
	  then 1 else null end) as nonnineMCI, 
		count(case when 
		(	(	([ChildCaseNo] IS NULL) 
      OR ([MCI] not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%') 
      OR ([DoB] IS NULL) 
      OR ([GenderID] IS NULL) 
      OR ([MostRecentCaseDate] IS NULL) 
      OR ([RaceID] IS NULL) 
      OR ([NICU] IS NULL) 
      OR ([ReferredToCW] IS NULL) 
      OR ([ReportSubstantiated] IS NULL) 
      OR ([MaltreatmentID] IS NULL) )
	  or   /* referring to ASQ specific vars */
      (		(
		([ASQScreeningDate] IS not NULL) 
      and (
	  ([ASQScreeningTool] IS NULL) 
      OR ([ASQScreeningAdministrator] IS NULL) 
      OR ([ASQConcernTypes] IS NULL) 
      OR ([DS_communication] IS NULL) 
      OR ([DS_FineMotor] IS NULL) 
      OR ([DS_GrossMotor] IS NULL) 
      OR ([DS_PersonalSocial] IS NULL) 
      OR ([DS_ProblemSolving] IS NULL) 
	  )
	  )
      /* OR ([ASQEarlyInterventionReferralDate] IS NULL) */
	  /* referral date can be null if not referred */
	  or 
	  		(	/* the ASQ:SE specific variables */
       ([ASQSEScreeningDate] IS not NULL) 
      and (
	  ([ASQSEScreeningTool] IS NULL) 
      OR ([ASQSEScreeningAdministrator] IS NULL) 
      OR ([ASQSEConcernTypes] IS NULL) 
      OR ([DS_ASQSE] IS NULL) 
	  )
	  /* OR ([ASQSEEarlyInterventionReferralDate] IS NULL) */
	  /* referral date can be null if not referred */
      
	  
      )			/* close out ASQ:SE specific variables */
				) /* close out the "either ASQ" or "either SE" clause */
				) /* close out the rest of list of demographics */
		then 1 else null end) as nonminstd

  FROM [Demo_Processing].[dbo].[ASQ_Import] 
   where 
   year(cast([SubmittedDate] as datetime))>2013
group by countyid, year(cast([SubmittedDate] as datetime)) ,
	month(cast([SubmittedDate] as datetime))
