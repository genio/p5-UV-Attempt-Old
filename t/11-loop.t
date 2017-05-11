use strict;
use warnings;

use UV::Loop ();

use Data::Dumper;
use Test::More;

can_ok(
    'UV::Loop', (
        qw(UV_LOOP_BLOCK_SIGNAL UV_RUN_NOWAIT UV_RUN_DEFAULT UV_RUN_ONCE),
        qw(UV_EBUSY UV_EINVAL UV_ENOSYS),
    )
);
can_ok(
    'UV::Loop', (
        qw(new default_loop alive default fileno get_timeout now run stop),
        qw(update_time),
    )
);

{
    my $loop = UV::Loop->new();
    isa_ok($loop, 'UV::Loop', 'new: got a new loop');
    is($loop->default, 0, 'default: false');
}

{
    my $loop = UV::Loop->new(1);
    isa_ok($loop, 'UV::Loop', 'new(1): got a new default loop');
    is($loop->default, 1, 'default: true');

    my $dloop = UV::Loop->default_loop();
    isa_ok($dloop, 'UV::Loop', 'default_loop: got a new default loop');
    is($dloop->default, 1, 'default: true');

    is(${$loop}, ${$dloop}, 'default loops one in the same!');
}

done_testing();
