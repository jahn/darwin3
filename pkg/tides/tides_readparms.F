#include "TIDES_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: TIDES_READPARMS

C !INTERFACE:
      SUBROUTINE TIDES_READPARMS( myThid )

C     !DESCRIPTION:
C     Initialize TIDES variables and constants.

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "cal.h"
#include "TIDES_PARAMS.h"
#include "TIDES_CONSTIT.h"

C     !INPUT PARAMETERS:
      INTEGER myThid
CEOP

#ifdef ALLOW_TIDES

C     !LOCAL VARIABLES:
C     msgBuf     :: Informational/error message buffer
C     iUnit      :: Work variable for IO unit number
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      CHARACTER*20 timestr
      CHARACTER*4 constitName(nconmax)
      INTEGER iUnit, i, j, iconstit
      INTEGER Doodson(7, nconmax)
      INTEGER inodalCnst(nconmax)
      _RL ampCnst(nconmax)
      _RL alphaCnst(nconmax)
      _RL cents, t1, s, h, p, N, pp
      _RL ph, sp, ds, dh, dp, dN, dpp
      REAL*8 time

      NAMELIST /TIDES_PARM01/
     &       tides_orientData, tides_metaKernel,
     &       tides_earthRadius,
     &       tides_h2, tides_k2,
     &       tides_permC0, tides_permC1,
     &       tides_fullLuniSolar,
     &       tides_constit,
     &       tides_refDate1,
     &       tides_refDate2,
     &       tides_nodalCorr

      NAMELIST /TIDES_PARM02/
     &       tides_speed,
     &       tides_phase,
     &       tides_amp,
     &       tides_alpha

      IF ( .NOT.useTIDES ) THEN
C-    pkg TIDES is not used
        _BEGIN_MASTER(myThid)
C-    Track pkg activation status:
C     print a (weak) warning if data.tides is found
         CALL PACKAGES_UNUSED_MSG( 'useTIDES', ' ', ' ' )
        _END_MASTER(myThid)
        RETURN
      ENDIF

      _BEGIN_MASTER(myThid)

C The following are parameters for all supported tidal constituents
C They will be assigned to selected constituents after reading
C tides_constit.
C
C     define available constituents
      constitName( 1) = 'm2'
      constitName( 2) = 's2'
      constitName( 3) = 'k1'
      constitName( 4) = 'o1'
      constitName( 5) = 'n2'
      constitName( 6) = 'p1'
      constitName( 7) = 'k2'
      constitName( 8) = 'q1'
      constitName( 9) = '2n2'
      constitName(10) = 'mu2'
      constitName(11) = 'nu2'
      constitName(12) = 'l2'
      constitName(13) = 't2'
      constitName(14) = 'j1'
      constitName(15) = 'm1'
      constitName(16) = 'oo1'
      constitName(17) = 'rho1'
      constitName(18) = 'mf'
      constitName(19) = 'mm'
      constitName(20) = 'ssa'
      constitName(21) = 'msf'
      constitName(22) = 'sa'
      constitName(23) = 'sta'
      constitName(24) = 'msm'
      constitName(25) = 'mst'
      constitName(26) = 'mt'
      constitName(27) = 'msq'
      constitName(28) = 'mq'
      constitName(29) = 'msp'
      constitName(30) = '2q1'
      constitName(31) = 'node'

