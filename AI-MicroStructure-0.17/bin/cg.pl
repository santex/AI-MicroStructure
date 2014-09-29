      use Data::Printer;
      use Data::Dumper;
      use  AI::MicroStructure;
      use Search::ContextGraph;
      my $meta = AI::MicroStructure->new(  "ufo" );

      BEGIN{

          our $all = {dir =>shift,store =>shift};


      };



sub ret{
  my $dir = shift;

  #die() unless(-d $dir);

  my $cg = Search::ContextGraph->load_from_dir( $dir );



  return $cg;

}


sub store{

  my $file = shift;

  die() unless(-f $file);


  $cg->store( $file);



        my $cg = Search::ContextGraph->retrieve($file);

  return $cg;

}

ret($all->{dir});
store($all->{store});


    my ( @docs, $words ) =
      $cg->mixed_search(
        {docs=>[$cg->doc_list()],
         terms => ['genetic',
                   'dreaming',
                   'evolutionary']});

      p @{[@docs,[keys %$words]]};
