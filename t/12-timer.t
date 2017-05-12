use strict;
use warnings;

use UV::Timer ();

use Data::Dumper;
use Test::More;

can_ok(
    'UV::Timer', (
        qw(new again stop),
    )
);

my $timer = UV::Timer->new();
isa_ok($timer, 'UV::Timer', 'new: got a new UV::Timer');

diag Dumper $timer;
done_testing();
