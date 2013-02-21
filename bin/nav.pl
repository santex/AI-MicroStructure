#!/usr/bin/perl -W
use strict;
use warnings;
use JSON::XS;
use Data::Dumper;
use AI::MicroStructure;
use AI::MicroStructure::Util;
use Storable::CouchDB;
my @ARGVX = ();

my $state = AI::MicroStructure::Util::load_config(); my @CWD=$state->{cwd}; my $config=$state->{cfg};

our $json_main =  {lang=>"C",category=>"no",name=>"santex",size=>1,children=>[]};

@ARGVX=("user",
      "pass",
      "localhost",
      "nav") unless($#ARGVX>2);



my $x = AI::MicroStructure->new;

sub getAll {
  my $key =shift;

  require LWP::UserAgent;
  my $ua = LWP::UserAgent->new;
  my ($server,$db) = ($config->{couchdb},"table");
  my $res = $ua->get(sprintf('%s/%s/_design/base/_view/instances?reduce=false&start_key=["%s"]&end_key=["%sZZZ"]',
                              $server,
                              $db,
                              $key,
                              $key));


my $content = decode_json($res->content);
my @all;
my @book;

foreach(@{$content->{rows}}){

  if(@{$_->{key}}){
    push @all,grep{!/\W/}@{$_->{key}};
  }
}


return @all;


}



eval
{
$ARGV[0] = "$_";
my $key = sprintf("%s_%s",join("",sort @ARGVX),$ARGV[0]);
my @datax = getAll($ARGV[0]);

if($#datax){


foreach my $i(0..$#datax) {

  printf("%s%s%s%s","\n"x3,"@"x123,,"\n"x3,$datax[$i]);

}
}
} for("a".."z");
1;
__DATA__


