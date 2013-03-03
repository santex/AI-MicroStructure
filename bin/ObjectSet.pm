package AI::MicroStructure::Object;
use strict;
use Digest::MD5 qw(md5_hex);
use AnyEvent::Subprocess::Easy qw(qx_nonblock);

sub new {
  my $pkg = shift;
  my $self = bless {}, $pkg;
  $self->{id} = md5_hex(@_);
  $self->{name} = lc shift @_;
  $self->{ elems } = {};


  foreach my $element (sort grep{/^$self->{name}/}split(/$self->{name},|\n/,`wn $self->{name} -hypon -hypen -synsv -synsn -grepn -grepa -grepv`)) {
    $element =~ s/\n//g;
    $element =~ s/([\\\'\"])/\\$1/gi;
    $element =~ s/^\s+//;
    $element =~ s/\s+$//;
    $element =~ s/\t//;
    $element =~ s/^\s//;
    $self->{ elems }->{$element} = 1;#`wn '$element' -grepn | egrep -v "Grep" | tr  "\n" "@"`;
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
  return scalar keys %{$_};
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

package main;
use Data::Dumper;
use Data::Printer;
use AI::MicroStructure;
use AI::MicroStructure::any;
our $micro = AI::MicroStructure->new();
our @t = $micro->structures;

my $set = AI::MicroStructure::ObjectSet->new();


foreach(@t){
my $ob = AI::MicroStructure::Object->new($_);

   $set->insert($ob) ;

   p $ob;
}

p $set;