C                         m   s   h   p   N  pp  90
      Doodson(:,  1) = (/ 2,  0,  0,  0,  0,  0,  0 /)
      Doodson(:,  2) = (/ 2,  2, -2,  0,  0,  0,  0 /)
      Doodson(:,  3) = (/ 1,  1,  0,  0,  0,  0,  1 /)
      Doodson(:,  4) = (/ 1, -1,  0,  0,  0,  0, -1 /)
      Doodson(:,  5) = (/ 2, -1,  0,  1,  0,  0,  0 /)
      Doodson(:,  6) = (/ 1,  1, -2,  0,  0,  0, -1 /)
      Doodson(:,  7) = (/ 2,  2,  0,  0,  0,  0,  0 /)
      Doodson(:,  8) = (/ 1, -2,  0,  1,  0,  0, -1 /)
      Doodson(:,  9) = (/ 2, -2,  0,  2,  0,  0,  0 /)
      Doodson(:, 10) = (/ 2, -2,  2,  0,  0,  0,  0 /)
      Doodson(:, 11) = (/ 2, -1,  2, -1,  0,  0,  0 /)
      Doodson(:, 12) = (/ 2,  1,  0, -1,  0,  0,  2 /)
      Doodson(:, 13) = (/ 2,  2, -3,  0,  0,  1,  0 /)
      Doodson(:, 14) = (/ 1,  2,  0, -1,  0,  0,  1 /)
      Doodson(:, 15) = (/ 1,  0,  0,  1,  0,  0,  1 /)
      Doodson(:, 16) = (/ 1,  3,  0,  0,  0,  0,  1 /)
      Doodson(:, 17) = (/ 1, -2,  2, -1,  0,  0, -1 /)
      Doodson(:, 18) = (/ 0,  2,  0,  0,  0,  0,  0 /)
      Doodson(:, 19) = (/ 0,  1,  0, -1,  0,  0,  0 /)
      Doodson(:, 20) = (/ 0,  0,  2,  0,  0,  0,  0 /)
      Doodson(:, 21) = (/ 0,  2, -2,  0,  0,  0,  0 /)
      Doodson(:, 22) = (/ 0,  0,  1,  0,  0, -1,  0 /)
      Doodson(:, 23) = (/ 0,  0,  3,  0,  0, -1,  0 /)
      Doodson(:, 24) = (/ 0,  1, -2,  1,  0,  0,  0 /)
      Doodson(:, 25) = (/ 0,  3, -2,  1,  0,  0,  0 /)
      Doodson(:, 26) = (/ 0,  3,  0, -1,  0,  0,  0 /)
      Doodson(:, 27) = (/ 0,  4, -2,  0,  0,  0,  0 /)
      Doodson(:, 28) = (/ 0,  4,  0, -2,  0,  0,  0 /)
      Doodson(:, 29) = (/ 0,  5, -2, -1,  0,  0,  0 /)
      Doodson(:, 30) = (/ 1, -3,  0,  2,  0,  0, -1 /)
      Doodson(:, 31) = (/ 0,  0,  0,  0,  1,  0,  2 /)

C     index into nodal correction arrays, 0: no correction
      inodalCnst( 1) = 15  ! m2
      inodalCnst( 2) = 0   ! s2
      inodalCnst( 3) = 12  ! k1
      inodalCnst( 4) = 6   ! o1
      inodalCnst( 5) = 15  ! n2
      inodalCnst( 6) = 11  ! p1
      inodalCnst( 7) = 17  ! k2
      inodalCnst( 8) = 7   ! q1
      inodalCnst( 9) = 15  ! 2n2
      inodalCnst(10) = 15  ! mu2
      inodalCnst(11) = 15  ! nu2
      inodalCnst(12) = 16  ! l2
      inodalCnst(13) = 0   ! t2
      inodalCnst(14) = 13  ! j1
      inodalCnst(15) = 9   ! m1
      inodalCnst(16) = 14  ! oo1
      inodalCnst(17) = 7   ! rho1
      inodalCnst(18) = 2   ! mf
      inodalCnst(19) = 1   ! mm
      inodalCnst(20) = 0   ! ssa
      inodalCnst(21) = 3   ! msf
      inodalCnst(22) = 0   ! sa
      inodalCnst(23) = 0   ! sta
      inodalCnst(24) = 1   ! msm
      inodalCnst(25) = 5   ! mst
      inodalCnst(26) = 4   ! mt
      inodalCnst(27) = 2   ! msq
      inodalCnst(28) = 2   ! mq
      inodalCnst(29) = 2   ! msp
      inodalCnst(30) = 7   ! 2q1
      inodalCnst(31) = 0   ! node

C     amplitudes in m
      ampCnst( 1) = 0.244102 _d 0
      ampCnst( 2) = 0.113568 _d 0
      ampCnst( 3) = 0.142435 _d 0
      ampCnst( 4) = 0.101270 _d 0
      ampCnst( 5) = 0.046735 _d 0
      ampCnst( 6) = 0.047129 _d 0
      ampCnst( 7) = 0.030879 _d 0
      ampCnst( 8) = 0.019387 _d 0
      ampCnst( 9) = 0.006184 _d 0
      ampCnst(10) = 0.007408 _d 0
      ampCnst(11) = 0.008811 _d 0
      ampCnst(12) = 0.006931 _d 0
      ampCnst(13) = 0.006608 _d 0
      ampCnst(14) = 0.007965 _d 0
      ampCnst(15) = 0.007915 _d 0
      ampCnst(16) = 0.004361 _d 0
      ampCnst(17) = 0.003661 _d 0
      ampCnst(18) = 0.042041 _d 0
      ampCnst(19) = 0.022193 _d 0
      ampCnst(20) = 0.019547 _d 0
      ampCnst(21) = 0.003681 _d 0
      ampCnst(22) = 0.003104 _d 0
      ampCnst(23) = 0.001141 _d 0
      ampCnst(24) = 0.004244 _d 0
      ampCnst(25) = 0.001528 _d 0
      ampCnst(26) = 0.008044 _d 0
      ampCnst(27) = 0.001285 _d 0
      ampCnst(28) = 0.001064 _d 0
      ampCnst(29) = 0.000310 _d 0
      ampCnst(30) = 0.002565 _d 0
      ampCnst(31) = 0.017617 _d 0

