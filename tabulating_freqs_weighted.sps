DEFINE !wgted (whcon = !TOKENS(1) / lownum = !TOKENS(1) / highnum = !TOKENS(1) / weightfilename= !TOKENS(1))

!let !whcon1=!concat(!whcon, 1)
!let !whcon2=!concat(!whcon, 2)
!let !weightfile=!concat(!weightfilename)

/* has valid values for both the first and second assessments */ 
COMPUTE filter_$=((!whcon1= !lownum OR !whcon1 = !highnum) and (!whcon2 = !lownum OR !whcon2 = !highnum)).
VARIABLE LABELS filter_$ 'Yes or No for !whcon'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Complex Samples Frequencies.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!whcon1 by !whcon2
  /CELLS POPSIZE TABLEPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.


!ENDDEFINE.

!wgted whcon=CommunicationCon  lownum=1 highnum=2 weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan'.

!wgted whcon=FineMotorConcern lownum=1 highnum=2  weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan'.
!wgted whcon=GrossMotorConcerns lownum=1 highnum=2  weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan'.
!wgted whcon=PersonalSocialConcern lownum=1 highnum=2  weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan'.
!wgted whcon=ProblemSolvingConcern lownum=1 highnum=2 weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan'.

!wgted whcon=More1Concern lownum=1 highnum=2  weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan'.

!wgted whcon=AnyConcerns lownum=1 highnum=2  weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan'.

!wgted whcon=ASQorSEConcerns lownum=0 highnum=1  weightfilename='H:\prep_files\followup_file\followupEitherwgt.csaplan'.

!wgted whcon=SEConcernTypes lownum=0 highnum=1  weightfilename='H:\prep_files\followup_file\followupSEwgt.csaplan'.




DEFINE !laterresult  (whcon = !TOKENS(1) / lownum = !TOKENS(1) / highnum = !TOKENS(1) / weightfilename= !TOKENS(1) / abbrev=!TOKENS(1))

!let !whcon1=!concat(!whcon, 1)
!let !whcon2=!concat(!whcon, 2)
!let !anyyes=!concat(!abbrev, SegmYes)
!let !edsequence=!concat(!abbrev, SegmEd)
!let !first1no=!concat(!abbrev, SegmE1No)
!let !first2no=!concat(!abbrev, SegmE2No)
!let !weightfile=!concat(!weightfilename)
!let !anyno=!concat(!abbrev, SegmNo)
!let !first1yes=!concat(!abbrev, SegmE1Yes)
!let !first2yes=!concat(!abbrev, SegmE2Yes)


/* has valid values for both the first and second assessments */ 
COMPUTE filter_$=((!whcon1= !lownum OR !whcon1 = !highnum) and (!whcon2 = !lownum OR !whcon2 = !highnum)).
VARIABLE LABELS filter_$ 'Yes or No for !whcon'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Complex Samples Frequencies Table #1.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!anyyes
  /CELLS POPSIZE TABLEPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

* Complex Samples Frequencies Table #1b.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!anyno
  /CELLS POPSIZE TABLEPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

* Complex Samples Frequencies Table #2.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=uptowhereASQ
  /CELLS POPSIZE TABLEPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

* Complex Samples Frequencies Table #3.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=uptowhereASQSE
  /CELLS POPSIZE TABLEPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

* Complex Samples Frequencies Table #4.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!edsequence
  /CELLS POPSIZE TABLEPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.


* Complex Samples Cross-Tab Table #1.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!first1no by !anyyes
  /CELLS POPSIZE TABLEPCT ROWPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

* Complex Samples Cross-Tab Table #1.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!first1yes by !anyno
  /CELLS POPSIZE TABLEPCT ROWPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

* Complex Samples Cross-Tab Table #2.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!first2no by !anyyes 
  /CELLS POPSIZE TABLEPCT ROWPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

* Complex Samples Cross-Tab Table #2b.
CSTABULATE
  /PLAN FILE=!weightfilename
  /TABLES VARIABLES=!first2yes by !anyno
  /CELLS POPSIZE TABLEPCT ROWPCT
  /STATISTICS SE COUNT
  /MISSING SCOPE=TABLE CLASSMISSING=EXCLUDE.

!ENDDEFINE.




!laterresult whcon=CommunicationCon  lownum=1 highnum=2 
 weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan' abbrev=Comm.

!laterresult whcon=FineMotorConcern lownum=1 highnum=2 
 weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan' abbrev=Fine.
!laterresult whcon=GrossMotorConcerns lownum=1 highnum=2 
 weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan' abbrev=Gros.
!laterresult whcon=PersonalSocialConcern lownum=1 highnum=2 
 weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan' abbrev=Pers.
!laterresult whcon=ProblemSolvingConcern lownum=1 highnum=2 
 weightfilename='H:\prep_files\followup_file\followupCommwgt.csaplan' abbrev=Prob.

!laterresult whcon=SEConcernTypes lownum=0 highnum=1 
 weightfilename='H:\prep_files\followup_file\followupSEwgt.csaplan' abbrev=ASQSE.

!laterresult whcon=ASQorSEConcerns lownum=0 highnum=1 
 weightfilename='H:\prep_files\followup_file\followupEitherwgt.csaplan' abbrev=Eith.


