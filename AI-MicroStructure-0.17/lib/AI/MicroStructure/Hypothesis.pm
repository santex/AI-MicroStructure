package AI::MicroStructure::Hypothesis;
use base("AI::Categorizer::Hypothesis");
use Class::Container;
use Params::Validate qw(:types);




__PACKAGE__->valid_params
 (
   all_categories => {type => ARRAYREF},
   scores => {type => HASHREF},
   threshold => {type => SCALAR},
   document_name => {type => SCALAR, optional => 1},
 );




sub all_categories { @{$_[0]->{all_categories}} }
sub document_name  { $_[0]->{document_name} }
sub threshold      { $_[0]->{threshold} }

sub new {}
sub best_category {
  my ($self) = @_;
  my $sc = $self->{scores};
  return unless %$sc;

  my ($best_cat, $best_score) = each %$sc;
  while (my ($key, $val) = each %$sc) {
    ($best_cat, $best_score) = ($key, $val) if $val > $best_score;
  }
  return $best_cat;
}

sub in_category {
  my ($self, $cat) = @_;
  return '' unless exists $self->{scores}{$cat};
  return $self->{scores}{$cat} > $self->{threshold};
}

sub categories {
  my $self = shift;
  return @{$self->{cats}} if $self->{cats};
  $self->{cats} = [sort {$self->{scores}{$b} <=> $self->{scores}{$a}}
                   grep {$self->{scores}{$_} >= $self->{threshold}}
                   keys %{$self->{scores}}];
  return @{$self->{cats}};
}

sub scores {
  my $self = shift;
  return @{$self->{scores}}{@_};
}

1;
 # Hypotheses are usually created by the Learner's categorize() method.
 # (assume here that $learner and $document have been created elsewhere)

__END__


=head1 NAME
=head1 DESCRIPTION
=head1 CONTRIBUTOR
=over 4
=back
=head1 DEDICATION
=head1 SEE ALSO
=head1 AUTHOR
=head1 COPYRIGHT
=cut
