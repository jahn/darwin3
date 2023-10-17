#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: INI_VERTICAL_GRID
C     !INTERFACE:
      SUBROUTINE INI_VERTICAL_GRID( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE INI_VERTICAL_GRID
C     | o Initialise vertical gridding arrays
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myThid   :: my Thread Id number
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     k        :: loop index
C     msgBuf   :: Informational/error message buffer
      INTEGER k
      _RL     tmpRatio, checkRatio1, checkRatio2
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      _RL maxErrC, maxErrF, epsil, tmpError
      _RL rFullDepth, recip_fullDepth
      _RS rSigBndRS, tmpRS
CEOP

      _BEGIN_MASTER(myThid)

      WRITE(msgBuf,'(A,2(A,L5))') 'Enter INI_VERTICAL_GRID:',
     &                            ' setInterFDr=', setInterFDr,
     &                          ' ; setCenterDr=', setCenterDr
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT, myThid )

C--   Set factors required for mixing pressure and meters as vertical coordinate.
C     rkSign is a "sign" parameter which is used where the orientation of the vertical
C     coordinate (pressure or meters) relative to the vertical index (k) is important.
C     rkSign = -1 applies when k and the coordinate are in the opposite sense.
C     rkSign =  1 applies when k and the coordinate are in the same sense.
      rkSign       = -1. _d 0
      gravitySign  = -1. _d 0
      IF ( usingPCoords ) THEN
         gravitySign = 1. _d 0
      ENDIF

      IF ( .NOT.(setInterFDr.OR.setCenterDr) ) THEN
        WRITE(msgBuf,'(A)')
     &  'S/R INI_VERTICAL_GRID: neither delR nor delRc are defined'
        CALL PRINT_ERROR( msgBuf, myThid )
        WRITE(msgBuf,'(A)')
     &  'S/R INI_VERTICAL_GRID: Need at least 1 of the 2 (delR,delRc)'
        CALL PRINT_ERROR( msgBuf, myThid )
        STOP 'ABNORMAL END: S/R INI_VERTICAL_GRID'
      ENDIF

C---  Set Level r-thickness (drF) and Center r-distances (drC)

      IF (setInterFDr) THEN
C--   Interface r-distances are defined:
       DO k=1,Nr
         drF(k) = delR(k)
       ENDDO
C-    Check that all thickness are > 0 :
       DO k=1,Nr
        IF (delR(k).LE.0.) THEN
         WRITE(msgBuf,'(A,I4,A,E16.8)')
     &  'S/R INI_VERTICAL_GRID: delR(k=',k,' )=',delR(k)
         CALL PRINT_ERROR( msgBuf, myThid )
         WRITE(msgBuf,'(A)')
     &  'S/R INI_VERTICAL_GRID: Vert. grid spacing MUST BE > 0'
         CALL PRINT_ERROR( msgBuf, myThid )
         STOP 'ABNORMAL END: S/R INI_VERTICAL_GRID'
        ENDIF
       ENDDO
      ELSE
C--   Interface r-distances undefined:
C     assume Interface at middle between 2 Center
       drF(1) = delRc(1)
       DO k=2,Nr
c        drF(k-1) = 0.5 _d 0 *delRc(k) + drF(k-1)
c        drF( k ) = 0.5 _d 0 *delRc(k)
C- note: change the order to prevent some compilers to produce wrong code
C        when trying to optimise this loop :
         drF( k ) = 0.5 _d 0 *delRc(k)
         drF(k-1) = 0.5 _d 0 *delRc(k) + drF(k-1)
       ENDDO
       drF(Nr) = delRc(Nr+1) + drF(Nr)
      ENDIF

      IF (setCenterDr) THEN
C--   Cell Center r-distances are defined:
       DO k=1,Nr+1
         drC(k) = delRc(k)
       ENDDO
C-    Check that all thickness are > 0 :
       DO k=1,Nr+1
        IF (delRc(k).LE.0.) THEN
         WRITE(msgBuf,'(A,I4,A,E16.8)')
     &  'S/R INI_VERTICAL_GRID: delRc(k=',k,' )=',delRc(k)
         CALL PRINT_ERROR( msgBuf, myThid )
         WRITE(msgBuf,'(A)')
     &  'S/R INI_VERTICAL_GRID: Vert. grid spacing MUST BE > 0'
         CALL PRINT_ERROR( msgBuf, myThid )
         STOP 'ABNORMAL END: S/R INI_VERTICAL_GRID'
        ENDIF
       ENDDO
      ELSE
