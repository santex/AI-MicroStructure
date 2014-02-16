package AI::MicroStructure::any;
use strict;
use List::Util 'shuffle';
use AI::MicroStructure;
use AI::MicroStructure::List;

our $structure = 'any';

sub import {
    # export the microany function
    my $callpkg = caller;
    my $micro    = AI::MicroStructure->new();
    no strict 'refs';
    *{"$callpkg\::microany"} = sub { $micro->name( @_ ) };
}

sub name {
    my $self  = shift;
    my $structure =
      ( shuffle( grep { !/^(any|random)$/ } AI::MicroStructure->structures() ) )[0];
    
    if($structure && $structure !~ /any/){
      $self->{micro}->name( $structure, @_ );
    
    }
    
}

sub new {
    my $class = shift;

    # we need a full AI::MicroStructure object, to support AMS::Locale
    return bless { micro => AI::MicroStructure->new( @_ ) }, $class;
}

sub structure { $structure };

sub has_remotelist { };

1;


