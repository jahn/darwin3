#include "TIDES_OPTIONS.h"

CBOP
C !ROUTINE: TIDES_ET

C !INTERFACE: ==========================================================
      SUBROUTINE TIDES_ET(
     I                     myDate,
     O                     centuries,
     I                     myThid)
C !DESCRIPTION:
C Compute ephemeris time in Julian centuries since J2000 for myDate
C
C Assumes model time is UT1

C !USES: ===============================================================
      IMPLICIT NONE
#include "cal.h"
#include "TIDES_PARAMS.h"

C !INPUT PARAMETERS: ===================================================
      INTEGER myDate(4)
      INTEGER myThid

C !OUTPUT PARAMETERS: ==================================================
      _RL centuries
CEOP

#ifdef ALLOW_TIDES

C     !FUNCTIONS
      _RL      TIDES_DELTAT
      EXTERNAL TIDES_DELTAT

C !LOCAL VARIABLES: ====================================================
      INTEGER numdays(4), year
      _RL secs, deltat, mjd, tjd

      year = myDate(1)/10000

C     Convert to modified Julian day, with zero on Nov 17 0:00 1858
      CALL CAL_TIMEPASSED(mjdEpoch, myDate, numdays, myThid)
      CALL CAL_TOSECONDS(numdays, secs, myThid)
      mjd = secs/86400 _d 0

C     Convert to Julian Day
      tjd = mjd + 2400000.5 _d 0

C     Difference between UT and ephemeris time (in seconds)
      deltat = TIDES_DELTAT(tjd, year)

C     Convert to Ephemeris Time
      tjd = tjd + deltat/86400 _d 0

C     Compute time argument in centuries relative to J2000
      centuries = ( tjd - 2451545 _d 0 )/36525 _d 0

#endif /* ALLOW_TIDES */

      RETURN
      END


C !ROUTINE: TIDES_DELTAT

C !INTERFACE: ==========================================================
      FUNCTION TIDES_DELTAT(tjd, year)
C !DESCRIPTION:

C..author: F X Timmes, University of Chicago

C..Slightly revised by R Ray, GSFC, Aug 2003.  Also updated table.
C  Updated periodically the tables.  -RDR

C..this routine computes the difference between
C..universal time and dynamical time.

C..input:
C..tjd  = UT julian day number
C..year = calendar year of tjd -- knowing this saves a search through tjd table

C..output:
C  deltat = ET - UT in seconds

C !USES: ===============================================================
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "TIDES_PARAMS.h"

C !INPUT PARAMETERS: ===================================================
      INTEGER year
      _RL tjd

C !OUTPUT PARAMETERS: ==================================================
      _RL tides_deltat
CEOP

#ifdef ALLOW_TIDES

C !LOCAL VARIABLES: ====================================================
      INTEGER i, iat
      _RL b, x, secdif
      _RL dt(tabsize)

C these tables of observed and extrapolated data are
C are from the us naval observatory ftp://maia.usno.navy.mil/ser7/
C or its mirror ftp://cddis.gsfc.nasa.gov/pub/products/iers/, see
C https://cddis.nasa.gov/Data_and_Derived_Products/Other_products/IERS_EOPs.html

C..years 1620 to 1709
      DATA (dt(i), i=1,90) /
     &    124.00d0, 119.00d0, 115.00d0, 110.00d0, 106.00d0, 102.00d0,
     &     98.00d0,  95.00d0,  91.00d0,  88.00d0,  85.00d0,  82.00d0,
     &     79.00d0,  77.00d0,  74.00d0,  72.00d0,  70.00d0,  67.00d0,
     &     65.00d0,  63.00d0,  62.00d0,  60.00d0,  58.00d0,  57.00d0,
     &     55.00d0,  54.00d0,  53.00d0,  51.00d0,  50.00d0,  49.00d0,
     &     48.00d0,  47.00d0,  46.00d0,  45.00d0,  44.00d0,  43.00d0,
     &     42.00d0,  41.00d0,  40.00d0,  38.00d0,  37.00d0,  36.00d0,
     &     35.00d0,  34.00d0,  33.00d0,  32.00d0,  31.00d0,  30.00d0,
     &     28.00d0,  27.00d0,  26.00d0,  25.00d0,  24.00d0,  23.00d0,
     &     22.00d0,  21.00d0,  20.00d0,  19.00d0,  18.00d0,  17.00d0,
     &     16.00d0,  15.00d0,  14.00d0,  14.00d0,  13.00d0,  12.00d0,
     &     12.00d0,  11.00d0,  11.00d0,  10.00d0,  10.00d0,  10.00d0,
     &      9.00d0,   9.00d0,   9.00d0,   9.00d0,   9.00d0,   9.00d0,
     &      9.00d0,   9.00d0,   9.00d0,   9.00d0,   9.00d0,   9.00d0,
     &      9.00d0,   9.00d0,   9.00d0,   9.00d0,  10.00d0,  10.00d0/

