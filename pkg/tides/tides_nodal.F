#include "TIDES_OPTIONS.h"

CBOP
C !ROUTINE: TIDES_NODAL_SET

C !INTERFACE: ==========================================================
      SUBROUTINE TIDES_NODAL_SET( myTime, myIter, myThid )

C !DESCRIPTION:
C Update astronomical parameters

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "cal.h"
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

C !LOCAL VARIABLES: ====================================================
      CHARACTER*20 timestr
      REAL*8 time
      INTEGER myDate(4)
      INTEGER yr, mon, day, hr, mn, sec, i
      _RL s,h,p,N,pp,cents
      _RL fnodal(0:nnodal)
      _RL unodal(0:nnodal)

      _BEGIN_MASTER(myThid)

      CALL cal_GetDate(myIter, myTime, myDate, myThid)
C      yr = myDate(1)/10000
C      mon = MOD(myDate(1)/100,100)
C      day = MOD(myDate(1),100)
C      hr = myDate(2)/10000
C      mn = MOD(myDate(2)/100,100)
C      sec = MOD(myDate(2),100)
C      convert UTC to ephemeris time using SPICE
C      WRITE(timestr,'(I4,X,I2.2,X,I2.2,X,I2.2,X,I2.2,X,I2.2)'),
C     &   yr, mon, day, hr, mn, sec
C      CALL UTC2ET(timestr, time)
C      convert to centuries since J2000
C      cents = time/86400 _d 0/36525 _d 0
      CALL TIDES_ET(myDate, cents, myThid)

C     Determine equilibrium arguments
C     -------------------------------
      CALL TIDES_ASTRO5(cents, s, h, p, N, pp)
      CALL TIDES_NODAL(N, p, fnodal, unodal)

C     map to individual constituents
      DO i=1,nconmax
        tides_f(i) = fnodal(tides_inodal(i))
        tides_u(i) = unodal(tides_inodal(i))
      ENDDO

      _END_MASTER(myThid)
      _BARRIER

#endif /* ALLOW_TIDES */

      RETURN
      END


      SUBROUTINE TIDES_NODAL(
     I                        N, p,
     O                        fnodal, unodal )
C !DESCRIPTION:
C  adapted from OTIS, original comments:
C
C  R Ray  21 August 2003
C  Revised 9/15/08.
C  Revised 3/28/11 - fixed Mt, MSt.

C !USES: ===============================================================
      IMPLICIT NONE
#include "TIDES_PARAMS.h"
C !INPUT PARAMETERS: ===================================================
C N      :: Mean longitude of ascending lunar node in degrees
C p      :: Mean longitude of lunar perigee in degrees
      _RL N, p

C !OUTPUT PARAMETERS: ==================================================
C fnodal :: Nodal correction factor for all 'nodal types'
C unodal :: Nodal phase correction for all 'nodal types' in rad
      _RL fnodal(0:nnodal)
      _RL unodal(0:nnodal)
CEOP

#ifdef ALLOW_TIDES

C !LOCAL VARIABLES: ====================================================
      INTEGER i
      _RL cosn,cos2n,sinn,sin2n,sin3n,sinpn,cospn
      _RL sinp,cosp,sin2p,cos2p,sin2pn,cos2pn
      _RL term1(0:nnodal)
      _RL term2(0:nnodal)
      _RL pi, rad
      PARAMETER(pi=3.141592654d0, rad=pi/180.D0)

!     -------------------------------------------------
      sinn = SIN(N*rad)
      cosn = COS(N*rad)
      sin2n = SIN(2*N*rad)
      cos2n = COS(2*N*rad)
      sin3n = SIN(3*N*rad)
      sinp  = SIN(p*rad)
      cosp  = COS(p*rad)
      sin2p = SIN(2*p*rad)
      cos2p = COS(2*p*rad)
      sinpn = SIN((p-N)*rad)
      cospn = COS((p-N)*rad)
      sin2pn = SIN((2*p-N)*rad)
      cos2pn = COS((2*p-N)*rad)

      term1(0) = 0.0
      term2(0) = 1.0

C     mm, msm
      term1(1) = -.0534*sin2p - .0219*sin2pn
      term2(1) = 1.0 - .1308*cosn - .0534*cos2p - .0219*cos2pn

C     mf, msq, msp, mq
      term1(2) = -0.04324*sin2p - 0.41465*sinn - 0.03873*sin2n
      term2(2) = 1.0 +0.04324*cos2p +0.41465*cosn +0.03873*cos2n

