#!/usr/bin/perl -w

 my $TOP = "/home/santex/data-hub/book";

BEGIN {

  package AI::MicroStructure::Object;
  use strict;
  use warnings;
  use Digest::MD5 qw(md5_hex);
  sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;
    $self->{name} = md5_hex(@_);
    foreach my $element (@_) {

      $self->{ $element } = $element;
    }
    return $self;
  }
  sub name {

      my $self = shift;
      return $self->{name};
  }
  1;

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
  #    warn "types are ", @_;
      $self->{ $element->name } = $element;
    }
  }

  sub retrieve { $_[0]->{$_[1]} }
  sub includes { exists $_[0]->{ $_[1]->name } }
  sub includes_name  { exists $_[0]->{ $_[1] } }

  1;


    package MyParser;
    use HTML::Parser;
    use HTML::Entities ();
    use URI::URL;

    use vars qw(@ISA);
    @ISA = qw(HTML::Parser);

    sub new {
      my $pack = shift;
      my $self = $pack->SUPER::new;
      @{$self}{qw(__base __out __within)} = @_;
      $self;
    }

    sub declaration {
      my $self = shift;
      my ($decl) = @_;
      $self->{__out}->print("<!$decl>");
    }

    sub start {
      my $self = shift;
      my ($tag, $attr, $attrseq, $origtext) = @_;
      my $out = $self->{__out};
      $out->print("<$tag");
      for (keys %$attr) {
        $out->print(" $_=\"");
        my $val = $attr->{$_};
        if ("$tag $_" =~ /^(a href|img src)$/) {
          $val = url($val)->abs($self->{__base},1);
          if ($self->{__within}->($val)) {
            $val = $val->rel($self->{__base});
          }
        }
        $out->print(HTML::Entities::encode($val, '<>&"'));
        $out->print('"');
      }
      $out->print(">");
    }

    sub end {
      my $self = shift;
      my ($tag) = @_;
      $self->{__out}->print("</$tag>");
    }

    sub text {
      my $self = shift;
      my ($text) = @_;
      $self->{__out}->print("$text");
    }

    sub comment {
      my $self = shift;
      my ($comment) = @_;
      $self->{__out}->print("<!-- $comment -->");
    }

  }

1;


package main;

$|++;
use strict;

use File::Find;
use Data::Dumper;
use Storable qw(lock_store lock_retrieve);
use Getopt::Long;
our $curSysDate = `date +"%F"`;
    $curSysDate=~ s/\n//g;

our %opts = (cache_file =>
              sprintf("/tmp/%s.cache",
              $curSysDate));

GetOptions (\%opts, "cache_file=s");

our $cache = {};
our @target = split("\/",$opts{cache_file});
my $set = AI::MicroStructure::ObjectSet->new();

eval {
    local $^W = 0;  # because otherwhise doesn't pass errors
#`rm $opts{cache_file}`;
    $cache = lock_retrieve($opts{cache_file});

    $cache = {} unless $cache;

    warn "New cache!\n" unless defined $cache;
};


END{

  lock_store($cache,$opts{cache_file});

  print Dumper [$set->size,$set->members];


  }




find(\&translate, "$TOP/./");

sub translate {
  return unless -f;
  (my $rel_name = $File::Find::name) =~ s{.*/}{}xs;

  $set->insert(AI::MicroStructure::Object->new($rel_name));

}





__END__
