package AI::MicroStructure::Alias;
use strict;
use warnings;
use Carp;

sub init {
    my ( $self, $alias ) = @_;
    my $class = caller(0);

    eval "require AI::MicroStructure::$alias;";
    croak "Aliased structure AI::MicroStructure::$alias failed to load: $@"
        if $@;

    no strict 'refs';
    no warnings;

    # copy almost everything over from the original
    for my $k ( grep { ! /^(?:structure|micro|import)$/ }
        keys %{"AI::MicroStructure::$alias\::"} )
    {
        *{"$class\::$k"} = *{"AI::MicroStructure::$alias\::$k"};
    }

    # local things
    ${"$class\::structure"} = ( split /::/, $class )[-1];
    ${"$class\::micro"}  = $class->new();
    *{"$class\::import"} = sub {
        my $callpkg = caller(0);
        my $structure   = ${"$class\::structure"};
        my $micro    = $class->new();
        *{"$callpkg\::micro$structure"} = sub { $micro->name(@_) };
      };
}

1;

__END__
