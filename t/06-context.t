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
      $c->retrieveIndex($PWD."/t/docs"); #"/home/santex/data-hub/data-hub" structures=0 text=1 json=1



     my $style = {};
        $style->{explicit}  = 0;
  printf("\ndoing %s\n\n",$_) && ok($c->simpleMixedSearch($style,$_)) && ok($c->play($style,$_))   for
   qw(ion planet matter atom tan log algebra mathematics );


  $style->{explicit}  = 1;

  foreach my $aret (qw(planet matter antimatter)){
  printf("\ndoing %s\n\n",$aret) && ok(print Dumper $c->intersect($style,$aret));
  # for
   #qw(tan log number mathematics exponent exponential quad);
  }
  #printf("\ndoing %s\n\n",$_) && ok(print Dumper $c->similar($style,$_)) for
  # qw(Algebra Tan Log);

  #p @out;

  1;

