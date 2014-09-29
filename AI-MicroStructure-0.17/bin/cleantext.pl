#!/usr/bin/perl
use HTML::Strip;
die("no args") unless(@ARGV);
die("no file") unless(-f $ARGV[0]);
my $file=shift;
my $html = sprintf("%s" ,`cat "./$file" | tr "\n"  " "`);

my $hs = HTML::Strip->new();
my $clean_text = $hs->parse($html);
$hs->eof;

#$clean_text ~=  tr/a-zA-Z//cd; tr/a-zA-Z/A-ZA-Z/s;
print $clean_text;
