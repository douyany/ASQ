/* This do-file takes the separate Concern Types in ASQ */
/* in the Philly file */

/* combines them into one field */
/* with numeric codes */
/* like it is in the web-based application */


/* delete variables ASQConcernTypes. */
string ASQConcernTypes (A15).

* define addconccodes (!POSITIONAL !TOKENS(1) / !POSITIONAL !TOKENS(2)).
* !DO !i !IN (!1).
* if (!1='yes') ASQConcernTypes=!CONCAT(LTRIM(RTRIM(ASQConcernTypes)), 'ha').
* !DOEND.
* !ENDDEFINE.

* addconccodes aoc_communication 0.




define !loop_asqconcerns (concern=!tokens(1) / whichcode=!tokens(1) / concname=!tokens(1))

*!let !base_stub=!concat(ASQConcernTypes, "Z", !whichcode).

string !concname (A5).
if (!concern='yes') !concname=!quote(!concat(!whichcode, ',')).
*FREQ vars=ASQConcernTypes.
*if (!concern='yes') ASQConcernTypes=!base_stub.

!enddefine


set mprint=yes.

!loop_asqconcerns concern= aoc_communication whichcode=0 concname=Comm.
!loop_asqconcerns concern= aoc_finemotor whichcode=1 concname=Fine.
!loop_asqconcerns concern= aoc_grossmotor whichcode=2 concname=Gross.
!loop_asqconcerns concern= aoc_personalsocial whichcode=4 concname=PersSoc.
!loop_asqconcerns concern= aoc_problemsolving whichcode=5 concname=ProbSolv.


/* concatenate fields */
* compute allblank=1
* do repeat ConctoCheck=Comm to ProbSolv.
* if (len(ConctoCheck)>0) allblank=0.
* end repeat. 
compute ASQConcernTypes=concat(Comm, Fine, Gross, PersSoc, ProbSolv).

compute lenASQConc=len(ASQConcernTypes).

/* remove the comma at the end */
*if (lenASQConc>0) ASQConcernTypes=left(ASQConcernTypes, lenASQConc-1).
if (lenASQConc>0) ASQConcernTypes=strunc(ASQConcernTypes, lenASQConc-1).

/* loop through all variables */
/* are they all no? */

*if (aoc_communication!='not applicable' AND ASQConcernTypes='') ASQConcernTypes='3'.

/* none */
if (aoc_communication~='not applicable' AND aoc_communication='no' AND lenASQConc=0) ASQConcernTypes='3'.

/* missing */
if (aoc_communication='missing' AND lenASQConc=0) ASQConcernTypes='6'.

/* don't know */
if (aoc_communication="don't know" AND lenASQConc=0) ASQConcernTypes='7'.

EXECUTE.
DELETE VARIABLES Comm to ProbSolv.
DELETE VARIABLES lenASQConc.

/* remove the individual ASQ concern variables */
DELETE VARIABLES aoc_communication aoc_finemotor aoc_grossmotor aoc_personalsocial aoc_problemsolving.

/* reshape file to be wide */
/* make sure that the same date is in both the ASQ and ASQ:SE fields */
/* for it to appear on the same row */

*CASESTOVARS.
