#include "DARWIN_OPTIONS.h"

      SUBROUTINE DARWIN_READ_TRAITS(iUnit,oUnit,myThid)
      use darwin_param_mod
      use darwin_param_data_mod
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#ifdef ALLOW_RADTRANS
#include "RADTRANS_SIZE.h"
#include "RADTRANS_PARAMS.h"
#endif
#include "DARWIN_SIZE.h"
#include "DARWIN_INDICES.h"
#include "DARWIN_RADTRANS.h"
#include "DARWIN_PARAMS.h"
#include "DARWIN_TRAITPARAMS.h"
#include "DARWIN_TRAITS.h"

      CHARACTER*(MAX_LEN_MBUF) msgBuf
      INTEGER iUnit,oUnit,myThid

#ifdef ALLOW_DARWIN

      INTEGER jp
      INTEGER jp2
      INTEGER jz
      INTEGER l
      INTEGER iopt

      NAMELIST/DARWIN_TRAITS/ traits

      NAMELIST/DARWIN_DEPENDENT_TRAITS/
#ifdef ALLOW_RADTRANS
     &    aptype,
#endif
     &    biovol,
     &    group,
     &    igroup,
     &    qcarbon,
     &    biovol_bygroup,
     &    deptraits


#ifdef ALLOW_RADTRANS
      NAMELIST/DARWIN_RADTRANS_TRAITS/
     &    aphy_chl,
     &    aphy_chl_ps,
     &    aphy_mgC,
     &    bphy_mgC,
     &    bbphy_mgC
#endif

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     DARWIN_TRAITS
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      READ(UNIT=iUnit, NML=DARWIN_TRAITS)

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     DARWIN_RADTRANS_TRAITS
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

C     now in traits

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     DARWIN_DEPENDENT_TRAITS
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      DO jp = 1,nPlank
        traits%VmaxNH4(jp) = traits%VmaxNH4(jp) * traits%useNH4(jp)
        traits%VmaxNO2(jp) = traits%VmaxNO2(jp) * traits%useNO2(jp)
        traits%VmaxNO3(jp) = traits%VmaxNO3(jp) * traits%useNO3(jp)
#ifndef DARWIN_ALLOW_NQUOTA
        IF (traits%diazo(jp).NE.0) THEN
          traits%useNH4(jp) = 0
          traits%useNO2(jp) = 0
          traits%useNO3(jp) = 0
        ENDIF
#endif
        IF (traits%useNO3(jp).EQ.0 .OR. traits%useNO2(jp).EQ.0) THEN
          traits%combNO(jp)=0
        ENDIF
C       Silicate parameters to zero for non-diatoms
        IF (traits%hasSi(jp) .EQ. 0) THEN
          traits%VmaxSiO2(jp) = 0.0 _d 0
          traits%ksatSiO2(jp) = 0.0 _d 0
          traits%R_SiC(jp) = 0.0 _d 0
        ENDIF
C       only Coccolithophores have PIC
        IF (traits%hasPIC(jp) .EQ. 0) THEN
          traits%R_PICPOC(jp) = 0.0 _d 0
        ENDIF
      ENDDO

#ifdef ALLOW_RADTRANS

      DO jp = 1, nPhoto
       deptraits%alpha_mean(jp) = 0.0 _d 0
       DO l = 1, nlam
        deptraits%alphachl(jp,l) = traits%mQyield(jp)*aphy_chl_ps(jp,l)
        deptraits%alpha_mean(jp) = deptraits%alpha_mean(jp)
     &        + RT_wbWidths(l)*deptraits%alphachl(jp,l)
       ENDDO
       deptraits%alpha_mean(jp) = deptraits%alpha_mean(jp)
     &                            /RT_wbTotalWidth
      ENDDO
#else
      DO jp = 1, nPhoto
       deptraits%alphachl(jp,1) = traits%mQyield(jp)
     &                            * params%aphy_chl_ave
       deptraits%alpha_mean(jp) = deptraits%alphachl(jp,1)
      ENDDO
#endif /* ALLOW_RADTRANS */

#ifdef ALLOW_RADTRANS
      DO jp = 1, nplank
       IF (traits%PCmax(jp) .GT. 0 _d 0) THEN
         deptraits%chl2cmin(jp)=traits%chl2cmax(jp)/
     &     (1+(traits%chl2cmax(jp)*deptraits%alpha_mean(jp)*2000. _d 0)
     &        /(2*traits%PCmax(jp)))
       ELSE
         deptraits%chl2cmin(jp) = 0 _d 0
       ENDIF
      ENDDO
#else
      DO jp = 1, nPhoto
       deptraits%chl2cmin(jp) = 0. _d 0
      ENDDO
#endif

