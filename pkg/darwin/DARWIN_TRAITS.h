#ifdef ALLOW_DARWIN

CBOP
C     !ROUTINE: DARWIN_TRAITS.h
C     !INTERFACE:
C #include DARWIN_TRAITS.h

C     !DESCRIPTION:
C Contains run-time parameters for the darwin package
C the parameters in this file are traits
C
C Requires: DARWIN_SIZE.h

C--   COMMON /DARWIN_DEPENDENT_TRAITS_i/ Dependent and constant (not read-in) parameters
C     group  :: which group this type belongs to
C     igroup :: index within group
C
C- Radtrans only:
C     aptype :: optical type (for absorption/scattering spectra)
      COMMON /DARWIN_DEPENDENT_TRAITS_i/
#ifdef ALLOW_RADTRANS
     &    aptype,
#endif
     &    group,
     &    igroup
#ifdef ALLOW_RADTRANS
      INTEGER aptype(nplank)
#endif
      INTEGER group(nplank)
      INTEGER igroup(nplank)

C--   COMMON /DARWIN_DEPENDENT_TRAITS_r/ Dependent and constant (not read-in) parameters
C     biovol           :: [um^3]                volume
C     qcarbon          :: [mmol C/cell]         cellular carbon content
C     biovol_bygroup   :: [um^3]                volume of types in each group
      COMMON /DARWIN_DEPENDENT_TRAITS_r/
     &    biovol,
     &    qcarbon,
     &    biovol_bygroup
      _RL biovol(nplank)
      _RL qcarbon(nplank)
      _RL biovol_bygroup(nplank,ngroup)


#endif /* ALLOW_DARWIN */

