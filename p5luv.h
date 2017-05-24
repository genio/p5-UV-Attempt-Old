#ifndef P5LUV_H
#define P5LUV_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "uv.h"

#define P5LUV_DOUBLETIME(TV) ((double)(TV).tv_sec + 1e-6*(TV).tv_usec)
#define P5LUV_SLAB_SIZE 65536
#define P5LUV_HANDLE_FIELDS  \
    int flags;              \
    int initialized;        \
    int ref_count;          \
    SV *alloc_cb;           \
    SV *close_cb;           \
    SV *timer_cb;

typedef struct p5luv_loop_data_s {
    int is_default;
    int ref_count;
    SV *walk_cb;
} p5luv_loop_data_t;

typedef struct p5luv_timer_s {
    P5LUV_HANDLE_FIELDS
    uv_timer_t handle;
    uv_timer_t *handle_ptr;
} p5luv_timer_t;

/* typedefs for XS return values of T_PTROBJ */
typedef uv_loop_t * UV__Loop;
typedef p5luv_timer_t * UV__Timer;

/* function definitions */
static void             p5luv_loop_destroy(uv_loop_t *loop);
/*static SV *             p5luv_loop_get_walk_cb(uv_loop_t *loop); */
static int              p5luv_loop_is_default(uv_loop_t *loop);
static uv_loop_t *      p5luv_loop_new();
static uv_loop_t *      p5luv_loop_new_default();
static int              p5luv_loop_ref_count(uv_loop_t *loop);
static void             p5luv_timer_destroy(p5luv_timer_t *timer);
static void             p5luv_timer_close_cb(uv_handle_t *handle);
static p5luv_timer_t *  p5luv_timer_new(uv_loop_t *loop);
static void             p5luv_timer_timer_cb(uv_timer_t *handle);

/* LOOP Functions */
uv_loop_t * p5luv_loop_new()
{
    p5luv_loop_data_t *data;
    uv_loop_t *loop;

    data = malloc(sizeof(p5luv_loop_data_t));
    if (data==NULL) {
        croak("Couldn't allocate space for our context data");
    }

    loop = malloc(sizeof(uv_loop_t));
    if (loop == NULL) {
        Safefree(data);
        croak("Error getting new UV Loop");
    }
    if (uv_loop_init(loop) != 0) {
        Safefree(data);
        Safefree(loop);
        croak("Can't initialize loop");
    }

    /* save a copy of our PTR in data for callback use later */
    data->is_default = 0;
    data->ref_count = 1;
    loop->data = data;
    return loop;
}

uv_loop_t * p5luv_loop_new_default()
{
    p5luv_loop_data_t *data;
    uv_loop_t *loop = uv_default_loop();
    if (loop == NULL) {
        croak("Error getting default loop");
    }

    if (loop->data == NULL) {
        data = malloc(sizeof(p5luv_loop_data_t));
        if (data == NULL) {
            croak("Unable to allocate space for loop context");
        }
        data->is_default = 1;
        data->ref_count = 1;
        loop->data = (void *)data;
    } else {
        data = (p5luv_loop_data_t *)loop->data;
        data->ref_count++;
    }
    return loop;
}

void p5luv_loop_destroy(uv_loop_t *loop)
{
    if (loop == NULL) return;

    if (p5luv_loop_is_default(loop)) {
        /* only clean up the loop if we don't have anymore of them */
        if (p5luv_loop_ref_count(loop) <= 0) {
            if (uv_loop_close(loop) == 0) {
                Safefree(loop->data);
                Safefree(loop);
            }
        }
    } else {
        if (uv_loop_close(loop) == 0) {
            Safefree(loop->data);
            Safefree(loop);
        }
    }
}

int p5luv_loop_is_default(uv_loop_t *loop)
{
    return ((p5luv_loop_data_t *)(loop->data))->is_default;
}

int p5luv_loop_ref_count(uv_loop_t *loop)
{
    return ((p5luv_loop_data_t *)(loop->data))->ref_count;
}

/* Timer functions */
p5luv_timer_t * p5luv_timer_new(uv_loop_t *loop)
{
    p5luv_timer_t *timer;
    timer = malloc(sizeof(p5luv_timer_t));
    if (timer == NULL) {
        croak("Unable to create new timer");
    }
    timer->initialized = 0;
    timer->flags = 0;
    timer->ref_count = 1;
    timer->alloc_cb = (SV *)NULL;
    timer->close_cb = (SV *)NULL;
    timer->timer_cb = (SV *)NULL;

    if (uv_timer_init(loop, &timer->handle) != 0) {
        Safefree(timer);
        croak("Could not initialize the timer");
    }

    timer->handle_ptr = &timer->handle;
    uv_ref(timer->handle_ptr);
    uv_ref(loop);
    timer->initialized = 1;
    timer->handle.data = timer;
    return timer;
}

void p5luv_timer_destroy(p5luv_timer_t *timer)
{
    timer->ref_count--;
    if (timer->ref_count <= 0) {
        if (timer->initialized && !uv_is_closing((uv_handle_t *)timer->handle_ptr)) {
            uv_close((uv_handle_t *)timer->handle_ptr, p5luv_timer_close_cb);
            if (!uv_is_closing((uv_handle_t *)timer->handle_ptr)) {
                croak("Odd state. We told the timer to close, yet it isn't.");
            }
        }
    }
}

void p5luv_timer_close_cb(uv_handle_t *handle)
{
    if (handle == NULL) return;
    p5luv_timer_t *self = (p5luv_timer_t *) handle->data;
    if (self != NULL && self->close_cb) {
        dSP;

        ENTER;
        SAVETMPS;

        PUSHMARK(SP);
        EXTEND(SP, 1);
        /* Add the invocant to the callback */
        {
            self->ref_count++;
            SV * RETVALSV;
            RETVALSV = sv_newmortal();
            sv_setref_pv(RETVALSV, "UV::Timer", (void*)self);
            PUSHs(RETVALSV);
        }
        PUTBACK;

        call_sv(self->close_cb, G_VOID);

        SPAGAIN;

        FREETMPS;
        LEAVE;
    }
    ((p5luv_loop_data_t *)(self->handle_ptr->loop->data))->ref_count--;
    self->handle_ptr->loop = NULL;
    self->handle_ptr = NULL;
    Safefree(self);
}

void p5luv_timer_timer_cb(uv_timer_t *handle)
{
    dSP;

    SV *invocant;
    p5luv_timer_t *self;

    ENTER;
    SAVETMPS;

    if (handle != NULL) {
        self = (p5luv_timer_t *) handle->data;
        if (self != NULL && self->timer_cb != (SV *)NULL) {
            self->ref_count++;
            invocant = sv_newmortal();
            sv_setref_pv(invocant, "UV::Timer", self);

            /* Add the invocant to the callback */
            PUSHMARK(SP);
            EXTEND(SP, 1);
            PUSHs(invocant);
            PUTBACK;

            call_sv(self->timer_cb, G_VOID);

            SPAGAIN;

        }
    }

    FREETMPS;
    LEAVE;
}

#endif /* P5LUV_H */
