match files file='H:\prep_phillyasq\processing_asq\Philly_Followup_plusMay2012.sav' /in=infromasq
 file='H:\prep_phillyasq\processing_asq\Philly_Followup_asqse_sorted.sav' /in=infromasqse
 /by case_number.


/* infromasqse=1: has ASQ:SE */
/* infromasq=1: has ASQ */

DEFINE !addconc ()
!do !j=2 !to 5.

!let !datestub=!concat(ASQDate, !j)
!let !datestub00=!concat(ASQDate, !j, .00)
!let !commlongchk=!concat(CommunicationCon, !j)
!let !finelongchk=!concat(FineMotorConcern, !j)
!let !groslongchk=!concat(GrossMotorConcerns, !j)
!let !perlongchk=!concat(PersonalSocialConcern, !j)
!let !problongchk=!concat(ProblemSolvingConcern, !j)
!let !checklongme=!concat(NoConcerns, !j)
!let !base_stub=!concat(More1Concern, !j)
!let !anyconc=!concat(AnyConcerns, !j)

!let !commlongchk00=!concat(CommunicationCon, !j, .00)
!let !finelongchk00=!concat(FineMotorConcern, !j, .00)
!let !groslongchk00=!concat(GrossMotorConcerns, !j, .00)
!let !perlongchk00=!concat(PersonalSocialConcern, !j, .00)
!let !problongchk00=!concat(ProblemSolvingConcern, !j, .00)
!let !checklongme00=!concat(NoConcerns, !j, .00)
!let !base_stub00=!concat(More1Concern, !j, .00)
!let !anyconc00=!concat(AnyConcerns, !j, .00)

rename variables (!datestub00=!datestub)
 (!commlongchk00=!commlongchk) 
 (!finelongchk00=!finelongchk) 
 (!groslongchk00=!groslongchk) 
 (!perlongchk00=!perlongchk) 
 (!problongchk00=!problongchk) 
 (!checklongme00=!checklongme) 
 (!base_stub00=!base_stub) 
 (!anyconc00=!anyconc). 

!doend.
!enddefine.

!addconc.


/* will use values of 0 no, 1 yes 2 missing, 3 don't know */
/* 58 obs. for ASE:SE Concerns */
/* whether ASQ or ASQ:SE Concern */
compute ASQorSEConcerns2=$sysmis.

/* No Concerns is No, Do Have Concerns */
if (NoConcerns2=2) ASQorSEConcerns2=1.

if (SEConcernTypes2=1) ASQorSEConcerns2=1.

/* other values are no */
if (sysmis(ASQorSEConcerns2) and sysmis(SEDate2)=0)  ASQorSEConcerns2=0.

if (sysmis(ASQorSEConcerns2) and sysmis(ASQDate2)=0)  ASQorSEConcerns2=0.

frequencies variables=ASQorSEConcerns2.

value labels ASQorSEConcerns2 1 'Yes'	0 'No' 2 'Missing' 3 'don''t know'.

sort cases by case_number.

/* file that includes both types of concerns */
save outfile='H:\prep_phillyasq\processing_asq\Philly_Followup_ASQandASQSE.sav'.
