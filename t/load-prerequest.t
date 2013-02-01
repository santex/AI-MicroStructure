#!/usr/bin/perl

use strict;
use warnings;
use lib;
use Test::More tests => 1;
use Config;

BEGIN {



  use_ok( sprintf("basedep.'.$_.'.t") ) for(qw(dodo santex));


}





sub prereq_message {

    return "*** YOU MUST INSTALL $_[0] BEFORE PROCEEDING ***\n";
}

# If Parse::RecDescent or Inline::C aren't cleanly installed there's no point
# continuing the test suite.

BEGIN {




    my @themes = AI::MicroStructure->structures;






   use_ok( $_ ) or BAIL_OUT( prereq_message( $_) ) for (@t);
}

done_testing();
