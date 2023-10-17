CBOP
C     !ROUTINE: FLT_META.h
C     !INTERFACE:
C     #include FLT_META.h

C     !DESCRIPTION:
C     *==========================================================*
C     | FLT_META.h
C     | o Parameters read from float trajectory meta file
C     *==========================================================*
CEOP

      COMMON / FLT_TRAC_FILE /
     &       flt_traj_nRec, flt_traj_nFld, flt_traj_prec
      INTEGER flt_traj_nRec
      INTEGER flt_traj_nFld
      INTEGER flt_traj_prec

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