C--   Cell Center r-distances undefined:
C     assume Center at middle between 2 Interfaces
       drC(1)  = 0.5 _d 0 *delR(1)
       DO k=2,Nr
         drC(k) = 0.5 _d 0 *(delR(k-1)+delR(k))
       ENDDO
       drC(Nr+1) = 0.5 _d 0 *delR(Nr)
      ENDIF

C---  Set r-position of  interFace (rF) and cell-Center (rC):
C --  Use top_Pres or seaLev_Z to set vertical axis position:
C OCN in Z: top_Pres(Ref) (= rhoConst*PhiRef(1)), seaLev_Z (=rF(1), @ the top)
C ATM in Z: top_Pres(Ref) (= rhoConst*PhiRef(1)), seaLev_Z (=rF(Nr+1), @ bottom)
C OCN in P: top_Pres (=rF(Nr+1)), seaLev_Z (<-> PhiRef(Nr+1)/g, @ the top)
C ATM in P: top_Pres (=rF(Nr+1)), seaLev_Z (<-> PhiRef(1)/g, @ the bottom)
      IF ( rF(1).EQ.UNSET_RS .AND.
     &     usingZCoords.AND.fluidIsWater ) THEN
        rF(1) = seaLev_Z
      ENDIF
      IF ( rF(1).NE.UNSET_RS ) THEN
        DO k=1,Nr
          rF(k+1) = rF(k) + rkSign*drF(k)
        ENDDO
        rC(1)   = rF(1)   + rkSign*drC(1)
        DO k=2,Nr
          rC(k) = rC(k-1) + rkSign*drC(k)
        ENDDO
c       IF ( usingPCoords ) THEN
c         top_Pres = rF(Nr+1)
c       ELSEIF ( fluidIsWater ) THEN
c         seaLev_Z = rF(1)
c       ELSE
c         seaLev_Z = rF(Nr+1)
c       ENDIF
      ELSE
        IF ( usingPCoords ) THEN
          rF(Nr+1) = top_Pres
        ELSE
          rF(Nr+1) = seaLev_Z
        ENDIF
        DO k=Nr,1,-1
          rF(k) = rF(k+1) - rkSign*drF(k)
        ENDDO
        rC(Nr) = rF(Nr+1) - rkSign*drC(Nr+1)
        DO k=Nr,2,-1
          rC(k-1) = rC(k) - rkSign*drC(k)
        ENDDO
      ENDIF

C---  Check vertical discretization :
      checkRatio2 = 100.
      checkRatio1 = 1. _d 0 / checkRatio2
      DO k=1,Nr
       tmpRatio = 0.
       IF ( (rC(k)-rF(k+1)) .NE. 0. )
     &   tmpRatio = (rF(k)-rC(k)) / (rC(k)-rF(k+1))
       IF ( tmpRatio.LT.checkRatio1 .OR. tmpRatio.GT.checkRatio2 ) THEN
c       write(0,*) 'drF=',drF
c       write(0,*) 'drC=',drC
c       write(0,*) 'rF=',rF
c       write(0,*) 'rC=',rC
        WRITE(msgBuf,'(A,I4,A,E16.8)')
     &   'S/R INI_VERTICAL_GRID: Invalid relative position, level k=',
     &     k, ' :', tmpRatio
        CALL PRINT_ERROR( msgBuf, myThid )
        WRITE(msgBuf,'(A,1PE14.6,A,2E14.6)')
     &   'S/R INI_VERTICAL_GRID: rC=', rC(k),
     &   ' , rF(k,k+1)=',rF(k),rF(k+1)
        CALL PRINT_ERROR( msgBuf, myThid )
        STOP 'ABNORMAL END: S/R INI_VERTICAL_GRID'
       ENDIF
      ENDDO

C-    Calculate reciprol vertical grid spacing :
      DO k=1,Nr+1
       recip_drC(k)   = 1. _d 0/drC(k)
      ENDDO
      DO k=1,Nr
       recip_drF(k)   = 1. _d 0/drF(k)
      ENDDO

C---  Hybrid-Sigma vertical coordinate code moved to ini_sigma_grid

      _END_MASTER(myThid)
      _BARRIER

      RETURN
      END
