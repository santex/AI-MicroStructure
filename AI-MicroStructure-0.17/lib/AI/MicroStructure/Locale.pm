package AI::MicroStructure::Locale;
use strict;
use warnings;
use AI::MicroStructure (); # do not export microname and friends
use AI::MicroStructure::MultiList;
use List::Util qw( shuffle );
use Carp;

our @ISA = qw( AI::MicroStructure::MultiList );

sub init {
    # alias the older package variable %Locale to %MultiList
    no strict 'refs';
    *{"$_[0]::Locale"}    = \%{"$_[0]::MultiList"};
    ${"$_[0]::Separator"} = '_';

    # call the parent class init code
    goto &AI::MicroStructure::MultiList::init;
}

sub new {
    my $class = shift;

    no strict 'refs';
    my $self = bless { @_, cache => [] }, $class;

    # compute some defaults
    if( ! exists $self->{category} ) {
        $self->{category} =
            exists $self->{lang}
            ? $self->{lang}
            : $ENV{LANGUAGE} || $ENV{LANG} || '';
        if( !$self->{category} && $^O eq 'MSWin32' ) {
            #eval { require Win32::Locale; };
            #$self->{category} = Win32::Locale::get_language() unless $@;
        }
    }

    my $cat = $self->{category};

    # support for territories
    if ( $cat && $cat ne ':all' ) {
        ($cat) = $cat =~ /^([-A-Za-z_]+)/;
        $cat = lc( $cat || '' );
        1 while $cat
            && !exists ${"$class\::MultiList"}{$cat}
            && $cat =~ s/_?[^_]*$//;
    }

    # fall back to last resort
    $self->{category} = $cat || ${"$class\::Default"};
    $self->_compute_base();
    return $self;
}

*lang      = \&AI::MicroStructure::MultiList::category;
*languages = \&AI::MicroStructure::MultiList::categories;

1;


=head1 NAME

  AI::MicroStructure::Locale

=head1 DESCRIPTION

  Gets Relations for Concepts based on  words

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

=cut
