#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use IO::Async::Loop;
use Net::Async::WebSocket::Server;
use JSON::XS;
use Env qw/PWD/;


my @symbols = ();
my $DEBUG = 10;
my $DEBUG_TO_SYSLOG=1;
my $LOGGER_EXE="/usr/bin/logger";
my $PORT = 3000;
my $JSON = {};
my $pwd = $PWD;#"/var/www/vhosts";



sub Dbg {
  my $level=shift @_;
  my $msg = shift @_;
  # If the $DEBUG level exceeds the level at which we log this mess
      my @args=`echo '$0 $msg' | $LOGGER_EXE`;

  return sprintf("\n",$msg);
}



sub printer {
  my ($msg) = @_;
  my $cmd = {};

     $msg = "space" unless($msg);

     $cmd->{action} = sprintf(`perl $pwd/nav.pl $msg | data-freq --limit 100 | egrep "[a-z|A-Z]" | grep -v "#"`);
     #sprintf(`perl /home/hagen/myperl/AI-MicroStructure-0.01/teswikilist05.pl $msg | data-freq --limit 100 | egrep ": [a-zA-Z]" | grep -v "#"`);

     $cmd->{action} = [map{my @a= [split(":",$_)]; $a[0][0]=~ s/ //g; $_={neighbour => $a[0][1], spawn => $a[0][0]};}split("\n",$cmd->{action})];

     $cmd->{json} = JSON::XS->new->pretty(0)->encode ({"meta" => {"type" => "json",
                                                                  "payload" => "neighbours"},
                                                      "query" => $msg,
                                                      "callback" => "makeList",
                                                      "responce" => $cmd->{action}});



#      print Dumper [$msg,$cmd];

      return $cmd->{json};

}
sub printerOverw {
  my ($self,$msg) = @_;
  my $cmd = {};

     $msg = "space" unless($msg);
    
    my $cmd = `perl $pwd/test005.pl $msg`;
    
     my @common = decode_json($cmd) unless($cmd!~/{/);
      
      
    foreach(@common){
      my $entry = $_->[0];
      foreach(keys %$entry){
   #   $self->send_frame( JSON::XS->new->pretty(0)->encode ($_));
   
      
   
        $entry->{key}=$_;
         $cmd->{$_} = JSON::XS->new->pretty(0)->encode ({"meta" => {"type" => $_,
                                                                  "payload" => "overw"},
                                                      "query" => $msg,
                                                      "callback" => "makeCommon",
                                                      "responce" => [$entry->{$_}]});

            $self->send_frame(  $cmd->{$_} );
      } 
    }
    
    
            
     return $cmd;

}




sub printerFiles{


  my ($self,$msg) = @_;

     $msg = "space" unless($msg);
     my $ret = {};
     my $set = `perl $pwd/semantic.pl $msg`;
     my @symbols = split("\n",$set);
  


  foreach my $k (@symbols[0..10]) {
   $self->send_frame( encode_json({"meta" => {"type" => "overw",
                         "payload" => $k},
                              "query" => $k,
                              "callback" => "makeCommon",
                              "responce" => $k}) );
  }
}


my $server = Net::Async::WebSocket::Server->new(
   on_client => sub {
      my ( undef, $client ) = @_;
      my $list;
      $client->configure(
         on_frame => sub {
            my ( $self, $frame ) = @_;
            $self->{frame} = $frame;
            $list = printer($frame);
            $self->send_frame( $list );
            $list = printerOverw($self, $frame);

   #        
            
#            printerFiles($self,$frame);
             #print Dumper $list;
         },
      );
   }
);

my $loop = IO::Async::Loop->new;#(max_payload_size=>40000);

$loop->add( $server );

$server->listen(
   family => "inet",
   service => $PORT,
   on_listen => sub { print Dumper "Cannot listen - ",$_[-1];  },
   on_resolve => sub { print Dumper "Cannot resolve - ",$_[-1];},
   on_listen_error => sub { die "Cannot listen - $_[-1]" },
   on_resolve_error => sub { die "Cannot resolve - $_[-1]" },
);

$loop->loop_forever;


