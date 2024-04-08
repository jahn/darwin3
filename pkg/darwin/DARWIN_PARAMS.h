#ifdef ALLOW_DARWIN

CBOP
C     !ROUTINE: DARWIN_PARAMS.h
C     !INTERFACE:
C #include DARWIN_PARAMS.h

C     !DESCRIPTION:
C Contains run-time parameters for the darwin package
C
C Requires: DARWIN_SIZE.h

      _RL DARWIN_UNINIT_RL
      PARAMETER(DARWIN_UNINIT_RL=-999999999 _d 0)

C--   COMMON/darwin_forcing_params_l/ darwin parameters related to forcing
C     darwin_chlInitBalanced :: Initialize Chlorophyll to a balanced value following Geider
C     darwin_haveSurfPAR     :: whether PAR forcing fields/constant were given
C     darwin_haveVentHe3     :: whether hydrothermal vent forcing was given
C     darwin_useSEAICE       :: whether to use ice area from seaice pkg
C     darwin_useQsw          :: whether to use model shortwave radiation
C     darwin_useEXFwind      :: whether to use wind speed from exf package
      COMMON/darwin_forcing_params_l/
     &    darwin_chlInitBalanced,
     &    darwin_haveSurfPAR,
     &    darwin_haveVentHe3,
     &    darwin_useSEAICE,
     &    darwin_useQsw,
     &    darwin_useEXFwind
      LOGICAL darwin_chlInitBalanced
      LOGICAL darwin_haveSurfPAR
      LOGICAL darwin_haveVentHe3
      LOGICAL darwin_useSEAICE
      LOGICAL darwin_useQsw
      LOGICAL darwin_useEXFwind

C--   COMMON/darwin_forcing_params_i/ darwin parameters related to forcing
C     darwin_chlIter0 :: Iteration number when to initialize Chlorophyll
      COMMON/darwin_forcing_params_i/
     &    darwin_chlIter0
      INTEGER darwin_chlIter0

C--   COMMON /DARWIN_CONSTANTS_r/
C     rad2deg ::
      COMMON /DARWIN_CONSTANTS_r/
     &    rad2deg
      _RL rad2deg

#ifdef DARWIN_ALLOW_CARBON
C--   COMMON /CARBON_CONSTANTS_r/ Coefficients for DIC chemistry
C     Pa2Atm :: Convert pressure in Pascal to atm
C     ptr2mol :: convert ptracers (in mmol/m3) to mol/m3
C-
C     sca1 :: Schmidt no. coefficient for CO2
C     sca2 :: Schmidt no. coefficient for CO2
C     sca3 :: Schmidt no. coefficient for CO2
C     sca4 :: Schmidt no. coefficient for CO2
C-
C     sox1 :: [] Schmidt no. coefficient for O2 [Keeling et al, GBC, 12, 141, (1998)]
C     sox2 :: [] Schmidt no. coefficient for O2 [Keeling et al, GBC, 12, 141, (1998)]
C     sox3 :: [] Schmidt no. coefficient for O2 [Keeling et al, GBC, 12, 141, (1998)]
C     sox4 :: [] Schmidt no. coefficient for O2 [Keeling et al, GBC, 12, 141, (1998)]
C-
C     oA0 :: Coefficient for determining saturation O2
C     oA1 :: Coefficient for determining saturation O2
C     oA2 :: Coefficient for determining saturation O2
C     oA3 :: Coefficient for determining saturation O2
C     oA4 :: Coefficient for determining saturation O2
C     oA5 :: Coefficient for determining saturation O2
C     oB0 :: Coefficient for determining saturation O2
C     oB1 :: Coefficient for determining saturation O2
C     oB2 :: Coefficient for determining saturation O2
C     oB3 :: Coefficient for determining saturation O2
C     oC0 :: Coefficient for determining saturation O2
      COMMON /CARBON_CONSTANTS_r/
     &    Pa2Atm,
     &    ptr2mol,
     &    sca1,
     &    sca2,
     &    sca3,
     &    sca4,
     &    sox1,
     &    sox2,
     &    sox3,
     &    sox4,
     &    oA0,
     &    oA1,
     &    oA2,
     &    oA3,
     &    oA4,
     &    oA5,
     &    oB0,
     &    oB1,
     &    oB2,
     &    oB3,
     &    oC0
      _RL Pa2Atm
      _RL ptr2mol
      _RL sca1
      _RL sca2
      _RL sca3
      _RL sca4
      _RL sox1
      _RL sox2
      _RL sox3
      _RL sox4
      _RL oA0
      _RL oA1
      _RL oA2
      _RL oA3
      _RL oA4
      _RL oA5
      _RL oB0
      _RL oB1
      _RL oB2
      _RL oB3
      _RL oC0

