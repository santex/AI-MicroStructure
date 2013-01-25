package AI::MicroStructure::util;

use strict;
use Cwd;
use Config::Auto;

sub get_cwd {
    my @CWD; if (!-e ".micro") {
        push @CWD, $ENV{HOME};
    } else {
        push @CWD, getcwd();
    }
    return @CWD;
}

sub load_config {

    my @CWD = AI::MicroStructure::util::get_cwd();
    my $config = Config::Auto::parse(".micro", path => @CWD);
    if($config->{default}) {
        shift @CWD;
        push @CWD, $config->{default};
    }
    return @CWD;
    return $config;

}

sub config {
    my (@CWD, $config) = AI::MicroStructure::util::load_config();

    $config->{couchdb}    ||= "http://user::pass\@localhost:5984/";
    $config->{conceptimg} ||= "http://localhost/tiny/concept2.php";
    $config->{wikipedia}  ||= "http://en.wikipedia.org/wiki/";
    $config->{db} ||= "micro-relations";

    return @CWD;
    return $config;
}

1;
