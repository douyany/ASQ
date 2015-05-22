/* this do-file moves the ASQ and ASQ-SE results on to one row when appropriate */

/* check to make sure all the non-ASQ and non-ASQ-SE variables in a row are the same */

/* missing values are treated as lowest value when sorting */
sort cases by ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID ASQSEScreeningDate (A) ASQScreeningDate (A) .

/* want the ASQ cases first (no ASQSE screening date) */
/* then the ASQSE cases */

compute caseorder=1.

if (ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID)) caseorder=lag(caseorder)+1.

freq vars=caseorder.
crosstabs 
 /table=caseorder by form_type.

/* there are some 3's present */
/* 350344086 had two ASQ's on same date */
/* 3 being two ASQ's and one ASQ-SE for that person */ 

/* now want to reverse sort */
/* and have values with ASQSE Screening Date in front of values with ASQ results */
sort cases by ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID caseorder (D).

COMPUTE maxwithingroup=caseorder.
if (ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID)) maxwithingroup=lag(maxwithingroup).

freq vars=maxwithingroup.

/* in Dec. 2013 file */
/* have 10 MCI's with 3 obs. */
/* have 1 MCI with 4 obs. */

/* list MCI values, DOB, screening date where age is negative at time of screening */
TEMPORARY.
SELECT IF (maxwithingroup gt 2).
LIST VARIABLES=MCI DOB ASQScreeningDate ASQSEScreeningDate maxwithingroup.

/* sort by ASQ Screening Date */
/* the ASQ-SE records will come before the ASQ records */
/* as missing values come first */
sort cases by ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID ASQScreeningDate ASQSEScreeningDate caseorder (A).

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

!rename2 vlist = ASQSEScreeningDate ASQSEScreeningTool ASQSEScreeningAdministrators ASQSEConcernTypes DS_ASQSE ASQSEEarlyInterventionReferralDate 
              /suffix = 2.


do repeat thisvar=ASQSEScreeningDate ASQSEScreeningTool ASQSEScreeningAdministrators ASQSEConcernTypes DS_ASQSE ASQSEEarlyInterventionReferralDate.


do repeat thisvar=ASQSEScreeningDate2 ASQSEScreeningTool2 ASQSEScreeningAdministrators2 ASQSEConcernTypes2 DS_ASQSE2 ASQSEEarlyInterventionReferralDate2.

if (ChildCaseNo=lag(ChildCaseNo) AND  MCI=lag(MCI) AND  DoB=lag(DoB) AND  GenderID=lag(GenderID) AND
  MostRecentCaseDate=lag(MostRecentCaseDate) AND  RaceID=lag(RaceID) AND  NICU=lag(NICU) AND 
 ReferredToCW=lag(ReferredToCW) AND  ReportSubstantiated=lag(ReportSubstantiated) AND 
 MaltreatmentID=lag(MaltreatmentID) and caseorder=1) thisvar=lag(thisvar).

end repeat.

format ASQSEScreeningDate2 (adate11) ASQSEEarlyInterventionReferralDate2 (adate11) .

compute marktodelete=0.
if (form_type='asq-se' AND maxwithingroup>1 AND caseorder>1) marktodelete=1.
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

/* filter the file */
select if (marktodelete=0).

