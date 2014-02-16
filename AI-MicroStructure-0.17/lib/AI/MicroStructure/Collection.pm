package  AI::MicroStructure::Collection;
use Data::Dumper;
use strict;


sub new {

  my($class,$args) = @_;

  my $self = bless { cache => [] }, $class;

  $self->import;
  $self->connectDriver;


  return $self;
}



sub reduction_function {
  my ($self,$term,$N,$allFeaturesSum,
      $coll_features,$cat_features,$cat_features_sum) = @_;
  my $CHI2SUM = 0;
  my $nbcats = 0;
  foreach my $catname (keys %{$cat_features}) {
#  while ( my ($catname,$catfeatures) = each %{$cat_features}) {
    my ($A,$B,$C,$D); # A = number of times where t and c co-occur
                      # B =   "     "   "   t occurs without c
                      # C =   "     "   "   c occurs without t
                      # D =   "     "   "   neither c nor t occur
    $A = $cat_features->{$catname}->value($term);
    $B = $coll_features->value($term) - $A;
    $C = $cat_features_sum->{$catname} - $A;
    $D = $allFeaturesSum - ($A+$B+$C);
    my $ADminCB = ($A*$D)-($C*$B);
    my $CHI2 = $N*$ADminCB*$ADminCB / (($A+$C)*($B+$D)*($A+$B)*($C+$D));
    $CHI2SUM += $CHI2;
    $nbcats++;
  }
  return $CHI2SUM/$nbcats;
}


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
    #warn "types are ", @_;
    $self->{ $element->name } = $element;
  }
}

sub retrieve { $_[0]->{$_[1]} }

sub includes { exists $_[0]->{ $_[1]->name } }
sub includes_name  { exists $_[0]->{ $_[1] } }


sub parse {
  my ($self, %args) = @_;


my %_operations = (
       '&' => {
           min     => sub { (sort {$a <=> $b} @_)[0] },
           product => sub { my $p = 1; $p *= $_ for @_; $p },
           default => 'min',
       },
       '|'  => {
           max     => sub { (sort {$a <=> $b} @_)[-1] },
           sum     => sub { my $s = 0; $s += $_ for @_; $s > 1 ? 1 : $s },
           default => 'max',
       },
       '!' => {
           complement => sub { 1 - $_[0] },
           custom  => sub {},
           default    => 'complement',
       },
       );


  $args{content} =~ s{
       ^(?:\.I)?\s+(\d+)\n  # ID number - becomes document name
       \.C\n
       ([^\n]+)\n     # Categories
       \.T\n
       (.+)\n+        # Title
       \.W\n
      }
                  {}sx

     or warn "Malformed record: $args{content}";

  my ($id, $categories, $title) = ($1, $2, $3);

  $self->{name} = $id;
  $self->{content} = { title => $title,
           body  => $args{content} };

  my @categories = $categories =~ m/(.*?)\s+\d+[\s;]*/g;
  @categories = map AI::Categorizer::Category->by_name(name => $_), @categories;
  $self->{categories} = \@categories;
}

1;


1;


=head1 NAME

 AI::MicroStructure::Collection

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
