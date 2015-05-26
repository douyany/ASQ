/* will want to merge this file */
/* with the file that has observations starting from first test */

/* need to know their county ID */
/* to be able to create weights for second and higher observations */

/* first file incl. ChildID is */
/* on h: drive */
/* ASQ Screening Database_Child Information.sav */ 
/* this file is only for the counties other than Philly */

/* Philly data is in the file called */
/* PhillyFlat_Merged_1.sav */
/* will need to use Philly's ASQ file */
/* to get the follow-up results for this one */

GET
  FILE='H:\prep_files\followup_file\ASQ Screening Database_Child Information.sav'.

sort cases by ChildID.

/* making sure there's only one case by ChildID */
/* start with #2 */
/* since the first screening already exists */
compute idwithingroup = 2.
if (ChildID = lag(ChildID)) idwithingroup = lag(idwithingroup) + 1.
exe.

/* yep, only one case per ChildID ! */
frequencies variables=idwithingroup.
delete variables idwithingroup.
execute.

rename variables (ChildCaseNumber=case_number) (ASQScreeningDate=ASQDate1)   (SEScreeningDate=SEDate1)
 (CommunicationCon=CommunicationCon1)
 (GrossMotorConcerns=GrossMotorConcerns1)
 (FineMotorConcern=FineMotorConcern1)
 (ProblemSolvingConcern=ProblemSolvingConcern1)
 (PersonalSocialConcern=PersonalSocialConcern1)
 (More1Concern=More1Concern1)
 (NoConcerns=NoConcerns1)
 (AnyConcerns=AnyConcerns1)
 (ASQSEConcernTypes=SEConcernTypes1)
 (ASQOrSEConcerns=ASQorSEConcerns1).

/* fit the coding of either concern */
/* to the values in other datasets */
/* the no's */
if (ASQorSEConcerns1=2) ASQorSEConcerns1=0.
/* the missings */
if (ASQorSEConcerns1=3) ASQorSEConcerns1=2.

/* add labels for ASQ or ASQ:SE variable */
value labels ASQorSEConcerns1 1 'yes' 0 'no' 2 'missing' 3 'don''t know'.


/* the merge! */
match files file='H:\prep_files\followup_file\followup_incl_whichcon.sav' /in=fromsubsequent
/file=*
	/by ChildID.


alter type case_number (amin).
compute case_number=rtrim(ltrim(case_number)).
alter type case_number (a7).


/* check out num of obs. for second result */
/* ASQ results: */


descriptives ASQDate1 ASQDate2 ASQDate3 ASQDate4 ASQDate5 ASQDate6 ASQDate7 ASQDate8.

/* ASQ:SE results: */
*descriptives SE2Date  SE3Date SE4Date.
descriptives SEDate1 SEDate2 SEDate3 SEDate4.


add files file=* file='H:\prep_phillyasq\processing_asq\Philly_initial_and_later.sav'. 

save outfile='H:\prep_files\followup_file\statewide_followup_file.sav'.  

add files file=* /keep=ChildID SEConcernTypes1 SEConcernTypes2
SEConcernTypes3
SEConcernTypes4
SEConcernTypes5
SEConcernTypes6
SEConcernTypes7
SEConcernTypes8
all.