#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_newRV_noinc
#define NEED_sv_2pv_flags
#include "ppport.h"
#include "string.h"
#include "uv.h"

MODULE = UV::Loop       PACKAGE = UV::Loop   PREFIX = luv_
