#!/usr/bin/perl -w



use strict;
use Test::More 'no_plan';#tests =>12;
use Data::Dumper;
use Data::Printer;
use AI::MicroStructure;
use AI::MicroStructure::Context;
use Search::ContextGraph;
use Env qw(PWD);


our $c = AI::MicroStructure::Context->new(@ARGV);
    $c->retrieveIndex($PWD."/t/docs"); #"/home/santex/data-hub/data-hub" structures=0 text=1 json=1



   my $style = {};
      $style->{explicit}  = 1;
ok($c->simpleMixedSearch($style,$_)) && ok($c->play($style,$_))   for
 qw(atom antimatter planet);



ok(print Dumper $c->intersect($style,$_)) for
 qw(atom antimatter planet);

ok(print Dumper $c->similar($style,$_)) for
 qw(atom antimatter planet);

#p @out;

1;

