#!/usr/bin/perl -w


use strict;
use Test;
BEGIN {
  require "00load.t";
  need_module('AI::MicroStructure');
  plan tests => 1 + num_standard_tests();
}

ok(1);

#########################

perform_standard_tests(learner_class => 'AI::Categorizer::Learner::DecisionTree');
