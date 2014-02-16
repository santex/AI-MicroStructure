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

=head1 NAME

  AI::MicroStructure::any

=head1 DESCRIPTION

  Creates Concepts for words

=head1 SYNOPSIS

  ~$ micro new world

  ~$ micro structures

  ~$ micro any 2

  ~$ micro drop world

  ~$ micro

=head1 AUTHOR

  Hagen Geissler <santex@cpan.org>

=head1 COPYRIGHT AND LICENCE

  Hagen Geissler <santex@cpan.org>

=head1 SUPPORT AND DOCUMENTATION

  ☞ [sample using concepts](http://quantup.com)

  ☞ [PDF info on my works](https://github.com/santex)


=head1 SEE ALSO

  AI-MicroStructure
  AI-MicroStructure-Cache
  AI-MicroStructure-Deamon
  AI-MicroStructure-Relations
  AI-MicroStructure-Concept
  AI-MicroStructure-Data
  AI-MicroStructure-Driver
  AI-MicroStructure-Plugin-Pdf
  AI-MicroStructure-Plugin-Twitter
  AI-MicroStructure-Plugin-Wiki


__END__

__DATA__

