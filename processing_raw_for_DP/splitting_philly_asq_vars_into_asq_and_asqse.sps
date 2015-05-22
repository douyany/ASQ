/* if (form_type='asq') ASQScreeningDate=datescreeningnum. */
/* if (form_type='asq-se') ASQSEScreeningDate=datescreeningnum. */

/* in December 2013 file */
/* is already in date format */
/* not a string */
if (form_type='asq') ASQScreeningDate=date_of_screening.
if (form_type='asq-se') ASQSEScreeningDate=date_of_screening.

format ASQScreeningDate (adate11).
format ASQSEScreeningDate (adate11).

if (form_type='asq') ASQScreeningAdministrator=ConductedScreen.
if (form_type='asq-se') ASQSEScreeningAdministrator=ConductedScreen.

*if (form_type='asq') ASQScreeningTool=asq_qtype.
*if (form_type='asq-se') ASQSEScreeningTool=asq_qtype.

/* what I want to accomplish */
*if (asq_qtype='2 month questionnaire') ASQScreeningTool=1.
compute ASQScreeningTool=$sysmis.

define !addASQscreentool  (whichmonth=!tokens(1) / whichcode=!tokens(1) )

if (asq_qtype=!whichmonth) ASQScreeningTool=!whichcode.

!enddefine

!addASQscreentool whichmonth='2 month asq' whichcode=1.
!addASQscreentool whichmonth='4 month asq' whichcode=2.
!addASQscreentool whichmonth='6 month asq' whichcode=3.
!addASQscreentool whichmonth='8 month asq' whichcode=4.
!addASQscreentool whichmonth='9 month asq' whichcode=5.
!addASQscreentool whichmonth='10 month asq' whichcode=6.
!addASQscreentool whichmonth='12 month asq' whichcode=7.
!addASQscreentool whichmonth='14 month asq' whichcode=8.
!addASQscreentool whichmonth='16 month asq' whichcode=9.
!addASQscreentool whichmonth='18 month asq' whichcode=10.
!addASQscreentool whichmonth='20 month asq' whichcode=11.
!addASQscreentool whichmonth='22 month asq' whichcode=12.
!addASQscreentool whichmonth='24 month asq' whichcode=13.
!addASQscreentool whichmonth='27 month asq' whichcode=14.
!addASQscreentool whichmonth='30 month asq' whichcode=15.
!addASQscreentool whichmonth='33 month asq' whichcode=16.
!addASQscreentool whichmonth='36 month asq' whichcode=17.
!addASQscreentool whichmonth='42 month asq' whichcode=18.
!addASQscreentool whichmonth='48 month asq' whichcode=19.
!addASQscreentool whichmonth='54 month asq' whichcode=20.
!addASQscreentool whichmonth='60 month asq' whichcode=21.

compute ASQSEScreeningTool=$sysmis.

define !addASQSEscreentool  (whichmonth=!tokens(1) / whichcode=!tokens(1) )

if (asq_qtype=!whichmonth) ASQSEScreeningTool=!whichcode.

!enddefine

!addASQSEscreentool whichmonth='6 month asq-se' whichcode=1.
!addASQSEscreentool whichmonth='12 month asq-se' whichcode=2.
!addASQSEscreentool whichmonth='18 month asq-se' whichcode=3.
!addASQSEscreentool whichmonth='24 month asq-se' whichcode=4.
!addASQSEscreentool whichmonth='30 month asq-se' whichcode=5.
!addASQSEscreentool whichmonth='36 month asq-se' whichcode=6.
!addASQSEscreentool whichmonth='48 month asq-se' whichcode=7.
!addASQSEscreentool whichmonth='60 month asq-se' whichcode=8.


if (form_type='asq') ASQEarlyInterventionReferralDate=datereferralnum.
if (form_type='asq-se') ASQSEEarlyInterventionReferralDate=datereferralnum.
/* from http://spssx-discussion.1045642.n5.nabble.com/Excel-to-SPSS-dates-garbled-td1072529.html */
/* only need minus one rather than minus two */
compute ASQEarlyInterventionReferralDate=date.dmy(1,1,1900)+ (ASQEarlyInterventionReferralDate-1)*60*60*24. 
compute ASQSEEarlyInterventionReferralDate=date.dmy(1,1,1900)+ (ASQSEEarlyInterventionReferralDate-1)*60*60*24. 
format ASQEarlyInterventionReferralDate (adate11).
format ASQSEEarlyInterventionReferralDate (adate11).
