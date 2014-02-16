#!/usr/bin/perl -w

use strict;
use warnings;
use threads;
use Data::Printer;
use Data::Freq;
use Statistics::Basic qw(mean);
use IO::Capture::Stdout;
our $data = Data::Freq->new();
my $search = $ARGV[0];
   $search = 'planet' unless($search);
our @all = ();

sub doSomething {
    my $thread = shift;
    my @q = split("\n",`micro-relation $thread  | tr " -" "_"`);
    
      foreach my $n( @q){
         push @all, $n;
    
             
     }

}
#my @arr = split("\n",`micro-relation $search | egrep -v ' 1:' | egrep -v '^1:' | tr " -" "_" | sort -u`);
my @arr = split("\n",`micro-relation $search | data-freq  | egrep -v ' 1:' | egrep -v '^1:' | tr " -" "_" | sed -s "s/^.*.:_//"`);
my @threads;

foreach (@arr) {
 my $t = threads->new(\&doSomething, $_); 
 $t->detach();
}


  
