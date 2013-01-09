#!/usr/bin/perl
use AI::MicroStructure::Relations;

INIT {
my $cache = {};
$ARGV[0] = "Space" unless($ARGV[0]);

utf8::decode($_) for @ARGV;
my $new = AI::MicroStructure::Relations->new();


$new ->gofor($_) for @ARGV;


print  Dumper $new;

}



1;
__END__

