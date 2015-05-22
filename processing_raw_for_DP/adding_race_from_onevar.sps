/* It is desirable to capture the racial information */
/* for the youth with multiple values */
/* if the youth is multi-racial */
/* instead of putting this person into "other" */

/* This code will add the multiple values for the RaceID */

/* code from when was only using one value */

/* 8 used to be mixed race */
/* now 4 is the code for other */
/* formerly converted into Racevar */
/* now called RaceID */
* RECODE race ('asian'=2)  ('asian^black'=4)
 ('black'=0)   ('black^asian'=4) ('black^indian/ala'=4) ('black^white'=4) 
 ("don't know"=6)
 ('white'=3) ('white^black'=4)  ('white^hawaiian/pacific islander'=4)
   INTO RaceID.

* execute.


/* adding RaceID */
/* field name in Philly Excel is race */

/* take the one field in the Philly excel file */
/* convert it into one field with commas for the DB */

string RaceID (A10).
/* code that I want to run */
* if (index(race, 'asian')>0) RaceID=concat(RaceID, "2,").

/* the macro to run that code */
define !loop_racecoding (concern=!tokens(1) / whichcode=!tokens(1) )

/* this code works in newer versions of SPSS */
/* if (index(maltreatment_type, !concern)>0) MaltreatmentID=!concat(MaltreatmentID, !whichcode, ",") */

/* this code works on the desktop in the office */
if (index(race, !concern)>0) RaceID=concat(RaceID, !quote(!whichcode), ",").
!enddefine

!loop_racecoding concern='black' whichcode=0.
!loop_racecoding concern='indian/ala' whichcode=1.
!loop_racecoding concern='asian' whichcode=2.
!loop_racecoding concern='white' whichcode=3.
!loop_racecoding concern='other' whichcode=4.
!loop_racecoding concern='hawaiian/pacific islander' whichcode=5.

!loop_racecoding concern="don't know" whichcode=6.


/* remove the extra comma at the end of the maltreatment var */
compute lenraceConc=len(RaceID).
if (lenraceConc>0) RaceID=strunc(RaceID, lenraceConc-1).

/* only allowed to split by 8 file variables */
* sort cases by maltreatment_type.
* split file by maltreatment_type.
* freq MaltreatmentID.
* split file off.

compute lenmaltxPH2=len(race).
compute lenmaltxDB2=len(RaceID).

crosstabs
 /tables=lenmaltxPH2 by lenmaltxDB.

crosstabs
 /tables=RaceID by race.

crosstabs
 /tables=race by RaceID.

/* shouldn't have anything that has a zero length for DB */
/* if it has a non-zero length in PH */  
/* 'not applicable' is length 14 */
string test2 (a20).
if (lenmaltxPH2=14 & lenmaltxDB2=0) test2=race.

freq vars=test2.
 