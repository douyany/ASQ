/* http://stackoverflow.com/questions/9318860/spss-macro-to-automate-sequential-variable-references */

define !loop_asqconcerns (concern=!tokens(1) / whichcode=!tokens(1))

*!let !base_stub=!concat(ASQConcernTypes, ",", !whichcode).

if (!concern='yes') ASQConcernTypes=!concat(ASQConcernTypes, ",", !whichcode)

!enddefine

/* remove the comma at the end */
compute ASQConcernTypes=left(ASQConcernTypes, len(ASQConcernTypes)-1)

!loop_asqconcerns aoc_communication
!loop_asqconcerns aoc_personal
!loop_asqconcerns aoc_gross

/* loop through all variables */
/* are they all no? */

if (!concern='no' AND sysmis(ASQConcernTypes)=1) ASQConcernTypes='3'.


/* reshape file to be wide */
/* make sure that the same date is in both the ASQ and ASQ:SE fields */
/* for it to appear on the same row */


