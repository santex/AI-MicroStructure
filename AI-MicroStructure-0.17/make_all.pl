#!/usr/bin/perl -w

use strict;
use Config;
use IPC::Run qw(run);
$| = 1;

my $perl = $Config{'perlpath'};

print "Attempting to test all ...\n";

my($in, $out, $err);

foreach my $file (sort <./t/*>) {
 next if $file =~ /make_all\.pl/;
  print "  Running $file...";
  run [$perl, "../$file"], \$in, \$out, \$err; # throw the output away
  print "done\n";
}

print "done\n";

1;
