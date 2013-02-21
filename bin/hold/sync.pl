#!/usr/bin/perl

use strict;
use warnings;
use Data::Printer;
use Getopt::Long;
use HTML::Tiny;
use LWP::UserAgent;
use File::Spec;
use File::Path;
use PerlIO::gzip;
use YAML qw<DumpFile LoadFile>;
use Parallel::Iterator qw( iterate );
use AnyEvent::Subprocess::Easy qw(qx_nonblock);
use AI::Classifier::Text::Analyzer;
use AI::MicroStructure;
our $micro = AI::MicroStructure->new();
our @t = $micro->structures;

my $analyzer = AI::Classifier::Text::Analyzer->new();

$| = 1;


use constant WORDS     =>  '/home/santex/data-hub/book/output-unique';
use constant MAIL_RC =>    'http://localhost/concept-knowledge/science/0.001-brain.txt.gz';
use constant USER_BASE => 'http://localhost//training-knowledge/science';
use constant AUTHOR    => 'http://localhost/~';
use constant OUTPUT    => 'cpan-faces';
use constant STATE     => File::Spec->catfile( OUTPUT, 'work.yml' );
use constant SIZE      => 80;

my $UPDATE = 0;

GetOptions( 'update' => \$UPDATE )
 or die "cpan-gravatar.pl [--update]\n";

my $ua = LWP::UserAgent->new;

mkpath( OUTPUT );

my $currents = -f STATE ? LoadFile( STATE ) : {};

$SIG{INT} = sub {
  print "Got SIGINT, stopping\n";
  exit;
};

my $pid = $$;

my $cmd = {};

$cmd->{one} = 'for o in `cat /home/santex/data-hub/book/output-unique | egrep "^*.(alg|qua|sozio|therm|exo|geo|bio|phys|chem).*"`;
do qq=$(wordnet $o  -grepn -hypen -hypon -synsn -smemn -ssubn -sprtn -partn -meron -holon -domnn -famln -coorn -hmern -hholn | egrep -v "of noun");  echo -split-hit $qq ;  done ';


#'for i in `cat '.WORDS.'  | egrep "(a|b|c|d)*('.join("|",@ARGV).')"`; done';

    our $index = File::Spec->catfile( OUTPUT, 'index.html' );
    open our $ih, '>>', $index or die "Can't write $index ($!)\n";
    print $ih $cmd->{one};
    close $ih;
#


  my $date ;
  our $sub ={};
  my ( %currents, $id ) = ();
 foreach(keys %$cmd){

  $date = qx_nonblock($cmd->{$_})->recv;

  my @set = split(/\n/,$date);
  my $index = File::Spec->catfile( OUTPUT, 'index.html' );
  open my $ih, '>>', $index or die "Can't write $index ($!)\n";

  foreach(0..$#set){
    print ".";
    next unless(!$_);
    if( $set[$_] =~ /^-split-hit/ && $set[1+  $_])
    {

      $set[$_] =~ s/-split-hit //g;
      $sub->{$set[$_]} = substr($set[1+  $_],1);
      $currents{$set[$_]}= $sub->{$set[$_]};


    open my $ih, '>>', $index or die "Can't write $index ($!)\n";
    print $ih build_page( sprintf("\n%s=%s\n<hr>\n",$set[$_],$sub->{$set[$_]}));


    }
    else
    {
      print ".\n" ;
    }
  }
  close $ih;


  #my $features = $analyzer->analyze( $date );

  #$sub->{f}={F=>$features,R=>$date};

  #p $sub;

 }


BEGIN
{


    our $index = File::Spec->catfile( OUTPUT, 'index.html' );
    open our $ih, '>', $index or die "Can't write $index ($!)\n";
    print $ih "";
  close $ih;


  }


END {
  if ( $$ == $pid ) {
    print "Saving ", STATE, "\n";
    DumpFile( STATE, $currents );



  }
}

update(
  $currents,
  $UPDATE
  ? sub {
    my ( $currents, $id ) = @_;
    return 0;
   }
  : sub {
    my ( $currents, $id ) = @_;
    return exists $currents->{$id}
     && $currents->{$id}->{state} eq 'done';
  }
);


sub build_head {
  my $currents = shift;
  return $currents;
}

sub update {
  my ( $currents, $skip_if ) = @_;
  print "Getting ", MAIL_RC, "\n";
  my $authors = get_authors( MAIL_RC );
  open my $ah, '<:gzip', $authors or die "Can't read $authors ($!)\n";

  my $iter = iterate(
    { workers => 20 },
    sub {
      my ( $id, undef ) = @_;
      print "Checking $id\n";
      return save_current( lc( $id ) );
    },
    sub {
      while ( defined( my $line = <$ah> ) ) {
        next unless $line =~ /^alias\s+(\S+)/;
        return $1;
      }
      return;
    }
  );

  while ( my ( $id, $current ) = $iter->() ) {
    $currents->{$id} = $current;
    print "Icon saved as ", $current->{name}, "\n"
     if $current && $current->{name};
  }
}

sub build_page {
  my $currents = shift;
  return $currents;
}
sub get_authors {
  my $url  = shift;
  my $resp = $ua->get( $url );
  if ( $resp->is_success ) {
    my $name = File::Spec->catfile( OUTPUT, '01mailrc.txt.gz' );
    open my $ah, '>', $name or die "Can't write $name ($!)\n";
    binmode $ah;
    print $ah $resp->content;
    close $ah;
    return $name;
  }
  else {
    die $resp->status_line;
  }
}

sub user_home {
  my $id = shift;
  return AUTHOR . lc( $id );
}

sub save_current {
  my $id = shift;
  my %ext_map = ( jpeg => 'jpg' );
  my ( $data, $type ) = eval { get_current( $id ) };

  if ( $@ ) {
    return {
      error => $@,
      state => 'error'
    };
  }

# if ( $data && $data ne $default_image && $type =~ m{ ^image/(\S+) }x ) {
  if ( $data ) {
    my $ext = $ext_map{$1} || $1;
    my $name = make_name( $id, $ext );
    return {
      name  => $name,
      state => 'done'
    };
  }

  return { state => 'done' };
}

sub make_name {
  my ( $email, $ext ) = @_;
  my %enc = (
    '@' => '-AT-',
    '.' => '-DOT-'
  );
  $email =~ s/([@.])/$enc{$1}||$1/eg;
  return File::Spec->catfile( OUTPUT, "$email.$ext" );
}

sub get_current {
  my $id = shift;
  $id =~ s{^(((.).).*)$}{$3/$2/$1};
  TRY: for my $ext ( qw( jpg png ) ) {
    my $url  = USER_BASE . '/' . $id . '.' . $ext;
    my $resp = $ua->get( $url );
    if ( $resp->is_success ) {
      return ( $resp->content, $resp->header( 'Content-Type' ) );
    }
    elsif ( $resp->code == 404 ) {
      next TRY;
    }
    else {
      die join ' ', $resp->code, $resp->message;
    }
  }
  return;
}


