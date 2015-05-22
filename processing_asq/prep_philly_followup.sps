get file='H:\prep_phillyasq\processing_asq\Philly_Followup_RW.sav'.

alter type case_number (amin).

compute case_number=rtrim(ltrim(case_number)).

alter type case_number (a7).

add files file=* file='H:\prep_phillyasq\processing_asq\Philly_Followup_May2012_varsrenamed.sav'.
execute.

/* checked that each case_number is unique */
/* no different dob's per case_number */
sort case_number dob.
compute melag=0.
if (case_number=lag(case_number) and dob<>lag(dob)) melag=lag(melag)+1.

frequencies variables=melag.


*compute case_number=rtrim(ltrim(case_number)).

/* Variables that could be dropped for the merge */
/* as they may already exist in the other dataset */

/*
list of all variables:
case_number
recent_case_opening
dob
due_dob
date_of_screening
FollowupScreen--is 1 for everyone
asq_qtype
sex
race
hisp
birth_weight_lbs
birth_weight_oz
nicu
enter_date--only six valid entries
diagnosed_condition
yes_please_explain
target_referral
indicated
maltreatment_type
if_other_explain
screen_additional_child
a_relationship_to_child
a_caregiver_dob
a_caregiver_race
a_caregiver_hisp
a_caregiver_ed
b_relationship_to_child
b_caregiver_dob
b_caregiver_race
b_caregiver_hisp
b_caregiver_ed
administered_by
persons_interviewed
screening_observation
screening_interview
screening_test
form_type--answer is always "asq" and never "asqse"
communication_score
grossmotor_score
finemotor_score
problem_solving_score
personalsocial_score
asqse_score--this number is missing for all, not like the other ASQ 		categories that actually will have a score
aoc_communication
aoc_grossmotor
aoc_finemotor
aoc_problemsolving
aoc_personalsocial
aoc_asqse
referral_date--either blank or not applicable
referral_agency--one blank, agency name, or not applicable
aoc_asqse
PrimaryLast
*/

/* In Philly's first file */
/* (the non-followup file) */
/* EIReferral not applicable, yes, no */
/* all have referral dates of */ 
/* blank or not applicable */
/* this variable isn't going to be too helpful! */

/* will move it to the deleted variables pile */

/* variables to be kept will be:
case_number
date_of_screening
aoc_communication
aoc_grossmotor
aoc_finemotor
aoc_problemsolving
aoc_personalsocial

*/

/* can use date_of_screening to assign order of screening */

sort cases by case_number date_of_screening.

compute idwithingroup=1.
if (case_number=lag(case_number) and date_of_screening=lag(date_of_screening)) idwithingroup=lag(idwithingroup)+1.

frequencies variable=idwithingroup.

/* one entry in the followup spreadsheet is a dupe */
/* case number 606558 */
/* two screenings on Jan. 13, 2012 */


/* differences between the two rows: */
/* which ASQ being given "18 month" vs "20 month"  */
/* caregiver DOB Jun. 16, '90 vs Sept. 16, '90 */
/* other results are same */

/* will delete the second entry */
compute todelete=0.
if (idwithingroup=2) todelete=1.


/* now delete */
FILTER OFF.
USE ALL.
SELECT IF (todelete=0).
EXECUTE.

/* add the "which screening per person" variable */

sort cases by case_number date_of_screening.

compute idwithingroup=2.
if (case_number=lag(case_number)) idwithingroup=lag(idwithingroup)+1.

frequencies variable=idwithingroup.

/* a maximum of four observations per ID number */