#ifndef DARWIN_ALLOW_GEIDER
      DO jp = 1, nplank
       IF (traits%ksatPAR(jp)*traits%kinhPAR(jp) .GT. 0.0) THEN
        deptraits%normI(jp) = 1.0/(traits%ksatPAR(jp)
     &        /(traits%ksatPAR(jp)+traits%kinhPAR(jp))*
     &        EXP(traits%kinhPAR(jp)/traits%ksatPAR(jp)*
     &   LOG(traits%kinhPAR(jp)/(traits%ksatPAR(jp)+traits%kinhPAR(jp)))
     &        ))
       ELSE
        deptraits%normI(jp) = 1.0
       ENDIF
      ENDDO
#endif

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     Checks
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

C     check types are within type ranges
      DO jp=1,nplank
       IF (traits%isPhoto(jp) .NE. 0) THEN
        IF (jp.GT.nPhoto) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'isPhoto set for type outside of photo range: ', jp
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
#ifdef DARWIN_ALLOW_CHLQUOTA
        IF (jp.GT.nPhoto) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'isPhoto set for type outside of Chl range: ', jp
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
#endif
       ELSE
        IF (traits%bactType(jp) .EQ. 0) THEN
         traits%PCmax(jp) = 0 _d 0
        ENDIF
        traits%VmaxPO4(jp) = 0 _d 0
        traits%VmaxNO3(jp) = 0 _d 0
        traits%VmaxNO2(jp) = 0 _d 0
        traits%VmaxNH4(jp) = 0 _d 0
        traits%VmaxFeT(jp) = 0 _d 0
        traits%VmaxSiO2(jp) = 0 _d 0
       ENDIF

       IF (traits%bactType(jp) .NE. 0) THEN
        IF (traits%isAerobic(jp).NE.0.AND.traits%isDenit(jp).NE.0) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'isAerobic and isDenit both set: ', jp
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
        IF (traits%R_SiC(jp).NE.0) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'bacteria has R_SiC.NE.0: ', jp
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
        IF (traits%R_PICPOC(jp).NE.0) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'bacteria has R_PICPOC.NE.0: ', jp
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
       ELSE
        IF (traits%isAerobic(jp).NE.0) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'isAerobic set for non-bacteria type: ', jp
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
        IF (traits%isDenit(jp).NE.0) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'isDenit set for non-bacteria type: ', jp
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
       ENDIF

       DO jz=1,nplank
        IF (traits%palat(jp,jz) .NE. 0.) THEN
         IF (traits%isPrey(jp) .EQ. 0) THEN
          WRITE(msgBuf,'(2A,2I4)') 'DARWIN_READTRAITS: WARNING: ',
     &    'palat set for type outside of prey range: ', jp, jz
          CALL PRINT_ERROR( msgBuf , 1)
          IF (darwin_strict_check) THEN
           STOP 'palat set outside of prey range'
          ELSE
           traits%palat(jp,jz) = 0. _d 0
          ENDIF
         ENDIF
         IF (traits%isPred(jz) .EQ. 0) THEN
          WRITE(msgBuf,'(2A,2I4)') 'DARWIN_READTRAITS: WARNING: ',
     &    'palat set for type outside of predator range: ', jp, jz
          CALL PRINT_ERROR( msgBuf , 1)
          IF (darwin_strict_check) THEN
           STOP 'palat set outside of predator range'
          ELSE
           traits%palat(jp,jz) = 0. _d 0
          ENDIF
         ENDIF
        ENDIF
       ENDDO
      ENDDO

C re-compute traits%isPrey and traits%isPred to speed up grazing loops
      DO jp=1,nplank
       traits%isPrey(jp) = 0
       traits%isPred(jp) = 0
      ENDDO
      DO jp=1,nplank
       DO jz=1,nplank
        IF (traits%palat(jp,jz) .NE. 0.) THEN
         traits%isPrey(jp) = 1
         traits%isPred(jz) = 1
        ENDIF
       ENDDO
      ENDDO

      DO jz=1,nplank
        IF (traits%isPred(jz).NE.0 .AND. traits%R_PICPOC(jz).NE.0) THEN
          WRITE(msgBuf,'(2A,I4)') 'DARWIN_READTRAITS: ERROR: ',
     &    'predator has R_PICPOC.NE.0: ', jz
          CALL PRINT_ERROR( msgBuf , 1)
          STOP 'ABNORMAL END: S/R DARWIN_READTRAITS'
        ENDIF
      ENDDO

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C zero out unused trait entries, so they do not mess up the traits file
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      DO jp=1,nplank
#ifndef DARWIN_ALLOW_NQUOTA
#ifndef DARWIN_ALLOW_CSTORE
       traits%VmaxNH4(jp) = DARWIN_UNUSED
       traits%VmaxNO2(jp) = DARWIN_UNUSED
       traits%VmaxNO3(jp) = DARWIN_UNUSED
       traits%VmaxN(jp) = DARWIN_UNUSED
#endif
       traits%Qnmax(jp) = DARWIN_UNUSED
       traits%Qnmin(jp) = DARWIN_UNUSED
#endif
#ifndef DARWIN_ALLOW_PQUOTA
#ifndef DARWIN_ALLOW_CSTORE
       traits%VmaxPO4(jp) = DARWIN_UNUSED
