/* now concatenate variables */
/* starting from first one */
/* depending on value for max */

define concatloop ()

*compute ASQstatussegment=.
*compute ASQSEstatussegment=.

string CommSegment FineSegment GrosSegment PersSegment ProbSegment ASQSESegment
 EithSegment (A8).

!do !j=1 !to 8.

!let !commlongchk=!concat(CommunicationCon, !j)
!let !finelongchk=!concat(FineMotorConcern, !j)
!let !groslongchk=!concat(GrossMotorConcerns, !j)
!let !perlongchk=!concat(PersonalSocialConcern, !j)
!let !problongchk=!concat(ProblemSolvingConcern, !j)
!let !eithlongchk=!concat(ASQorSEConcerns, !j)

!let !commlongchkstring=!concat(CommunicationCon, !j, string)
!let !finelongchkstring=!concat(FineMotorConcern, !j, string)
!let !groslongchkstring=!concat(GrossMotorConcerns, !j, string)
!let !perlongchkstring=!concat(PersonalSocialConcern, !j, string)
!let !problongchkstring=!concat(ProblemSolvingConcern, !j, string)
!let !eithlongchkstring=!concat(ASQorSEConcerns, !j, string)

!let !SEcon=!concat(SEConcernTypes, !j)
!let !SEconstring=!concat(SEConcernTypes, !j, string)

DO REPEAT V# = !commlongchk  !finelongchk  !groslongchk  !perlongchk  !problongchk
 !eithlongchk
 /W# = !commlongchkstring  !finelongchkstring  !groslongchkstring  
 !perlongchkstring  !problongchkstring !eithlongchkstring.
string W# (A1).
COMPUTE W# = string(V#, F1.0).

end repeat.


/* for the ASQ variables */
DO REPEAT W# = !commlongchkstring  !finelongchkstring  !groslongchkstring
  !perlongchkstring  !problongchkstring !eithlongchkstring
 /Seg#=CommSegment FineSegment GrosSegment PersSegment ProbSegment EithSegment.
*if (uptowhereASQ>=!j) !then.
*  !let !Seg#=!concat(!Seg#, W#).
*  !ifend.
compute Seg#=concat(Seg#, W#).

end repeat.
*delete variables W#.
*execute.
*frequencies variables=!Seg#.

/* tabulate the counties */
use all.
COMPUTE filter_$=(uptowhereASQ>=!j).
VARIABLE LABELS filter_$ 'Yes or No for !whcon'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
frequencies variables=CountyID.
use all.

/* tabulate the counties */
use all.
COMPUTE filter_$=(uptowhereeither>=!j).
VARIABLE LABELS filter_$ 'Yes or No for either !whcon'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
frequencies variables=CountyID.
use all.



/* for the ASQ:SE variables */

!if (!j<=6) !then 

string !SEconstring (A1).
COMPUTE !SEconstring = string(!SEcon, F1.0).
EXECUTE.

*!if (uptowhereASQSE>=!j) !then.
*  !let !ASQSESegment=!concat(!ASQSESegment, !SEconstring).

*  !ifend.
*  delete variables !SEconstring.
*  execute.

compute ASQSESegment=concat(ASQSESegment, !SEconstring).

/* tabulate the counties */
COMPUTE filter_$=(uptowhereASQSE>=!j).
VARIABLE LABELS filter_$ 'Yes or No for !whcon'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
frequencies variables=CountyID.
use all.

/* close for ASQ:SE */

!ifend.

!doend.
!enddefine.

concatloop.


/* create the shortened segment */
/* uses the substring command */
string CommSegmEd FineSegmEd GrosSegmEd PersSegmEd ProbSegmEd EithSegmEd ASQSESegmEd (A8).

DO REPEAT U#= CommSegmEd FineSegmEd GrosSegmEd PersSegmEd ProbSegmEd
 /Seg#=CommSegment FineSegment GrosSegment PersSegment ProbSegment.
compute U#=substr(Seg#, 1, uptowhereASQ).
end repeat.

compute EithSegmEd=substr(EithSegment, 1, uptowhereeither).

compute ASQSESegmEd=substr(ASQSESegment, 1, uptowhereASQSE).

