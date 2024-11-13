#include "TIDES_OPTIONS.h"

CBOP
C !ROUTINE: TIDES_INIT_CONSTIT

C !INTERFACE: ==========================================================
      SUBROUTINE TIDES_INIT_CONSTIT( myThid )

C !DESCRIPTION:
C Initialize global arrays for tidal constituents

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "TIDES_PARAMS.h"
#include "TIDES_CONSTIT.h"
#include "cal.h"

C !INPUT PARAMETERS: ===================================================
C myThid    :: my Thread Id number
      INTEGER myThid

C !OUTPUT PARAMETERS: ==================================================
CEOP

#ifdef ALLOW_TIDES

C !LOCAL VARIABLES: ====================================================
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      INTEGER bi,bj,i,j,days
      INTEGER date_array(4)
      INTEGER difftime(4)
      INTEGER hr, mn, sec
      _RL a0, a1, a2, secs
      _RL cents, s, h, p, N, pp
      _RL ds, dh, dp, dN, dpp
      _RL t1, ph, sp
#ifdef ALLOW_DIAGNOSTICS
      CHARACTER*8    diagName
      CHARACTER*16   diagCode
      CHARACTER*16   diagUnits
      CHARACTER*(80) diagTitle
      INTEGER diagNum
#endif

      _BEGIN_MASTER(myThid)

C--   convert reference date for constituent phases to model time
      CALL CAL_FULLDATE( tides_refDate1, tides_refDate2,
     &                   date_array, myThid )
      CALL cal_TimePassed(modelstartdate,date_array,difftime,myThid)
      CALL cal_ToSeconds(difftime, tides_reftime, myThid)
      tides_reftime = modelstart + tides_reftime

C--   compute speeds and phases for reference date where not set
      CALL TIDES_ET(date_array, cents, myThid)
      CALL TIDES_ASTRO5(cents, s, h, p, N, pp)
      CALL TIDES_ASTRO5SPEEDS(cents, ds, dh, dp, dN, dpp)

C     compute hour angle for reference date
      hr = tides_refDate2/10000
      mn = MOD(tides_refDate2/100,100)
      sec = MOD(tides_refDate2,100)
      t1 = ((sec/60 _d 0 + mn)/60 _d 0 + hr)*15 _d 0

C--   map parameters to selected constituents
      DO i=1,nconmax
       IF (tides_constit(i) .NE. ' ') THEN
C       compute speed and phase for reference date
        IF (tides_phase(i) .EQ. UNSET_RL) THEN
C        phase in degrees
         ph = tides_Doodson(1,i)*(t1 + h - s)
         ph = ph + tides_Doodson(2,i)*s
         ph = ph + tides_Doodson(3,i)*h
         ph = ph + tides_Doodson(4,i)*p
         ph = ph - tides_Doodson(5,i)*N
         ph = ph + tides_Doodson(6,i)*pp
         ph = ph + tides_Doodson(7,i)*90 _d 0
         ph = MODULO(ph, 360 _d 0)
C        convert to radians
         tides_phase(i) = ph/180 _d 0*PI
        ENDIF

        IF (tides_speed(i) .EQ. UNSET_RL) THEN
C        these are in degrees per day
         sp = tides_Doodson(1,i)*(360 _d 0 + dh - ds)
         sp = sp + tides_Doodson(2,i)*ds
         sp = sp + tides_Doodson(3,i)*dh
         sp = sp + tides_Doodson(4,i)*dp
         sp = sp - tides_Doodson(5,i)*dN
         sp = sp + tides_Doodson(6,i)*dpp
C        convert to rad per second
         tides_speed(i) = sp/180 _d 0*PI/86400 _d 0
        ENDIF
       ENDIF
       tides_f(i) = 1 _d 0
       tides_u(i) = 0 _d 0
      ENDDO

      _END_MASTER(myThid)

C--   compute spherical harmonics for semi-diurnal, diurnal and
C     long-period tidal constituents
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO j=1-OLy,sNy+OLy
         DO i=1-OLx,sNx+OLx
          a2 = COS(deg2rad*YC(i,j,bi,bj))**2
          tides_SH(i,j,bi,bj,1,2) = a2*COS(deg2rad*2*XC(i,j,bi,bj))
          tides_SH(i,j,bi,bj,2,2) = a2*SIN(deg2rad*2*XC(i,j,bi,bj))
          a1 = SIN(2.*deg2rad*YC(i,j,bi,bj))
          tides_SH(i,j,bi,bj,1,1) = a1*COS(deg2rad*XC(i,j,bi,bj))
          tides_SH(i,j,bi,bj,2,1) = a1*SIN(deg2rad*XC(i,j,bi,bj))
          a0 = 1.5 _d 0*a2 - 1 _d 0
          tides_SH(i,j,bi,bj,1,0) = a0
          tides_SH(i,j,bi,bj,2,0) = 0 _d 0
         ENDDO
        ENDDO
       ENDDO
      ENDDO

C--   initialize diagnostics for tide-generating potential constituents
#ifdef ALLOW_DIAGNOSTICS
      IF (useDiagnostics) THEN
       diagUnits = 'm^2/s^2         '
       diagCode  = 'SM      U1      '
       DO i=1,nconmax
        WRITE(diagName,'(A,I2.2)'), 'phiTid', i
        WRITE(diagTitle, '(A,I2,A)') 'TGP constituent # ', i
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I           diagName, diagCode, diagUnits, diagTitle, 0, myThid )
       ENDDO
      ENDIF
#endif

      _BEGIN_MASTER(myThid)

C--   sanity checks
      DO i=1,nconmax
       IF ((tides_speed(i).EQ.UNSET_RL .OR. tides_phase(i).EQ.UNSET_RL)
     &     .AND. tides_amp(i).NE. 0 _d 0) THEN
         WRITE(msgBuf,'(2A,I)') 'TIDES_READPARMS: ',
     &    'Have to set speed and phase for unknown constituent # ', i
         CALL PRINT_ERROR( msgBuf, myThid )
         CALL ALL_PROC_DIE( myThid )
         STOP 'ABNORMAL END: S/R TIDES_READPARMS'
       ENDIF
      ENDDO

C--   log tidal constituent parameters
      days = INT(tides_reftime/86400 _d 0)
      secs = MODULO(tides_reftime, 86400 _d 0)
      WRITE(msgBuf,'(A,I12,A,F12.6,A)') 'TIDES: reftime: ',
     &      days, ' days, ', secs, ' secs'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , 1)

      CALL WRITE_0D_L( tides_nodalCorr, INDEX_NONE,
     & 'tides_nodalCorr =', '  /* apply nodal corrections */')

      DO i=1,nconmax
       IF (tides_amp(i) .NE. 0 _d 0) THEN
        WRITE(msgBuf,'(A)') 'TIDES:'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,I2,2A)') 'TIDES: constituent ', i, ': ',
     &           tides_constit(i)
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,7I3)') 'TIDES:  Doodson = ', tides_Doodson(:,i)
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,I2)') 'TIDES:  inodal  = ', tides_inodal(i)
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F20.16,A)') 'TIDES:  amp     = ',
     &        tides_amp(i), ' m'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F20.16,A)') 'TIDES:  speed   = ',
     &        tides_speed(i)*86400/(2*PI), ' cycles/day'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F20.16,A)') 'TIDES:  phase   = ',
     &        tides_phase(i)/deg2rad, ' degrees'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F19.15)') 'TIDES:  alpha   = ', tides_alpha(i)
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
       ENDIF
      ENDDO

      _END_MASTER(myThid)

#endif /* ALLOW_TIDES */

      RETURN
      END
