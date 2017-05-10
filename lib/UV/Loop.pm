package UV::Loop;

our $VERSION = '0.001';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use strict;
use warnings;

require XSLoader;
XSLoader::load();

# Preloaded methods go here.

1;
__END__

=encoding utf8

=head1 NAME

UV::Loop - libUV loops in Perl.

=head1 SYNOPSIS

  #!/usr/bin/env perl
  use strict;
  use warnings;
  use feature ':5.14';

  use UV::Loop;

  my $loop = UV::Loop->default_loop();
  $loop->run();

=head1 DESCRIPTION

This module provides access to the event loop via
L<libUV|http://docs.libuv.org/en/latest/loop.html>. While it's extremely
unlikely, all functions here can throw an exception on error unless specifically
stated otherwise in the function's description.

=head1 CONSTANTS

L<UV::Loop> makes the following constants available.

=head2 UV_LOOP_BLOCK_SIGNAL

    # 0

=head2 UV_RUN_NOWAIT

    # 1

=head2 UV_RUN_DEFAULT

    # 2

=head2 UV_RUN_ONCE

    # 3

=head1 CONSTRUCTORS

L<UV::Loop> provides the following constructors.

=head2 new

    # create a new loop
    my $loop = UV::Loop->new();
    # create a new default_loop
    my $default_loop = UV::Loop->new(1);

The constructor provides a new,
L<initialized|http://docs.libuv.org/en/latest/loop.html#c.uv_loop_init>
L<libUV loop|http://docs.libuv.org/en/latest/loop.html> object. If a C<true>
value is provided, the constructor will give you back the
L<default loop|http://docs.libuv.org/en/latest/loop.html#c.uv_default_loop>.

=head2 default_loop

    # create a new default_loop
    my $loop = UV::Loop->default_loop();
    # behaves the same as new with a true value
    $loop = UV::Loop->new(1);

This form of the constructor is an alias to the L<UV::Loop/new> constructor that
only returns the
L<default loop|http://docs.libuv.org/en/latest/loop.html#c.uv_default_loop>.

=head1 METHODS

L<UV::Loop> provides the following methods.

=head2 alive

    my $alive = $loop->alive();

This L<method|http://docs.libuv.org/en/latest/loop.html#c.uv_loop_alive>
returns true value if there are active handles or requests in the loop.

=head2 default

    my $def = $loop->default();

This method returns C<1> if this instance is the
L<default loop|http://docs.libuv.org/en/latest/loop.html#c.uv_default_loop>,
C<0> otherwise.

=head2 fileno

    my $backend_fd = $loop->fileno();

This L<method|http://docs.libuv.org/en/latest/loop.html#c.uv_backend_fd> returns
the backend file descriptor. Only kqueue, epoll and event ports are supported.

=head2 get_timeout

    my $timeout = $loop->get_timeout();

This L<method|http://docs.libuv.org/en/latest/loop.html#c.uv_backend_timeout>
returns the poll timeout for this loop. The value is in microseconds or C<-1>
for no timeout.

=head2 now

    my $time = $loop->now();

This L<method|http://docs.libuv.org/en/latest/loop.html#c.uv_now>
returns the current timestamp in milliseconds. The timestamp is cached at the
start of the event loop tick, see L<UV::Loop/update_time> for details and
rationale.

The timestamp increases monotonically from some arbitrary point in time. Don't
make assumptions about the starting point, you will only get disappointed.

Use L<UV::Util/hrtime> if you need sub-millisecond granularity.

=head2 run

    # by default, we use UV_RUN_DEFAULT
    my $res = $loop->run();
    $res = $loop->run(UV::Loop::UV_RUN_DEFAULT);
    # run once
    $res = $loop->run(UV::Loop::UV_RUN_ONCE);
    # no wait
    $res = $loop->run(UV::Loop::UV_RUN_NOWAIT);

This L<method|http://docs.libuv.org/en/latest/loop.html#c.uv_run> runs the
event loop. It will act differently depending on the specified mode.

The mode is one of the three L<UV::Loop/CONSTANTS> above (
L<UV::Loop/UV_RUN_DEFAULT>, L<UV::Loop/UV_RUN_ONCE>, or
L<UV::Loop/UV_RUN_NOWAIT>).

L<UV::Loop::UV_RUN_DEFAULT>: Runs the event loop until there are no more active
and referenced handles or requests. Returns non-zero if L<UV::Loop/stop> was
called and there are still active handles or requests. Returns zero in all
other cases.

L<UV::Loop/UV_RUN_ONCE>: Poll for i/o once. Note that this function blocks if
there are no pending callbacks. Returns zero when done (no active handles or
requests left), or non-zero if more callbacks are expected (meaning you should
run the event loop again sometime in the future).

L<UV::Loop/UV_RUN_NOWAIT>: Poll for i/o once but don’t block if there are no
pending callbacks. Returns zero if done (no active handles or requests left),
or non-zero if more callbacks are expected (meaning you should run the event
loop again sometime in the future).

=head2 stop

    $loop->stop();


This L<method|http://docs.libuv.org/en/latest/loop.html#c.uv_stop> stops the
event loop, causing L<UV::Loop/run> to end as soon as possible. This will
happen not sooner than the next loop iteration. If this function was called
before blocking for i/o, the loop won't block for i/o on this iteration.

=head2 update_time

    $loop->update_time();

This L<method|http://docs.libuv.org/en/latest/loop.html#c.uv_update_time>
updates the event loop's concept of L<UV::Loop/now>. Libuv caches the current
time at the start of the event loop tick in order to reduce the number of
time-related system calls.

You won't normally need to call this function unless you have callbacks that
block the event loop for longer periods of time, where "longer" is somewhat
subjective but probably on the order of a millisecond or more.

=head1 COPYRIGHT AND LICENSE

Copyright 2017, Chase Whitener.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
