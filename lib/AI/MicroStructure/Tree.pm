#!/usr/bin/perl
package AI::MicroStructure::Tree; # or whatever you're doing

use strict;
use Class::Container;
use base qw(Tree::DAG_Node);
use Params::Validate qw(:types);
use Data::Dumper;
use AI::MicroStructure::Collection;
use AI::MicroStructure;
my @themes = grep { !/^(?:any)/ } AI::MicroStructure->structures;

my $root = Tree::DAG_Node->new({attributes=>{BASE_STRUCTURE=>[@themes]}});
   $root->name("micro");
my $new_daughter = $root->new_daughter;
   $new_daughter->name("More");


  print Dumper $root;


1;
