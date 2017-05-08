#include "p5_luv.h"
#define NEED_newRV_noinc_GLOBAL
#define NEED_newCONSTSUB_GLOBAL
#include "ppport.h"

typedef Loop * UV_Loop;
typedef Loop * UV__Loop;

static Loop *default_loop;

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
        uv_loop_t *uv_loop;

        if (ix == 1) is_default = 1;
        if (is_default) {
            if (default_loop) {
                RETVAL = default_loop;
            } else {
                RETVAL = malloc(sizeof(Loop));
                if (!RETVAL) {
                    croak("Class %s failed to initialize", class);
                }
                uv_loop = uv_default_loop();
                if (uv_loop_init(uv_loop) < 0) {
                    croak("Error initializing loop");
                }
                uv_loop->data = RETVAL;
                RETVAL->uv_loop = uv_loop;
                RETVAL->is_default = 1;
                RETVAL->buffer.in_use = 0;
                default_loop = RETVAL;
            }
        } else {
            RETVAL = malloc(sizeof(Loop));
            if (!RETVAL) {
                croak("Class %s failed to initialize", class);
            }
            uv_loop = &RETVAL->loop_struct;
            if (uv_loop_init(uv_loop) < 0) {
                croak("Error initializing loop");
            }
            uv_loop->data = RETVAL;
            RETVAL->uv_loop = uv_loop;
            RETVAL->is_default = 0;
            RETVAL->buffer.in_use = 0;
        }
    OUTPUT:
    RETVAL

void luv_DESTROY(self)
    UV::Loop self;
    CODE:
        if (self->uv_loop) {
            self->uv_loop->data = NULL;
            uv_loop_close(self->uv_loop);
        }
        free(self);

int luv_alive(self)
    UV::Loop self;
    CODE:
        RETVAL = uv_loop_alive(self->uv_loop);
    OUTPUT:
    RETVAL

int luv_default(self)
    UV::Loop self;
    CODE:
        RETVAL = (self->is_default)? 1: 0;
    OUTPUT:
        RETVAL

int luv_fileno(self)
    UV::Loop self;
    CODE:
        RETVAL = (int) uv_backend_fd(self->uv_loop);
    OUTPUT:
    RETVAL

double luv_get_timeout(self)
    UV::Loop self;
    CODE:
        RETVAL=(double) (uv_backend_timeout(self->uv_loop) / 1000.0);
    OUTPUT:
    RETVAL

size_t luv_now(self)
    UV::Loop self;
    CODE:
        RETVAL = (size_t) uv_now(self->uv_loop);
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
        RETVAL = uv_run(self->uv_loop, mode);
    OUTPUT:
    RETVAL

void luv_stop(self)
    UV::Loop self;
    CODE:
        uv_stop(self->uv_loop);

void luv_update_time(self)
    UV::Loop self;
    CODE:
        uv_update_time(self->uv_loop);
