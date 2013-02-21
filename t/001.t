use strict;
use Test::More;


BEGIN{
use Test::More tests => 4;
use_ok('AI::MicroStructure');
use_ok('AI::MicroStructure::Object');
use_ok('AI::MicroStructure::ObjectSet');
use_ok('AI::MicroStructure::Context'); };


1;
__DATA__

 |-- Categorizer.pm
|   |   |-- Collection.pm
|   |   |-- Context.pm
|   |   |-- Fitnes.pm
|   |   |-- Hypothesis.pm
|   |   |-- List.pm
|   |   |-- Locale.pm
|   |   |-- Memorizer.pm
|   |   |-- MultiList.pm
|   |   |-- Object.pm
|   |   |-- ObjectParser.pm
|   |   |-- ObjectSet.pm
|   |   |-- Relations.pm
|   |   |-- Remember.pm
|   |   |-- RemoteList.pm
