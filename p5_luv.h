#ifndef P5_LUV_H
#define P5_LUV_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "uv.h"

#define LUV_DOUBLETIME(TV) ((double)(TV).tv_sec + 1e-6*(TV).tv_usec)
#define LUV_SLAB_SIZE 65536
#define LUV_CHECK_HASH(self)                                         \
if (!(SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV)) {              \
    croak("Invalid instance method invocant: no hash ref supplied"); \
}

/* Loop */
typedef struct Loops {
    uv_loop_t loop_struct;
    uv_loop_t *uv_loop;
    int is_default;
    struct {
        char slab[LUV_SLAB_SIZE];
        int in_use;
    } buffer;
} Loop;

/* Handle */
typedef struct Handles {
    uv_handle_t *uv_handle;
    int flags;
    int initialized;
    Loop *loop;
    CV *on_close_cb;
} Handle;


#endif
