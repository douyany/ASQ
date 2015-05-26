SET MPRINT=yes /PRINTBACK=yes. 

/*rename vars for the program */
rename variables (ASQ5ScreeningType=ASQ5ScreeningTypes) (ASQ5ConcernType=ASQ5ConcernTypes) (ASQ6ScreeningType=ASQ6ScreeningTypes) (ASQ6ConcernType=ASQ6ConcernTypes)(ASQ7ScreeningType=ASQ7ScreeningTypes) (ASQ7ConcernType=ASQ7ConcernTypes)(ASQ8ScreeningType=ASQ8ScreeningTypes) (ASQ8ConcernType=ASQ8ConcernTypes).


/* code for filter from */
/* http://www.unt.edu/rss/class/SPSS/Examples.htm */

define myboops ()

!do !j=2 !to 8.
!let !base_stub=!concat(ASQreferralstatus, !j, .00)
!let !groslongchk=!concat(ASQ, !j, Date)
!let !perlongchk=!concat(ASQ, !j, ScreeningTypes)
!let !problongchk=!concat(ASQ, !j, ConcernTypes)
!let !checklongme=!concat(Screening, !j, EIReferral)



/* the three concerns per ASQ */
!do !i=1 !to 3.
/* test #2 has up to five concerns */
/* also three Screening Types for ASQ */

!let !commlongchk=!concat(ASQ, !j, concern, !i)
!let !finelongchk=!concat(ASQ, !j, ScreeningType, !i)



if (!groslongchk=date.mdy(12, 31, 9999)) !commlongchk=$sysmis.
if (!groslongchk=date.mdy(12, 31, 9999)) !finelongchk=$sysmis.

!doend.

/* code from http://stackoverflow.com/questions/5358159/cant-assign-missing-value-to-string-in-spss */
/* system-missing doesn't exist for strings */

if (!groslongchk=date.mdy(12, 31, 9999)) !base_stub=$sysmis.
if (!groslongchk=date.mdy(12, 31, 9999)) !perlongchk=''.

/* numbers 2 to 4 are string */
/* numbers 5 to 8 are 
if (!groslongchk=date.mdy(12, 31, 9999)) !problongchk=''.
if (!groslongchk=date.mdy(12, 31, 9999)) !checklongme=$sysmis.

if (!groslongchk=date.mdy(12, 31, 9999) AND !j=2) ASQ2Concern4=$sysmis.
if (!groslongchk=date.mdy(12, 31, 9999) AND !j=2) ASQ2Concern5=$sysmis.

/* change the date to missing */
if (!groslongchk=date.mdy(12, 31, 9999)) !groslongchk=$sysmis.

!doend.

!enddefine.

myboops.


/*return var names for the rest of the code */
rename variables (ASQ5ScreeningTypes=ASQ5ScreeningType) (ASQ5ConcernTypes=ASQ5ConcernType) (ASQ6ScreeningTypes=ASQ6ScreeningType) (ASQ6ConcernTypes=ASQ6ConcernType)(ASQ7ScreeningTypes=ASQ7ScreeningType) (ASQ7ConcernTypes=ASQ7ConcernType)(ASQ8ScreeningTypes=ASQ8ScreeningType)  (ASQ8ConcernTypes=ASQ8ConcernType).

set mprint off.