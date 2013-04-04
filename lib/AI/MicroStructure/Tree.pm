#!/usr/bin/perl
package AI::MicroStructure::Tree; # or whatever you're doing

use strict;
use Class::Container;
use base qw(Tree::DAG_Node);
use Params::Validate qw(:types);
use Data::Dumper;
use AI::MicroStructure::Collection;
use AI::MicroStructure;
exit(0) unless(@ARGV);
my @themes = grep { !/^(?:any)/ } AI::MicroStructure->structures;

my $root = Tree::DAG_Node->new();
   $root->name("micro");

my $set = {};

 foreach my $f (split( "\n",`micrownet $ARGV[0]`)){
   my @atr = split( "\n",`micrownet $f`);
   $set->{$f} =  $root->new_daughter();
   $set->{$f}->attributes->{name} =  $f;

   my $x=0;
   foreach my $ar (@atr){
    next if ($ar=~/'/);

     $ar=~s/ /_/g;
     my @aatr = split( "\n",`micrownet $ar`);


     next unless($#aatr>1);
     if(!$set->{$f}->{$ar}){
     $set->{$f}->{$ar} =  $set->{$f}->new_daughter();

     $set->{$f}->{$ar}->attributes->{count} =  $#aatr;
#     $set->{$f}->{$ar}->attributes->{elements} =  join("#",@aatr);
     $set->{$f}->{$ar}->attributes->{name} =  $ar;
     }else{
     $set->{$f}->{$ar}->attributes->{fuse} =  $x++;
     }
   }

 }
  print map("$_\n", @{$root->tree2string});




1;
