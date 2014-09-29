#!/usr/bin/perl -X

use strict;
use warnings;
use AI::MicroStructure;
use Data::Printer;

my $h = AI::MicroStructure->new( 'germany', category => 'Dresden' );
my @h =  $h->name(0);
p @h;
