/* This version, */
/* from the "from Emily" version */
/* has a streamlined list of fields */
/* started this do-file in April 2014 */


/* These variables already have all the fit */
/* to how they are in other datasets */
/* adding_onlyneedrecode_to_philly.sps */

/* they only need to be converted from strings to numbers */

/* Yaou already converted the sex labels into numbers */
/* don't need this line of code */ 
RECODE sex ('female'=2) ('male'=1) ('missing'=0) ('unknown'=3)  INTO GenderID.
*rename variables (sex=GenderID).

/* 8 used to be mixed race */
/* now 4 is the code for other */
/* formerly converted into Racevar */
/* now called RaceID */

/* made these lines of code inactive after decided to use multiple values  */
/* to capture race */
* RECODE race ('asian'=2)  ('asian^black'=4)
 ('black'=0)   ('black^asian'=4) ('black^indian/ala'=4) ('black^white'=4) 
 ("don't know"=6)
 ('white'=3) ('white^black'=4)  ('white^hawaiian/pacific islander'=4)
   INTO RaceID.

* execute.

* crosstabs.
*  /tables=race by RaceID.

* delete variables race.
/* name was previously Race now RaceID */
* rename variables (Racevar=RaceID).

/* no Hisp info in minimum standard dataset */
/* don't need this line of code */ 
*RECODE hisp ('no'=2) 
 ("don't know"=3)  ('yes'=1) INTO Ethnicity.
/* ("don't know"=3) */

/* name was previously ReferredToChildWelfare */
/* now ReferredToCW */
RECODE target_referral ("don't know"=3) ('no'=2) ('yes'=1) INTO ReferredToCW. 

/* weren't actually any missing values */
RECODE indicated  ("don't know"=3) ('no'=2) ('yes'=1) ('ongoing investigation'=5) ('missing'=4) INTO ReportSubstantiated.
if (target_referral="don't know") ReportSubstantiated=3.
if (target_referral='no') ReportSubstantiated=2.
/* value 4 is "missing" */

/* no caregiver ed info in minimum standard dataset */
/* don't need this line of code */ 
*RECODE a_caregiver_ed ('associates degree'=6) 
 ('bachelors degree'=7) ('did not complete high school'=1) 
 ('doctoral degree'=10) ("don't know"=12) 
 ('ged or alternative credential'=3) ('high school diploma'=2) 
 ('masters degree'=8) ('no degree'=5) 
 ('no schooling completed'=0) ('some college credit'=4) 
 ('professional degree beyond bachelors'=9) INTO CGEducationalID1.

/* a value in the Philly dataset */
/* not in the statewide dataset */
/* will have it as "don't know" */
*if (a_caregiver_ed='currently enrolled and attending school')  CGEducationalID1=12.
*if (a_caregiver_ed='not applicable')  CGEducationalID1=11.

/* value 11 is "missing" */

/* no caregiver ed info in minimum standard dataset */
/* don't need this line of code */ 
*RECODE b_caregiver_ed  ('associates degree'=6) 
 ('bachelors degree'=7) ('did not complete high school'=1)  ('doctoral degree'=10) ("don't know"=12) 
 ('ged or alternative credential'=3) 
 ('high school diploma'=2) ('masters degree'=8) 
 ('no degree'=5) ('no schooling completed'=0) 
 ('some college credit'=4) 
 ('professional degree beyond bachelors'=9) INTO  CGEducationalID2.

*if (b_caregiver_ed='currently enrolled and attending school')  CGEducationalID2=12.
*if (b_caregiver_ed='not applicable')  CGEducationalID2=11.

/* value 11 is "missing" */

/* will need to split this variable into */
/* ASQScreeningAdministrators and */
/* ASQSEScreeningAdministrators */

RECODE administered_by ('child welfare staff'=0) 
 ('county mh/mr'=3) ("don't know"=5) ('early intervention'=1)  ('early intervention provider'=1)  ('other'=4) INTO ConductedScreen.
/* value 2 is "missing" */

/* they aren't using these fields in this way */

* RECODE aoc_communication ('no'=2)  ('not applicable'=-8) ('yes'=1)  ('missing'=6) ("don't know"=7) INTO  CommunicationCon.
/* value 6 is "missing" */
/* value 7 is "don't know" */

* RECODE aoc_grossmotor ('no'=2) ('not applicable'=-8) ('yes'=1)  ('missing'=6) ("don't know"=7) INTO GrossMotorConcerns.

* RECODE aoc_finemotor ('no'=2) ('not applicable'=-8) ('yes'=1)  ('missing'=6) ("don't know"=7) INTO FineMotorConcerns.

* RECODE aoc_problemsolving  ('no'=2) ('not applicable'=-8) ('yes'=1)  ('missing'=6) ("don't know"=7) INTO ProblemSolvingConcern.

* RECODE aoc_personalsocial  ('no'=2) ('not applicable'=-8) ('yes'=1)  ('missing'=6) ("don't know"=7) INTO PersonalSocialConcern.

RECODE aoc_asqse ('no'=0) ('not applicable'=-8) ('yes'=1)  ('missing'=2) ("don't know"=3) INTO ASQSEConcernTypes.
if (form_type='asq') ASQSEConcernTypes=$sysmis.

RECODE nicu ("don't know"=3) ('no'=2)  ('yes'=1) INTO NICUnum.
/* value 4 is "missing" */
execute.
delete variables nicu.
rename variables (NICUnum=NICU).

/* no DevelopmentCondition info in minimum standard dataset */
/* don't need this line of code */ 
* RECODE diagnosed_condition ("don't know"=3) ('no'=2) ('yes'=1) INTO  DevelopmentCondition.

/* NEW CODES */
/* for the domain scores that weren't previously collected */
*RECODE communication_score (convert) ('not applicable'=sysmis) INTO DS_Communication.



DEFINE macdef (!positional !tokens(1) / !positional !tokens(1))
RECODE !1 (convert) ('not applicable'=sysmis) INTO !2.
EXECUTE.

!ENDDEFINE.

macdef communication_score DS_Communication.
macdef grossmotor_score DS_GrossMotor.
macdef finemotor_score DS_FineMotor.
macdef problemsolving_score DS_ProblemSolving.
macdef personalsocial_score DS_PersonalSocial.

/* put the other ASQ domains here */
macdef asqse_score DS_ASQSE.

/* put the date for screening here */
/* all values for date of screening are numbers */
/* no values of 'not applicable' for date of screening */
/* macdef date_of_screening datescreeningnum. */

macdef referral_date datereferralnum.
COMPUTE CountyID=51.