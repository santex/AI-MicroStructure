#!/usr/bin/perl -w

use strict;
use warnings;
use Data::Printer;
use Data::Freq;
use Statistics::Basic qw(mean);
use IO::Capture::Stdout;
our $data = Data::Freq->new();
use JSON::XS;
use threads;

our @all = [];

#my @arr = split("\n",`micro-relation $search | egrep -v ' 1:' | egrep -v '^1:' | tr " -" "_" | sort -u`);
#my @arr = @ARGV;#_split("\n",`micro-relation $search | data-freq  | egrep -v ' 1:' | egrep -v '^1:' | tr " -" "_" | sed -s "s/^.*.:_//"`);
my @threads;

foreach my $arg  (@ARGV) {
 my $t = threads->new(doSomething($arg));
 $t->detach();
}
END{
p @all;
}


sub doSomething {
    my $q = shift;  
    my @q = [split("\n",`micro-relation $q;`)];
      foreach my $n(@q){
         push @all, $n;

     }

}
1;
