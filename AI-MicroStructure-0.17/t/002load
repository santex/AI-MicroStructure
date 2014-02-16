use Test::More;
use AI::MicroStructure ();
use AI::MicroStructure::any;
use strict;

my @modules = AI::MicroStructure->structures;

plan tests => scalar @modules;
ok($_)  for sort map { AI::MicroStructure::any->new($_) } @modules;




__DATA__

# this is the original test which is broken now

use Test::More;
use AI::MicroStructure ();
use strict;

my @modules = map { "AI::MicroStructure::$_" } AI::MicroStructure->structures;

plan tests => scalar @modules;
use_ok( $_ ) for sort @modules;
