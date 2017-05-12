#include "p5_luv.h"

#define NEED_newRV_noinc_GLOBAL
#define NEED_newCONSTSUB_GLOBAL
#include "ppport.h"

typedef Timer * UV_Timer;
typedef Timer * UV__Timer;

MODULE = UV::Timer       PACKAGE = UV::Timer   PREFIX = luv_

PROTOTYPES: ENABLE

UV::Timer luv_new(class)
        char * class;
    CODE:
        RETVAL = &(Timer){};
        RETVAL->timer_h.data = RETVAL;
        ((Handle *)RETVAL)->uv_handle = (uv_handle_t *)&RETVAL->timer_h;
    OUTPUT:
    RETVAL

void luv_again(self)
    UV::Timer self;
    CODE:
        int err;
        if (uv_is_closing(((Handle *)self)->uv_handle)) {
            croak("Handle is closing/closed.");
        }
        err = uv_timer_again(&self->timer_h);
        if (err != 0) {
            croak("Timer initialization error (%i): %s", err, uv_strerror(err));
        }

void luv_stop(self)
    UV::Timer self;
    CODE:
        int err;
        if (uv_is_closing(((Handle *)self)->uv_handle)) {
            croak("Handle is closing/closed.");
        }
        err = uv_timer_stop(&self->timer_h);
        if (err != 0) {
            croak("Timer stop error (%i): %s", err, uv_strerror(err));
        }
