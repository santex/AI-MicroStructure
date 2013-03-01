package mathworld;
use strict;
use warnings;
use Test::More;
use Data::Printer;

use feature "say";

BEGIN { use_ok("AI::MicroStructure::Utils::Mathworld"); }


my $url = "http://mathworld.wolfram.com";
my $file = "mathworld_index.html";


our @first_stage_expected = ();
our @second_stage_expected = ();

sub _init_test_data
{
    my $flag = 0;
    while (<mathworld::DATA>) {
        chomp;
        if (/^==(?:\w\s?)+==$/) {
            $flag++;
            next;
        }
        unless ( $flag ) {
            push @first_stage_expected, $_;
        }
        else { 
            push @second_stage_expected, $_;
        }
    }
}

_init_test_data();
@first_stage_expected = sort {$a cmp $b} @first_stage_expected;
@second_stage_expected = sort {$a cmp $b} @second_stage_expected;
%ignore = get_links($file);
my @got = sort {$a cmp $b} grep {/^\/topics/} keys %ignore;
is_deeply(\@got,
          \@first_stage_expected,
          qq/first stage done/);

$ignore{'/'} = 1;

my @aoh = ();
for my $topic ( @got ) {
    push @aoh, { get_links($topic) };
}
@got = ();
my %tmp = ();
for (@aoh) {
    %tmp = ( %tmp, myfilter($_) );
}
@got = sort {$a cmp $b} keys %tmp;
is($#got,
    $#second_stage_expected,
    qq/same length of expected array and compute array/);

is_deeply(\@got,
    \@second_stage_expected,
    qq/second stage done/);

# say $_  for (@all_links);
# for (@all_links) {
#     $_ = $url.$_; 
#     `wget --user-agent=Mozilla5/0 $_`;
# }

done_testing();

