#ifndef P5_LUV_H
#define P5_LUV_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_newRV_noinc
#define NEED_sv_2pv_flags
#include "ppport.h"
#include "string.h"
#include "uv.h"

#define LUV_DOUBLETIME(TV) ((double)(TV).tv_sec + 1e-6*(TV).tv_usec)
#define LUV_SLAB_SIZE 65536
#define LUV_CHECK_HASH(self)                                         \
if (!(SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV)) {              \
    croak("Invalid instance method invocant: no hash ref supplied"); \
}

/* Loop */
typedef struct {
    uv_loop_t loop_struct;
    uv_loop_t *uv_loop;
    int is_default;
    struct {
        char slab[LUV_SLAB_SIZE];
        int in_use;
    } buffer;
} Loop;


/*
void luv_new(class, ...)
    SV* class;
    int is_default;
  PREINIT:
    unsigned int iStack;
    HV* hash;
    SV* obj;
    const char* classname;
    Loop *loop;
    uv_loop_t *uv_loop;
  PPCODE:
    if (sv_isobject(class)) {
      classname = sv_reftype(SvRV(class), 1);
    }
    else {
      if (!SvPOK(class))
        croak("Need an object or class name as first argument to the constructor.");
      classname = SvPV_nolen(class);
    }

    hash = (HV *)sv_2mortal((SV *)newHV());
    obj = sv_bless( newRV_noinc((SV*)hash), gv_stashpv(classname, 1) );


    if (items > 1) {
      if (!(items % 2))
        croak("Uneven number of argument to constructor.");

      for (iStack = 1; iStack < items; iStack += 2) {
        hv_store_ent(hash, ST(iStack), newSVsv(ST(iStack+1)), 0);
      }
    }
    XPUSHs(sv_2mortal(obj));
*/

#endif
