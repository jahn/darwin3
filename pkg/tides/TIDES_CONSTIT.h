#ifdef ALLOW_TIDES

C     tides_refDate1 :: reference date for speeds and phases, YYYYMMDD part
C     tides_refDate2 :: reference date for speeds and phases, HHMMSS part
C     tides_inodal   :: index into nodal correction arrays for each constituent
      COMMON/TIDES_CONSTIT_I/
     &      tides_refDate1, tides_refDate2,
     &      tides_inodal,
     &      tides_Doodson
      INTEGER tides_refDate1, tides_refDate2
      INTEGER tides_inodal(nconmax)
      INTEGER tides_Doodson(7, nconmax)

C     tides_SH     :: spherical harmonics for tidal constituents
C     tides_speed  :: speed of constituents [rad/s]
C     tides_phase  :: phase of constituents [rad]
C     tides_amp    :: amplitude of constituents [m]
C     tides_alpha  :: solid-Earth tide corrections factors
C     tides_f      :: nodal correction factor
C     tides_u      :: nodal phase correction [rad]
      COMMON/TIDES_CONSTIT_R/
     &      tides_SH,
     &      tides_speed,
     &      tides_phase,
     &      tides_amp,
     &      tides_alpha,
     &      tides_f,
     &      tides_u,
     &      tides_reftime
      _RL tides_SH(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy,2,0:2)
      _RL tides_speed(nconmax)
      _RL tides_phase(nconmax)
      _RL tides_amp(nconmax)
      _RL tides_alpha(nconmax)
      _RL tides_f(nconmax)
      _RL tides_u(nconmax)
      _RL tides_reftime

#endif /* ALLOW_TIDES */