__DATA__
/topics/Algebra.html
/topics/AppliedMathematics.html
/topics/CalculusandAnalysis.html
/topics/DiscreteMathematics.html
/topics/FoundationsofMathematics.html
/topics/Geometry.html
/topics/HistoryandTerminology.html
/topics/NumberTheory.html
/topics/ProbabilityandStatistics.html
/topics/RecreationalMathematics.html
/topics/Topology.html
/topics/InteractiveEntries.html
==second stage==
/topics/AlgebraicCurves.html
/topics/FieldTheory.html
/topics/QuadraticForms.html
/topics/AlgebraicEquations.html
/topics/GeneralAlgebra.html
/topics/QuaternionsandCliffordAlgebras.html
/topics/AlgebraicGeometry.html
/topics/GroupTheory.html
/topics/RateProblems.html
/topics/AlgebraicIdentities.html
/topics/HomologicalAlgebra.html
/topics/RingTheory.html
/topics/AlgebraicInvariants.html
/topics/LinearAlgebra.html
/topics/ScalarAlgebra.html
/topics/AlgebraicOperations.html
/topics/NamedAlgebras.html
/topics/Sums.html
/topics/AlgebraicProperties.html
/topics/NoncommutativeAlgebra.html
/topics/ValuationTheory.html
/topics/VectorAlgebra.html
/topics/Cyclotomy.html
/topics/Wavelets.html
/topics/EllipticCurves.html
/topics/Products.html
/topics/Business.html
/topics/ComplexSystems.html
/topics/ControlTheory.html
/topics/DataVisualization.html
/topics/Engineering.html
/topics/ErgodicTheory.html
/topics/GameTheory.html
/topics/InverseProblems.html
/topics/NumericalMethods.html
/topics/Optimization.html
/topics/PopulationDynamics.html
/topics/SignalProcessing.html
/topics/Calculus.html
/topics/FunctionalAnalysis.html
/topics/MeasureTheory.html
/topics/CalculusofVariations.html
/topics/Functions.html
/topics/Norms.html
/topics/CatastropheTheory.html
/topics/GeneralAnalysis.html
/topics/OperatorTheory.html
/topics/ComplexAnalysis.html
/topics/GeneralizedFunctions.html
/topics/Polynomials.html
/topics/DifferentialEquations.html
/topics/HarmonicAnalysis.html
/topics/Roots.html
/topics/DifferentialForms.html
/topics/Inequalities.html
/topics/Series.html
/topics/IntegralTransforms.html
/topics/Singularities.html
/topics/DynamicalSystems.html
/topics/InversionFormulas.html
/topics/SpecialFunctions.html
/topics/FixedPoints.html
/topics/CellularAutomata.html
/topics/CodingTheory.html
/topics/Combinatorics.html
/topics/ComputationalSystems.html
/topics/ComputerScience.html
/topics/ExperimentalMathematics.html
/topics/FiniteGroups.html
/topics/GeneralDiscreteMathematics.html
/topics/GraphTheory.html
/topics/InformationTheory.html
/topics/PackingProblems.html
/topics/PointLattices.html
/topics/RecurrenceEquations.html
/topics/UmbralCalculus.html
/topics/Axioms.html
/topics/CategoryTheory.html
/topics/Logic.html
/topics/MathematicalProblems.html
/topics/Point-SetTopology.html
/topics/SetTheory.html
/topics/TheoremProving.html
/topics/PlaneGeometry.html
/topics/CombinatorialGeometry.html
/topics/GeneralGeometry.html
/topics/Points.html
/topics/ComputationalGeometry.html
/topics/GeometricConstruction.html
/topics/ProjectiveGeometry.html
/topics/ContinuityPrinciple.html
/topics/GeometricDuality.html
/topics/Rigidity.html
/topics/CoordinateGeometry.html
/topics/GeometricInequalities.html
/topics/SangakuProblems.html
/topics/Curves.html
/topics/InversiveGeometry.html
/topics/SolidGeometry.html
/topics/DifferentialGeometry.html
/topics/LineGeometry.html
/topics/Surfaces.html
/topics/MultidimensionalGeometry.html
/topics/Symmetry.html
/topics/Distance.html
/topics/NoncommutativeGeometry.html
/topics/Transformations.html
/topics/Non-EuclideanGeometry.html
/topics/Trigonometry.html
/topics/Biography.html
/topics/Contests.html
/topics/DisciplinaryTerminology.html
/topics/History.html
/topics/MathematicaCode.html
/topics/MathematicaCommands.html
/topics/Mnemonics.html
/topics/Notation.html
/topics/Prizes.html
/topics/Terminology.html
/topics/DivisionProblems.html
/topics/AlgebraicNumberTheory.html
/topics/p-adicNumbers.html
/topics/Arithmetic.html
/topics/GeneralNumberTheory.html
/topics/RationalApproximation.html
/topics/AutomorphicForms.html
/topics/GeneratingFunctions.html
/topics/RationalNumbers.html
/topics/BinarySequences.html
/topics/IntegerRelations.html
/topics/RealNumbers.html
/topics/ClassNumbers.html
/topics/Integers.html
/topics/ReciprocityTheorems.html
/topics/Congruences.html
/topics/IrrationalNumbers.html
/topics/Rounding.html
/topics/Constants.html
/topics/NormalNumbers.html
/topics/Sequences.html
/topics/ContinuedFractions.html
/topics/Numbers.html
/topics/SpecialNumbers.html
/topics/DiophantineEquations.html
/topics/NumberTheoreticFunctions.html
/topics/TranscendentalNumbers.html
/topics/Divisors.html
/topics/Parity.html
/topics/PrimeNumbers.html
/topics/BayesianAnalysis.html
/topics/NonparametricStatistics.html
/topics/StatisticalAsymptoticExpansions.html
/topics/DescriptiveStatistics.html
/topics/Probability.html
/topics/StatisticalDistributions.html
/topics/ErrorAnalysis.html
/topics/RandomNumbers.html
/topics/StatisticalIndices.html
/topics/Estimators.html
/topics/RandomWalks.html
/topics/StatisticalPlots.html
/topics/MarkovProcesses.html
/topics/RankStatistics.html
/topics/StatisticalTests.html
/topics/Moments.html
/topics/Regression.html
/topics/Time-SeriesAnalysis.html
/topics/MultivariateStatistics.html
/topics/Runs.html
/topics/Trials.html
/topics/Cryptograms.html
/topics/Dissection.html
/topics/Folding.html
/topics/Games.html
/topics/Illusions.html
/topics/MagicFigures.html
/topics/MathematicalArt.html
/topics/MathematicalHumor.html
/topics/MathematicalRecords.html
/topics/MathematicsintheArts.html
/topics/NumberGuessing.html
/topics/Numerology.html
/topics/Puzzles.html
/topics/Sports.html
/topics/AlgebraicTopology.html
/topics/Bundles.html
/topics/Cohomology.html
/topics/GeneralTopology.html
/topics/KnotTheory.html
/topics/Low-DimensionalTopology.html
/topics/Manifolds.html
/topics/Spaces.html
/topics/TopologicalInvariants.html
/topics/TopologicalOperations.html
/topics/TopologicalStructures.html
/topics/AnimatedGIFs.html
/topics/InteractiveDemonstrations.html
/topics/LiveGraphics3DApplets.html
/topics/webMathematicaExamples.html
