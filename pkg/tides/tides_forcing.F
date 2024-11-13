#include "TIDES_OPTIONS.h"

CBOP
C !ROUTINE: TIDES_FORCING

C !INTERFACE: ==========================================================
      SUBROUTINE TIDES_FORCING(
     I                          myTime, myIter, myThid )

C !DESCRIPTION:
C Compute tide generating potential phiTide2d

C !USES: ===============================================================
      IMPLICIT NONE
#include "TIDES_PARAMS.h"

C !INPUT PARAMETERS: ===================================================
C myTime    :: Current time in simulation
C myIter    :: Current time-step number
C myThid    :: my Thread Id number
      _RL     myTime
      INTEGER myIter, myThid

C !OUTPUT PARAMETERS: ==================================================
CEOP

#ifdef ALLOW_TIDES

C !LOCAL VARIABLES: ====================================================

      IF (tides_fullLuniSolar) THEN
        CALL TIDES_CALC_LUNISOLAR( myTime, myIter, myThid )
      ELSE
        CALL TIDES_CALC_CONSTIT( myTime, myIter, myThid )
      ENDIF

#endif /* ALLOW_TIDES */

      RETURN
      END

