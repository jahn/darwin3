c#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: INI_SIGMA_GRID
C     !INTERFACE:
      SUBROUTINE INI_SIGMA_GRID( myThid )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE INI_SIGMA_GRID
C     | o Initialise grid factors when using Sigma coordiante
C     *==========================================================*
C     | These arrays are used throughout the code and describe
C     | fractional height factors.
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "SURFACE.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myThid  ::  Number of this instance of INI_SIGMA_GRID
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     bi, bj     :: tile indices
C     i, j, k    :: Loop counters
C     msgBuf     :: Informational/error message buffer
      INTEGER bi, bj
      INTEGER i, j, k
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

C---  Hybrid-Sigma vertical coordinate:
      DO k=1,Nr+1
       aHybSigmF(k) = 0. _d 0
       dAHybSigC(k) = 0. _d 0
      ENDDO
      DO k=1,Nr
       aHybSigmC(k) = 0. _d 0
       dAHybSigF(k) = 0. _d 0
      ENDDO

      IF ( selectSigmaCoord .EQ. 0 ) THEN

       DO bj=myByLo(myThid), myByHi(myThid)
        DO bi=myBxLo(myThid), myBxHi(myThid)
         DO k=1,Nr+1
          DO j=1-OLy,sNy+OLy
           DO i=1-OLx,sNx+OLx
            bHybSigmF(i,j,k,bi,bj) = 0 _d 0
            dBHybSigC(i,j,k,bi,bj) = 0 _d 0
           ENDDO
          ENDDO
         ENDDO
         DO k=1,Nr
          DO j=1-OLy,sNy+OLy
           DO i=1-OLx,sNx+OLx
            bHybSigmC(i,j,k,bi,bj) = 0 _d 0
            dBHybSigF(i,j,k,bi,bj) = 0 _d 0
           ENDDO
          ENDDO
         ENDDO
        ENDDO
       ENDDO

      ELSE

C-     Center position at the middle between 2 interfaces
       DO bj=myByLo(myThid), myByHi(myThid)
        DO bi=myBxLo(myThid), myBxHi(myThid)
         DO k=1,Nr
          DO j=1-OLy,sNy+OLy
           DO i=1-OLx,sNx+OLx
            bHybSigmC(i,j,k,bi,bj) = ( bHybSigmF(i,j,k,bi,bj)
     &                               + bHybSigmF(i,j,k+1,bi,bj) )
     &                               *0.5 _d 0
            dBHybSigF(i,j,k,bi,bj) = ( bHybSigmF(i,j,k+1,bi,bj)
     &                               - bHybSigmF(i,j,k,bi,bj) )*rkSign
           ENDDO
          ENDDO
         ENDDO
         DO k=2,Nr
          DO j=1-OLy,sNy+OLy
           DO i=1-OLx,sNx+OLx
            dBHybSigC(i,j,k,bi,bj) = ( bHybSigmC(i,j,k,bi,bj)
     &                               - bHybSigmC(i,j,k-1,bi,bj) )*rkSign
           ENDDO
          ENDDO
         ENDDO
         DO j=1-OLy,sNy+OLy
          DO i=1-OLx,sNx+OLx
           dBHybSigC(i,j,1,bi,bj) = ( bHybSigmC(i,j,1,bi,bj)
     &                              - bHybSigmF(i,j,1,bi,bj) )*rkSign
           dBHybSigC(i,j,Nr+1,bi,bj) = ( bHybSigmF(i,j,Nr+1,bi,bj)
     &                               - bHybSigmC(i,j,Nr,bi,bj) )*rkSign
          ENDDO
         ENDDO
        ENDDO
       ENDDO

C---  End setting-up Hybrid-Sigma vertical coordinate:
      ENDIF

      RETURN
      END