/* code while I tried to figure out how to get substr to work */
*if (uptowhereASQ=1)  CommSegmEd=substr(CommSegment, 1,  1).
*if (uptowhereASQ=2)  CommSegmEd=substr(CommSegment, 1,  2).
*if (uptowhereASQ=3)  CommSegmEd=substr(CommSegment, 1,  3).
*if (uptowhereASQ=4)  CommSegmEd=substr(CommSegment, 1,  4).
*if (uptowhereASQ=5)  CommSegmEd=substr(CommSegment, 1,  5).
*if (uptowhereASQ=6)  CommSegmEd=substr(CommSegment, 1,  6).
*if (uptowhereASQ=7)  CommSegmEd=substr(CommSegment, 1,  7).
*if (uptowhereASQ=8)  CommSegmEd=substr(CommSegment, 1,  8).

/* whether has any yes response */
/* yes =1 */

DO REPEAT U#= CommSegmEd FineSegmEd GrosSegmEd PersSegmEd ProbSegmEd
 /T#= CommSegmYes FineSegmYes GrosSegmYes PersSegmYes ProbSegmYes 
 /S#= CommSegmE1No FineSegmE1No GrosSegmE1No PersSegmE1No ProbSegmE1No 
 /R#= CommSegmE2No FineSegmE2No GrosSegmE2No PersSegmE2No ProbSegmE2No 
 /Q#= CommSegmNo FineSegmNo GrosSegmNo PersSegmNo ProbSegmNo  
 /P#= CommSegmE1Yes FineSegmE1Yes GrosSegmE1Yes PersSegmE1Yes ProbSegmE1Yes  
 /N#= CommSegmE2Yes FineSegmE2Yes GrosSegmE2Yes PersSegmE2Yes ProbSegmE2Yes . 

/* who goes in the denominator */
if (uptowhereASQ>=2) T#=0.
if (uptowhereASQ>=2) S#=0.
if (uptowhereASQ>=2) R#=0.
if (uptowhereASQ>=2) Q#=0.
if (uptowhereASQ>=2) P#=0.
if (uptowhereASQ>=2) N#=0.

