#include "p5luv.h"

#include "ppport.h"

MODULE = UV::Handle       PACKAGE = UV::Handle   PREFIX = luv_

PROTOTYPES: ENABLE

BOOT:
{
    HV *stash = gv_stashpvn("UV::Handle", 10, TRUE);

    /* expose the different handle type constants */
    newCONSTSUB(stash, "UV_UNKNOWN_HANDLE", newSViv(UV_UNKNOWN_HANDLE));
    newCONSTSUB(stash, "UV_ASYNC", newSViv(UV_ASYNC));
    newCONSTSUB(stash, "UV_CHECK", newSViv(UV_CHECK));
    newCONSTSUB(stash, "UV_FS_EVENT", newSViv(UV_FS_EVENT));
    newCONSTSUB(stash, "UV_FS_POLL", newSViv(UV_FS_POLL));
    newCONSTSUB(stash, "UV_HANDLE", newSViv(UV_HANDLE));
    newCONSTSUB(stash, "UV_IDLE", newSViv(UV_IDLE));
    newCONSTSUB(stash, "UV_NAMED_PIPE", newSViv(UV_NAMED_PIPE));
    newCONSTSUB(stash, "UV_POLL", newSViv(UV_POLL));
    newCONSTSUB(stash, "UV_PREPARE", newSViv(UV_PREPARE));
    newCONSTSUB(stash, "UV_PROCESS", newSViv(UV_PROCESS));
    newCONSTSUB(stash, "UV_STREAM", newSViv(UV_STREAM));
    newCONSTSUB(stash, "UV_TCP", newSViv(UV_TCP));
    newCONSTSUB(stash, "UV_TIMER", newSViv(UV_TIMER));
    newCONSTSUB(stash, "UV_TTY", newSViv(UV_TTY));
    newCONSTSUB(stash, "UV_UDP", newSViv(UV_UDP));
    newCONSTSUB(stash, "UV_SIGNAL", newSViv(UV_SIGNAL));
    newCONSTSUB(stash, "UV_FILE", newSViv(UV_FILE));
    newCONSTSUB(stash, "UV_HANDLE_TYPE_MAX", newSViv(UV_HANDLE_TYPE_MAX));
}
