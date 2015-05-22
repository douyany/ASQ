/* adding MaltreatmentID */
/* field name in Philly Excel is maltreatment_type */

/* take the one field in the Philly excel file */
/* convert it into one field with commas for the DB */

string MaltreatmentID (A30).
/* code that I want to run */
* if (index(maltreatment_type, 'physical abuse')>0) MaltreatmentID=concat(MaltreatmentID, "0,").

/* the macro to run that code */
define !loop_maltxconcerns (concern=!tokens(1) / whichcode=!tokens(1) )

/* this code works in newer versions of SPSS */
/* if (index(maltreatment_type, !concern)>0) MaltreatmentID=!concat(MaltreatmentID, !whichcode, ",") */

/* this code works on the desktop in the office */
if (index(maltreatment_type, !concern)>0) MaltreatmentID=concat(MaltreatmentID, !quote(!whichcode), ",").
!enddefine

!loop_maltxconcerns concern='physical abuse' whichcode=0.
!loop_maltxconcerns concern='sexual abuse' whichcode=1.
!loop_maltxconcerns concern='physical neglect' whichcode=2.
!loop_maltxconcerns concern='supervisory neglect' whichcode=3.
!loop_maltxconcerns concern='other' whichcode=4.
!loop_maltxconcerns concern='missing' whichcode=6.
!loop_maltxconcerns concern='serious mental/emotional abuse' whichcode=6.
!loop_maltxconcerns concern="don't know" whichcode=7.
!loop_maltxconcerns concern='parenting concerns' whichcode=8.
!loop_maltxconcerns concern='caregiver substance abuse' whichcode=9.
!loop_maltxconcerns concern='lacking basic needs' whichcode=10.
!loop_maltxconcerns concern='failure to protect' whichcode=11.
!loop_maltxconcerns concern='child behavior concerns' whichcode=12.
!loop_maltxconcerns concern='physical maltreatment' whichcode=13.
!loop_maltxconcerns concern='caregiver mental health' whichcode=14.
/* in Dec. 2013 file called it caregivers MH */
!loop_maltxconcerns concern='caregivers mental health' whichcode=14.
!loop_maltxconcerns concern='domestic violence' whichcode=15.
!loop_maltxconcerns concern='homeless' whichcode=16.

/* remove the extra comma at the end of the maltreatment var */
compute lenmaltxConc=len(MaltreatmentID).
if (lenmaltxConc>0) MaltreatmentID=strunc(MaltreatmentID, lenmaltxConc-1).

/* only allowed to split by 8 file variables */
* sort cases by maltreatment_type.
* split file by maltreatment_type.
* freq MaltreatmentID.
* split file off.

compute lenmaltxPH=len(maltreatment_type).
compute lenmaltxDB=len(MaltreatmentID).

crosstabs
 /tables=lenmaltxPH by lenmaltxDB.

/* shouldn't have anything that has a zero length for DB */
/* if it has a non-zero length in PH */  
/* 'not applicable' is length 14 */
string test (a20).
if (lenmaltxPH=14 & lenmaltxDB=0) test=maltreatment_type.

freq vars=test.
