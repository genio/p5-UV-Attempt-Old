use strict;
use warnings;

use UV::Util ();

use Data::Dumper::Concise qw(Dumper);
use Test::More;

ok(UV::Util::hrtime(), 'hrtime: Got a time');
ok(UV::Util::get_free_memory(), 'get_free_memory: Got memory size');
ok(UV::Util::get_total_memory(), 'get_total_memory: Got memory sizez');
ok(UV::Util::get_total_memory() > UV::Util::get_free_memory(), 'memory: more total than free');
isa_ok(UV::Util::loadavg(), 'ARRAY', 'loadavg: array ref received');
ok(UV::Util::uptime(), 'uptime: got uptime');
ok(UV::Util::resident_set_memory(), 'resident_set_memory: got value');
isa_ok(UV::Util::interface_addresses(), 'ARRAY', 'interface_addresses: array ref received');
isa_ok(UV::Util::cpu_info, 'ARRAY', 'cpu_info: got array ref');
isa_ok(UV::Util::getrusage, 'HASH', 'getrusage: got hashref');
ok(UV::Util::guess_handle_type(\*STDIN), 'guess_handle_type: got a result');

done_testing();
