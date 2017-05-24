use strict;
use warnings;

use UV::Handle ();
use Test::More;

can_ok(
    'UV::Handle', (
        qw(UV_UNKNOWN_HANDLE UV_ASYNC UV_CHECK UV_FS_EVENT UV_FS_POLL),
        qw(UV_HANDLE UV_IDLE UV_NAMED_PIPE UV_POLL UV_PREPARE),
        qw(UV_PROCESS UV_STREAM UV_TCP UV_TIMER UV_TTY UV_UDP UV_SIGNAL),
        qw(UV_FILE UV_HANDLE_TYPE_MAX),
    )
);

done_testing();
