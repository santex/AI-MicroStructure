#!/usr/bin/perl

use File::Find::Rule;
use File::Temp qw(tempdir);
use IO::File;
use HTML::Entities;
use Data::Printer;
use Data::Dumper;
use Parallel::ForkManager;
use AI::MicroStructure;
use Getopt::Long;
use JSON;

use JSON::XS;
use Storable qw(lock_store lock_retrieve);
my $pm = Parallel::ForkManager->new(8);
sub nicefy { return reverse sort {length($a) <=> length($b)}@_ }
our $cache = {};
our $kkey = sprintf "%s",join("_",@ARGV);




BEGIN{

    use  Try::Tiny;
    eval {
    local $^W = 0;  # because otherwhise doesn't pass errors


    use vars qw($cache $micro $result $curSysDate %opts $results);
    use Cache::Memcached::Fast;
         our $memd = new Cache::Memcached::Fast({
             servers => [ { address => 'localhost:11211', weight => 2.5 }],
             namespace => 'my:',
             connect_timeout => 0.2,
             io_timeout => 0.1,
             close_on_error => 1,
             compress_threshold => 100_000,
             compress_ratio => 0.9,
             max_failures => 1,
             max_size => 512 * 1024,
         });

    my $ping = `ping -c 1 google.com  | grep -c trans`;
    if(!$ping)
    {
      warn($ping);
    }

    $curSysDate = `date +"%Y%m%d"`;
    $curSysDate=~ s/\n//g;
    %opts = (
                  match => `micro | cut -f 1`,
                  max_cache_age => 18000,
                  cache_file    => sprintf("%s/realtime_%s.cache",
                                            "/tmp",
                                            $curSysDate),
                  cache         => 1,
    );
    GetOptions (\%opts, "match=s",
                        "query=s",
                        "max_cache_age=i",
                        "cache_file=s",
                        "cache!",
                        );
    if(!`ls $opts{cache_file}`){
     lock_store({},$opts{cache_file});
     }
    $cache = lock_retrieve($opts{cache_file});
    $cache = {} unless $cache;
  };
}


    #micro-dict share/apps/kcookiejar/cookies | data-freq | sort -n | egrep -v ": $"
 my @structures =  map{encode_entities($_) } AI::MicroStructure->new()->structures();

        printf("%s",join("\n",nicefy @structures));
                                                        @structures  = grep{m/$opts{match}/i}@structures;
                                              push @structures,$opts{match};
                                                    p @structures;

for ( 0 ..$#structures) {

      my $micro = $structures[$_];

      $pm->start and next;

      alarm 60;             # <---


          $cache->{$micro}->{structure} = $micro;
          $cache->{$micro}->{names} =   [nicefy split "\n",`micro "$micro" all`];
          $cache->{$micro}->{names} =   [ @{$cache->{$micro}->{names}}];
          $cache->{$micro}->{relation} =  [nicefy split "\n",`micro-relation  $micro `];

          my @lower = split(/\W/,$micro);
          p @lower;
          push @{$cache->{$micro}->{bilangual}},  [nicefy split "\n",`bash /home/santex/bin/sex.sh   "$_"`]  for @{$cache->{$micro}->{names}};
          my $file1;
          $file1 .= sprintf  join(" ",@{$cache->{$micro}->{$_}}) for qw(bilangual relation names);


           $cache->{$micro}->{category} =  [split "\n",`getcat $micro`];
          my $sear = $micro ;
          $sear=~ s/_/ /g;
          $cache->{$micro}->{search} = [find( file    =>
            name =>["*".$sear."*.*" ],
            size    => '>0k',
            in      => [@INC])];

  my $encoder = JSON->new->allow_blessed->pretty(1);
  my $json = $encoder->encode($cache);
  #print $fh $json;
  #close $fh;
  open defined(my $fh), ">", sprintf("%s/cache.json",$cache->{ "tempdir"});
  print $fh $json;
  close $fh;

   my $cmd = sprintf("'micro-dict  %s/cache.json 1 | data-freq | sort -n",$cache->{ "tempdir"}) ;
      print  `$cmd`;


          my %hash;
          foreach my $line (@{$cache->{$micro}->{names}}){
              while ($file1 =~ m/$line/g){
              $cache->{freq}->{$line}++;
              }}
              $cache->{$micro}->freq = \%hash;

$pm->finish; }
$pm->wait_all_children();

END{
  lock_store($cache,$opts{cache_file});
  p $cache; }