C     Earth tide correction factors 1 - h + k
      alphaCnst( 1) = 0.693 _d 0  ! m2: 1 - .609 + .302
      alphaCnst( 2) = 0.693 _d 0  ! s2
      alphaCnst( 3) = 0.736 _d 0  ! k1: 1 - .520 + .256
      alphaCnst( 4) = 0.695 _d 0  ! o1: 1 - .603 + .298
      alphaCnst( 5) = 0.693 _d 0  ! n2
      alphaCnst( 6) = 0.706 _d 0  ! p1: 1 - .581 + .287
      alphaCnst( 7) = 0.693 _d 0  ! k2
      alphaCnst( 8) = 0.695 _d 0  ! q1: 1 - .603 + .298
      alphaCnst( 9) = 0.693 _d 0  ! 2n2
      alphaCnst(10) = 0.693 _d 0  ! mu2
      alphaCnst(11) = 0.693 _d 0  ! nu2
      alphaCnst(12) = 0.693 _d 0  ! l2
      alphaCnst(13) = 0.693 _d 0  ! t2
      alphaCnst(14) = 0.695 _d 0  ! j1
      alphaCnst(15) = 0.695 _d 0  ! m1
      alphaCnst(16) = 0.695 _d 0  ! oo1
      alphaCnst(17) = 0.695 _d 0  ! rho1
      alphaCnst(18) = 0.693 _d 0  ! mf
      alphaCnst(19) = 0.693 _d 0  ! mm
      alphaCnst(20) = 0.693 _d 0  ! ssa
      alphaCnst(21) = 0.693 _d 0  ! msf
      alphaCnst(22) = 0.693 _d 0  ! sa
      alphaCnst(23) = 0.693 _d 0  ! sta
      alphaCnst(24) = 0.693 _d 0  ! msm
      alphaCnst(25) = 0.693 _d 0  ! mst
      alphaCnst(26) = 0.693 _d 0  ! mt
      alphaCnst(27) = 0.693 _d 0  ! msq
      alphaCnst(28) = 0.693 _d 0  ! mq
      alphaCnst(29) = 0.693 _d 0  ! msp
      alphaCnst(30) = 0.693 _d 0  ! 2q1
      alphaCnst(31) = 0.693 _d 0  ! node

C--   Default values
      tides_orientData = 'IAU_EARTH'
      tides_metaKernel = ' '
C     tides_earthRadius = rSphere
      tides_earthRadius = 6371 _d 3
      tides_h2 = 0.61 _d 0
      tides_k2 = 0.3 _d 0
C     permanent tide coefficients from HW95
      tides_permC0 = 0.8695487585 _d 0
      tides_permC1 = 0.0002826064 _d 0
      tides_fullLuniSolar = .FALSE.
C     date for which to compute speed and phase
      tides_refDate1 = 20000101
      tides_refDate2 = 0
C     whether to apply nodal corrections (f and u)
      tides_nodalCorr = .TRUE.

      DO i=1,nconmax
        tides_constit(i) = ' '
        tides_speed(i) = UNSET_RL
        tides_phase(i) = UNSET_RL
        tides_amp(i) = 0 _d 0
        tides_alpha(i) = 0.693 _d 0
        tides_Doodson(:,i) = 0
      ENDDO

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
      WRITE(msgBuf,'(A)') 'TIDES_READPARMS: opening data.tides'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , 1)
      CALL OPEN_COPY_DATA_FILE(
     I                     'data.tides', 'TIDES_READPARMS',
     O                     iUnit,
     I                     myThid )

C     Read parameters from open data file
      READ(UNIT=iUnit,NML=TIDES_PARM01)

