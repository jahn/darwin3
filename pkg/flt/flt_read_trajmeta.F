#include "FLT_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: FLT_READ_TRAJMETA
C     !INTERFACE:
      SUBROUTINE FLT_READ_TRAJMETA(
     I                      fName,
     O                      nRec, nFld, filePrec,
     I                      myIter, myThid )

C     !DESCRIPTION:

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "FLT_META.h"

C     !INPUT/OUTPUT PARAMETERS:
C     fName    :: current MFLDS file name (prefix) to read
C     nRec     :: number of records in current meta file
C     nFld     :: number of fields in current meta file
C     filePrec :: data-precision in current meta file
C     myIter   :: Iteration number
C     myThid   :: my Thread Id. number
      CHARACTER*(MAX_LEN_FNAM) fName
      INTEGER nRec
      INTEGER nFld
      INTEGER filePrec
      INTEGER myIter
      INTEGER myThid
CEOP

C     !FUNCTIONS:
      INTEGER ILNBLNK
      EXTERNAL ILNBLNK

C     !LOCAL VARIABLES:
C-    do change dir. (using mdsioLocalDir):
      LOGICAL  useCurrentDir
      INTEGER  nSizD, nSizT
      PARAMETER( nSizD = 3 , nSizT = 2 )
      CHARACTER*(MAX_LEN_PREC/2) simulName
      CHARACTER*(MAX_LEN_MBUF/2) titleLine
      INTEGER nDims, nTimRec
      INTEGER dimList(3,nSizD)
      _RL     timList(nSizT)
      _RL     misVal
      INTEGER nRecords, fileIter
C-    for debug print:
      INTEGER i
      CHARACTER*(MAX_LEN_MBUF) msgBuf
C-----
      INTEGER nFlds
      CHARACTER*(8) fldList(1)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
C-----

C     master thread reads metafile
      _BEGIN_MASTER( myThid )

#ifdef ALLOW_MDSIO
      useCurrentDir = .FALSE.
      nDims = nSizD
      nFlds = 1
      nTimRec = nSizT
      CALL MDS_READ_META(
     I               fName,
     O               simulName,
     O               titleLine,
     O               flt_traj_prec,
     U               nDims,   nFlds,   nTimRec,
     O               dimList, fldList, timList,
     O               misVal, nRecords, fileIter,
     I               useCurrentDir, myThid )
#endif /* ALLOW_MDSIO */

      IF (nFlds .GE. 0) THEN
       print*,'dimList',dimList
       flt_traj_nRec = nRecords - 1
       flt_traj_nFld = dimList(1,3)
      ELSE
       i = ILNBLNK(fName)
       WRITE(msgBuf,'(2A)')'FLT_READ_TRAJMETA: not found: ',fName(1:i)
       CALL PRINT_ERROR( msgBuf, myThid )
       flt_traj_nRec = 0
       flt_traj_nFld = -1
      ENDIF

      _END_MASTER( myThid )
      _BARRIER

C-    set output arguments from common block (filled by master thread)
      nRec = flt_traj_nRec
      nFld = flt_traj_nFld
      filePrec = flt_traj_prec

      RETURN
      END
