#!/usr/bin/perl
package AI::MicroStructure::Context;
use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION);

require Carp;
require Symbol;
require Exporter;
require DynaLoader;
use Data::Printer;
use Data::Dumper;
use Search::ContextGraph;
use Statistics::Basic qw(:all);

@ISA = qw(Exporter DynaLoader);

@EXPORT = ();

@EXPORT_OK = ();

%EXPORT_TAGS = (all => [@EXPORT_OK]);

$VERSION = "0.1";


##  bootstrap AI::MicroStructure::Context $VERSION;

my $Class = __PACKAGE__;    ##  This class's name
my $Table = $Class . '::';  ##  This class's symbol table

my $Count = 0;  ##  Counter for generating unique names for all locations
my $Alive = 1;  ##  Flag for disabling auto-dump during global destruction

sub _usage_
{
    my($text) = @_;

    Carp::croak("Usage: $text");
}


sub new {
   my ( $class, @tools ) = ( @_ );


  my $self = bless {tools => @_ ,
                    micro => AI::MicroStructure->new(),
                    graph => {content=>Search::ContextGraph->new()}}, $class;

    $self->{structures} = [$self->{micro}->structures];

    return $self;

}



sub retrieveIndex {

    my $self = shift;
    my $in = shift;

    if(!$in) {

    Carp::croak("Usage: provide path") unless($self->{micro}->{state}->{path}->{"cwd/structures"});

    $in = $self->{micro}->{state}->{path}->{"cwd/structures"}  unless($in);
    }

    $self->{graph}->{content}  =$self->{graph}->{content}->load_from_dir($in);

#    $self->{graph}->{content}  = $self->retrieve($in);
   #$g->retrieve($in);


  }

sub storeIndex {

    my $self = shift;
    my $in = shift;
    $in = "stored.cng"  unless($in);

    $self->{graph}->{content}->store( $in );

  }




  sub training_docs {


    my $self = shift;

    my ($i,$prop) = ();

    my $cat={};
    foreach my $th (@{$self->{structures}})
    {

     $prop = sprintf(`micro  $th   all`);

     $cat->{sprintf("%s",$th)}={categories => [$th],content =>$prop};

      $i++;
    }

    return $cat;
  }



  sub play {

    my $self = shift;

    my ($style,$in) = @_;

    $style->{$in}->{structs} = [$self->{graph}->{content}->search($self->metaArg($in,$style))];

    return $style;

  };

  sub metaArg {

    my $self = shift;
    my $in = shift;
    my $style  = shift;

    my @metaArg = ();

    $style->{explicit} = 0 unless($style->{explicit});

    return split(" ",$style->{explicit} ? $in : `micro all $in`);


  }


  sub getOverAvg {

    my $self = shift;

    my $style  = shift;

    my ($payload) = @_;

    my @files = keys %$payload;
    my @scores = values %$payload;
    my $avgscrore= mean(@scores);


     foreach my $file ( sort { $a cmp $b } @files ) {
        printf("%s=%s\n",$file,
                         $payload->{$file})
                         unless(($payload->{$file}*$payload->{modifier})<=$avgscrore);

     }
  }

sub intersect {

      my $self = shift;

      my ($style,$in) = @_;

      my @in = $self->metaArg($in,$style);

      return [$self->{graph}->{content}->intersection( terms => [@in] )];


  }


sub similar {


    my $self = shift;

    my ($style,$in) = @_;


    my @in = $self->metaArg($in,$style);

    my @ranked_docs =  $self->{graph}->{content}->simple_search(@in);

    return [$self->{graph}->{content}->find_similar(@ranked_docs)];

 #   return @in;

  }

  sub simpleMixedSearch {



    my $self = shift;

    my ($style,$in) = @_;

    my @in = $self->metaArg($in,$style);

    my @ranked_docs =  $self->{graph}->{content}->simple_search(@in);


    p @ranked_docs;

    my( $docs, $words ) =$self->{graph}->{content}->mixed_search( {documents => [@ranked_docs],
                                    terms => [@in]
                               } );


    p $docs;
    p $words;


    $words->{modifier} = 0.1;
    $docs->{modifier} = 0.1;

    $self->getOverAvg($words);
    $self->getOverAvg($docs);

    return 1;
  }


1;


=head1 NAME

  AI::MicroStructure::Context

=head1 DESCRIPTION

  Context driven scoreing

=head1 SYNOPSIS

  ~$ micro new world

  ~$ micro structures

  ~$ micro any 2

  ~$ micro drop world

  ~$ micro

=head1 AUTHOR

  Hagen Geissler <santex@cpan.org>

=head1 COPYRIGHT AND LICENCE

  Hagen Geissler <santex@cpan.org>

=head1 SUPPORT AND DOCUMENTATION

 [sample using concepts](http://quantup.com)

 [PDF info on my works](https://github.com/santex)


=head1 SEE ALSO

  AI-MicroStructure

=cut
