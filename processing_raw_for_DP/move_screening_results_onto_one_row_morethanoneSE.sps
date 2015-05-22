/* this do-file moves the ASQ and ASQ-SE results on to one row when appropriate */
/* it was necessary to modify the move_screening_results_onto_one_row.sps file */
/* since there was more than one SE for the same child within the period */
/* when combining three Philly files together */
/* rather than one file on its own */

/* check to make sure all the non-ASQ and non-ASQ-SE variables in a row are the same */

/* missing values are treated as lowest value when sorting */

/* create rank within ASQ for each combo */

sort cases by SubmittedDate ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID ASQSEScreeningDate (A) ASQScreeningDate (A) .

/* want the ASQ cases first (no ASQSE screening date) */
/* then the ASQSE cases */

compute caseorderASQ=$sysmis.
if (form_type='asq') caseorderASQ=1.

if (SubmittedDate=lag(SubmittedDate) AND ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID) and sysmis(ASQScreeningDate)=0) caseorderASQ=lag(caseorderASQ)+1.

freq vars=caseorderASQ.
crosstabs 
 /table=caseorderASQ by form_type.

/* find max of ASQ values for group */
/* highest ASQ value first */

compute maxASQwithingroup=caseorderASQ.
if (form_type='asq-se') maxASQwithingroup=0.

/* now want to reverse sort */
/* and have values with ASQSE Screening Date in front of values with ASQ results */
sort cases by SubmittedDate ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID maxASQwithingroup (D).

COMPUTE maxwithingroup=caseorder.
if (SubmittedDate=lag(SubmittedDate) AND ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID)) maxASQwithingroup=lag(maxASQwithingroup).

freq vars=maxASQwithingroup.

crosstabs 
 /table=caseorderASQ by maxASQwithingroup.





/* create rank within ASQSE for each combo */

sort cases by SubmittedDate ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID ASQScreeningDate (A) ASQSEScreeningDate (A) .

/* want the ASQSE cases first (no ASQ screening date) */
/* then the ASQ cases */

if (form_type='asq-se') caseorderASQSE=1.

if (SubmittedDate=lag(SubmittedDate) AND ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID) and sysmis(ASQSEScreeningDate)=0) caseorderASQSE=lag(caseorderASQSE)+1.

freq vars=caseorderASQSE.
crosstabs 
 /table=caseorderASQSE by form_type.

/* find max of ASQSE values for group */
/* highest ASQSE value first */

compute maxASQSEwithingroup=caseorderASQSE.
if (form_type='asq') maxASQSEwithingroup=0.

/* now want to reverse sort */
/* and have values with ASQSE Screening Date in front of values with ASQ results */
sort cases by SubmittedDate ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID maxASQSEwithingroup (D).

COMPUTE maxwithingroup=caseorder.
if (SubmittedDate=lag(SubmittedDate) AND ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID)) maxASQSEwithingroup=lag(maxASQSEwithingroup).

freq vars=maxASQSEwithingroup.

crosstabs 
 /table=caseorderASQSE by maxASQSEwithingroup.





/* create overall order to be able to interfile records */
/* 1st SE */
/* 1st ASQ */
/* 2nd ASQSE */
/* 2nd ASQ */
/* etc. */
if (form_type='asq-se') caseorderoverall=(2*caseorderASQSE)-1.
if (form_type='asq') caseorderoverall=2*caseorderASQ.

/* sort by overall order */

sort cases by SubmittedDate ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID caseorderoverall (A).

/* put the info for the ASQ-SE */
/* into the next following record */

/* code from http://www.ats.ucla.edu/stat/spss/code/renaming_variables_dynamically.htm */

/* code so that I could test the variable names */
/* appended a 2 at the end of the variable name */
define !rename2 (vlist = !charend('/')
                        /suffix=!cmdend )

!do !vname !in (!vlist) 
!let !nname = !concat(!vname, !suffix)
* rename variables (!vname = !nname).
compute !nname=!vname.
!doend
!enddefine.

!rename2 vlist = ASQSEScreeningDate ASQSEScreeningTool ASQSEScreeningAdministrator ASQSEConcernTypes DS_ASQSE ASQSEEarlyInterventionReferralDate 
              /suffix = 2.


do repeat thisvar=ASQSEScreeningDate ASQSEScreeningTool ASQSEScreeningAdministrator ASQSEConcernTypes DS_ASQSE ASQSEEarlyInterventionReferralDate.


do repeat thisvar=ASQSEScreeningDate2 ASQSEScreeningTool2 ASQSEScreeningAdministrator2 ASQSEConcernTypes2 DS_ASQSE2 ASQSEEarlyInterventionReferralDate2.

if (SubmittedDate=lag(SubmittedDate) AND ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID) and 
 sysmis(thisvar)=1 and sysmis(lag(thisvar))=0 and
 sysmis(caseorderASQ)=0 and sysmis(lag(caseorderASQSE))=0) thisvar=lag(thisvar).

end repeat.
/* row's value is currently blank */
/* prior row's value is not currently blank */
/* row is an ASQ row */
/* prior row is an ASQ:SE row */

format ASQSEScreeningDate2 (adate11) ASQSEEarlyInterventionReferralDate2 (adate11) .

compute marktodelete=0.
if (form_type='asq-se' AND caseorderASQSE<=maxASQwithingroup) marktodelete=1.
/* at least one ASQ within group maxASQ>=maxASQSE condition */
/* would have filled at least some ASQ values */
/* choose the specific ASQ:SE row value (being less than the ASQ values caseorderASQSE<=maxASQ condition */

freq vars=marktodelete.

/* in the cross-tab */
/* the number with marktodelete equals zero */
/* likely at least some obs. are not getting deleted */
/* at least some obs. are getting kept */
crosstabs 
 /table=ASQSEScreeningDate by marktodelete.

/* in the cross-tab */
/* the number with marktodelete equals zero */
/* should equal the inital number of asq-se rows in the spreadsheet */
/* for the ASQSEScreeningDate2 variable */

crosstabs 
 /table=ASQSEScreeningDate2 by marktodelete.

crosstabs 
 /table=ASQScreeningDate by marktodelete.

temporary.
select if (marktodelete=0).
freq vars=ASQScreeningDate ASQSEScreeningDate.
/* numbers should be same as in original file */

temporary.
select if (form_type='asq-se').
freq vars=ASQSEScreeningDate.
/* count of ASQSE here should match count in prior temporary freq vars */

/* remove cases from before July 01, 2013 */
if (MostRecentCaseDate<DATE.MDY(07,01,2013)) marktodelete=1.

crosstabs 
 /table=MostRecentCaseDate by marktodelete.


/* filter the file */
select if (marktodelete=0).

