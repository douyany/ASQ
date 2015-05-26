frequencies variables=CommunicationCon1 CommunicationCon2 SEConcernTypes1 SEConcernTypes2.

compute havebothComms=0.
if 

compute missingComm1haveComm2=0.
if (sysmis(CommunicationCon1) and CommunicationCon2=1) missingComm1haveComm2=1.
if (sysmis(CommunicationCon1) and CommunicationCon2=2) missingComm1haveComm2=2.

frequencies variables=missingComm1haveComm2.

compute missingMore1haveComm2=0.
if (CommunicationCon2=1 and (More1Concern2=0)) missingMore1haveComm2=7.
if (CommunicationCon2=1 and (More1Concern2=1)) missingMore1haveComm2=8.

if (CommunicationCon2=1 and (More1Concern2=2)) missingMore1haveComm2=1.
if (CommunicationCon2=1 and (More1Concern2=3)) missingMore1haveComm2=2.
if (CommunicationCon2=1 and sysmis(More1Concern2)) missingMore1haveComm2=5.
if (CommunicationCon2=2 and (More1Concern2=2)) missingMore1haveComm2=3.
if (CommunicationCon2=2 and (More1Concern2=3)) missingMore1haveComm2=4.
if (CommunicationCon2=2 and (More1Concern2=0)) missingMore1haveComm2=9.
if (CommunicationCon2=2 and (More1Concern2=1)) missingMore1haveComm2=10.

if (CommunicationCon2=2 and sysmis(More1Concern2)) missingMore1haveComm2=6.

frequencies variables=missingMore1haveComm2.

compute includedintab=0.
if ((More1Concern1=1 or More1Concern1=2) and (More1Concern2=1 or More1Concern2=2)) includedintab=1.

compute reverseincludedintab=1.
if ((More1Concern1=1 or More1Concern1=2) and (More1Concern2=1 or More1Concern2=2)) reverseincludedintab=0.
if (countyID<>11 and countyID<>49) reverseincludedintab=0.
if (sysmis(CommunicationCon2)) reverseincludedintab=0.
if (sysmis(CommunicationCon1)) reverseincludedintab=0.
if (countvalid2<5) reverseincludedintab=0.
/* 4 obs at this point */


frequencies variables=reverseincludedintab.

use all.
filter by reverseincludedintab.
execute.
frequencies variables=CommunicationCon2 to ProblemSolvingConcern2.
use all.

use all.
filter by reverseincludedintab.
execute.
frequencies variables=ChildID.
use all.


frequencies variables=includedintab.

use all.
filter by includedintab.
execute.
frequencies variables=CommunicationCon2 to ProblemSolvingConcern2.
use all.


end repeat.
crosstabs
/tables=missingMore1haveComm2 by ASQorSEConcerns2  .

compute missingeither2haveASQ2=0.
if (sysmis(ASQorSEConcerns2) and CommunicationCon=1) missingeither2haveASQ2=1.
if (sysmis(ASQorSEConcerns2) and CommunicationCon=2) missingeither2haveASQ2=4.
if (sysmis(ASQorSEConcerns2) and SEConcernTypes2=0) missingeither2haveASQ2=2.
if (sysmis(ASQorSEConcerns2) and SEConcernTypes2=1) missingeither2haveASQ2=3.

frequencies variables=missingeither2haveASQ2.


/* how many valid values */
compute countvalid1=nvalid(CommunicationCon1, FineMotorConcern1, GrossMotorConcerns1, PersonalSocialConcern1,  ProblemSolvingConcern1).

compute countvalid2=nvalid(CommunicationCon2, FineMotorConcern2, GrossMotorConcerns2, PersonalSocialConcern2,  ProblemSolvingConcern2).

frequencies variables=countvalid1 countvalid2.

crosstabs
/tables=countvalid1 by countvalid2.

crosstabs
/tables=CountyID by ASQorSEConcerns1  .

crosstabs
/tables=CountyID by ASQorSEConcerns2  .

