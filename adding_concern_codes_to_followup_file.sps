/* starts from the file called */
/* 'H:\prep_files\followup_file\followup_incl_highernums.sav' */

/* number of follow-up screenings by assessment */

/* ASQ */
/* ASQ:SE */
DESCRIPTIVES VARIABLES=ASQ2Date ASQ3Date ASQ4Date ASQ5Date ASQ6Date ASQ7Date ASQ8Date ASQ9Date ASQ10Date SE2Date SE3Date SE4Date
  /STATISTICS=MEAN STDDEV MIN MAX.


/* reorder the variables */

Add files file=* /keep ChildID 
 ASQ2Concern1 ASQ2Concern2 ASQ2Concern3 ASQ2Concern4 ASQ2Concern5
 ASQ3Concern1 ASQ3Concern2 ASQ3Concern3 
 ASQ4Concern1 ASQ4Concern2 ASQ4Concern3 
 ASQ5Concern1 ASQ5Concern2 ASQ5Concern3 
 ASQ6Concern1 ASQ6Concern2 ASQ6Concern3 
 ASQ7Concern1 ASQ7Concern2 ASQ7Concern3 
 ASQ8Concern1 ASQ8Concern2 ASQ8Concern3  
 SE2ConcernTypes
 SE3ConcernTypes
 SE4ConcernTypes
 all. 














DEFINE !addconc (whcon = !TOKENS(1) / relcode = !TOKENS(1)) 
 
