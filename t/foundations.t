use strict;
use warnings;
use Test::More;
use Data::Printer;
use feature "say";

BEGIN { use_ok('AI::MicroStructure::Utils::Mathworld'); }

require 'mathworld.t';

mathworld::_init_test_data();
our @expected = qw(
/topics/Axioms.html
/topics/CategoryTheory.html
/topics/Logic.html
/topics/MathematicalProblems.html
/topics/Point-SetTopology.html
/topics/SetTheory.html
/topics/TheoremProving.html
);

our @exp_math_problems = qw(
/topics/PrizeProblems.html
/topics/Prizes.html
/topics/ProblemCollections.html
/topics/ProvedConjectures.html
/topics/RefutedConjectures.html
/topics/SolvedProblems.html
/topics/UnsolvedProblems.html
);

( my $elem ) = grep { /Foundations.*$/i } @mathworld::first_stage_expected;
my $_elem = $elem;
$elem =~ s#^/[^/]+/(.*)$#$1#; # get rid of first url part
ok( -f $elem, qq/element exists/ );
my %elem_links = get_links($elem);
%elem_links = myfilter( \%elem_links );
is_deeply([sort keys %elem_links],
          \@expected,
          qq/ right subset/);

( $elem ) = grep { /MathematicalProblems.*/ } keys %elem_links;
$elem =~ s#^/[^/]+/(.*)$#$1#; # get rid of first url part
ok( -f $elem, qq/element exists/ );
undef %elem_links;
%elem_links = get_links($elem);
%elem_links = myfilter(\%elem_links);
is_deeply([sort keys %elem_links],
          \@exp_math_problems,
          qq/right subset/);

 
# my $p = HTML::Parser->new(api_version => 3,
#                           start_h => [ \&my_start, "attr, self" ]);
# 
# $p->parse_file($elem);
# 
# sub my_start
# {
#     # return if shift ne 'td';
#     my $hash = shift;
#     p %{$hash};
#     my $self = shift;
#     # $self->handler(text => sub { say shift }, '');
#     # $self->handler(end => [ \&my_end, "text" ]);
# }
# 
# sub my_end
# {
#     my($self, $tag, $origintext) = @_;
#     p $origintext;
# }
# 


done_testing();
