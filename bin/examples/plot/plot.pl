#!/usr/bin/perl -X
use strict;
use warnings;
use Encode;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Data::Printer;
use Net::Twitter::Search;
use Getopt::Long;
use Data::Dumper;
use List::Util qw(min max);
use Storable qw(lock_store lock_retrieve freeze thaw dclone);
use Statistics::Basic qw(:all);
my $qq = `ping -c 1 google.com  | grep -c trans`;

our $curSysDate = `date +"%F"`;
    $curSysDate=~ s/\n//g;

our %opts = (      table         => "intraday",
                    db            => "x20",
                    max_cache_age => 5,
                    cache_file    => sprintf("/home/hagen/data/ufo_%s.cache",$curSysDate),
                    cache         => 1,
);
GetOptions (\%opts,"table=s",
                    "db=s",
                    "max_cache_age=i",
                    "cache_file=s",
                    "cache!",
                    );

#$ARGV[0]="Moon";
our $cache = {};

eval {
    local $^W = 0;  # because otherwhise doesn't pass errors
#`rm $opts{cache_file}`;
    $cache = lock_retrieve($opts{cache_file});

    $cache = {} unless $cache;

    warn "New cache!\n" unless defined $cache;
};




sub mergesort_string
{
	my ($aref, $begin, $end)=@_;

	my $size=$end-$begin;

	if($size<2) {return;}
	my $half=$begin+int($size/2);

	mergesort_string($aref, $begin, $half);
	mergesort_string($aref, $half, $end);

	for(my $i=$begin; $i<$half; ++$i) {
		if($$aref[$i] gt $$aref[$half]) {
			my $v=$$aref[$i];
			$$aref[$i]=$$aref[$half];

			my $i=$half;
			while($i<$end-1 && $$aref[$i+1] lt $v) {
				($$aref[$i], $$aref[$i+1])=
					($$aref[$i+1], $$aref[$i]);
				++$i;
			}
			$$aref[$i]=$v;
		}
	}
}

sub msort_string
{
	my $size=@_;
	mergesort_string(\@_, 0, $size);
}


sub mergesort_number
{
	my ($aref, $begin, $end)=@_;

	my $size=$end-$begin;

	if($size<2) {return;}
	my $half=$begin+int($size/2);

	mergesort_number($aref, $begin, $half);
	mergesort_number($aref, $half, $end);

	for(my $i=$begin; $i<$half; ++$i) {
		if($$aref[$i] > $$aref[$half]) {
			my $v=$$aref[$i];
			$$aref[$i]=$$aref[$half];

			my $i=$half;
			while($i<$end-1 && $$aref[$i+1] < $v) {
				($$aref[$i], $$aref[$i+1])=
					($$aref[$i+1], $$aref[$i]);
				++$i;
			}
			$$aref[$i]=$v;
		}
	}
}

sub msort_number
{
	my $size=@_;
	mergesort_number(\@_, 0, $size);
}


sub check{
  
#  my $cache = shift;

  if(!$cache->{ARGV}) {
   
   $cache->{ARGV} = ();

  }
  
  my $plot = {};
  foreach(sort{$a cmp $b} keys %{$cache->{ARGV}}){
  my $k = $_;
  $k =~ s/[ |:]//g;
  $k = substr($k,13,4);
  if(!defined($plot->{$k})) {
    $plot->{$k} = 1;
  }else{
    $plot->{$k} =   $plot->{$k}+1;
  }
  print "$k $cache->{ARGV}->{$_}\n";
  } 

return $plot;

    
}




END {
  
my $plot = check();

use  GD::Graph::mixed;

my @m = ();
foreach(sort{$a cmp $b}keys %$plot)
{

}
my  @data = (
           [sort{$a cmp $b}keys %$plot],
           [ values %$plot]
         );

         my $graph = GD::Graph::mixed->new(900, 300);

         $graph->set(
             x_label           => 'Hour',
             y_label           => 'avg Frequencey',
             title             => 'hourly freq.',
             transparent => 0,
             x_label_skip=>30,
             x_labels_vertical=>1
            
       

         ) or die $graph->error;


         my $gd = $graph->plot(\@data) or die $graph->error;

         open(IMG, '>/tmp/file.gif') or die $!;
         binmode IMG;
         print IMG $gd->gif;
         close IMG;

      `killall -9 geeqie; geeqie /tmp/ &`;

}


#you can also use any methods from Net::Twitter.

__END__
__DATA__
