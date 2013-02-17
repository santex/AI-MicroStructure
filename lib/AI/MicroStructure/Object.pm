#!/usr/bin/perl -w


  package AI::MicroStructure::Object;

  use strict;
  use warnings;
  use Digest::MD5 qw(md5_hex);
  sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;
    $self->{name} = md5_hex(@_);
    foreach my $element (@_) {
  #    warn "types are ", @_;
      $self->{ $element } = $element;
    }
    return $self;
  }
  sub name {

      my $self = shift;
      return $self->{name};
  }
  1;

