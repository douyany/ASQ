get file='H:\prep_phillyasq\PhillyFlat_Merged_1.sav'.

/* get these names to match the names in the other (statewide) file */

rename variables (ChildCaseNumber=case_number) (ASQScreeningDate=ASQDate1)   (SEScreeningDate=SEDate1)
 (CommunicationCon=CommunicationCon1)
 (GrossMotorConcerns=GrossMotorConcerns1)
 (FineMotorConcern=FineMotorConcern1)
 (ProblemSolvingConcern=ProblemSolvingConcern1)
 (PersonalSocialConcern=PersonalSocialConcern1)
 (More1Concern=More1Concern1)
 (NoConcerns=NoConcerns1)
 (AnyConcerns=AnyConcerns1)
 (ASQSEConcernTypes=SEConcernTypes1)
 (ASQOrSEConcerns=ASQorSEConcerns1).

/* no -9's in the data */
/* the missings */
if (ASQorSEConcerns1=-9) ASQorSEConcerns1=20.

/* the no's */
if (ASQorSEConcerns1=2) ASQorSEConcerns1=0.

/* no missings in the data */
/* the missings, adjusted */
if (ASQorSEConcerns1=20) ASQorSEConcerns1=2.

/* only have yes or no in the data */

alter type case_number (amin).
compute case_number=rtrim(ltrim(case_number)).
alter type case_number (a7).

sort cases by case_number.

/* checked that each case_number is unique */
/* no different dob's per case_number */
sort case_number BirthDate.
compute melag=0.
if (case_number=lag(case_number) and BirthDate<>lag(BirthDate)) melag=lag(melag)+1.

frequencies variables=melag.

/* all the case_numbers have unique birthdays */
/* no people have the same case_numbers */

execute.

delete variables 
PhillyCaseID
recent_case_opening
BirthDate
DueDate
ASQAgeAtScreening
ASQAgeAtScreeningMos
DiffInWksBtwnDOBDD
PrematureYN
SEAgeAtScreening
AgeatScreening
SEAgeAtScreeningMos
AgeatScreeningMos
ChildAge2to6Mos
ChildAge7to9Mos
ChildAge10to12Mos
ChildAge13to15Mos
ChildAge16to18Mos
ChildAge19to21Mos
ChildAge22to24Mos
ChildAge25to28Mos
ChildAge29to32Mos
ChildAge33to36Mos
ChildAge37to43Mos
ChildAge44to50Mos
ChildAge51to62Mos
OverAge3YN
Under3YN
sex
Gender
raceS
Race1
Race2
Race3
Race
RaceRecode
hisp
Ethnicity
BirthWeightPounds
BrithWeightOunces
nicuS
NICU
enter_date
diagnosed_condition
DevelopmentCondition
yes_please_explain
MedicalDx
PsychDx
DevelopDx
target_referral
ReferredToChildWelfare
indicated
ReportSubstantiated
MaltreatmentID
Maltreat1S
Maltreat2S
Maltreat3S
Maltreat4S
Maltreat5S
Maltreat6S
Maltreat1
Maltreat2
Maltreat3
Maltreat4
Maltreat5
Maltreat6
PhysicalAbus
SexualAbus
PhysicalNegl
OtherAbus
SrsMentEmotAbus
ParentingCons
CareSubsAbus
LackingBasNeeds
FailureToProtect
ChildBehConcerns
PhysicalMaltreat
CareMH
DomesticViol
SuperNeglect
if_other_explain
screen_additional_child
administered_by
persons_interviewed
ASQscreening_observation
ASQscreening_interview
ASQscreening_test
ASQScreeningType1
ASQScreeningType2
ASQScreeningType3
ASQ_Observation
ASQInt
ASQtest
ASQform_type
communication_score
grossmotor_score
finemotor_score
problem_solving_score
personalsocial_score
aoc_communication
aoc_grossmotor
aoc_finemotor
aoc_problemsolving
aoc_personalsocial
ConcernSum
EIReferral
referral_date
referral_agency
SEreferral_date
SEreferral_agency
FollowupScreen
asq_qtype
NotInFlatFile
asqse_score
aoc_asqse
SEFollowupScreen
SE_qtype
CGBirthDate1
a_caregiver_race
CGRaceID1
CG1Race1
CG1Race2
b_caregiver_race
CGRaceID2
a_caregiver_hisp
CGEthnicityID1
b_caregiver_hisp
CGEthnicityID2
a_caregiver_ed
CGEducationID1
CGBirthDate2
b_caregiver_ed
CGEducationID2
SEa_caregiver_dob
SEa_caregiver_race
SEa_caregiver_hisp
SEa_caregiver_ed
SEb_caregiver_dob
SEb_caregiver_race
SEb_caregiver_hisp
SEb_caregiver_ed
SEpersons_interviewed
SEscreening_observation
SEscreening_interview
SEscreening_test
SEScreeningType1
SEScreeningType2
SEScreeningType3
SE_Observation
SEint
SEtest
SEform_type
a_relationship_to_child
CGRelationshipID1
b_relationship_to_child
CGRelationshipID2
SEa_relationship_to_child
SEb_relationship_to_child
LivSitAtScreen
CountyPopStat
RegionID
CG1AgeAtChildsBirth
CG2AgeAtChildsBirth
ConductedScreen
Maltreat7
Maltreat8
Maltreat9
Maltreat10
Maltreat11
Maltreat12
Maltreat13
melag.

execute.

sort cases by case_number.

/* time for the merge! */
match files file=* file='H:\prep_phillyasq\processing_asq\Philly_Followup_ASQandASQSE.sav' /in=fromfollowup
 /by=case_number.

frequencies variables=fromfollowup.

save outfile='H:\prep_phillyasq\processing_asq\Philly_initial_and_later.sav' /drop=infromasq infromasqse fromfollowup.