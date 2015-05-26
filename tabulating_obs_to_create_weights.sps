/* create the tabulations of observations by county */
/* to get the weights for the tabulations */

/* will go through each of the ASQ Concerns in turn */
/* then SE Concern */
/* then ASQorSE concern */

DEFINE !addconc (whcon = !TOKENS(1) / lownum = !TOKENS(1) / highnum = !TOKENS(1))

!let !whcon1=!concat(!whcon, 1)
!let !whcon2=!concat(!whcon, 2)

use all.

/* has valid values for both the first and second assessments */ 
COMPUTE filter_$=((!whcon1= !lownum OR !whcon1 = !highnum) and (!whcon2 = !lownum OR !whcon2 = !highnum)).
VARIABLE LABELS filter_$ 'Yes or No for !whcon'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
 
frequencies variables=!whcon1 !whcon2.

frequencies variables=CountyID.

use all.
!ENDDEFINE.

set mprint on.



/* when there's multiple values in  */
/* the concern types fields */
!addconc whcon=CommunicationCon lownum=1 highnum=2.
!addconc whcon=FineMotorConcern lownum=1 highnum=2.
!addconc whcon=GrossMotorConcerns lownum=1 highnum=2.
!addconc whcon=PersonalSocialConcern lownum=1 highnum=2.
!addconc whcon=ProblemSolvingConcern lownum=1 highnum=2.
!addconc whcon=More1Concern lownum=1 highnum=2.
!addconc whcon=AnyConcerns lownum=1 highnum=2.

!addconc whcon=SEConcernTypes lownum=0 highnum=1.
!addconc whcon=ASQorSEConcerns lownum=0 highnum=1.
