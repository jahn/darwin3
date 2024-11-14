#include "TIDES_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: TIDES_INIT_FIXED

C !INTERFACE:
      SUBROUTINE TIDES_INIT_FIXED( myThid )

C     !DESCRIPTION:
C     Initialize TIDES variables that are kept fixed during the run.

C     !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "TIDES_PARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     myThid ::  my Thread Id number
      INTEGER myThid
CEOP

#ifdef ALLOW_TIDES

C     !LOCAL VARIABLES:
C     === Local variables ===
      INTEGER myDate(4), numdays(4)
      INTEGER year, yyyymmdd, hhmmss, i, j
      INTEGER dm
      _RL mjd, xx
      REAL*8 GM

      _BEGIN_MASTER(myThid)

C     compute date for modified Julian day epoch
      yyyymmdd = 18581117
      hhmmss = 0
      CALL CAL_FULLDATE( yyyymmdd, hhmmss, mjdEpoch, myThid )

C..initialize dates for deltat table:
C..put the julian date at the first of the year in the array
C..years so that we can interpolate/extrapolate directly on
C..the given ut julian date
      DO i=1,tabsize
C--    Get full date for Jan.1 00:00 of each year in the table
       year = tabstart + (i-1)
       yyyymmdd = year*10000 + 101
       hhmmss = 0
       CALL CAL_FULLDATE(yyyymmdd, hhmmss, myDate, myThid)

C      Convert to modified Julian day, with zero on Nov 17 0:00 1858
       CALL CAL_TIMEPASSED(mjdEpoch, myDate, numdays, myThid)
       mjd = numdays(1)

C      Convert to Julian Day and to Ephemeris Time
       tides_tjds(i) = mjd + 2400000.5 _d 0
      ENDDO

#ifdef TIDES_ALLOW_FULL
      IF (tides_fullLuniSolar) THEN
C      initialize SPICE library
       CALL FURNSH( tides_metaKernel )

C      get grav.constant times mass and convert to m^3/s^2
       CALL BODVRD('SUN', 'GM', 1, dm, GM)
       tides_sunGM = GM*1 _d 9

       CALL BODVRD('MOON', 'GM', 1, dm, GM)
       tides_moonGM = GM*1 _d 9
      ENDIF
#endif

      _END_MASTER(myThid)
      _BARRIER

      IF (tides_haveConstit) THEN
        CALL TIDES_INIT_CONSTIT(myThid)
      ENDIF

#endif /* ALLOW_TIDES */

      RETURN
      END
