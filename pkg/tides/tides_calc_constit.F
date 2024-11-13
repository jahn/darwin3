#include "TIDES_OPTIONS.h"

CBOP
C !ROUTINE: TIDES_CALC_CONSTIT

C !INTERFACE: ==========================================================
      SUBROUTINE TIDES_CALC_CONSTIT( myTime, myIter, myThid )
C !DESCRIPTION:
C Compute tide-generating potential using constituents

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "FFIELDS.h"
#include "TIDES_PARAMS.h"
#include "TIDES_CONSTIT.h"

C !INPUT PARAMETERS: ===================================================
C myTime    :: Current time in simulation
C myIter    :: Current time-step number
C myThid    :: my Thread Id number
      _RL     myTime
      INTEGER myIter, myThid

C !OUTPUT PARAMETERS: ==================================================
CEOP

#ifdef ALLOW_TIDES

C !LOCAL PARAMETERS: ==================================================
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      INTEGER bi,bj,i,j,c,m
      _RL timet
      _RL arg, amp, pot
#ifdef ALLOW_DIAGNOSTICS
      CHARACTER*8 diagName
      _RS tmp(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
#endif

      IF (tides_nodalCorr) THEN
C     compute current nodal parameters
       CALL TIDES_NODAL_SET(myTime, myIter, myThid)
      ENDIF

      timet = myTime - tides_refTime

      DO c=1,nconmax
       IF (tides_amp(c) .NE. 0 _d 0) THEN

        amp = -gravity*tides_alpha(c)*tides_amp(c)*tides_f(c)
        arg = tides_speed(c)*timet + tides_phase(c) + tides_u(c)
        arg = MODULO(arg, 2*PI)
        m = tides_Doodson(1,c)
#ifdef TIDES_PRINT_NODAL_PARAMS
        IF (myProcID.EQ.0 .AND. myThid.EQ.1) THEN
         WRITE(msgBuf,'(A,I10,I3,3E24.16)') 'nodal param ',
     &        myIter, c, arg, tides_f(c), tides_u(c)
         CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                       SQUEEZE_RIGHT , 1)
        ENDIF
#endif
        DO bj=myByLo(myThid),myByHi(myThid)
         DO bi=myBxLo(myThid),myBxHi(myThid)
          DO j=1-OLy,sNy+OLy
           DO i=1-OLx,sNx+OLx
            pot  = amp*(tides_SH(i,j,bi,bj,1,m)*COS(arg)
     &                 -tides_SH(i,j,bi,bj,2,m)*SIN(arg))
#ifdef ALLOW_DIAGNOSTICS
            IF (useDiagnostics) THEN
             tmp(i,j,bi,bj) = pot
            ENDIF
#endif
            phiTide2d(i,j,bi,bj) = phiTide2d(i,j,bi,bj) + pot
           ENDDO
          ENDDO
         ENDDO
        ENDDO
#ifdef ALLOW_DIAGNOSTICS
        IF (useDiagnostics) THEN
         WRITE(diagName,'(A,I2.2)') 'phiTid', c
         CALL DIAGNOSTICS_FILL(tmp,diagName,0,1,0,1,1,myThid)
        ENDIF
#endif

       ENDIF
      ENDDO

#endif /* ALLOW_TIDES */

      RETURN
      END

