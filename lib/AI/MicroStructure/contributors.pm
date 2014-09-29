=encoding iso-8859-1

=head1 NAME

AI::MicroStructure::contributors - Acme::MetaSyntactic contributors

=head1 DESCRIPTION

The following people contributed to AI::MicroStructure,
either by proposing structure ideas, updating existing themes,
sending bug reports, running the test suite on their machine
and sending me the report or sending complete lists of items
for new or existing structures. Thanks for all the work I didn't
have to do!

They are listed below in chronological order (of when I actually
used their contributions):

=cut

package AI::MicroStructure::contributors;
use strict;
use AI::MicroStructure::List;
our @ISA = qw( AI::MicroStructure::List );
our $VERSION = '1.001';

{
    my %seen;
    __PACKAGE__->init(
        {   names => join ' ',
            grep    { !$seen{$_}++ }
                map { s/_+/_/g; $_ }
                map { AI::MicroStructure::RemoteList::tr_nonword($_) }
                map { AI::MicroStructure::RemoteList::tr_accent($_) }
                map { /^=item (.*)/ ? $1 : () }
                split /\n/ => <<'=cut'} );

=pod

=over 4

=item Vahe Sarkissian

=item David Landgren

=item Sébastien Aperghis-Tramoni

=item Mike Castle

=item anonymous

=item Scott Lanning

=item Michel Rodriguez

=item Rafael Garcia-Suarez

=item Aldo Calpini

=item Jérôme Fenal

=item Ricardo Signes

=item Hakim Cassimally

=item Max Maischein

=item Offer Kaye

=item Cédric Bouvier

=item Jean Forget

=item Guy Widloecher

=item Xavier Caron

=item Paul-Christophe Varoutas

=item Gábor Szabó

=item Mark Fowler

=item Miss Barbie

=item Martin Vorländer

=item Alberto Manuel Brandão Simões

=item Nicholas Clark

=item Gaal Yahas

=item Estelle Souche

=item Abigail

=item Antoine Hulin

=item Michael Scherer

=item Jan Pieter Cornet

=item Flavio Poletti

=item Leon Brocard

=item Anja Krebber

=item Yanick Champoux

=item Gisbert W. Selke

=item José Castro

=item David Golden

=item Matthew Musgrove

=item David H. Adler

=item Éric Cholet

=item Elliot Shank

=item Simon Myers

=item Olivier Mengué

=back

=cut

}

1;

__END__

=pod

Thank you all for making AI::MicroStructure such a successful module!

=head1 CONTRIBUTOR

Philippe Bruhat.

Introduced in Acme-MetaSyntactic version 1.000, published on May 7, 2012.

=head1 SEE ALSO

L<AI::MicroStructure>, L<Acme::MetaSyntactic::List>.

=cut

