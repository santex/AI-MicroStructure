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
my $pwd = $PWD;

sub printer {
  my ($msg) = @_;
  my $cmd = {};

     $msg = "space" unless($msg);

     $cmd->{action} = sprintf(`perl $pwd/nav.pl $msg | data-freq --limit 100 | egrep "[a-z|A-Z]" | grep -v "#"`);

     $cmd->{action} = [map{my @a= [split(":",$_)]; $a[0][0]=~ s/ //g; $_={neighbour => $a[0][1], spawn => $a[0][0]};}split("\n",$cmd->{action})];

     $cmd->{json} = JSON::XS->new->pretty(0)->encode ({"meta" => {"type" => "json",
                                                                  "payload" => "neighbours"},
                                                      "query" => $msg,
                                                      "callback" => "makeList",
                                                      "responce" => $cmd->{action}});

      return $cmd->{json};

}


my $server = Net::Async::WebSocket::Server->new(
   on_client => sub {
      my ( undef, $client ) = @_;
      my $list;
      $client->configure(
         on_frame => sub {
            my ( $self, $frame ) = @_;
            $self->{frame} = $frame;
            print STDOUT $frame;
            $list = printer($frame);
            $self->send_frame( $list );
    
         },
      );
   }
);

my $loop = IO::Async::Loop->new;#(max_payload_size=>40000);

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