C     msf     !  This is linear tide, not compound.
      term1(3) = 0.137*sinn
      term2(3) = 1.0

C     mt
      term1(4) = -0.018*sin2p - 0.4145*sinn - 0.040*sin2n
      term2(4) = 1.0 +0.018*cos2p +0.4145*cosn +0.040*cos2n

C     mst
      term1(5) = -0.380*sin2p - 0.413*sinn - 0.037*sin2n
      term2(5) = 1.0 +0.380*cos2p +0.413*cosn +0.037*cos2n

C     o1, so3
      term1(6) = 0.1886*sinn - 0.0058*sin2n - 0.0065*sin2p
      term2(6) = 1.0 + 0.1886*cosn - 0.0058*cos2n - 0.0065*cos2p

C     2q1, q1, rho1, sig1
      term1(7) = 0.1886*sinn
      term2(7) = 1.0 + 0.1886*cosn
C     tau1
      term1(8) = 0.219*sinn
      term2(8) = 1.0 - 0.219*cosn

C     m1        ! This assumes m1 argument includes p.
      term1(9) = -0.2294*sinn - 0.3594*sin2p - 0.0664*sin2pn
      term2(9) = 1.0 + 0.1722*cosn + 0.3594*cos2p + 0.0664*cos2pn
C     chi1
      term1(10) = -0.221*sinn
      term2(10) = 1.0 + 0.221*cosn
C     p1
      term1(11) = -0.0112*sinn
      term2(11) = 1.0 - 0.0112*cosn
C     k1, sk3
      term1(12) = -0.1554*sinn + 0.0031*sin2n
      term2(12) = 1.0 + 0.1158*cosn - 0.0028*cos2n
C     j1, the1
      term1(13) = -0.227*sinn
      term2(13) = 1.0 + 0.169*cosn
C     oo1
      term1(14) = -0.640*sinn - 0.134*sin2n - 0.150*sin2p
      term2(14) = 1.0 + 0.640*cosn + 0.134*cos2n + 0.150*cos2p

C     m2, 2n2, mu2, n2, nu2, lam2, 2sm2, ms4, eps2
      term1(15) = -0.03731*sinn + 0.00052*sin2n
      term2(15) = 1.0 - 0.03731*cosn + 0.00052*cos2n

C     l2
      term1(16) = -0.250*sin2p - 0.110*sin2pn - 0.037*sinn
      term2(16) = 1.0 - 0.250*cos2p - 0.110*cos2pn - 0.037*cosn
C     k2
      term1(17) = -0.3108*sinn - 0.0324*sin2n
      term2(17) = 1.0 + 0.2853*cosn + 0.0324*cos2n

C     eta2
      term1(18) = -0.436*sinn
      term2(18) = 1.0 + 0.436*cosn

C     m3, o3, F3   ! Linear 3rd-deg terms
C     term1(19) = -0.056*sinn
C     term2(19) = 1.0 - 0.056*cosn
C     j3
C     term1(20) = -0.43*sinn
C     term2(20) = 1.0 + 0.43*cosn

      DO i=0,nnodal
         fnodal(i) = SQRT(term1(i)**2 + term2(i)**2)
         unodal(i) = ATAN2(term1(i), term2(i))
      ENDDO

#endif /* ALLOW_TIDES */

      RETURN
      END


      SUBROUTINE TIDES_ASTRO5(
     I                         T,
     O                         s, h, p, N, pp )
C
C     Computes the 5 basic astronomical mean longitudes  s, h, p, N, p'.
C
C     Note N is not N', i.e. N is decreasing with time.
C
C     T is ephemeris time in Julian centuries since J2000.
C
C     Code adapted from OTIS, https://www.tpxo.net/
C
C     original comments:
C
C     R. D. Ray, NASA/GSFC   August 2003
C
C     Most of the formulae for mean longitudes are extracted from
C     Jean Meeus, Astronomical Algorithms, 2nd ed., 1998.
C     Page numbers below refer to this book.
C
C     Note: This routine uses TIME in UT and does not distinguish between
C     the subtle differences of UTC, UT1, etc.  This is more than adequate
C     for the calculation of these arguments, especially in tidal studies.
C
C     Revised 4/15/10 - minor change to modulo function eliminates some extra code.

      IMPLICIT NONE
C !INPUT PARAMETERS: ===================================================
C     T   :: ephemeris time in Julian centuries since J2000
      _RL T