C..years 1710 to 1799
      DATA (dt(i), i=91, 180) /
     &     10.00d0,  10.00d0,  10.00d0,  10.00d0,  10.00d0,  10.00d0,
     &     10.00d0,  11.00d0,  11.00d0,  11.00d0,  11.00d0,  11.00d0,
     &     11.00d0,  11.00d0,  11.00d0,  11.00d0,  11.00d0,  11.00d0,
     &     11.00d0,  11.00d0,  11.00d0,  11.00d0,  11.00d0,  11.00d0,
     &     12.00d0,  12.00d0,  12.00d0,  12.00d0,  12.00d0,  12.00d0,
     &     12.00d0,  12.00d0,  12.00d0,  12.00d0,  13.00d0,  13.00d0,
     &     13.00d0,  13.00d0,  13.00d0,  13.00d0,  13.00d0,  14.00d0,
     &     14.00d0,  14.00d0,  14.00d0,  14.00d0,  14.00d0,  14.00d0,
     &     15.00d0,  15.00d0,  15.00d0,  15.00d0,  15.00d0,  15.00d0,
     &     15.00d0,  16.00d0,  16.00d0,  16.00d0,  16.00d0,  16.00d0,
     &     16.00d0,  16.00d0,  16.00d0,  16.00d0,  16.00d0,  17.00d0,
     &     17.00d0,  17.00d0,  17.00d0,  17.00d0,  17.00d0,  17.00d0,
     &     17.00d0,  17.00d0,  17.00d0,  17.00d0,  17.00d0,  17.00d0,
     &     17.00d0,  17.00d0,  17.00d0,  17.00d0,  16.00d0,  16.00d0,
     &     16.00d0,  16.00d0,  15.00d0,  15.00d0,  14.00d0,  14.00d0/

C..years 1800 to 1889
      DATA (dt(i), i=181, 270) /
     &     13.70d0,  13.40d0,  13.10d0,  12.90d0,  12.70d0,  12.60d0,
     &     12.50d0,  12.50d0,  12.50d0,  12.50d0,  12.50d0,  12.50d0,
     &     12.50d0,  12.50d0,  12.50d0,  12.50d0,  12.50d0,  12.40d0,
     &     12.30d0,  12.20d0,  12.00d0,  11.70d0,  11.40d0,  11.10d0,
     &     10.60d0,  10.20d0,   9.60d0,   9.10d0,   8.60d0,   8.00d0,
     &      7.50d0,   7.00d0,   6.60d0,   6.30d0,   6.00d0,   5.80d0,
     &      5.70d0,   5.60d0,   5.60d0,   5.60d0,   5.70d0,   5.80d0,
     &      5.90d0,   6.10d0,   6.20d0,   6.30d0,   6.50d0,   6.60d0,
     &      6.80d0,   6.90d0,   7.10d0,   7.20d0,   7.30d0,   7.40d0,
     &      7.50d0,   7.60d0,   7.70d0,   7.70d0,   7.80d0,   7.80d0,
     &      7.88d0,   7.82d0,   7.54d0,   6.97d0,   6.40d0,   6.02d0,
     &      5.41d0,   4.10d0,   2.92d0,   1.82d0,   1.61d0,   0.10d0,
     &     -1.02d0,  -1.28d0,  -2.69d0,  -3.24d0,  -3.64d0,  -4.54d0,
     &     -4.71d0,  -5.11d0,  -5.40d0,  -5.42d0,  -5.20d0,  -5.46d0,
     &     -5.46d0,  -5.79d0,  -5.63d0,  -5.64d0,  -5.80d0,  -5.66d0/

