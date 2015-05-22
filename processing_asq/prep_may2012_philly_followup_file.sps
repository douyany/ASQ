/* prep the May 2012 followup file */
get file='H:\prep_phillyasq\processing_asq\Philly_Followup_May2012.sav'.

rename variables (case__number=case_number) 
 (ASQdate_of_screening=date_of_screening)
 (aoc_commuyesicatioyes=aoc_communication)
 (aoc_fiyesemotor=aoc_finemotor)
 (aoc_problemsolviyesg=aoc_problemsolving)
 (aoc_persoyesalsocial=aoc_personalsocial).

alter type case_number (amin).
compute case_number=rtrim(ltrim(case_number)).
alter type case_number (a7).

save outfile='H:\prep_phillyasq\processing_asq\Philly_Followup_May2012_varsrenamed.sav' /keep=case_number
 date_of_screening
 aoc_communication
 aoc_grossmotor
 aoc_finemotor
 aoc_problemsolving
 aoc_personalsocial. 

/* then go into the prep_philly_followup.sps */
/* do-file to add this data into the other ASQ data */