compute !whcon=$sysmis.
DO REPEAT V# = ASQ2Concern1 to ASQ2Concern5. 
if (V# = !relcode and sysmis(!whcon))  !whcon = 1.
END REPEAT.

!ENDDEFINE.

set mprint on.



/* when there's multiple values in  */
/* the concern types fields */
!addconc whcon=CommCon2 relcode=0.
!addconc whcon=FineCon2 relcode=1.
!addconc whcon=GrosCon2 relcode=2.
/* No Concerns */
!addconc whcon=NoCon2 relcode=3.
!addconc whcon=PerCon2 relcode=4.
!addconc whcon=ProbCon2 relcode=5.


/* will do for both Venango and Dauphin */
/* people with more than one concern */
/* none with more than 1 concern for Venango, though */
if (NoCon2=1) More1Concern2=2.

/* when concern types is a number*/
/* like it is in Venango */
if (ASQ2Concern1=6) More1Concern2=6.
if (ASQ2Concern1=7) More1Concern2=7.

if (sysmis(ASQ2Date)) More1Concern2=-8.

/* if more than one valid value */
if (nvalid(CommCon2, FineCon2, GrosCon2, PerCon2, ProbCon2)>1) More1Concern2=1.
/* only one concern */
if (nvalid(CommCon2, FineCon2, GrosCon2, PerCon2, ProbCon2)=1) More1Concern2=2.

/* will do for both Venango and Dauphin */
/* add the missings, don't knows,  */
/* not applicables */

DO REPEAT V# = CommCon2 to ProbCon2. 
/* when concern types is a number*/
if (ASQ2Concern1=6)  V# =6.
if (ASQ2Concern1=7)  V# =7.

if (sysmis(V#) and sysmis(ASQ2Date)) V#=-8.
END REPEAT.

/* will do for both Venango and Dauphin */
/* add the no's  */


/* start adding the "no" responses */
DO REPEAT V# = CommCon2 to ProbCon2. 
if (sysmis(V#) and sysmis(ASQ2Date)=0) V#=2.
END REPEAT.

execute.

/* designate user-missing values  */
DO REPEAT V# = CommCon2 to More1Concern2. 
MISSING VALUES V# (-8, 6, 7).
END REPEAT.


/* Do the renames to get the same names */
/* As in the other datasets */
rename variables 
	(CommCon2=CommunicationCon2)
	(FineCon2=FineMotorConcern2)
	(GrosCon2=GrossMotorConcerns2)
	(NoCon2=NoConcerns2)
	(PerCon2=PersonalSocialConcern2)
	(ProbCon2=ProblemSolvingConcern2).

/* add labels for variables */
value labels CommunicationCon2 TO More1Concern2 -8 'Not Applicable'
	1 'Yes'
	2 'No'
	6 'Missing'
	7 "Don't Know".





/* Changing names of the variables */
rename variables (ASQ3Concern1=ASQConcern13)  (ASQ3Concern2=ASQConcern23)  (ASQ3Concern3=ASQConcern33).
 
rename variables  (ASQ4Concern1=ASQConcern14)  (ASQ4Concern2=ASQConcern24)  (ASQ4Concern3=ASQConcern34).

rename variables (ASQ5Concern1=ASQConcern15)  (ASQ5Concern2=ASQConcern25)  (ASQ5Concern3=ASQConcern35).


rename variables  (ASQ6Concern1=ASQConcern16)  (ASQ6Concern2=ASQConcern26)  (ASQ6Concern3=ASQConcern36).

rename variables  (ASQ7Concern1=ASQConcern17)  (ASQ7Concern2=ASQConcern27)  (ASQ7Concern3=ASQConcern37).
rename variables (ASQ8Concern1=ASQConcern18)  (ASQ8Concern2=ASQConcern28)  (ASQ8Concern3=ASQConcern38).

rename variables   (ASQ3Date=ASQDate3)   (ASQ4Date=ASQDate4)  (ASQ5Date=ASQDate5)  (ASQ6Date=ASQDate6)  (ASQ7Date=ASQDate7)
 (ASQ8Date=ASQDate8) .



/* Doing the higher assessment numbers */
/* code from */
/* http://www.pressingquestion.com/2551550/Spss-Macro-To-Automate-Sequential-Variable-References */


DEFINE !addconc (whcon = !TOKENS(1) / relcode = !TOKENS(1)) 
!do !j=3 !to 8.

!let !base_stub=!concat(!whcon, !j)

compute !base_stub=$sysmis.

!do !i=1 !to 3.



*vector stat= !concat('ASQConcern', !i, !j).

!let !checkme=!concat('ASQConcern', !i, !j)

if (!checkme = !relcode and sysmis(!base_stub)) !base_stub = 1.

!doend. 


!doend.

!ENDDEFINE.



/* when there's multiple values in  */
/* the concern types fields */
!addconc whcon=CommCon relcode=0.
!addconc whcon=FineCon relcode=1.
!addconc whcon=GrosCon relcode=2.
/* No Concerns */
!addconc whcon=NoCon relcode=3.
!addconc whcon=PerCon relcode=4.
!addconc whcon=ProbCon relcode=5.




/* code from */
/* https://groups.google.com/forum/#!topic/comp.soft-sys.stat.spss/_7CUsyU_ReY */

define myloops ()

!do !j=3 !to 8.

!let !base_stub=!concat(More1Concern, !j)
!let !checkme=!concat(NoCon, !j)
!let !asqone=!concat(ASQConcern1, !j)
!let !asqdate=!concat(ASQDate, !j)
!let !commchk=!concat(CommCon, !j)
!let !finechk=!concat(FineCon, !j)
!let !groschk=!concat(GrosCon, !j)
!let !perchk=!concat(PerCon, !j)
!let !probchk=!concat(ProbCon, !j)
!let !commlongchk=!concat(CommunicationCon, !j)
!let !finelongchk=!concat(FineMotorConcern, !j)
!let !groslongchk=!concat(GrossMotorConcerns, !j)
!let !perlongchk=!concat(PersonalSocialConcern, !j)
!let !problongchk=!concat(ProblemSolvingConcern, !j)
!let !checklongme=!concat(NoConcerns, !j)

/* will do for both Venango and Dauphin */
/* people with more than one concern */
/* none with more than 1 concern for Venango, though */
if (!checkme=1) !base_stub=2.

/* when concern types is a number*/
/* like it is in Venango */
if (!asqone=6) !base_stub=6.
if (!asqone=7) !base_stub=7.

if (sysmis(!asqdate)) !base_stub=-8.

/* if more than one valid value */
if (nvalid(!commchk, !finechk, !groschk, !perchk, !probchk)>1) !base_stub=1.
/* only one concern */
if (nvalid(!commchk, !finechk, !groschk, !perchk, !probchk)=1) !base_stub=2.

do repeat V# = !commchk  !finechk  !groschk  !perchk  !probchk.
if (!asqone = 6) V# = 6.
if (!asqone = 7) V# = 7.


if (sysmis(V#) and sysmis(!asqdate)) V#=-8.

/* start adding the "no" responses */
if (sysmis(V#) and sysmis(!asqdate)=0) V#=2.

execute.

/* designate user-missing values  */
MISSING VALUES V# (-8, 6, 7).

/* Do the renames to get the same names */
/* As in the other datasets */




end repeat.


rename variables (!commchk=!commlongchk)
	 (!finechk=	!finelongchk)
	 (!groschk=	!groslongchk)
	 (!checkme=	!checklongme)
	 (!perchk=	!perlongchk)
	 (!probchk=	!problongchk)


!doend.
*execute.
!enddefine.

myloops.

/*
*	if (ChildID >=2981 ) !commlongchk=!commchk.
*	if (ChildID >=2981 ) !finelongchk=	!finechk.
*	if (ChildID >=2981 ) !groslongchk=	!groschk.
*	if (ChildID >=2981 ) !checklongme=	!checkme.
*	if (ChildID >=2981 ) !perlongchk=	!perchk.
*	if (ChildID >=2981 ) !problongchk=	!probchk.
*/

/* reorder the variables */

Add files file=* /keep ChildID 
 CommunicationCon3 
 FineMotorConcern3 
 GrossMotorConcerns3 
 PersonalSocialConcern3 
 ProblemSolvingConcern3 
 NoConcerns3 
 More1Concern3 
 CommunicationCon4 
 FineMotorConcern4 
 GrossMotorConcerns4 
 PersonalSocialConcern4 
 ProblemSolvingConcern4 
 NoConcerns4 
 More1Concern4 
 CommunicationCon5 
 FineMotorConcern5 
 GrossMotorConcerns5 
 PersonalSocialConcern5 
 ProblemSolvingConcern5 
 NoConcerns5 
 More1Concern5 
 CommunicationCon6 
 FineMotorConcern6 
 GrossMotorConcerns6 
 PersonalSocialConcern6 
 ProblemSolvingConcern6 
 NoConcerns6 
 More1Concern6 
 CommunicationCon7 
 FineMotorConcern7 
 GrossMotorConcerns7 
 PersonalSocialConcern7 
 ProblemSolvingConcern7 
 NoConcerns7 
 More1Concern7 
 CommunicationCon8 
 FineMotorConcern8 
 GrossMotorConcerns8 
 PersonalSocialConcern8 
 ProblemSolvingConcern8 
 NoConcerns8 
 More1Concern8 
 all. 


/* add labels for variables */
value labels CommunicationCon3  TO More1Concern8 -8 'Not Applicable' 	1 'Yes'
	2 'No'
	6 'Missing'
	7 "Don't Know".




/*
*Add ASQ:SE concern codes .
*/


Add files file=* /keep ChildID SE2ConcernTypes SE3ConcernTypes SE4ConcernTypes SE5ConcernTypes SE6ConcernTypes SE7ConcernTypes SE8ConcernTypes  all.

execute.

/* set 'missing' and "don't know" values to user-missing values */
MISSING VALUES SE2ConcernTypes to SE8ConcernTypes (2,3).

/* ASQ:SE concerns */

value labels SE2ConcernTypes to SE8ConcernTypes  0 'no referral indicated' 1 'yes referral indicated' 2 'missing' 3 "don't know".




/*
*Add about whether concern on ASQ or ASQ:SE codes .
*/

Add files file=* /keep ChildID SE2ConcernTypes SE3ConcernTypes SE4ConcernTypes SE5ConcernTypes SE6ConcernTypes SE7ConcernTypes SE8ConcernTypes CommunicationCon2 
 FineMotorConcern2 
 GrossMotorConcerns2 
 PersonalSocialConcern2 
 ProblemSolvingConcern2 
 NoConcerns2 
 More1Concern2 
  CommunicationCon3 
 FineMotorConcern3 
 GrossMotorConcerns3 
 PersonalSocialConcern3 
 ProblemSolvingConcern3 
 NoConcerns3 
 More1Concern3 
 CommunicationCon4 
 FineMotorConcern4 
 GrossMotorConcerns4 
 PersonalSocialConcern4 
 ProblemSolvingConcern4 
 NoConcerns4 
 More1Concern4 
 CommunicationCon5 
 FineMotorConcern5 
 GrossMotorConcerns5 
 PersonalSocialConcern5 
 ProblemSolvingConcern5 
 NoConcerns5 
 More1Concern5 
 CommunicationCon6 
 FineMotorConcern6 
 GrossMotorConcerns6 
 PersonalSocialConcern6 
 ProblemSolvingConcern6 
 NoConcerns6 
 More1Concern6 
 CommunicationCon7 
 FineMotorConcern7 
 GrossMotorConcerns7 
 PersonalSocialConcern7 
 ProblemSolvingConcern7 
 NoConcerns7 
 More1Concern7 
 CommunicationCon8 
 FineMotorConcern8 
 GrossMotorConcerns8 
 PersonalSocialConcern8 
 ProblemSolvingConcern8 
 NoConcerns8 
 More1Concern8 
 all.

/* remove the designations of missing */
/* to be able to do the match */

execute.

/* designate user-missing values  */
DO REPEAT V# = SE2ConcernTypes TO More1Concern8. 
MISSING VALUES V# ().
END REPEAT.


/* rename variables, so that they can be in a loop */
rename variables (SE2ConcernTypes=SEConcernTypes2) (SE3ConcernTypes=SEConcernTypes3) (SE4ConcernTypes=SEConcernTypes4) (SE5ConcernTypes=SEConcernTypes5) (SE6ConcernTypes=SEConcernTypes6) (SE7ConcernTypes=SEConcernTypes7) (SE8ConcernTypes=SEConcernTypes8) .


/*
*value labels ASQSEConcernTypes 0 'no referral indicated' 1 'yes referral indicated' 2 'missing' 3 "don't know".
*/

/*
*value labels CommunicationCon TO More1Concern -8 'Not Applicable'
	1 'Yes'
	2 'No'
	6 'Missing'
	7 "Don't Know".
*/

/* concern on either ASQ or ASQ:SE */
/* who gets included in the denominator? */


***stopped here on Oct. 29.






define myhoops ()

!do !j=2 !to 8.
!let !base_stub=!concat(More1Concern, !j)
!let !commlongchk=!concat(CommunicationCon, !j)
!let !finelongchk=!concat(FineMotorConcern, !j)
!let !groslongchk=!concat(GrossMotorConcerns, !j)
!let !perlongchk=!concat(PersonalSocialConcern, !j)
!let !problongchk=!concat(ProblemSolvingConcern, !j)
!let !checklongme=!concat(NoConcerns, !j)
!let !eithercon=!concat(ASQorSEConcerns, !j)
!let !SEcon=!concat(SEConcernTypes, !j)

/* if the ASQ concerns are don't know (7) */
/* then ASQorASQSE is don't know (3)*/
/* start adding the "no" responses */

do repeat V# = !commlongchk  !finelongchk  !groslongchk  !perlongchk  !problongchk.
if (V#=7) !eithercon=3.
end repeat.

/* if the ASQ:SE concerns are don't know (3) */
/* then ASQorASQSE is don't know (3)*/

if (!SEcon=3) !eithercon=3.




/* if the ASQ concerns are missing (6) */
/* then ASQorASQSE is don't know (3)*/

do repeat V# = !commlongchk  !finelongchk  !groslongchk  !perlongchk  !problongchk.
if (V#=6) !eithercon=3.
end repeat.

/* if the ASQ:SE concerns are missing (2) */
/* then ASQorASQSE is don't know (3)*/

if (!SEcon=2) !eithercon=3.

/* if ASQ is present, but ASQ:SE is not present */
/* gets to be included in denominator */

/* if ASQ:SE is present, but ASQ is not present */
/* gets to be included in denominator */

/* if either ASQ or ASQ:SE is yes, */
/* then ASQorASQSE is yes */
do repeat V# = !commlongchk  !finelongchk  !groslongchk  !perlongchk  !problongchk.
if (V#=1) !eithercon=1.
end repeat.

if (!SEcon=1) !eithercon=1.

/* if one is missing and the other is no */
/* then ASQorASQSE is missing */

/* if one is not applicable and the other is no */
/* then ASQorASQSE is no */

/* ASQ not applicable and ASQ:SE a no */
do repeat V# = !commlongchk  !finelongchk  !groslongchk  !perlongchk  !problongchk.
if (V#=-8 and !SEcon=0) !eithercon=0.
end repeat.

/* if both are no */
compute otherthanno=$sysmis.
/* valid values would be yes or no to create the denom */
if (!commlongchk=1) otherthanno=0.
if (!commlongchk=2) otherthanno=0.
do repeat V# = !commlongchk  !finelongchk  !groslongchk  !perlongchk  !problongchk.
if (V#~=2) otherthanno=1.
END REPEAT.

/* all ASQ values are no and SE value is no */
if (otherthanno=0 AND !SEcon=0) !eithercon=0.

/* one or the other is missing */

/* commented out this one */
/* if have all values missing, already have a line for  */
/* when ASQ equals six */
*if (nmiss(!commlongchk,  !finelongchk,  !groslongchk,  !perlongchk,  !problongchk)=5) !eithercon=3.
if (otherthanno=0 AND sysmis(!SEcon)) !eithercon=0.

/* add labels for ASQ or ASQ:SE variable */
value labels !eithercon 1 'yes' 0 'no' 2 'missing' 3 'don''t know'.

execute.
/* set 'missing' values to user-missing values */
MISSING VALUES !eithercon (2,3).


/* restore the designations of missing */



/* designate user-missing values  */
DO REPEAT V# = !commlongchk  !finelongchk  !groslongchk  !perlongchk  !problongchk.
MISSING VALUES V# (-8, 6, 7).
END REPEAT.

/* set 'missing' and "don't know" values to user-missing values */
MISSING VALUES !SEcon (2,3).

!doend.
*execute.
!enddefine.

myhoops.


/* create the any concerns variable

define myjoops ()

!do !j=2 !to 8.
!let !checklongme=!concat(NoConcerns, !j)
!let !anyconc=!concat(AnyConcerns, !j)

execute.
MISSING VALUES !checklongme ().
execute.

compute !anyconc=!checklongme.

/*yes, have no concerns */
/* any concern will be no */
if (!checklongme=1) !anyconc=20.

/*no, do have concerns */
/* any concern will be yes, do have concerns */
if (!checklongme=2) !anyconc=1.
if (!anyconc=20) !anyconc=2.

crosstabs
/tables=!anyconc by !checklongme.

/* add labels for any concerns variable */
value labels !anyconc -8 'Not Applicable'
	1 'Yes'
	2 'No'
	6 'Missing'
	7 "Don't Know".

execute.
MISSING VALUES !checklongme !anyconc (-8, 6, 7).
execute.

!doend.
!enddefine.

myjoops.





sort cases by ChildID.

/* Changing names of the variables */
rename variables (ASQ2Concern1=ASQConcern12)  (ASQ2Concern2=ASQConcern22)  (ASQ2Concern3=ASQConcern32).

rename variables   (ASQ2Date=ASQDate2).

rename variables (SE2Date=SEDate2)
 (SE3Date=SEDate3)
 (SE4Date=SEDate4).



/* file that includes which concerns */
save outfile='H:\prep_files\followup_file\followup_incl_whichcon.sav'.













