package UV::Handle;

our $VERSION = '0.001';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use strict;
use warnings;

require XSLoader;
XSLoader::load();

# Preloaded methods go here.

1;
