#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdlib.h>

MODULE = Devel::Malloc    PACKAGE = Devel::Malloc   PREFIX = smh

IV
smh_malloc(size)
    size_t size;

    PROTOTYPE: DISABLE

    CODE:
    RETVAL = PTR2IV(malloc(size));

    OUTPUT:
    RETVAL

void
smh_free(address)
    IV address;

    PROTOTYPE: DISABLE

    CODE:
    free((void*)address);

    OUTPUT:

IV
smh_memset(address, src, size = 0)
    IV address;
    SV * src;
    STRLEN size;

    PROTOTYPE: DISABLE

    CODE:
    char * ptr = (size == 0) ? SvPVbyte(src, size) : SvPVbyte_nolen(src);
    RETVAL = PTR2IV(memcpy((void*)address, ptr, size));

    OUTPUT:
    RETVAL

SV *
smh_memget(address, size)
    IV address;
    STRLEN size;

    PROTOTYPE: DISABLE

    CODE:
    RETVAL = newSVpv("",0); 
    SvGROW(RETVAL, size);
    memcpy(SvPVbyte_nolen(RETVAL), (void*)address, size);
    SvCUR_set(RETVAL, size);

    OUTPUT:
    RETVAL
