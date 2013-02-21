use strict;
use warnings;
use Test::More;
use AI::MicroStructure;
use AI::MicroStructure::any;

my $any = AI::MicroStructure::any->new();

my $meta = AI::MicroStructure->new();
my @themes =  $meta->structures();


plan tests => 10;
ok(sprintf $any->name(1));


