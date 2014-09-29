#!/usr/bin/perl
use Cwd;
use strict;
use warnings;
use JSON::XS;
use Config::Auto;
use Data::Dumper;
use Data::Printer;
use AI::MicroStructure;
use AI::MicroStructure::Util;
use Storable::CouchDB;
use IO::Async::Loop;
use Digest::MD5;
use Net::Async::WebSocket::Server;
use JSON::XS;
use Env qw/PWD/;
my @symbols = ();
my $DEBUG = 10;
my $DEBUG_TO_SYSLOG=1;
my $LOGGER_EXE="/usr/bin/logger";
my $PORT = 3000;
my $JSON = {};
my $pwd = $PWD;
my @ARGVX = ();
our $json_main =  {lang=>"C",category=>"no",name=>"santex",size=>1,children=>[]};
@ARGVX=("user",
      "pass",
      "localhost",
      "nav") unless($#ARGVX>2);
our $x = AI::MicroStructure->new;
sub getAll {
  my $key =shift;
  require LWP::UserAgent;
  my $ua = LWP::UserAgent->new;
  my ($server,$db) = ($x->{state}->{cfg}->{couchdb},"table");
  my $res = $ua->get(sprintf('%s/%s/_design/base/_view/instances?reduce=false&start_key=["%s"]&end_key=["%sZZZ"]',
                              $server,
                              $db,
                              $key,
                              $key));
my $cc= {};
my $content = decode_json($res->content);
my @all;
my @book;
foreach(@{$content->{rows}}){
  if(@{$_->{key}}){
    push @all,@{$_->{key}};
  }
}
my $cont = {};
  $res = $ua->get(sprintf('%s/%s/_design/base/_view/pdf?start_key="%s"&end_key="%sZZZ"',
                              $server,
                              $db,
                              $key,
                              $key));
 my $pdf = decode_json($res->content);
 foreach(@{$pdf->{rows}}) {
   foreach my $l(@{$_->{value}}){
    if($l){
      $cc->{$l} = 1 unless($l!~ m/^http.*.pdf$/i);
    }
  }
}
  $res = $ua->get(sprintf('%s/%s/_design/base/_view/image?reduce=false&start_key="%s"&end_key="%sZZZ"',
                              $server,
                              $db,
                              $key,
                              $key));
 my $img  = decode_json($res->content);
 foreach(@{$img->{rows}}) {
   foreach my $l(@{$_->{value}}){
     if($l){
      $cc->{$l} = 1 unless($l!~ m/upload.*.(png|jpg|gif|svg|jpeg)$/i);
     }
  }
}
$res = $ua->get(sprintf('%s/%s/_design/base/_view/audio?reduce=false&start_key="%s"&end_key="%sZZZ"',
                              $server,
                              $db,
                              $key,
                              $key));
 my $media  = decode_json($res->content);
 foreach(@{$media->{rows}}) {
   foreach my  $l  (@{$_->{value}}){
     if($l){
      $cc->{$l} = 1 unless($l!~ m/upload.*.(ogg|avi|mpg)$/i);
     }
  }
}
return {set=>[@all],kv=>[]};
}
#$ARGV[0] = "" unless($ARGV[0]);
#my $key = sprintf("%s_%s",join("",@ARGVX),$ARGV[0]);
#my @datax = getAll($ARGV[0]);
#if($#datax){
#foreach my $i(0..$#datax) {
 # printf("%s\n","".$datax[$i]) unless(!$datax[$i]);
#}
#}
sub printer {
  my ($msg) = @_;
  my $cmd = {};
     $msg = "space" unless($msg);
     my $data = getAll($msg);
    my @data = @{$data->{set}};
     @data  = @data[0..5000] unless($#data<10000);
     $cmd->{q} = join(" ",@data);
     $cmd->{action} =
      [map{my @a= [split(":",$_)]; $a[0][0]=~ s/ //g;
                    $_={neighbour => $a[0][1], spawn => $a[0][0]}}
                    split ("\n",`echo "$cmd->{q}" | tr " " "\n" | data-freq --limit 100`)];
     $cmd->{json} = JSON::XS->new->pretty(0)->encode({ "query" => $msg,
                                                      "callback" => "makeList",
                                                      "responce" =>
                                                      [$cmd->{action},
                                                      $data]});
      return $cmd->{json};
}
my $server = Net::Async::WebSocket::Server->new(
   on_client => sub {
      my ( undef, $client ) = @_;
      my $list;
      $client->configure(
         on_frame => sub {
            my ( $self, $frame ) = @_;
            $list = printer($frame);
            my %args = (max_payload_size=>9999999,buffer=> $list);
            $self->send_frame(%args);
         },
      );
   }
);
my $loop = IO::Async::Loop->new(max_payload_size=>11110);
$loop->add( $server );
$server->listen(
   family => "inet",
   service => $PORT,
   ip=>"127.0.0.1",
   on_listen => sub { print Dumper "Cannot listen - ",$_[-1];  },
   on_resolve => sub { print Dumper "Cannot resolve - ",$_[-1];},
   on_listen_error => sub { die "Cannot listen - $_[-1]" },
   on_resolve_error => sub { die "Cannot resolve - $_[-1]" },
);
$loop->loop_forever;
1;
__END__
