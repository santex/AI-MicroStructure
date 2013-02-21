  #!/usr/bin/perl -w



  use strict;
  use Test::More 'no_plan';#tests =>12;
  use Data::Dumper;
  use Data::Printer;
  use AI::MicroStructure;
  use AI::MicroStructure::Context;
  use Search::ContextGraph;
  use Env qw(PWD);


  our $c = AI::MicroStructure::Context->new(@ARGV);
     $c->retrieveIndex(sprintf("%s/t/canned/docs",$PWD));#"home/santex/data-hub/data-hub" structures=0 text=1 json=1
#      $c->retrieveIndex("/tmp/test");



     my $style = {};
        $style->{explicit}  = 0;
  printf("\ndoing %s\n\n",$_) && ok($c->simpleMixedSearch($style,$_)) && ok($c->play($style,$_))   for
   qw(point vector);


  $style->{explicit}  = 1;

  foreach my $aret (qw(point vector polar symbol)){
  print Dumper $c->intersect($style,$aret);
  # for
   #qw(tan log number mathematics exponent exponential quad);
  }
  #$style->{explicit}  = 1;
#  printf("\ndoing %s\n\n",$_) && ok(print Dumper $c->similar($style,$_)) for
 #  qw(point vector polar symbol);

  #p @out;

  1;

