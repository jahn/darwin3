C CPP options file for TIDES
C Use this file for selecting options within package tides

#ifndef TIDES_OPTIONS_H
#define TIDES_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

#ifdef ALLOW_TIDES
C Place CPP define/undef flag here

C need this for full lunisolar potential (requires SPICE toolkit)
#define TIDES_ALLOW_FULL

C log nodal parameters (phase shift and ampitude factor for each
C constituent) to STDOUT.0000
#undef TIDES_PRINT_NODAL_PARAMS

#endif /* ALLOW_TIDES */
#endif /* TIDES_OPTIONS_H */

