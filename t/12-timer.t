use strict;
use warnings;

use UV::Timer ();
use UV::Loop ();

use Data::Dumper;
use Test::More;

can_ok(
    'UV::Timer', (
        qw(new on),
    )
);

my $loop = UV::Loop->new(1);
isa_ok($loop, 'UV::Loop', 'new: got a new UV::Loop');
my $timer = UV::Timer->new($loop);
isa_ok($timer, 'UV::Timer', 'new: got a new UV::Timer');
$timer->on("close", sub {warn "yay. closing\n"; warn Dumper \@_;});
$timer->on("timer", sub {sleep 2000;warn "yay. timing\n"; warn Dumper \@_;});
$loop->run();

$timer->start();
$loop->stop();
#$timer->init($loop);

#my $foo = 0;
#$timer->start(0, 0, sub {
#    $foo++;
#});
# $loop->start();
#$timer->stop;
#ok($foo);

done_testing();
