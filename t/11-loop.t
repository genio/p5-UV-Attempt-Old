use strict;
use warnings;

use UV::Loop ();

use Data::Dumper;
use Test::More;

can_ok('UV::Loop', 'new');

# diag( Dumper UV::Loop::);

ok(1);
done_testing();
