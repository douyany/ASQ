get file='H:\prep_phillyasq\processing_asq\Philly_SE_Followup.sav'.

alter type case_number (amin).

compute case_number=rtrim(ltrim(case_number)).

alter type case_number (a7).

/* checked that each case_number is unique */
/* no different dob's per case_number */
sort case_number dob.
compute melag=0.
if (case_number=lag(case_number) and dob<>lag(dob)) melag=lag(melag)+1.

frequencies variables=melag.

rename variables (SEdate_of_screening=SEDate).

/* check for dupes */
sort cases by case_number SEDate.

compute idwithingroup=1.
if (case_number=lag(case_number) and SEDate=lag(SEDate)) idwithingroup=lag(idwithingroup)+1.

frequencies variable=idwithingroup.
 /* no dupes! */

/* screening number */
sort cases by case_number SEDate.

compute idwithingroup=2.
if (case_number=lag(case_number)) idwithingroup=lag(idwithingroup)+1.

frequencies variable=idwithingroup.

if (aoc_asqse='yes') SEConcerns=1.
if (aoc_asqse='no') SEConcerns=0.

value labels SEConcerns -8 'not applicable' 
 1 'yes' 0 'no' 2 'missing' 3 'don''t know'.

execute.


/* listing of variables to drop */
delete variables recent_case_opening
dob
due_dob
SEFollowupScreen
SE_qtype
PrimaryFirst
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
SEscreening_observation
SEscreening_interview
SEscreening_test
form_type
communication_score
grossmotor_score
finemotor_score
problem_solving_score
personalsocial_score
asqse_score
aoc_communication
aoc_grossmotor
aoc_finemotor
aoc_problemsolving
aoc_personalsocial
referral_date
referral_agency
melag aoc_asqse.


/* no need to do cases to vars */
/* as there's only 1 follow-up person */

/* now make the data wide */
casestovars 
 /id=case_number
 /index=idwithingroup
 /SEPARATOR="".

/* will rename the variables instead */
rename variables (SEDate=SEDate2) (SEConcerns=SEConcernTypes2).

sort cases by case_number.

save outfile='H:\prep_phillyasq\processing_asq\Philly_Followup_asqse_sorted.sav'.