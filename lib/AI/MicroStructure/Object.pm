#!/usr/bin/perl -w


  package AI::MicroStructure::Object;

  use strict;
  use warnings;
  use Digest::MD5 qw(md5_hex);
  sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;

    $self->{name} = sprintf(@_);
    $self->{md5} = md5_hex(@_);
    $self->{soundex} = $self->soundex(@_);


    foreach my $element (@_) {
  #    warn "types are ", @_;
      $self->{ $element }->{name} = $element;
      $self->{ $element }->{md5} = md5_hex($element );
      $self->{ $element }->{soundex} = $self->soundex($element);

    }
    return $self;
  }

  sub soundex
  {
      my $self = shift;

      my ( @res ) = @_;
      my ($i, $t, $_);
      for ( @res ) { tr/a-zA-Z//cd; tr/a-zA-Z/A-ZA-Z/s;
          ($i,$t) = /(.)(.*)/;
         $t =~ tr/BFPVCGJKQSXZDTLMNRAEHIOUWY/111122222222334556/sd;
         $_ = substr(($i||'Z').$t.'000', 0, 4 );
      }
      wantarray ? @res : $res[0];
  }

  sub name {

      my $self = shift;
      return $self->{name};
  }
  1;


=head1 NAME

  AI::MicroStructure::Object

=head1 DESCRIPTION

  Stack of ObjectContainers

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