C..years 1890 to 1979
      DATA (dt(i), i=271, 360) /
     &     -5.87d0,  -6.01d0,  -6.19d0,  -6.64d0,  -6.44d0,  -6.47d0,
     &     -6.09d0,  -5.76d0,  -4.66d0,  -3.74d0,  -2.72d0,  -1.54d0,
     &     -0.2d0,   1.24d0,   2.64d0,   3.86d0,   5.37d0,   6.14d0,
     &      7.75d0,   9.13d0,  10.46d0,  11.53d0,  13.36d0,  14.65d0,
     &     16.01d0,  17.20d0,  18.24d0,  19.06d0,  20.25d0,  20.95d0,
     &     21.16d0,  22.25d0,  22.41d0,  23.03d0,  23.49d0,  23.62d0,
     &     23.86d0,  24.49d0,  24.34d0,  24.08d0,  24.02d0,  24.00d0,
     &     23.87d0,  23.95d0,  23.86d0,  23.93d0,  23.73d0,  23.92d0,
     &     23.96d0,  24.02d0,  24.33d0,  24.83d0,  25.30d0,  25.70d0,
     &     26.24d0,  26.77d0,  27.28d0,  27.78d0,  28.25d0,  28.71d0,
     &     29.15d0,  29.57d0,  29.97d0,  30.36d0,  30.72d0,  31.07d0,
     &     31.35d0,  31.68d0,  32.18d0,  32.68d0,  33.15d0,  33.59d0,
     &     34.00d0,  34.47d0,  35.03d0,  35.73d0,  36.54d0,  37.43d0,
     &     38.29d0,  39.20d0,  40.18d0,  41.17d0,  42.23d0,  43.37d0,
     &     44.49d0,  45.48d0,  46.46d0,  47.52d0,  48.53d0,  49.59d0/

C..years 1980 to 2020
      DATA (dt(i), i=361, 401) /
     &     50.54d0,  51.38d0,  52.17d0,  52.96d0,  53.79d0,  54.34d0,
     &     54.87d0,  55.32d0,  55.82d0,  56.30d0,  56.86d0,  57.57d0,
     &     58.31d0,  59.12d0,  59.98d0,  60.78d0,  61.63d0,  62.29d0,
     &     62.97d0,  63.47d0,  63.83d0,  64.09d0,  64.30d0,  64.47d0,
     &     64.57d0,  64.69d0,  64.85d0,  65.15d0,  65.46d0,  65.78d0,
     &     66.07d0,  66.32d0,  66.60d0,  66.91d0,  67.28d0,  67.64d0,
     &     68.10d0,  68.59d0,  68.97d0,  69.22d0,  69.36d0/

C..years 2021 to 2027 -- predicted
      DATA (dt(i), i=402, 408) /
     &     70.39d0,  70.91d0,  71.40d0,  71.88d0,  72.36d0,  72.83d0,
     &     73.32d0/

C..if we are outside the table on the low end
C..use the stephenson and morrison expression 948 to 1600,
C..and the borkowski formula for earlier years
      IF (year .LT. tabstart) THEN
       IF (year .GE. 948) THEN
        b      = 0.01 _d 0 * FLOAT(year - 2000)
        secdif = b * (b * 23.58 _d 0 + 100.3 _d 0) + 101.6 _d 0
       ELSE
        b      = 0.01 _d 0 * FLOAT(year - 2000) + 3.75 _d 0
        secdif = 35.0 _d 0 * b * b + 40.0 _d 0
       END IF

C..if we are outside the table on the high end
C..use a linear extrapolation into the future
      ELSE IF (year .GT. tabend) THEN
       b      = FLOAT(year - tabend)
       secdif = dt(tabsize) + b*(dt(tabsize) - dt(tabsize-1))

C..otherwise we are in the table
C..get the table location and interpolate
      ELSE
       iat = year - tabstart + 1
       iat = MAX(1, MIN(iat, tabsize - 1))
       x = (tjd - tides_tjds(iat))/(tides_tjds(iat+1) - tides_tjds(iat))
       secdif = (1 _d 0 - x)*dt(iat) + x*dt(iat+1)

C..the astronomical almanac table is corrected by adding the expression
C..      -0.000091 (ndot + 26)(year-1955)^2  seconds
C..to entries prior to 1955 (page K8), where ndot is the secular tidal
C..term in the mean motion of the moon. entries after 1955 are referred
C..to atomic time standards and are not affected by errors in lunar
C..or planetary theory.  a value of ndot = -25.8 arcsec per century squared
C..is the value used in jpl's de403 ephemeris, the earlier de200 ephemeris
C..used the value -23.8946. note for years below the table (less than 1620)
C..the time difference is not adjusted for small improvements in the
C..current estimate of ndot because the formulas were derived from
C..studies of ancient eclipses and other historical information, whose
C..interpretation depends only partly on ndot.
C..here we make the ndot correction.

       IF (year .LT. 1955) THEN
        b = FLOAT(year - 1955)
        secdif = secdif - 0.000091d0 * (-25.8d0 + 26.0d0)*b*b
       ENDIF
      ENDIF

      tides_deltat = secdif

#endif /* ALLOW_TIDES */

      RETURN
      END

