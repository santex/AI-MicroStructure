package AI::MicroStructure::Object;
use strict;
use Digest::MD5 qw(md5_hex);
use AnyEvent::Subprocess::Easy qw(qx_nonblock);

sub new {
  my $pkg = shift;
  my $self = bless {}, $pkg;
  $self->{id} = md5_hex(@_);
  $self->{name} = lc shift @_;
  $self->{ elems } = {};


  foreach my $element (sort grep{/^$self->{name}/}split(/$self->{name},|\n/,`wn $self->{name} -hypon -hypen -synsv -synsn -grepn -grepa -grepv`)) {
    $element =~ s/\n//g;
    $element =~ s/([\\\'\"])/\\$1/gi;
    $element =~ s/^\s+//;
    $element =~ s/\s+$//;
    $element =~ s/\t//;
    $element =~ s/^\s//;
    $self->{ elems }->{$element} = 1;#`wn '$element' -grepn | egrep -v "Grep" | tr  "\n" "@"`;
  }

  return $self;
}

sub name {

    my $self = shift;
    return $self->{name};
}
1;


=head1 NAME

  AI::MicroStructure::Object

=head1 DESCRIPTION

  Stack of ObjectContainers

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

 [sample using concepts](http://quantup.com)

 [PDF info on my works](https://github.com/santex)


=head1 SEE ALSO

  AI-MicroStructure

=cut
