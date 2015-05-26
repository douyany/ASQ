/* this do-file checks up to which assessment has a value */
/* for the ASQ concerns */
/* and */
/* for the ASQ:SE concerns */

/* prior project had only been looking */
/* at 1st and 2nd assessments */
/* */
/* I wanted to check what the upper limit would be */

/* tabulating higher frequencies */

/* go from 3 to the end */
DEFINE !tabconc (whcon = !TOKENS(1) 

!do !j=3 !to 10.

!let !whcon1=!concat(!whcon, !j)


frequencies variables=!whcon1.

!doend.
!ENDDEFINE.


/* got from someone who apparently works for SPSS */
/* http://web.uvic.ca/~cass/spss-macros.html#M2 */

DEFINE @VLOOP@ (@VARS@ !ENCLOSE('(',')')  )
!DO !V !IN (!@VARS@)
!do !j=3 !to 10.
!let !whcon1=!concat(!V, !j)
FREQUENCIES !whcon1.
!DOEND.
!DOEND.
!ENDDEFINE .

@VLOOP@ @VARS@ (CommunicationCon FineMotorConcern GrossMotorConcerns).
@VLOOP@ @VARS@ (PersonalSocialConcern ProblemSolvingConcern).
@VLOOP@ @VARS@ SEConcernTypes.

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
