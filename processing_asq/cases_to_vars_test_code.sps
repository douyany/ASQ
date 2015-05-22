﻿sort cases by case_number date_of_screening.

compute idwithingroup = 1.
if case_number = lag(case_number) idwithingroup = lag(idwithingroup) + 1.
exe.

CASESTOVARS
/id=case_number
/index=idwithingroup
/drop=case_number
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
referral_agency
PrimaryLast
idwithingroup.
list.