# ifdef DARWIN_ALLOW_RADI
C--   COMMON /DARWIN_SED_CONSTANTS_R/ Coefficients for sediment model
C     sed_a1 :: coefficient for sediment model
C     sed_b1 :: coefficient for sediment model
C     sed_c1 :: coefficient for sediment model
C     sed_d1 :: coefficient for sediment model
C     sed_a2 :: coefficient for sediment model
C     sed_b2 :: coefficient for sediment model
C     sed_c2 :: coefficient for sediment model
C     sed_d2 :: coefficient for sediment model
C     sed_a3 :: coefficient for sediment model
C     sed_b3 :: coefficient for sediment model
C     sed_c3 :: coefficient for sediment model
C     sed_d3 :: coefficient for sediment model
C     sed_a4 :: coefficient for sediment model
C     sed_b4 :: coefficient for sediment model
C     sed_c4 :: coefficient for sediment model
C     sed_d4 :: coefficient for sediment model
C     sed_a5 :: coefficient for sediment model
C     sed_b5 :: coefficient for sediment model
C     sed_c5 :: coefficient for sediment model
C     sed_d5 :: coefficient for sediment model
C     sed_c :: coefficient for sediment model
      COMMON /DARWIN_SED_CONSTANTS_R/
     &    sed_a1,
     &    sed_b1,
     &    sed_c1,
     &    sed_d1,
     &    sed_a2,
     &    sed_b2,
     &    sed_c2,
     &    sed_d2,
     &    sed_a3,
     &    sed_b3,
     &    sed_c3,
     &    sed_d3,
     &    sed_a4,
     &    sed_b4,
     &    sed_c4,
     &    sed_d4,
     &    sed_a5,
     &    sed_b5,
     &    sed_c5,
     &    sed_d5,
     &    sed_c
      _RL sed_a1
      _RL sed_b1
      _RL sed_c1
      _RL sed_d1
      _RL sed_a2
      _RL sed_b2
      _RL sed_c2
      _RL sed_d2
      _RL sed_a3
      _RL sed_b3
      _RL sed_c3
      _RL sed_d3
      _RL sed_a4
      _RL sed_b4
      _RL sed_c4
      _RL sed_d4
      _RL sed_a5
      _RL sed_b5
      _RL sed_c5
      _RL sed_d5
      _RL sed_c
# endif
#endif

C     COMMON /DARWIN_PARAMS_c/ General parameters (same for all plankton)
C     darwin_pickupSuff :: pickup suffix for darwin; set to ' ' to disable reading at PTRACERS_Iter0
      COMMON /DARWIN_PARAMS_c/ darwin_pickupSuff
      CHARACTER*10 darwin_pickupSuff
C     darwin_strict_check  :: stop instead of issuing warnings
C     darwin_linFSConserve :: correct non-conservation due to linear free surface (globally)
C     darwin_read_phos     :: initial conditions for plankton biomass are in mmol P/m3
C--   COMMON /DARWIN_PARAMS_l/ General parameters (same for all plankton)
      COMMON /DARWIN_PARAMS_l/
     &    darwin_strict_check,
     &    darwin_linFSConserve,
     &    darwin_read_phos
      LOGICAL darwin_strict_check
      LOGICAL darwin_linFSConserve
      LOGICAL darwin_read_phos

C--   COMMON /DARWIN_PARAMS_i/ General parameters (same for all plankton)
C     iDEBUG      :: index in x dimension for debug prints
C     jDEBUG      :: index in y dimension for debug prints
C     kDEBUG      :: index in z dimension for debug prints
      COMMON /DARWIN_PARAMS_i/
     &    iDEBUG,
     &    jDEBUG,
     &    kDEBUG
      INTEGER iDEBUG
      INTEGER jDEBUG
      INTEGER kDEBUG

#ifdef DARWIN_SOLVESAPHE
C If using Solvesaphe routines (Munhoven, 2013) this is used internally
       COMMON /DARWIN_SOLVESAPHE_I/
     &                     at_maxniter
      INTEGER at_maxniter
#endif /* DARWIN_SOLVESAPHE */

C--   COMMON /DARWIN_DEPENDENT_PARAMS_i/
C     laCDOM     :: index of reference waveband for CDOM absorption spectrum
C     kMinFeSed  :: minimum level index for iron sedimentation
C     kMaxFeSed  :: maximum level index for iron sedimentation
C     kMinFeVent :: minimum level index for hydrothermal vents
      COMMON /DARWIN_DEPENDENT_PARAMS_i/
     &    darwin_dependent_i_dummy,
#ifdef ALLOW_RADTRANS
#ifdef DARWIN_ALLOW_CDOM
#else
     &    laCDOM,
#endif
#endif
     &    kMinFeSed,
     &    kMaxFeSed,
     &    kMinFeVent
      INTEGER darwin_dependent_i_dummy
#ifdef ALLOW_RADTRANS
#ifdef DARWIN_ALLOW_CDOM
#else
      INTEGER laCDOM
#endif
#endif
      INTEGER kMinFeSed
      INTEGER kMaxFeSed
      INTEGER kMinFeVent


#endif /* ALLOW_DARWIN */