/* the delete command: */ 
delete variables 
 recent_case_opening
 dob
 due_dob
 FollowupScreen
 asq_qtype
 sex
 race
 hisp
 birth_weight_lbs
 birth_weight_oz
 nicu
 sex
 race
 hisp
 birth_weight_lbs
 birth_weight_oz
 nicu
 enter_date
 diagnosed_condition
 yes_please_explain
 target_referral
 indicated
 maltreatment_type
 if_other_explain
 screen_additional_child
 a_relationship_to_child
 a_caregiver_dob
 a_caregiver_race
 a_caregiver_hisp
 a_caregiver_ed
 b_relationship_to_child
 b_caregiver_dob
 b_caregiver_race
 b_caregiver_hisp
 b_caregiver_ed
 administered_by
 persons_interviewed
 screening_observation
 screening_interview
 screening_test
 form_type
 communication_score
 grossmotor_score
 finemotor_score
 problem_solving_score
 personalsocial_score
 asqse_score
 referral_date
 referral_agency
 todelete
 aoc_asqse
 PrimaryLast. 

/* after now having a smaller file, can now */
/* change variables to fit the other file */ 

display dictionary.

frequencies variables=aoc_communication to aoc_personalsocial
 /order=analysis.

/* will want to recode the aoc scores from words to numbers */
/* will want to match the values already in use in other files */
/* yes => 1 */
/* no => 2 */

DEFINE !addconc (whcon = !TOKENS(1) / relcode = !TOKENS(1)) 

if (!whcon = 'yes') !relcode = 1.
if (!whcon = 'no') !relcode = 2.

!ENDDEFINE.

!addconc whcon=aoc_communication relcode=CommunicationCon.
!addconc whcon=aoc_grossmotor relcode=GrossMotorConcerns.
!addconc whcon=aoc_finemotor relcode=FineMotorConcern.
!addconc whcon=aoc_problemsolving relcode=ProblemSolvingConcern.
!addconc whcon=aoc_personalsocial relcode=PersonalSocialConcern.

value labels CommunicationCon to PersonalSocialConcern -8 'not applicable' 
 1 'yes' 2 'no' 6 'missing' 7 'don''t know'.
execute.

delete variables aoc_communication TO aoc_personalsocial.
rename variables (date_of_screening=ASQDate).

/* it didn't help avoid the .00 var names, though! */
formats CommunicationCon to PersonalSocialConcern (F8.0).

compute otherthanno=0.
compute numofconcerns=0.

/* create the no concerns variable */
DO REPEAT V# = CommunicationCon to PersonalSocialConcern. 
if (V#=1) NoConcerns=2.
if (V#~=2) otherthanno=1.
if (V#=1) numofconcerns=numofconcerns+1.
if (sysmis(V#)) NoConcerns=6.
END REPEAT.

if (otherthanno=0 and numofconcerns=0 and sysmis(NoConcerns)) NoConcerns=1.

if (otherthanno=1 and numofconcerns>1) More1Concern=1.
if (otherthanno=1 and numofconcerns=1) More1Concern=2.
if (NoConcerns=1) More1Concern=2.

frequencies variables=NoConcerns More1Concern.

value labels NoConcerns More1Concern -8 'not applicable' 
 1 'yes' 2 'no' 6 'missing' 7 'don''t know'.
execute.

/* create the any concerns variables */
/* create the any concerns variable

compute AnyConcerns=NoConcerns.

/*yes, have no concerns */
/* any concern will be no */
if (NoConcerns=1) AnyConcerns=20.

/*no, do have concerns */
/* any concern will be yes, do have concerns */
if (NoConcerns=2) AnyConcerns=1.
if (AnyConcerns=20) AnyConcerns=2.

crosstabs
/tables=AnyConcerns by NoConcerns.

/* add labels for any concerns variable */
value labels AnyConcerns -8 'Not Applicable'
	1 'Yes'
	2 'No'
	6 'Missing'
	7 "Don't Know".



delete variables melag otherthanno numofconcerns.

/* now make the data wide */
casestovars 
 /id=case_number
 /index=idwithingroup
 /SEPARATOR="".

sort cases by case_number.
save outfile='H:\prep_phillyasq\processing_asq\Philly_Followup_plusMay2012.sav'.