/* for the yes set */
if (index(U#, '1')>0) T#=1.
if (index(U#, '2')=1) S#=1.
if (index(U#, '22')=1) R#=1.

/* for the no set */
if (index(U#, '2')>0) Q#=1.
if (index(U#, '1')=1) P#=1.
if (index(U#, '11')=1) N#=1.

end repeat.

/* adding ASQ:SE variables */
/* for the denominator */
if (uptowhereASQSE>=2) ASQSESegmYes=0.
if (uptowhereASQSE>=2) ASQSESegmE1No=0.
if (uptowhereASQSE>=2) ASQSESegmE2No=0.
if (uptowhereASQSE>=2) ASQSESegmNo=0.
if (uptowhereASQSE>=2) ASQSESegmE1Yes=0.
if (uptowhereASQSE>=2) ASQSESegmE2Yes=0.

/* for the yes set */
if (index(ASQSESegmEd, '1')>0) ASQSESegmYes=1.
if (index(ASQSESegmEd, '0')=1) ASQSESegmE1No=1.
if (index(ASQSESegmEd, '00')=1) ASQSESegmE2No=1.

/* for the no set */
if (index(ASQSESegmEd, '0')>0) ASQSESegmNo=1.
if (index(ASQSESegmEd, '1')=1) ASQSESegmE1Yes=1.
if (index(ASQSESegmEd, '11')=1) ASQSESegmE2Yes=1.


/* adding either ASQ or ASQ:SE variables */
/* for the denominator */
if (uptowhereeither>=2) EithSegmYes=0.
if (uptowhereeither>=2) EithSegmE1No=0.
if (uptowhereeither>=2) EithSegmE2No=0.
if (uptowhereeither>=2) EithSegmNo=0.
if (uptowhereeither>=2) EithSegmE1Yes=0.
if (uptowhereeither>=2) EithSegmE2Yes=0.

/* for the yes set */
if (index(EithSegmEd, '1')>0) EithSegmYes=1.
if (index(EithSegmEd, '0')=1) EithSegmE1No=1.
if (index(EithSegmEd, '00')=1) EithSegmE2No=1.

/* for the no set */
if (index(EithSegmEd, '0')>0) EithSegmNo=1.
if (index(EithSegmEd, '1')=1) EithSegmE1Yes=1.
if (index(EithSegmEd, '11')=1) EithSegmE2Yes=1.



value labels CommSegmYes to EithSegmYes 1 'Yes' 0 'No'.
value labels CommSegmE1No to EithSegmE1No 1 'Yes' 0 'No'.
value labels CommSegmE2No to EithSegmE2No 1 'Yes' 0 'No'.

value labels CommSegmNo to EithSegmNo 1 'Yes' 0 'No'.
value labels CommSegmE1Yes to EithSegmE1Yes 1 'Yes' 0 'No'.
value labels CommSegmE2Yes to EithSegmE2Yes 1 'Yes' 0 'No'.

value labels ASQSESegmYes ASQSESegmE1No ASQSESegmE2No 1 'Yes' 0 'No'.
value labels ASQSESegmNo ASQSESegmE1Yes ASQSESegmE2Yes 1 'Yes' 0 'No'.

variable labels CommSegmYes 'Communication Concern--Any Yes'.
variable labels CommSegmE1No 'Communication Concern--Initial No'.
variable labels CommSegmE2No 'Communication Concern--First Two No'.
variable labels FineSegmYes 'Fine Motor Concern--Any Yes'.
variable labels FineSegmE1No 'Fine Motor Concern--Initial No'.
variable labels FineSegmE2No 'Fine Motor Concern--First Two No'.
variable labels GrosSegmYes 'Gross Motor Concern--Any Yes'.
variable labels GrosSegmE1No 'Gross Motor Concern--Initial No'.
variable labels GrosSegmE2No 'Gross Motor Concern--First Two No'.
variable labels PersSegmYes 'Personal Social Concern--Any Yes'.
variable labels PersSegmE1No 'Personal Social Concern--Initial No'.
variable labels PersSegmE2No 'Personal Social Concern--First Two No'.
variable labels ProbSegmYes 'Problem Solving Concern--Any Yes'.
variable labels ProbSegmE1No 'Problem Solving Concern--Initial No'.
variable labels ProbSegmE2No 'Problem Solving Concern--First Two No'.
variable labels EithSegmYes 'Either ASQ or ASQ:SE Concern--Any Yes'.
variable labels EithSegmE1No 'Either ASQ or ASQ:SE Concern--Initial No'.
variable labels EithSegmE2No 'Either ASQ or ASQ:SE Concern--First Two No'.


variable labels CommSegmNo 'Communication Concern--Any No'.
variable labels CommSegmE1Yes 'Communication Concern--Initial Yes'.
variable labels CommSegmE2Yes 'Communication Concern--First Two Yes'.
variable labels FineSegmNo 'Fine Motor Concern--Any No'.
variable labels FineSegmE1Yes 'Fine Motor Concern--Initial Yes'.
variable labels FineSegmE2Yes 'Fine Motor Concern--First Two Yes'.
variable labels GrosSegmNo 'Gross Motor Concern--Any No'.
variable labels GrosSegmE1Yes 'Gross Motor Concern--Initial Yes'.
variable labels GrosSegmE2Yes 'Gross Motor Concern--First Two Yes'.
variable labels PersSegmNo 'Personal Social Concern--Any No'.
variable labels PersSegmE1Yes 'Personal Social Concern--Initial Yes'.
variable labels PersSegmE2Yes 'Personal Social Concern--First Two Yes'.
variable labels ProbSegmNo 'Problem Solving Concern--Any No'.
variable labels ProbSegmE1Yes 'Problem Solving Concern--Initial Yes'.
variable labels ProbSegmE2Yes 'Problem Solving Concern--First Two Yes'.
variable labels EithSegmNo 'Either ASQ or ASQ:SE Concern--Any No'.
variable labels EithSegmE1Yes 'Either ASQ or ASQ:SE Concern--Initial Yes'.
variable labels EithSegmE2Yes 'Either ASQ or ASQ:SE Concern--First Two Yes'.


variable labels ASQSESegmYes 'ASQ:SE Concern--Any Yes'.
variable labels ASQSESegmE1No 'ASQ:SE Concern--Initial No'.
variable labels ASQSESegmE2No 'ASQ:SE Concern--First Two No'.

variable labels ASQSESegmNo 'ASQ:SE Concern--Any No'.
variable labels ASQSESegmE1Yes 'ASQ:SE Concern--Initial Yes'.
variable labels ASQSESegmE2Yes 'ASQ:SE Concern--First Two Yes'.