C !OUTPUT PARAMETERS: ==================================================
c     s   :: mean longitude of moon
c     h   :: mean longitude of sun
c     p   :: mean longitude of lunar perigee
c     N   :: mean longitude of ascending lunar node
c     pp  :: mean longitude of solar perigee
      _RL s, h, p, N, pp
CEOP

#ifdef ALLOW_TIDES

C !LOCAL VARIABLES: ====================================================
      _RL D

C     mean longitude of moon (p.338)
      s = (((-1.53388D-8*T + 1.855835D-6)*T - 1.5786D-3)*T +
     &     481267.88123421D0)*T + 218.3164477D0

C     mean elongation of moon (p.338)
      D = (((-8.8445D-9*T + 1.83195D-6)*T - 1.8819D-3)*T +
     &     445267.1114034D0)*T + 297.8501921D0

C     mean longitude of sun
      h = s - D

C     mean longitude of lunar perigee (p.343)
      p = ((-1.249172D-5*T - 1.032D-2)*T + 4069.0137287D0)*T +
     &    83.3532465D0

C     mean longitude of ascending lunar node (p.144)
      N = ((2.22222D-6*T + 2.0708D-3)*T - 1934.136261D0)*T +
     &    125.04452D0

C     mean longitude of solar perigee (Simon et al., 1994)
      pp = 282.94D0 + 1.7192D0*T

      s = MODULO(s, 360 _d 0)
      h = MODULO(h, 360 _d 0)
      p = MODULO(p, 360 _d 0)
      N = MODULO(N, 360 _d 0)
      pp = MODULO(pp, 360 _d 0)

#endif /* ALLOW_TIDES */

      RETURN
      END


      SUBROUTINE TIDES_ASTRO5SPEEDS(
     I                               T,
     O                               ds, dh, dp, dN, dpp )
C
C     Computes the change rates of the 5 basic astronomical mean longitudes,
C     s, h, p, N, p'.
C
C     Note N is not N', i.e. N is decreasing with time.
C
C     T is ephemeris time in Julian centuries since J2000.
C     All speeds are returned in degrees per day.

C     Code adapted from OTIS, https://www.tpxo.net/
C
C     original comments:
C
C     R. D. Ray, NASA/GSFC   August 2003
C
C     Most of the formulae for mean longitudes are extracted from
C     Jean Meeus, Astronomical Algorithms, 2nd ed., 1998.
C     Page numbers below refer to this book.
C
C     Note: This routine uses TIME in UT and does not distinguish between
C     the subtle differences of UTC, UT1, etc.  This is more than adequate
C     for the calculation of these arguments, especially in tidal studies.
C
C     Revised 4/15/10 - minor change to modulo function eliminates some extra code.

      IMPLICIT NONE
C !INPUT PARAMETERS: ===================================================
C     T   :: ephemeris time in Julian centuries since J2000
      _RL T

C !OUTPUT PARAMETERS: ==================================================
c     s   :: mean longitude of moon
c     h   :: mean longitude of sun
c     p   :: mean longitude of lunar perigee
c     N   :: mean longitude of ascending lunar node
c     pp  :: mean longitude of solar perigee
      _RL ds, dh, dp, dN, dpp
CEOP

#ifdef ALLOW_TIDES

C !LOCAL VARIABLES: ====================================================
      _RL dD

C     mean longitude of moon (p.338)
      ds = ((-4*1.53388D-8*T + 3*1.855835D-6)*T - 2*1.5786D-3)*T +
     &     481267.88123421D0

C     mean elongation of moon (p.338)
      dD = ((-4*8.8445D-9*T + 3*1.83195D-6)*T - 2*1.8819D-3)*T +
     &     445267.1114034D0

C     mean longitude of sun
      dh = ds - dD

C     mean longitude of lunar perigee (p.343)
      dp = (-3*1.249172D-5*T - 2*1.032D-2)*T + 4069.0137287D0

C     mean longitude of ascending lunar node (p.144)
      dN = (3*2.22222D-6*T + 2*2.0708D-3)*T - 1934.136261D0

C     mean longitude of solar perigee (Simon et al., 1994)
      dpp = 1.7192D0

C     convert to degrees per day
      ds = ds/36525 _d 0
      dh = dh/36525 _d 0
      dp = dp/36525 _d 0
      dN = dN/36525 _d 0
      dpp = dpp/36525 _d 0

#endif /* ALLOW_TIDES */

      RETURN
      END
