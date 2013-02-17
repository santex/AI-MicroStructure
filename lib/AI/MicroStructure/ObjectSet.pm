#!/usr/bin/perl -W
  package AI::MicroStructure::ObjectSet;
  use strict;

  sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;
    $self->insert(@_) if @_;
    return $self;
  }

  sub members {
    return values %{$_[0]};
  }

  sub size {
    return scalar keys %{$_[0]};
  }

  sub insert {
    my $self = shift;
    foreach my $element (@_) {

      $self->{ $element->name } = $element;
    }

    return 1;
  }

  sub retrieve { $_[0]->{$_[1]} }
  sub includes { exists $_[0]->{ $_[1]->name } }
  sub includes_name  { exists $_[0]->{ $_[1] } }

  1;


=head1 NAME

  AI::MicroStructure::ObjectSet

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