#endif
       traits%Qpmax(jp) = DARWIN_UNUSED
       traits%Qpmin(jp) = DARWIN_UNUSED
#endif
#ifndef DARWIN_ALLOW_FEQUOTA
#ifndef DARWIN_ALLOW_CSTORE
       traits%VmaxFeT(jp) = DARWIN_UNUSED
#endif
       traits%Qfemax(jp) = DARWIN_UNUSED
       traits%Qfemin(jp) = DARWIN_UNUSED
#endif
#ifndef DARWIN_ALLOW_SIQUOTA
#ifndef DARWIN_ALLOW_CSTORE
       traits%VmaxSiO2(jp) = DARWIN_UNUSED
#endif
       traits%Qsimax(jp) = DARWIN_UNUSED
       traits%Qsimin(jp) = DARWIN_UNUSED
#endif
#ifndef DARWIN_ALLOW_EXUDE
       traits%kexcc(jp) = DARWIN_UNUSED
       traits%kexcn(jp) = DARWIN_UNUSED
       traits%kexcp(jp) = DARWIN_UNUSED
       traits%kexcsi(jp) = DARWIN_UNUSED
       traits%kexcfe(jp) = DARWIN_UNUSED
#endif
       IF (jp.GT.nPhoto) THEN
        traits%diazo(jp) = DARWIN_UNUSED
        traits%useNH4(jp) = DARWIN_UNUSED
        traits%useNO2(jp) = DARWIN_UNUSED
        traits%useNO3(jp) = DARWIN_UNUSED
        traits%combNO(jp) = DARWIN_UNUSED
        traits%amminhib(jp) = DARWIN_UNUSED
        traits%acclimtimescl(jp) = DARWIN_UNUSED

        traits%phytoTempCoeff(jp) = DARWIN_UNUSED
        traits%phytoTempExp1(jp) = DARWIN_UNUSED
        traits%phytoTempAe(jp) = DARWIN_UNUSED
        traits%phytoTempExp2(jp) = DARWIN_UNUSED
        traits%phytoTempOptimum(jp) = DARWIN_UNUSED
        traits%phytoDecayPower(jp) = DARWIN_UNUSED

        traits%VmaxNH4(jp) = DARWIN_UNUSED
        traits%VmaxNO2(jp) = DARWIN_UNUSED
        traits%VmaxNO3(jp) = DARWIN_UNUSED
        traits%VmaxPO4(jp) = DARWIN_UNUSED
        traits%VmaxSiO2(jp) = DARWIN_UNUSED
        traits%VmaxFeT(jp) = DARWIN_UNUSED

        traits%ksatNH4(jp) = DARWIN_UNUSED
        traits%ksatNO2(jp) = DARWIN_UNUSED
        traits%ksatNO3(jp) = DARWIN_UNUSED
        traits%ksatPO4(jp) = DARWIN_UNUSED
        traits%ksatSiO2(jp) = DARWIN_UNUSED
        traits%ksatFeT(jp) = DARWIN_UNUSED

#ifdef DARWIN_ALLOW_GEIDER
        traits%inhibGeider(jp) = DARWIN_UNUSED
#else
        traits%ksatPAR(jp) = DARWIN_UNUSED
        traits%kinhPAR(jp) = DARWIN_UNUSED
        deptraits%normI(jp) = DARWIN_UNUSED
#endif
        traits%mQyield(jp) = DARWIN_UNUSED
        traits%chl2cmax(jp) = DARWIN_UNUSED
        deptraits%chl2cmin(jp) = DARWIN_UNUSED
        DO l=1,nlam
         deptraits%alphachl(jp,l) = DARWIN_UNUSED
        ENDDO
        deptraits%alpha_mean(jp) = DARWIN_UNUSED
       ENDIF
       IF (traits%isPred(jp) .EQ. 0) THEN
        traits%grazemax(jp) = DARWIN_UNUSED
        traits%kgrazesat(jp) = DARWIN_UNUSED
       ENDIF
       DO jp2=1,nplank
        IF (traits%isPred(jp).EQ.0 .OR. traits%isPrey(jp2).EQ.0) THEN
          traits%palat(jp2,jp) = DARWIN_UNUSED
          traits%asseff(jp2,jp) = DARWIN_UNUSED
          traits%ExportFracPreyPred(jp2,jp) = DARWIN_UNUSED
        ENDIF
       ENDDO
      ENDDO

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     log all parameters to a namelist file

      IF ( oUnit .GE. 0 ) THEN
       WRITE(UNIT=oUnit, NML=DARWIN_TRAITS)
       WRITE(UNIT=oUnit, NML=DARWIN_DEPENDENT_TRAITS)
#ifdef ALLOW_RADTRANS
       WRITE(UNIT=oUnit, NML=DARWIN_RADTRANS_TRAITS)
#endif
      ENDIF

#endif /* ALLOW_DARWIN */

      RETURN
      END
