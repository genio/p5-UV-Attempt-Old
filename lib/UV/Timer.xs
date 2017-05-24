#include "p5luv.h"

#include "ppport.h"

MODULE = UV::Timer       PACKAGE = UV::Timer   PREFIX = luv_

PROTOTYPES: ENABLE

BOOT:
{
    HV *stash = gv_stashpvn("UV::Timer", 10, TRUE);

    /* expose the different handle type constants */
    newCONSTSUB(stash, "UV_TIMER", newSViv(UV_TIMER));
}

UV::Timer luv_new(class, loop)
        char * class;
        UV::Loop loop;
    CODE:
        PERL_UNUSED_VAR(class);
        /* handles the uv_timer_init(loop) and adds context */
        RETVAL = p5luv_timer_new(loop);
    OUTPUT:
    RETVAL

void luv_DESTROY(self)
    UV::Timer self;
    CODE:
        p5luv_timer_destroy(self);

UV::Timer luv_on(self, action, callback)
    UV::Timer self;
    const char *action;
    SV *callback;
    CODE:
        if (strcmp(action, "close") == 0) {
            self->close_cb = newSVsv(callback);
        } else if (strcmp(action, "alloc") == 0) {
            self->alloc_cb = newSVsv(callback);
        } else if (strcmp(action, "timer") == 0) {
            self->timer_cb = newSVsv(callback);
        } else {
            warn("Invalid action. Can't supply callback for %s", action);
        }
        RETVAL = self;
    OUTPUT:
    RETVAL

UV::Timer luv_start(self, timeout=0, repeat=0, cb=NULL)
    UV::Timer self;
    size_t timeout;
    size_t repeat;
    SV *cb;
    CODE:
        int err;
        if (cb != (SV *)NULL) self->timer_cb = newSVsv(cb);
        err = uv_timer_start(self->handle_ptr, p5luv_timer_timer_cb, ((uint64_t)timeout)*1000, ((uint64_t)repeat)*1000);
        if (err != 0) {
            croak("Error starting timer (%i): %s", err, uv_strerror(err));
        }
        RETVAL = self;
    OUTPUT:
    RETVAL
