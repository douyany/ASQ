/* this do-file checks what the number of consecutive */
/* non-missing values are during the ASQ and ASQ:SE follow-up surveys */

/* checking for ASQ */
/* yes and no are 1 and 2 */


compute uptowhereASQ=0.
compute canstayASQ=1.

define !checkitasq ()
!do !j=1 !to 8.

!let !whcon=!concat(CommunicationCon, !j)

/* now checking the values */

/* is the value either yes or no */
if (canstayASQ=1 and (!whcon=1 or !whcon=2)) uptowhereASQ=!j.
if ((!whcon<>1 and !whcon<>2)) canstayASQ=0.
if (missing(!whcon)) canstayASQ=0.

freq vars=canstayASQ.

crosstabs 
 /tables=!whcon by canstayASQ
 /missing=include.

!doend.
!enddefine.

!checkitasq.



/* checking for ASQ:SE */
/* yes and no are 0 and 1 */

compute uptowhereASQSE=0.
compute canstayASQSE=1.

define !checkitasqse ()
!do !j=1 !to 8.

!let !whcon=!concat(SEConcernTypes, !j)

/* now checking the values */

/* is the value either yes or no */
if (canstayASQSE=1 and (!whcon=0 or !whcon=1)) uptowhereASQSE=!j.
if ((!whcon<>0 and !whcon<>1)) canstayASQSE=0.
if (missing(!whcon)) canstayASQSE=0.

freq vars=canstayASQSE.

crosstabs 
 /tables=!whcon by canstayASQSE
 /missing=include.

!doend.
!enddefine.

!checkitasqse.




/* checking for either ASQ or ASQ:SE */
/* yes and no are 0 and 1 */

compute uptowhereeither=0.
compute canstayeither=1.

define !checkiteither ()
!do !j=1 !to 8.

!let !whcon=!concat(ASQorSEConcerns, !j)

/* now checking the values */

/* is the value either yes or no */
if (canstayeither=1 and (!whcon=0 or !whcon=1)) uptowhereeither=!j.
if ((!whcon<>0 and !whcon<>1)) canstayeither=0.
if (missing(!whcon)) canstayeither=0.

freq vars=canstayeither.

crosstabs 
 /tables=!whcon by canstayeither
 /missing=include.

!doend.
!enddefine.

!checkiteither.

