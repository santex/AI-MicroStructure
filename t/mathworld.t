use strict;
use warnings;
use Test::More;
use Data::Printer;

use feature "say";

BEGIN { use_ok("AI::MicroStructure::Utils::Mathworld"); }


my $url = "http://mathworld.wolfram.com/";
my $file = "mathworld_index.html";


our @first_stage_expected = ();
our @second_stage_expected = ();

sub _init_test_data
{
    my $flag = 0;
    while (<DATA>) {
        chomp;
        if (/^==(?:\w\s?)+==$/) {
            $flag++;
            next;
        }
        unless ( $flag ){
            push @first_stage_expected, $_;
        }
        else {
            push @second_stage_expected, $_;
        }
    }
}

_init_test_data();
my @links = get_topics($file,());
is_deeply(\@links,
          \@first_stage_expected,
          qq/first stage done/);

my @all_links = ();
for (@links) {
    push @all_links, get_topics($_,@links);
}

is_deeply(\@all_links,
          \@second_stage_expected,
          qq/second stage done/);

# 
# p @all_links;
# `wget --user-agent=Mozilla5/0 $_` for (@links);

done_testing();

__DATA__
Algebra.html
AppliedMathematics.html
CalculusandAnalysis.html
DiscreteMathematics.html
FoundationsofMathematics.html
Geometry.html
HistoryandTerminology.html
NumberTheory.html
ProbabilityandStatistics.html
RecreationalMathematics.html
Topology.html
InteractiveEntries.html
==second stage==
AlgebraicCurves.html
FieldTheory.html
QuadraticForms.html
AlgebraicEquations.html
GeneralAlgebra.html
QuaternionsandCliffordAlgebras.html
AlgebraicGeometry.html
GroupTheory.html
RateProblems.html
AlgebraicIdentities.html
HomologicalAlgebra.html
RingTheory.html
AlgebraicInvariants.html
LinearAlgebra.html
ScalarAlgebra.html
AlgebraicOperations.html
NamedAlgebras.html
Sums.html
AlgebraicProperties.html
NoncommutativeAlgebra.html
ValuationTheory.html
CodingTheory.html
NumberTheory.html
VectorAlgebra.html
Cyclotomy.html
Polynomials.html
Wavelets.html
EllipticCurves.html
Products.html
Business.html
ComplexSystems.html
ControlTheory.html
DataVisualization.html
DynamicalSystems.html
Engineering.html
ErgodicTheory.html
GameTheory.html
InformationTheory.html
InverseProblems.html
NumericalMethods.html
Optimization.html
PopulationDynamics.html
SignalProcessing.html
Calculus.html
FunctionalAnalysis.html
MeasureTheory.html
CalculusofVariations.html
Functions.html
Norms.html
CatastropheTheory.html
GeneralAnalysis.html
OperatorTheory.html
ComplexAnalysis.html
GeneralizedFunctions.html
Polynomials.html
DifferentialEquations.html
HarmonicAnalysis.html
Roots.html
DifferentialForms.html
Inequalities.html
Series.html
DifferentialGeometry.html
IntegralTransforms.html
Singularities.html
DynamicalSystems.html
InversionFormulas.html
SpecialFunctions.html
FixedPoints.html
Manifolds.html
CellularAutomata.html
CodingTheory.html
Combinatorics.html
ComputationalSystems.html
ComputerScience.html
DivisionProblems.html
ExperimentalMathematics.html
FiniteGroups.html
GeneralDiscreteMathematics.html
GraphTheory.html
InformationTheory.html
PackingProblems.html
PointLattices.html
RecurrenceEquations.html
UmbralCalculus.html
Axioms.html
CategoryTheory.html
Logic.html
MathematicalProblems.html
Point-SetTopology.html
SetTheory.html
TheoremProving.html
AlgebraicGeometry.html
ErgodicTheory.html
PlaneGeometry.html
CombinatorialGeometry.html
GeneralGeometry.html
Points.html
ComputationalGeometry.html
GeometricConstruction.html
ProjectiveGeometry.html
ContinuityPrinciple.html
GeometricDuality.html
Rigidity.html
CoordinateGeometry.html
GeometricInequalities.html
SangakuProblems.html
Curves.html
InversiveGeometry.html
SolidGeometry.html
DifferentialGeometry.html
LineGeometry.html
Surfaces.html
Dissection.html
MultidimensionalGeometry.html
Symmetry.html
Distance.html
NoncommutativeGeometry.html
Transformations.html
DivisionProblems.html
Non-EuclideanGeometry.html
Trigonometry.html
Biography.html
Contests.html
DisciplinaryTerminology.html
History.html
MathematicaCode.html
MathematicaCommands.html
MathematicalProblems.html
Mnemonics.html
Notation.html
Prizes.html
Terminology.html
AlgebraicNumberTheory.html
ErgodicTheory.html
p-adicNumbers.html
Arithmetic.html
GeneralNumberTheory.html
RationalApproximation.html
AutomorphicForms.html
GeneratingFunctions.html
RationalNumbers.html
BinarySequences.html
IntegerRelations.html
RealNumbers.html
ClassNumbers.html
Integers.html
ReciprocityTheorems.html
Congruences.html
IrrationalNumbers.html
Rounding.html
Constants.html
NormalNumbers.html
Sequences.html
ContinuedFractions.html
Numbers.html
SpecialNumbers.html
DiophantineEquations.html
NumberTheoreticFunctions.html
TranscendentalNumbers.html
Divisors.html
Parity.html
EllipticCurves.html
PrimeNumbers.html
BayesianAnalysis.html
NonparametricStatistics.html
StatisticalAsymptoticExpansions.html
DescriptiveStatistics.html
Probability.html
StatisticalDistributions.html
ErrorAnalysis.html
RandomNumbers.html
StatisticalIndices.html
Estimators.html
RandomWalks.html
StatisticalPlots.html
MarkovProcesses.html
RankStatistics.html
StatisticalTests.html
Moments.html
Regression.html
Time-SeriesAnalysis.html
MultivariateStatistics.html
Runs.html
Trials.html
Cryptograms.html
Dissection.html
Folding.html
Games.html
Illusions.html
MagicFigures.html
MathematicalArt.html
MathematicalHumor.html
MathematicalRecords.html
MathematicsintheArts.html
NumberGuessing.html
Numerology.html
Puzzles.html
Sports.html
AlgebraicTopology.html
Bundles.html
Cohomology.html
GeneralTopology.html
KnotTheory.html
Low-DimensionalTopology.html
Manifolds.html
Point-SetTopology.html
Spaces.html
TopologicalInvariants.html
TopologicalOperations.html
TopologicalStructures.html
AnimatedGIFs.html
InteractiveDemonstrations.html
LiveGraphics3DApplets.html
webMathematicaExamples.html
