#!/usr/bin/perl -X
package AI::MicroStructure::List;
use strict;
use AI::MicroStructure (); # do not export microname and friends
use AI::MicroStructure::RemoteList;
use List::Util qw( shuffle );
use Carp;

our @ISA = qw( AI::MicroStructure::RemoteList );

sub init {
    my ($self, $data) = @_;
    my $class = caller(0);

    $data ||= AI::MicroStructure->load_data($class);
    croak "The optional argument to init() must be a hash reference"
      if ref $data ne 'HASH';

    no strict 'refs';
    no warnings;
    ${"$class\::structure"} = ( split /::/, $class )[-1];
    @{"$class\::List"} = split /\s+/, $data->{names};
    *{"$class\::import"} = sub {
        my $callpkg = caller(0);
        my $structure   = ${"$class\::structure"};
        my $micro    = $class->new();
        *{"$callpkg\::micro$structure"} = sub { $micro->name(@_) };
      };
    ${"$class\::micro"} = $class->new();
}

sub name {
    my ( $self, $count ) = @_;
    my $class = ref $self;

    if( ! $class ) { # called as a class method!
        $class = $self;
        no strict 'refs';
        $self = ${"$class\::micro"};
    }
  no strict 'refs';

    if( defined $count){
    if ($count == 0 ) {
        return
          wantarray ? shuffle @{"$class\::List"} : scalar @{"$class\::List"};
    }
    }
    $count ||= 1;
    my $list = $self->{cache};
    {
      no strict 'refs';
      if (@{"$class\::List"}) {
          push @$list, shuffle @{"$class\::List"} while @$list < $count;
      }
    }
    splice( @$list, 0, $count );
}

sub new {
    my $class = shift;

    bless { cache => [] }, $class;
}

sub structure {
    my $class = ref $_[0] || $_[0];
    no strict 'refs';
    return ${"$class\::structure"};
}




1;



=head1 NAME

  AI::MicroStructure::List

=head1 DESCRIPTION

  Gets Relations for Concepts based on  words

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

  ☞ [sample using concepts](http://quantup.com)

  ☞ [PDF info on my works](https://github.com/santex)


=head1 SEE ALSO

  AI-MicroStructure
  AI-MicroStructure-Cache
  AI-MicroStructure-Deamon
  AI-MicroStructure-Relations
  AI-MicroStructure-Concept
  AI-MicroStructure-Data
  AI-MicroStructure-Driver
  AI-MicroStructure-Plugin-Pdf
  AI-MicroStructure-Plugin-Twitter
  AI-MicroStructure-Plugin-Wiki

=cut

