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

    return $self;
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
