#ifdef ALLOW_TIDES

      INTEGER nconmax
      PARAMETER(nconmax=31)

      INTEGER nnodal
      PARAMETER(nnodal=18)

C     for the table of deltat values
      INTEGER tabstart,tabend,tabsize
      PARAMETER(tabstart = 1620)
      PARAMETER(tabend   = 2027)
      PARAMETER(tabsize  = tabend - tabstart + 1)

      LOGICAL tides_fullLuniSolar
      LOGICAL tides_haveConstit
      LOGICAL tides_nodalCorr
      COMMON /TIDES_PARAMS_L/
     &  tides_fullLuniSolar,
     &  tides_haveConstit,
     &  tides_nodalCorr

      COMMON/TIDES_PARAMS_I/
     &      mjdEpoch
      INTEGER mjdEpoch(4)

      CHARACTER*4 tides_constit(nconmax)
      COMMON /TIDES_PARAMS_C/
     &  tides_constit

      CHARACTER*(255) tides_orientData
      CHARACTER*(255) tides_metaKernel
      COMMON /TIDES_PARAMS_C/
     &  tides_orientData,
     &  tides_metaKernel

      _RL tides_earthRadius
      _RL tides_h2
      _RL tides_k2
      _RL tides_sunGM
      _RL tides_moonGM
      _RL tides_permC0
      _RL tides_permC1
      _RL tides_permC
      _RL aSU, aMO
      _RL tides_tjds(tabsize)
      REAL*8 lonSU, latSU
      REAL*8 lonMO, latMO
      COMMON /TIDES_PARAMS_R/
     &  tides_tjds,
     &  tides_earthRadius, tides_h2, tides_k2,
     &  tides_sunGM, tides_moonGM,
     &  tides_permC0, tides_permC1, tides_permC,
     &  aSU, aMO, lonSU, latSU, lonMO, latMO

#endif /* ALLOW_TIDES */
