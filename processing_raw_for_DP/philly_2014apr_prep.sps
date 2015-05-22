/* code for the Philly 2014 Feb file */
GET DATA /TYPE=XLS
  /FILE='H:\prep_phillyasq\processing_raw_for_DP\philly_2014feb_data.xls'
  /SHEET=name 'Sheet1'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
compute which_cohort=201402.
save outfile='H:\prep_phillyasq\processing_raw_for_DP\philly2014feb.sav'.

/* code for the Philly 2013 Dec file */
GET DATA /TYPE=XLS
  /FILE='H:\prep_phillyasq\processing_raw_for_DP\philly_2013dec_data_withoutblankcolumn.xls'
  /SHEET=name 'Sheet1'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
compute which_cohort=201312.
save outfile='H:\prep_phillyasq\processing_raw_for_DP\philly2013dec.sav'.

/* code for the amalgamated 2014 file from June */
GET DATA /TYPE=XLS
  /FILE='H:\prep_phillyasq\processing_raw_for_DP\phillyAllASQ_SE52714_modified.xls'
  /SHEET=name 'Sheet1'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
rename variables file_date=which_cohort.
save outfile='H:\prep_phillyasq\processing_raw_for_DP\philly2014juneagg.sav'.

/* code for the amalgamated 2014 file from June plus the two records from the disc */
GET DATA /TYPE=XLS
  /FILE='H:\prep_phillyasq\processing_raw_for_DP\phillyAll20140618.xls'
  /SHEET=name 'Sheet1'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
rename variables file_date=which_cohort.
save outfile='H:\prep_phillyasq\processing_raw_for_DP\philly2014june18agg.sav'.


/* run the files that convert the codes */

/* diagnosis codes not collected */

/* adding the maltreatment codes */
/* not used to break into separate maltreatment variables */

include file='H:\prep_phillyasq\processing_raw_for_DP\adding_maltreatment_from_onevar.sps'.

/* Race information */
include file='H:\prep_phillyasq\processing_raw_for_DP\adding_race_from_onevar.sps'.

/* living situation codes not collected */

/* adding numeric codes and re-naming variables */
include file='H:\prep_phillyasq\processing_raw_for_DP\adding_onlyneedrecode_to_philly_fewer_fields.sps'.

/* initial ASQ and ASQ:SE starter values codes not needed */
/* of initial vs. follow-up */

include file='H:\prep_phillyasq\processing_raw_for_DP\adding_ASQConcernTypes_from_sepvars.sps'.

include file='H:\prep_phillyasq\processing_raw_for_DP\splitting_philly_asq_vars_into_asq_and_asqse.sps'.

string ChildCaseNo (A7).
string case_numberstring (A7).
compute case_numberstring=string(case_number,F6.0).
compute ChildCaseNo=concat(case_numberstring, sfx).
execute.

/* restore the variable names used for the DP */
/* Variables already in the correct format that only need renaming */
rename variables 
 (dob=DoB)
 (mci=MCI)
 (recent_case_opening=MostRecentCaseDate)
 (which_cohort=SubmittedDate).

/* move results onto one row */

/* for when it was a single file without multiple ASQ-SE's for one child */
include file='H:\prep_phillyasq\processing_raw_for_DP\move_screening_results_onto_one_row.sps'.

/* when it was multiple files together and a child has multiple ASQ-SE's */
include file='H:\prep_phillyasq\processing_raw_for_DP\move_screening_results_onto_one_row_morethanoneSE.sps'.

formats GenderID NICU ReferredToCW ReportSubstantiated ASQScreeningTool ASQSEScreeningTool 
 ASQSEScreeningAdministrator ASQScreeningAdministrator ASQSEConcernTypes
 DS_Communication DS_GrossMotor DS_FineMotor DS_ProblemSolving DS_PersonalSocial DS_ASQSE
 CountyID (F3).

/* List of Defunct Ones */
* (dob=BirthDate).
* (due_dob=DueDate).
*  (case_number=ChildCaseNo).
* (a_caregiver_dob=CGBirthDate1).

save translate 
 /outfile='H:\prep_phillyasq\processing_raw_for_DP\philly_2014feb_processed.xls'
 /type=xls
 /fieldnames
 /keep=ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID 
 ASQScreeningDate ASQScreeningTool ASQScreeningAdministrator ASQConcernTypes DS_communication DS_FineMotor
  DS_GrossMotor DS_PersonalSocial DS_ProblemSolving ASQEarlyInterventionReferralDate ASQSEScreeningDate 
 ASQSEScreeningTool ASQSEScreeningAdministrator ASQSEConcernTypes DS_ASQSE ASQSEEarlyInterventionReferralDate 
 CountyID SubmittedDate
 /replace
 /unselected=delete
 /missing=recode.


/* when keeping the two sets of ASQSE variables, for data checking purposes */ 
save translate 
 /outfile='H:\prep_phillyasq\processing_raw_for_DP\philly_2014feb_processed.xls'
 /type=xls
 /fieldnames
 /keep=ChildCaseNo MCI DoB GenderID MostRecentCaseDate RaceID NICU ReferredToCW ReportSubstantiated MaltreatmentID 
 ASQScreeningDate ASQScreeningTool ASQScreeningAdministrator ASQConcernTypes DS_communication DS_FineMotor
  DS_GrossMotor DS_PersonalSocial DS_ProblemSolving ASQEarlyInterventionReferralDate ASQSEScreeningDate2 ASQSEScreeningTool2 ASQSEScreeningAdministrator2 ASQSEConcernTypes2 DS_ASQSE2  ASQSEEarlyInterventionReferralDate2 
 CountyID SubmittedDate
 /rename (ASQSEScreeningDate2 ASQSEScreeningTool2 ASQSEScreeningAdministrator2 ASQSEConcernTypes2 DS_ASQSE2 
 ASQSEEarlyInterventionReferralDate2 = ASQSEScreeningDate 
 ASQSEScreeningTool ASQSEScreeningAdministrator ASQSEConcernTypes DS_ASQSE ASQSEEarlyInterventionReferralDate )
 /replace
 /unselected=delete
 /missing=recode.



