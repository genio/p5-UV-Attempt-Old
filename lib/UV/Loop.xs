#include "p5luv.h"

#define NEED_newCONSTSUB_GLOBAL
#include "ppport.h"


MODULE = UV::Loop       PACKAGE = UV::Loop    PREFIX = luv_

PROTOTYPES: ENABLE

BOOT:
{
    HV *stash = gv_stashpvn("UV::Loop", 8, TRUE);

    /* expose the different handle type constants */
    newCONSTSUB(stash, "UV_LOOP_BLOCK_SIGNAL", newSViv(UV_LOOP_BLOCK_SIGNAL));
    newCONSTSUB(stash, "UV_RUN_NOWAIT", newSViv(UV_RUN_NOWAIT));
    newCONSTSUB(stash, "UV_RUN_DEFAULT", newSViv(UV_RUN_DEFAULT));
    newCONSTSUB(stash, "UV_RUN_ONCE", newSViv(UV_RUN_ONCE));
    newCONSTSUB(stash, "UV_EBUSY", newSViv(UV_EBUSY));
    newCONSTSUB(stash, "UV_EINVAL", newSViv(UV_EINVAL));
    newCONSTSUB(stash, "UV_ENOSYS", newSViv(UV_ENOSYS));
}

UV::Loop luv_new(class, is_default = 0)
        char * class;
        int is_default;
    ALIAS:
        UV::Loop::default_loop = 1
    CODE:
        PERL_UNUSED_VAR(class);
        if (ix == 1) is_default = 1;
        if (is_default) {
            RETVAL = p5luv_loop_new_default();
        }
        else {
            RETVAL = p5luv_loop_new();
        }
    OUTPUT:
    RETVAL

void luv_DESTROY(self)
    UV::Loop self;
    CODE:
        p5luv_loop_destroy(self);

int luv_alive(self)
    UV::Loop self;
    CODE:
        RETVAL = uv_loop_alive(self);
    OUTPUT:
    RETVAL

int luv_default(self)
    UV::Loop self;
    CODE:
        RETVAL = p5luv_loop_is_default(self);
    OUTPUT:
        RETVAL

int luv_fileno(self)
    UV::Loop self;
    CODE:
        RETVAL = (int) uv_backend_fd(self);
    OUTPUT:
    RETVAL

double luv_get_timeout(self)
    UV::Loop self;
    CODE:
        RETVAL=(double) uv_backend_timeout(self);
        if (RETVAL > 0) RETVAL = RETVAL / 1000.0;
    OUTPUT:
    RETVAL

size_t luv_now(self)
    UV::Loop self;
    CODE:
        RETVAL = (size_t) uv_now(self);
    OUTPUT:
    RETVAL

int luv_run(self, mode = UV_RUN_DEFAULT)
    UV::Loop self;
    int mode;
    CODE:
        if (mode != UV_RUN_NOWAIT && mode != UV_RUN_DEFAULT && mode != UV_RUN_ONCE) {
            croak("Invalid mode specified: %i", mode);
        }

        /* TODO: thread safety? */
        RETVAL = uv_run(self, mode);
    OUTPUT:
    RETVAL

void luv_stop(self)
    UV::Loop self;
    CODE:
        uv_stop(self);

void luv_update_time(self)
    UV::Loop self;
    CODE:
        uv_update_time(self);
