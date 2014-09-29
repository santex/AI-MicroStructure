use Test::More;
use strict;
use AI::MicroStructure;
#use AI::MicroStructure::germany;
use Data::Printer;

    # test has_category (instance)
    my $meta = AI::MicroStructure->new( "germany",category => 'Dresden');
my  @names =$meta->name(0);
p $meta;
