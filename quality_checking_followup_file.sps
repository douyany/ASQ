/* This code checks the desktop followup file */

rename variables (ASQ7ScreeningDate=ASQ7Date)  (ASQ8ScreeningDate=ASQ8Date) 
 (ASQ9ScreeningDate=ASQ9Date) 
 (ASQ10ScreeningDate=ASQ10Date) .


define myfoops ()

!do !j=2 !to 10.

!let !asqone=!concat(ASQ, !j, Concern1)
!let !asqbase=!concat(ASQ, !j, ConcernTypes)
*!let !SEone=!concat(SE, !j, Concern1).
*!let !SEbase=!concat(SE, !j, ConcernTypes).
!let !allincluded=!concat(allincluded, !j)

compute !allincluded=0.
if (!asqbase<>'' & sysmis(!asqone)) !allincluded=1.

frequencies variables=!allincluded.

use all.

FILTER BY !allincluded.
EXECUTE.
frequencies variables=ChildID.
crosstabs
/tables=ChildID by !asqbase .

use all.

!doend.
!enddefine. 

myfoops. 