crosstabs
/tables=countvalid2 by ASQorSEConcerns2  .

crosstabs
/tables=ASQorSEConcerns1  by ASQorSEConcerns2  .

use all.

/* has valid values for both the first and second assessments */ 
COMPUTE filter_$=(countvalid1=5 and countvalid2=1).
VARIABLE LABELS filter_$ 'Yes or No for !whcon'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

compute missingeither=0.
if (((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) and (ASQorSEConcerns2<>2 and ASQorSEConcerns2<>1)) missingeither=1.

if (((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) missingeither=1.

compute missingeither2=0.
if ((SEConcernTypes2=1 or SEConcernTypes2=0) and (ASQorSEConcerns2<>2 and ASQorSEConcerns2<>1)) missingeither2=1.

compute missingeither3=0.
if (sysmis(ASQorSEConcerns2)) missingeither3=1.

compute missingeither4=0.
if ((CommunicationCon2=-8 or CommunicationCon2=1 or CommunicationCon2=2)) missingeither4=1.

compute missingeither5=0.
if (missingeither3=1 and missingeither4=1) missingeither5=1.

compute missingeither6=0.
if (SEConcernTypes2=1 or SEConcernTypes2=0) missingeither6=1.

compute missingeither7=0.
if (missingeither3=1 and missingeither6=1) missingeither7=1.

compute missingeither8=0.
if ((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) missingeither8=1.
if (SEConcernTypes2=2 or SEConcernTypes2=3) missingeither8=2.
if (SEConcernTypes1=2 or SEConcernTypes1=3) missingeither8=3.
if (ASQorSEConcerns1<>1 and ASQorSEConcerns1<>2) missingeither8=4.

compute missingeither9=0.
if (SEConcernTypes2=2 or SEConcernTypes2=3) missingeither9=1.


crosstabs
/tables=missingeither3 by missingeither4.

crosstabs
/tables=missingeither3 by missingeither8.

crosstabs
/tables=missingeither6 by missingeither8.

crosstabs
/tables=SEConcernTypes2 by missingeither8.

crosstabs
/tables=recodedeither2 by missingeither8.

use all.
FILTER BY missingeither.
EXECUTE.

use all.
FILTER BY missingeither5.
EXECUTE.

frequencies variables=SEConcernTypes2.
frequencies variables=SEDate2.


compute recodedeither2=ASQorSEConcerns2.
if (ASQorSEConcerns2=6) recodedeither2=6.
if (sysmis(ASQorSEConcerns2)) recodedeither2=7.
if (ASQorSEConcerns1<>1 and ASQorSEConcerns1<>2) recodedeither2=8.


/* checked the people who have yes or no for ASQ Comm2 */
/* but don't have a value for "either concern" */
/* those people have a "missing" or "don't know" value */
/* for their SE 2 Concern Types value */
/* I checked it against dbo_ASQSE spreadsheet */
/* that these values were accurate */

/* checked the people who have yes or no for SE Concern Types 2 */
/* but don't have a value for "either concern" */
/* no values with this situation, though */


compute missingeither8=0.
if ((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) missingeither8=1.

frequencies variables=missingeither8.

compute missingeither6=0.
if (SEConcernTypes2=1 or SEConcernTypes2=0) missingeither6=1.

crosstabs
/tables=missingeither6 by missingeither8.

compute missingeither9=0.
if (SEConcernTypes2=2 or SEConcernTypes2=3) missingeither9=1.

crosstabs
/tables=missingeither9 by missingeither8.

frequencies variables=missingeither9.

crosstabs
/tables=SEConcernTypes2 by missingeither8 /missing=include.

crosstabs
/tables=ASQorSEConcerns1 by missingeither8  /missing=include.


crosstabs
/tables=ASQorSEConcerns2  by missingeither8  /missing=include.

frequencies variables=ASQorSEConcerns2  .

compute missingeither8=0.
if ((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) missingeither8=1.
if (SEConcernTypes2=2 or SEConcernTypes2=3) missingeither8=2.
if (SEConcernTypes1=2 or SEConcernTypes1=3) missingeither8=3.
if (ASQorSEConcerns1<>1 and ASQorSEConcerns1<>2) missingeither8=4.
frequencies variables=missingeither8.

compute recodedeither2=ASQorSEConcerns2.
if (ASQorSEConcerns2=6) recodedeither2=6.
if (sysmis(ASQorSEConcerns2)) recodedeither2=7.
if (ASQorSEConcerns1<>1 and ASQorSEConcerns1<>2) recodedeither2=8.
if (ASQorSEConcerns2=3) recodedeither2=9.

compute missingeither9=0.
if (recodedeither2=7 and missingeither8=1) missingeither9=1.

use all.
filter by missingeither9.
execute.
frequencies variables=ChildID.
crosstabs
/tables=ChildID by SEConcernTypes2 /missing=include.

use all.

crosstabs
/tables=recodedeither2 by missingeither8.

crosstabs
/tables=recodedeither2 by ASQorSEConcerns2   /missing=include.

crosstabs
/tables=recodedeither2 by ASQorSEConcerns2   /missing=include.

compute missingeither=0.
if ((CommunicationCon2=1 or CommunicationCon2=2) and (ASQorSEConcerns2<>2 and ASQorSEConcerns2<>1)) missingeither=1.

use all.
sort cases by missingeither ChildID.

compute missingeither=0.
if (((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) and (ASQorSEConcerns2<>2 and ASQorSEConcerns2<>1)) missingeither=1.


compute missingeither=0.
if (((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) and (ASQorSEConcerns2<>2 and ASQorSEConcerns2<>1)) missingeither=1.

if ((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) missingeither=1.
if (((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) and (ASQorSEConcerns2=2)) missingeither=11.
if (((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) and (ASQorSEConcerns2=1)) missingeither=12.
if (((CommunicationCon1=1 or CommunicationCon1=2) and (CommunicationCon2=1 or CommunicationCon2=2)) and ((ASQorSEConcerns1=1 or ASQorSEConcerns1=2) and (ASQorSEConcerns2=1 or ASQorSEConcerns2=2))) missingeither=13.

frequencies variables=missingeither.

filter by missingeither.
execute.

compute recodedeither22=SEConcernTypes2.
if (SEConcernTypes2=6) recodedeither22=6.
if (SEConcernTypes2=2) recodedeither22=2.
if (SEConcernTypes2=3) recodedeither22=3.
if (sysmis(SEConcernTypes2)) recodedeither22=7.

crosstabs
/tables=recodedeither22 by missingeither   /missing=include.

sort cases by missingeither recodedeither22.

compute missingeither90=0.
if (recodedeither22=0 and missingeither=1) missingeither90=1.

use all.
filter by missingeither90.
execute.
frequencies variables=SEConcernTypes2 CommunicationCon2 to More1Concern2.
frequencies variables=SEConcernTypes1 CommunicationCon1 to More1Concern1.

compute missingeither91=0.
if (recodedeither22=1 and missingeither=1) missingeither91=1.

use all.
filter by missingeither91.
execute.
frequencies variables=SEConcernTypes2 CommunicationCon2 to More1Concern2.
frequencies variables=SEConcernTypes1 CommunicationCon1 to More1Concern1.


compute missingeither97=0.
if (recodedeither22=7 and missingeither=1) missingeither97=1.

use all.
filter by missingeither97.
execute.
frequencies variables=SEConcernTypes2 CommunicationCon2 to More1Concern2.
frequencies variables=SEConcernTypes1 CommunicationCon1 to More1Concern1.

compute missingeither98=0.
if (recodedeither22=7 and missingeither=1 and (SEConcernTypes1=1 or SEConcernTypes1=0)) missingeither98=1.

use all.
filter by missingeither98.
execute.
frequencies variables=SEConcernTypes2 CommunicationCon2 to More1Concern2.
frequencies variables=SEConcernTypes1 CommunicationCon1 to More1Concern1.


sort cases by missingeither98.

