#include "DARWIN_OPTIONS.h"
#ifdef ALLOW_DARWIN

      MODULE DARWIN_PARAM_MOD

      private

#ifdef ALLOW_RADTRANS
#include "RADTRANS_SIZE.h"
#endif
#include "DARWIN_SIZE.h"

C--   COMMON /DARWIN_PARAMS_i/ General parameters (same for all plankton)
C     darwin_disscSelect   :: Switch for PIC dissolution rate formulation
C                          :: 0: fixed dissolution rate Kdissc
C                          :: 1: Keir 1980 power law
C                          :: 2: Naviaux et al. 2019
C
C--   COMMON /DARWIN_PARAMS_r/ General parameters (same for all plankton)
C     katten_w          :: [1/m]            atten coefficient water
C     katten_chl        :: [m2/mg Chl]      atten coefficient chl
C
C     parfrac           :: []               fraction Qsw that is PAR
C     parconv           :: [uEin/s/W]       conversion from W/m2 to uEin/m2/s
C     tempnorm          :: []               set temperature function (was 1.0)
C     TempAeArr         :: [K]              slope for pseudo-Arrhenius (TEMP_VERSION 2)
C     TemprefArr        :: [K]              reference temp for pseudo-Arrhenius (TEMP_VERSION 2)
C     TempCoeffArr      :: []               pre-factor for pseudo-Arrhenius (TEMP_VERSION 2)
C     reminTempAe       :: [1/K]            temperature coefficient for remineralization (TEMP_VERSION 4)
C     mortTempAe        :: [1/K]            temperature coefficient for linear mortality (TEMP_VERSION 4)
C     mort2TempAe       :: [1/K]            temperature coefficient for quadr. mortality (TEMP_VERSION 4)
C     uptakeTempAe      :: [1/K]            temperature coefficient for uptake (TEMP_VERSION 4)
C
C- Iron parameters
C     alpfe             :: []                  solubility of Fe dust
C     scav              :: [1/s]               fixed iron scavenging rate (#undef DARWIN_PART_SCAV)
C     ligand_tot        :: [mol/m3]            total ligand concentration
C     ligand_stab       :: [m3/mol]            ligand stability rate ratio
C     freefemax         :: [mol/m3]            max concentration of free iron
C     scav_tau          :: [1]                 factor to go from Th scavenging rate to iron
C     scav_inter        :: [L^e mg^-e s^-1]    intercept of scavenging power law (e=scav_exp)
C     scav_exp          :: [1]                 exponent of scavenging power law
C     scav_POC_wgt      :: [g / mmol C]        weight POC contributes to POM for scavenging
C     scav_POSi_wgt     :: [g / mmol Si]       weight POSi contributes to POM for scavenging
C     scav_PIC_wgt      :: [g / mmol C]        weight PIC contributes to POM for scavenging
C     scav_rat          :: [1]                 factor Th to iron for DARWIN_PART_SCAV_POP
C     scav_R_POPPOC     :: [mmol P / g C]      POP:POC ratio for DARWIN_PART_SCAV_POP
C     depthfesed        :: [m]                 depth above which to add sediment source (was -1000)
C     fesedflux         :: [mmol Fe /m2/s]     fixed iron flux from sediment
C     fesedflux_pcm     :: [mmol Fe / mmol C]  iron input per POC sinking into bottom for DARWIN_IRON_SED_SOURCE_VARIABLE
C     fesedflux_min     :: [mmol Fe /s]        min iron input rate subtracted from fesedflux_pcm*wc_sink*POC
C     R_CP_fesed        :: [mmol C / mmol P]   POC:POP conversion for DARWIN_IRON_SED_SOURCE_POP
C     depthFeVent       :: [m]                 depth below which iron from hydrothermal vents is added
C     solFeVent         :: []                  solubility of iron from hydrothermal vents
C     R_FeHe3_vent      :: [mmol Fe / mmol He3]  Fe:He3 ratio for hydrothermal vents
C
C     Knita             :: [1/s]               ammonia oxidation rate
C     Knitb             :: [1/s]               nitrite oxidation rate
C     PAR_oxi           :: [uEin/m2/s]         critical light level after which oxidation starts
C
C     Kdoc              :: [1/s]  DOC remineralization rate
C     Kdop              :: [1/s]  DON remineralization rate
C     Kdon              :: [1/s]  DOP remineralization rate
C     KdoFe             :: [1/s]  DOFe remineralization rate
C     KPOC              :: [1/s]  POC remineralization rate
C     KPON              :: [1/s]  PON remineralization rate
C     KPOP              :: [1/s]  POP remineralization rate
C     KPOFe             :: [1/s]  POFe remineralization rate
C     KPOSi             :: [1/s]  POSi remineralization rate
C
C     wC_sink           :: [m/s]  sinking velocity for POC
C     wN_sink           :: [m/s]  sinking velocity for PON
C     wP_sink           :: [m/s]  sinking velocity for POP
C     wFe_sink          :: [m/s]  sinking velocity for POFe
C     wSi_sink          :: [m/s]  sinking velocity for POSi
C     wPIC_sink         :: [m/s]  sinking velocity for PIC
C     darwin_KeirCoeff  :: [1/s]  Keir PIC dissolution rate coefficient
C     darwin_KeirExp    :: [1]    Keir PIC dissolution rate exponent
C     Kdissc            :: [1/s]  dissolution rate for PIC
C
C- Carbon chemistry parameters
C     R_OP              :: [mmol O2 / mmol P]  O:P ratio for respiration and consumption
C     R_OC              :: [mmol O2 / mmol C]  NOT USED
C     m3perkg           :: [m3/kg]         constant for converting per kg to per m^3
C     surfSaltMinInit   :: [ppt]           minimum salt for carbon solver at initialization
C     surfSaltMaxInit   :: [ppt]           maximum salt for carbon solver at initialization
C     surfTempMinInit   :: [degrees C]     minimum temp for carbon solver at initialization
C     surfTempMaxInit   :: [degrees C]     maximum temp for carbon solver at initialization
C     surfDICMinInit    :: [mmol C m^-3]   minimum DIC for carbon solver at initialization
C     surfDICMaxInit    :: [mmol C m^-3]   maximum DIC for carbon solver at initialization
C     surfALKMinInit    :: [meq m^-3]      minimum alkalinity for carbon solver at initialization
C     surfALKMaxInit    :: [meq m^-3]      maximum alkalinity for carbon solver at initialization
C     surfPO4MinInit    :: [mmol P m^-3]   minimum PO4 for carbon solver at initialization
C     surfPO4MaxInit    :: [mmol P m^-3]   maximum PO4 for carbon solver at initialization
C     surfSiMinInit     :: [mmol Si m^-3]  minimum SiO2 for carbon solver at initialization
C     surfSiMaxInit     :: [mmol Si m^-3]  maximum SiO2 for carbon solver at initialization
C     surfSaltMin       :: [ppt]           minimum salt for carbon solver during run
C     surfSaltMax       :: [ppt]           maximum salt for carbon solver during run
C     surfTempMin       :: [degrees C]     minimum temp for carbon solver during run
C     surfTempMax       :: [degrees C]     maximum temp for carbon solver during run
C     surfDICMin        :: [mmol C m^-3]   minimum DIC for carbon solver during run
C     surfDICMax        :: [mmol C m^-3]   maximum DIC for carbon solver during run
C     surfALKMin        :: [meq m^-3]      minimum alkalinity for carbon solver during run
C     surfALKMax        :: [meq m^-3]      maximum alkalinity for carbon solver during run
C     surfPO4Min        :: [mmol P m^-3]   minimum PO4 for carbon solver during run
C     surfPO4Max        :: [mmol P m^-3]   maximum PO4 for carbon solver during run
C     surfSiMin         :: [mmol Si m^-3]  minimum SiO2 for carbon solver during run
C     surfSiMax         :: [mmol Si m^-3]  maximum SiO2 for carbon solver during run
C
C     diaz_ini_fac      :: reduce tracer concentrations by this factor on initialization
C
C- Denitrification
C     O2crit            :: [mmol O2 m-3]      critical oxygen for O2/NO3 remineralization
C     denit_NP          :: [mmol N / mmol P]  ratio of n to p in denitrification process
C     denit_NO3         :: [mmol N / mmol P]  ratio of NO3 uptake to phos remineralization in denitrification
C     NO3crit           :: [mmol N m-3]       critical nitrate below which no denit (or remin) happens
C
C- These should probably be traits
C     PARmin            :: [uEin/m2/s]        minimum light for photosynthesis; for non-Geider: 1.0
C     aphy_chl_ave      :: [m2/mg Chl]        Chl-specific absorption coefficient
C     Chl2Nmax          :: [mg Chl / mmol N]  max Chl:N ratio for Chl synthesis following Moore 2002
C     synthcost         :: [mmol C / mmol N]  cost of biosynthesis
C     inhib_graz        :: [(mmol C m-3)-1]   inverse decay scale for grazing inhibition
C     inhib_graz_exp    :: []                 exponent for grazing inhibition (0 to turn off inhibition)
C     hillnumUptake     :: []                 exponent for limiting quota uptake in nutrient uptake
C     hillnumGraz       :: []                 exponent for limiting quota uptake in grazing
C     hollexp           :: []                 grazing exponential 1= "Holling 2", 2= "Holling 3"
C     phygrazmin        :: [mmol C m-3]       minimum total prey conc for grazing to occur
C
C- Bacteria
C     pmaxDIN           :: [1/s]           max DIN uptake rate for denitrifying bacteria
C     pcoefO2           :: [m3/mmol O2/s]  max O2-specific O2 uptake rate for aerobic bacteria
C     ksatDIN           :: [mmol N m-3]    half-saturation conc of dissolved inorganic nitrogen
C     alpha_hydrol      :: []              increase in POM needed due to hydrolysis
C     yod               :: []              organic matter yield of aerobic bacteria
C     yoe               :: []              energy yield of aerobic bacteria
C     ynd               :: []              organic matter yield of denitrifying bacteria
C     yne               :: []              energy yield of denitrifying bacteria
C     fnh4              :: []              not implemented (for ammonia-oxidizing bacteria)
C     ynh4              :: []              not implemented (for ammonia-oxidizing bacteria)
C     yonh4             :: []              not implemented (for ammonia-oxidizing bacteria)
C     fno2              :: []              not implemented (for nitrite-oxidizing bacteria)
C     yno2              :: []              not implemented (for nitrite-oxidizing bacteria)
C     yono2             :: []              not implemented (for nitrite-oxidizing bacteria)
C
C- To be implemented
C     depthdenit        :: [m]             not implemented (depth for denitrification relaxation to start)
C
C--   COMMON /DARWIN_CDOM_PARAMS_r/
C     fracCDOM   :: []                  fraction of remineralized POP contributing to CDOM
C     CDOMdegrd  :: [1/s]               CDOM degradation rate
C     CDOMbleach :: [1/s]               CDOM bleaching rate
C     PARCDOM    :: [uEin/m2/s]         PAR where CDOM bleaching becomes maximal
C     R_NC_CDOM  :: [mmol N / mmol C]   CDOM N:C ratio
C     R_FeC_CDOM :: [mmol Fe / mmol C]  CDOM Fe:C ratio
C     R_PC_CDOM  :: [mmol P / mmol C]   CDOM P:C ratio
C     R_NP_CDOM  :: [mmol N / mmol P]   CDOM N:P ratio
C     R_FeP_CDOM :: [mmol Fe / mmol P]  CDOM Fe:P ratio
C     R_CP_CDOM  :: [mmol C / mmol P]   CDOM C:P ratio
C     CDOMcoeff  :: [m2 / mmol C]       C-specific absorption coefficient of CDOM
C                                       (with #define DARWIN_CDOM_UNITS_CARBON)
C     CDOMcoeff  :: [m2 / mmol P]       P-specific absorption coefficient of CDOM
C                                       (with #undef DARWIN_CDOM_UNITS_CARBON)

      TYPE, PUBLIC :: DARWIN_PARAMS_TYPE
      _RL :: katten_w
      _RL :: katten_chl
      _RL :: parfrac
      _RL :: parconv
      _RL :: tempnorm
      _RL :: TempAeArr
      _RL :: TemprefArr
      _RL :: TempCoeffArr
      _RL :: reminTempAe
      _RL :: mortTempAe
      _RL :: mort2TempAe
      _RL :: uptakeTempAe
      _RL :: alpfe
      _RL :: ligand_tot
      _RL :: ligand_stab
      _RL :: freefemax
#ifdef DARWIN_PART_SCAV_POP
      _RL :: scav_rat
      _RL :: scav_inter
      _RL :: scav_exp
      _RL :: scav_R_POPPOC
#elif defined(DARWIN_PART_SCAV)
      _RL :: scav_tau
      _RL :: scav_inter
      _RL :: scav_exp
      _RL :: scav_POC_wgt
      _RL :: scav_POSi_wgt
      _RL :: scav_PIC_wgt
#else
      _RL :: scav
#endif
      _RL :: depthfesed
      _RL :: fesedflux
      _RL :: fesedflux_pcm
      _RL :: fesedflux_min
      _RL :: R_CP_fesed
      _RL :: depthFeVent
      _RL :: solFeVent
      _RL :: R_FeHe3_vent
      _RL :: Knita
      _RL :: Knitb
      _RL :: PAR_oxi
      _RL :: Kdoc
      _RL :: Kdop
      _RL :: Kdon
      _RL :: KdoFe
      _RL :: KPOC
      _RL :: KPON
      _RL :: KPOP
      _RL :: KPOFe
      _RL :: KPOSi
      _RL :: wC_sink
      _RL :: wN_sink
      _RL :: wP_sink
      _RL :: wFe_sink
      _RL :: wSi_sink
      _RL :: wPIC_sink
      _RL :: Kdissc
      _RL :: darwin_KeirCoeff
      _RL :: darwin_KeirExp
#ifdef DARWIN_ALLOW_CARBON
      _RL :: R_OP
      _RL :: R_OC
      _RL :: m3perkg
      _RL :: surfSaltMinInit
      _RL :: surfSaltMaxInit
      _RL :: surfTempMinInit
      _RL :: surfTempMaxInit
      _RL :: surfDICMinInit
      _RL :: surfDICMaxInit
      _RL :: surfALKMinInit
      _RL :: surfALKMaxInit
      _RL :: surfPO4MinInit
      _RL :: surfPO4MaxInit
      _RL :: surfSiMinInit
      _RL :: surfSiMaxInit
      _RL :: surfSaltMin
      _RL :: surfSaltMax
      _RL :: surfTempMin
      _RL :: surfTempMax
      _RL :: surfDICMin
      _RL :: surfDICMax
      _RL :: surfALKMin
      _RL :: surfALKMax
      _RL :: surfPO4Min
      _RL :: surfPO4Max
      _RL :: surfSiMin
      _RL :: surfSiMax
#endif
      _RL :: diaz_ini_fac
      _RL :: O2crit
      _RL :: denit_NP
      _RL :: denit_NO3
      _RL :: NO3crit
      _RL :: PARmin
      _RL :: aphy_chl_ave
      _RL :: Chl2Nmax
      _RL :: synthcost
      _RL :: inhib_graz
      _RL :: inhib_graz_exp
      _RL :: hillnumUptake
      _RL :: hillnumGraz
      _RL :: hollexp
      _RL :: phygrazmin
      _RL :: pcoefO2
      _RL :: pmaxDIN
      _RL :: ksatDIN
      _RL :: alpha_hydrol
      _RL :: yod
      _RL :: yoe
      _RL :: ynd
      _RL :: yne
C      _RL :: fnh4
C      _RL :: ynh4
C      _RL :: yonh4
C      _RL :: fno2
C      _RL :: yno2
C      _RL :: yono2
      _RL :: depthdenit

#ifdef DARWIN_ALLOW_CDOM
      _RL :: fracCDOM
      _RL :: CDOMdegrd
      _RL :: CDOMbleach
      _RL :: PARCDOM
# ifdef DARWIN_CDOM_UNITS_CARBON
      _RL :: R_NC_CDOM
      _RL :: R_FeC_CDOM
      _RL :: R_PC_CDOM
# else
      _RL :: R_NP_CDOM
      _RL :: R_FeP_CDOM
      _RL :: R_CP_CDOM
# endif
      _RL :: CDOMcoeff
#endif
      INTEGER :: darwin_disscSelect

#ifdef DARWIN_SOLVESAPHE
C If using Solvesaphe routines (Munhoven, 2013) then in addition,
C  selectBTconst :: estimates borate concentration from salinity:
C     =1 :: use default formulation of Uppström (1974)(same as S/R CARBON_COEFFS)
C     =2 :: use new formulation from Lee et al (2010)
C
C  selectFTconst :: estimates fluoride concentration from salinity:
C     =1 :: use default formulation of Riley (1965) (same as S/R CARBON_COEFFS)
C     =2 :: use new formulation from Culkin (1965)
C
C  selectHFconst :: sets the first dissociation constant for hydrogen fluoride:
C     =1 :: use default  Dickson and Riley (1979) (same as S/R CARBON_COEFFS)
C     =2 :: use new formulation of Perez and Fraga (1987)
C
C  selectK1K2const :: sets the 1rst & 2nd dissociation constants of carbonic acid:
C     =1 :: use default formulation of Millero (1995) with data
C            from Mehrbach et al. (1973) (same as S/R CARBON_COEFFS)
C     =2 :: use formulation of Roy et al. (1993)
C     =3 :: use "combination" formulation of Millero (1995)
C     =4 :: use formulation of Luecker et al. (2000)
C     =5 :: use formulation of Millero (2010, Mar. Fresh Wat. Res.)
C     =6 :: use formulation of Waters, Millero, Woosley (2014, Mar. Chem.)
C  selectPHsolver :: sets the pH solver to use:
C     =1 :: use the GENERAL solver ;  =2 :: use SEC solver ;
C     =3 :: use FAST solver routine.
      INTEGER :: selectBTconst
      INTEGER :: selectFTconst
      INTEGER :: selectHFconst
      INTEGER :: selectK1K2const
      INTEGER :: selectPHsolver
#endif /* DARWIN_SOLVESAPHE */
C     needed to avoid misalignment warnings
      INTEGER :: darwin_dummy_param_i
      END TYPE

C--   COMMON /DARWIN_TRAITS_i/ Per-plankton traits (generated, maybe overwritten by data.traits)
C     isPhoto   :: 1: does photosynthesis, 0: not
C     bactType  :: 1: particle associated, 2: free living bacteria, 0: not bacteria
C     isAerobic :: 1: is aerobic bacteria (also set bactType), 0: not
C     isDenit   :: 1: is dentrifying bacteria (also set (bactType), 0: not
C     hasSi     :: 1: uses silica (Diatom), 0: not
C     hasPIC    :: 1: calcifying, 0: set R_PICPOC to zero
C     diazo     :: 1: use molecular instead of mineral nitrogen, 0: not
C     useNH4    :: 1: can use ammonia, 0: not
C     useNO2    :: 1: can use nitrite, 0: not
C     useNO3    :: 1: can use nitrate, 0: not
C     combNO    :: 1: combined nitrite/nitrate limitation, 0: not
C     isPrey    :: 1: can be grazed, 0: not
C     isPred    :: 1: can graze, 0: not
C     tempMort  :: 1: mortality is temperature dependent, 0: turn dependence off
C     tempMort2 :: 1: quadratic mortality is temperature dependent, 0: turn dependence off
C     tempGraz  :: 1: grazing is temperature dependent, 0: turn dependence off
C
C--   COMMON /DARWIN_TRAITS_r/ Per-plankton traits (generated, maybe overwritten by data.traits)
C     Xmin               :: [mmol C m^-3]              minimum abundance for mortality, respiration and exudation
C     amminhib           :: [(mmol N m^-3)^-1]         coefficient for NH4 inhibition of NO uptake
C     acclimtimescl      :: [s^-1]                     rate of chlorophyll acclimation
C
C     mort               :: [s^-1]                     linear mortality rate
C     mort2              :: [(mmol C m^-3)^-1 s^-1]    quadratic mortality coefficient
C     ExportFracMort     :: []                         fraction of linear mortality to POM
C     ExportFracMort2    :: []                         fraction of quadratic mortality to POM
C     ExportFracExude    :: []                         fraction of exudation to POM
C     FracExudeC         :: []                         fraction of excess C exuded
C
C- temperature dependence:
C     phytoTempCoeff     :: []                         see :numref:`pkg_darwin_temperature_params`
C     phytoTempExp1      :: [exp(1/degrees C)]         see :numref:`pkg_darwin_temperature_params`
C     phytoTempAe        :: [1/degrees C]              see :numref:`pkg_darwin_temperature_params`
C     phytoTempExp2      :: []                         see :numref:`pkg_darwin_temperature_params`
C     phytoTempOptimum   :: [degrees C]                see :numref:`pkg_darwin_temperature_params`
C     phytoDecayPower    :: []                         see :numref:`pkg_darwin_temperature_params`
C     hetTempAe          :: [1/degrees C]              see :numref:`pkg_darwin_temperature_params`
C     hetTempExp2        :: []                         see :numref:`pkg_darwin_temperature_params`
C     hetTempOptimum     :: [degrees C]                see :numref:`pkg_darwin_temperature_params`
C     hetDecayPower      :: []                         see :numref:`pkg_darwin_temperature_params`
C     grazTempAe         :: [1/degrees C]              see :numref:`pkg_darwin_temperature_params`
C     grazTempExp2       :: []                         see :numref:`pkg_darwin_temperature_params`
C     grazTempOptimum    :: [degrees C]                see :numref:`pkg_darwin_temperature_params`
C     grazDecayPower     :: []                         see :numref:`pkg_darwin_temperature_params`
C
C     R_NC               :: [mmol N (mmol C)^-1]       nitrogen-carbon ratio (not used with DARWIN_ALLOW_NQUOTA)
C     R_PC               :: [mmol P (mmol C)^-1]       phosphorus-carbon ratio (not used with DARWIN_ALLOW_PQUOTA)
C     R_SiC              :: [mmol Si (mmol C)^-1]      silica-carbon ratio (not used with DARWIN_ALLOW_SIQUOTA)
C     R_FeC              :: [mmol Fe (mmol C)^-1]      iron-carbon ratio (not used with DARWIN_ALLOW_FEQUOTA)
C     R_ChlC             :: [mg Chl (mmol C)^-1]       chlorophyll-carbon ratio (not used with DARWIN_ALLOW_CHLQUOTA)
C     R_PICPOC           :: [mmol PIC (mmol POC)^-1]   inorganic-organic carbon ratio
C
C     biosink            :: [m s^-1]                   sinking velocity (positive downwards)
C     bioswim            :: [m s^-1]                   upward swimming velocity (positive upwards)
C
C     respRate           :: [s^-1]                     respiration rate
C     PCmax              :: [s^-1]                     maximum carbon-specific growth rate
C
C     Qnmax              :: [mmol N (mmol C)^-1]       maximum nitrogen quota (only with DARWIN_ALLOW_NQUOTA)
C     Qnmin              :: [mmol N (mmol C)^-1]       minimum nitrogen quota (only with DARWIN_ALLOW_NQUOTA)
C     Qpmax              :: [mmol P (mmol C)^-1]       maximum phosphorus quota (only with DARWIN_ALLOW_PQUOTA)
C     Qpmin              :: [mmol P (mmol C)^-1]       minimum phosphorus quota (only with DARWIN_ALLOW_PQUOTA)
C     Qsimax             :: [mmol Si (mmol C)^-1]      maximum silica quota (only with DARWIN_ALLOW_SIQUOTA)
C     Qsimin             :: [mmol Si (mmol C)^-1]      minimum silica quota (only with DARWIN_ALLOW_SIQUOTA)
C     Qfemax             :: [mmol Fe (mmol C)^-1]      maximum iron quota (only with DARWIN_ALLOW_FEQUOTA)
C     Qfemin             :: [mmol Fe (mmol C)^-1]      minimum iron quota (only with DARWIN_ALLOW_FEQUOTA)
C
C     VmaxNH4            :: [mmol N (mmol C)^-1 s^-1]  maximum ammonia uptake rate (only with DARWIN_ALLOW_NQUOTA)
C     VmaxNO2            :: [mmol N (mmol C)^-1 s^-1]  maximum nitrite uptake rate (only with DARWIN_ALLOW_NQUOTA)
C     VmaxNO3            :: [mmol N (mmol C)^-1 s^-1]  maximum nitrate uptake rate (only with DARWIN_ALLOW_NQUOTA)
C     VmaxN              :: [mmol N (mmol C)^-1 s^-1]  maximum nitrogen uptake rate for diazotrophs (only with DARWIN_ALLOW_NQUOTA)
C                        ::                            has to be >= vmaxNO3 + vmaxNO2 + vmaxNH4
C     VmaxPO4            :: [mmol P (mmol C)^-1 s^-1]  maximum phosphate uptake rate (only with DARWIN_ALLOW_PQUOTA)
C     VmaxSiO2           :: [mmol Si (mmol C)^-1 s^-1] maximum silica uptake rate (only with DARWIN_ALLOW_SIQUOTA)
C     VmaxFeT            :: [mmol Fe (mmol C)^-1 s^-1] maximum iron uptake rate (only with DARWIN_ALLOW_FEQUOTA)
C
C     ksatNH4            :: [mmol N m^-3]              half-saturation conc. for ammonia uptake/limitation
C     ksatNO2            :: [mmol N m^-3]              half-saturation conc. for nitrite uptake/limitation
C     ksatNO3            :: [mmol N m^-3]              half-saturation conc. for nitrate uptake/limitation
C     ksatPO4            :: [mmol P m^-3]              half-saturation conc. for phosphate uptake/limitation
C     ksatSiO2           :: [mmol Si m^-3]             half-saturation conc. for silica uptake/limitation
C     ksatFeT            :: [mmol Fe m^-3]             half-saturation conc. for iron uptake/limitation
C
C     kexcc              :: [s^-1]                 exudation rate for carbon
C     kexcn              :: [s^-1]                 exudation rate for nitrogen
C     kexcp              :: [s^-1]                 exudation rate for phosphorus
C     kexcsi             :: [s^-1]                 exudation rate for silica
C     kexcfe             :: [s^-1]                 exudation rate for iron
C
C- Geider
C     inhibGeider        :: []                     photo-inhibition coefficient for Geider growth
C- not Geider
C     ksatPAR            :: [(uEin m^-2 s^-1)^-1]  saturation coefficient for PAR (w/o GEIDER)
C     kinhPAR            :: [(uEin m^-2 s^-1)^-1]  inhibition coefficient for PAR (w/o GEIDER)
C- always defined
C     mQyield            :: [mmol C (uEin)^-1]     maximum quantum yield
C     chl2cmax           :: [mg Chl (mmol C)^-1]   maximum Chlorophyll-carbon ratio
C
C- Grazing
C     grazemax           :: [s^-1]          maximum grazing rate
C     kgrazesat          :: [mmol C m^-3]   grazing half-saturation concentration
C     palat              :: []              palatability matrix
C     asseff             :: []              assimilation efficiency matrix
C     ExportFracPreyPred :: []              fraction of unassimilated prey becoming particulate organic matter
C
C- Bacteria
C     yield              :: []              bacterial growth yield for all organic matter
C     yieldO2            :: []              bacterial growth yield for oxygen
C     yieldNO3           :: []              bacterial growth yield for nitrate
C     ksatPON            :: [mmol N m^-3]   half-saturation of PON for bacterial growth
C     ksatPOC            :: [mmol C m^-3]   half-saturation of POC for bacterial growth
C     ksatPOP            :: [mmol P m^-3]   half-saturation of POP for bacterial growth
C     ksatPOFe           :: [mmol Fe m^-3]  half-saturation of POFe for bacterial growth
C     ksatDON            :: [mmol N m^-3]   half-saturation of DON for bacterial growth
C     ksatDOC            :: [mmol C m^-3]   half-saturation of DOC for bacterial growth
C     ksatDOP            :: [mmol P m^-3]   half-saturation of DOP for bacterial growth
C     ksatDOFe           :: [mmol Fe m^-3]  half-saturation of DOFe for bacterial growth
C

      TYPE, PUBLIC :: DARWIN_TRAITS_TYPE
      INTEGER :: isPhoto(nplank)
      INTEGER :: bactType(nplank)
      INTEGER :: isAerobic(nplank)
      INTEGER :: isDenit(nplank)
      INTEGER :: hasSi(nplank)
      INTEGER :: hasPIC(nplank)
      INTEGER :: diazo(nplank)
      INTEGER :: useNH4(nplank)
      INTEGER :: useNO2(nplank)
      INTEGER :: useNO3(nplank)
      INTEGER :: combNO(nplank)
      INTEGER :: isPrey(nplank)
      INTEGER :: isPred(nplank)
      INTEGER :: tempMort(nplank)
      INTEGER :: tempMort2(nplank)
      INTEGER :: tempGraz(nplank)
      _RL :: Xmin(nplank)
      _RL :: amminhib(nplank)
      _RL :: acclimtimescl(nplank)
      _RL :: mort(nplank)
      _RL :: mort2(nplank)
      _RL :: ExportFracMort(nplank)
      _RL :: ExportFracMort2(nplank)
      _RL :: ExportFracExude(nplank)
      _RL :: FracExudeC(nplank)
      _RL :: phytoTempCoeff(nplank)
      _RL :: phytoTempExp1(nplank)
      _RL :: phytoTempAe(nplank)
      _RL :: phytoTempExp2(nplank)
      _RL :: phytoTempOptimum(nplank)
      _RL :: phytoDecayPower(nplank)
      _RL :: hetTempAe(nplank)
      _RL :: hetTempExp2(nplank)
      _RL :: hetTempOptimum(nplank)
      _RL :: hetDecayPower(nplank)
      _RL :: grazTempAe(nplank)
      _RL :: grazTempExp2(nplank)
      _RL :: grazTempOptimum(nplank)
      _RL :: grazDecayPower(nplank)
      _RL :: R_NC(nplank)
      _RL :: R_PC(nplank)
      _RL :: R_SiC(nplank)
      _RL :: R_FeC(nplank)
      _RL :: R_ChlC(nplank)
      _RL :: R_PICPOC(nplank)
      _RL :: biosink(nplank)
      _RL :: bioswim(nplank)
      _RL :: respRate(nplank)
      _RL :: PCmax(nplank)
      _RL :: Qnmax(nplank)
      _RL :: Qnmin(nplank)
      _RL :: Qpmax(nplank)
      _RL :: Qpmin(nplank)
      _RL :: Qsimax(nplank)
      _RL :: Qsimin(nplank)
      _RL :: Qfemax(nplank)
      _RL :: Qfemin(nplank)
      _RL :: VmaxNH4(nplank)
      _RL :: VmaxNO2(nplank)
      _RL :: VmaxNO3(nplank)
      _RL :: VmaxN(nplank)
      _RL :: VmaxPO4(nplank)
      _RL :: VmaxSiO2(nplank)
      _RL :: VmaxFeT(nplank)
      _RL :: ksatNH4(nplank)
      _RL :: ksatNO2(nplank)
      _RL :: ksatNO3(nplank)
      _RL :: ksatPO4(nplank)
      _RL :: ksatSiO2(nplank)
      _RL :: ksatFeT(nplank)
      _RL :: kexcc(nplank)
      _RL :: kexcn(nplank)
      _RL :: kexcp(nplank)
      _RL :: kexcsi(nplank)
      _RL :: kexcfe(nplank)
#ifdef DARWIN_ALLOW_GEIDER
      _RL :: inhibGeider(nplank)
#else
      _RL :: ksatPAR(nplank)
      _RL :: kinhPAR(nplank)
#endif
      _RL :: mQyield(nplank)
      _RL :: chl2cmax(nplank)
      _RL :: grazemax(nplank)
      _RL :: kgrazesat(nplank)
      _RL :: palat(nplank,nplank)
      _RL :: asseff(nplank,nplank)
      _RL :: ExportFracPreyPred(nplank,nplank)
      _RL :: yield(nplank)
      _RL :: yieldO2(nplank)
      _RL :: yieldNO3(nplank)
      _RL :: ksatPON(nplank)
      _RL :: ksatPOC(nplank)
      _RL :: ksatPOP(nplank)
      _RL :: ksatPOFe(nplank)
      _RL :: ksatDON(nplank)
      _RL :: ksatDOC(nplank)
      _RL :: ksatDOP(nplank)
      _RL :: ksatDOFe(nplank)
      END TYPE

C--   COMMON /DARWIN_DEPENDENT_TRAITS_r/ Dependent and constant (not read-in) parameters
C     normI      :: []                    normalization factor for non-Geider light curve
C     chl2cmin   :: [mg Chl (mmol C)^-1]  minimum Chl:C ratio (function of chl2cmax and depalpha_mean)
C     alpha_mean :: [mmol C s-1 (uEin m^-2 s^-1)^-1 (mg Chl)^-1]  mean initial slope of light curve (over wavebands)
C
C     COMMON /DARWIN_RT_DEPTRAITS_r/
C     alphachl :: [mmol C m^2 (uEin mg Chl)^-1]  Chlorophyll-specific initial slope for photosynthesis

      TYPE, PUBLIC :: DARWIN_DEP_TRAITS_TYPE
#ifndef DARWIN_ALLOW_GEIDER
      _RL :: normI(nplank)
#endif
      _RL :: alpha_mean(nplank)
      _RL :: chl2cmin(nplank)
      _RL :: alphachl(nplank,nlam)
      END TYPE

      END MODULE

#endif /* ALLOW_DARWIN */