C--   map parameters to selected constituents
      tides_haveConstit = .FALSE.
      DO i=1,nconmax
       IF (tides_constit(i) .NE. ' ') THEN
        iconstit = 0
        DO j=1,nconmax
         IF (tides_constit(i) .EQ. constitName(j)) THEN
          tides_haveConstit = .TRUE.
          iconstit = j
          tides_Doodson(:,i) = Doodson(:,j)
          tides_inodal(i) = inodalCnst(j)
          tides_amp(i) = ampCnst(j)
          tides_alpha(i) = alphaCnst(j)
C         speed and phase are computed in tides_init_constit
         ENDIF
        ENDDO
        IF (iconstit .EQ. 0) THEN
         WRITE(msgBuf,'(2A,I,2A)') 'TIDES_READPARMS: ',
     &    'Unknown constituent # ', i, ': ', tides_constit(i)
         CALL PRINT_ERROR( msgBuf, myThid )
         CALL ALL_PROC_DIE( myThid )
         STOP 'ABNORMAL END: S/R TIDES_READPARMS'
        ENDIF
       ENDIF
      ENDDO

C--   individual parameters may be overwritten
      READ(UNIT=iUnit,NML=TIDES_PARM02)

      WRITE(msgBuf,'(A)')
     &    'TIDES_READPARMS: finished reading data.tides'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &    SQUEEZE_RIGHT , 1)
C     Close the open data file
#ifdef SINGLE_DISK_IO
      CLOSE(iUnit)
#else
      CLOSE(iUnit,STATUS='DELETE')
#endif /* SINGLE_DISK_IO */

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
C sanity checks

#ifdef ALLOW_CAL
      IF (.NOT.useCAL) THEN
#else
      IF (.TRUE.) THEN
#endif
       WRITE(msgBuf,'(A)')
     &    'TIDES_READPARMS: The tides pkg requires the cal pkg.'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A)')
     &    'TIDES_READPARMS: Enable it in packages.conf and data.pkg.'
       CALL PRINT_ERROR( msgBuf, myThid )
       CALL ALL_PROC_DIE( myThid )
       STOP 'ABNORMAL END: S/R TIDES_READPARMS'
      ENDIF

#ifndef TIDES_ALLOW_FULL
      IF ( tides_fullLuniSolar ) THEN
       WRITE(msgBuf,'(2A)') 'TIDES_READPARMS: tides_fullLuniSolar ',
     &    'requires #define TIDES_ALLOW_FULL'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(2A)') 'TIDES_READPARMS: ',
     &    'in TIDES_OPTIONS.h and the SPICE toolkit'
       CALL PRINT_ERROR( msgBuf, myThid )
       CALL ALL_PROC_DIE( myThid )
       STOP 'ABNORMAL END: S/R TIDES_READPARMS'
      ENDIF
#endif

      IF ( tides_fullLuniSolar .AND. tides_metaKernel .EQ. ' ' ) THEN
       WRITE(msgBuf,'(2A)') 'TIDES_READPARMS: need to provide ',
     &    'SPICE meta-kernel file in tides_metaKernel'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(2A)') 'TIDES_READPARMS: ',
     &    'for tides_fullLuniSolar = TRUE'
       CALL PRINT_ERROR( msgBuf, myThid )
       CALL ALL_PROC_DIE( myThid )
       STOP 'ABNORMAL END: S/R TIDES_READPARMS'
      ENDIF

      IF ( tides_fullLuniSolar .AND. tides_haveConstit ) THEN
       WRITE(msgBuf,'(2A)') 'TIDES_READPARMS: cannot specify ',
     &    'constituents when tides_fullLuniSolar is true.'
       CALL PRINT_ERROR( msgBuf, myThid )
       CALL ALL_PROC_DIE( myThid )
       STOP 'ABNORMAL END: S/R TIDES_READPARMS'
      ENDIF

      _END_MASTER(myThid)

C--   Everyone else must wait for the parameters to be loaded
      _BARRIER

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
      IF (tides_fullLuniSolar) THEN

        WRITE(msgBuf,'(A)') 'TIDES: computing full lunisolar potential'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,A)') 'TIDES: orientData = ',
     &        tides_orientData
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F20.12)') 'TIDES: Earth radius = ',
     &        tides_earthRadius
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F19.15)') 'TIDES: alpha = ',
     &        1 _d 0 - tides_h2 + tides_k2
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F20.16)') 'TIDES: permC0 = ',
     &        tides_permC0
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A,F20.16)') 'TIDES: permC1 = ',
     &        tides_permC1
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                      SQUEEZE_RIGHT , 1)

      ENDIF

#endif /* ALLOW_TIDES */

      RETURN
      END
