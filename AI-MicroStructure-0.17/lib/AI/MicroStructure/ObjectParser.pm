
    package AI::MicroStructure::ObjectParser;
    use HTML::Parser;
    use HTML::Entities ();
    use URI::URL;

    use vars qw(@ISA);
    @ISA = qw(HTML::Parser);

    sub new {
      my $pack = shift;
      my $self = $pack->SUPER::new;
      @{$self}{qw(__base __out __within)} = @_;
      $self;
    }

    sub declaration {
      my $self = shift;
      my ($decl) = @_;
      $self->{__out}->print("<!$decl>");
    }

    sub start {
      my $self = shift;
      my ($tag, $attr, $attrseq, $origtext) = @_;
      my $out = $self->{__out};
      $out->print("<$tag");
      for (keys %$attr) {
        $out->print(" $_=\"");
        my $val = $attr->{$_};
        if ("$tag $_" =~ /^(a href|img src)$/) {
          $val = url($val)->abs($self->{__base},1);
          if ($self->{__within}->($val)) {
            $val = $val->rel($self->{__base});
          }
        }
        $out->print(HTML::Entities::encode($val, '<>&"'));
        $out->print('"');
      }
      $out->print(">");
    }

    sub end {
      my $self = shift;
      my ($tag) = @_;
      $self->{__out}->print("</$tag>");
    }

    sub text {
      my $self = shift;
      my ($text) = @_;
      $self->{__out}->print("$text");
    }

    sub comment {
      my $self = shift;
      my ($comment) = @_;
      $self->{__out}->print("<!-- $comment -->");
    }

1;





=head1 NAME

  AI::MicroStructure::ObjectParser

=head1 DESCRIPTION

  Html Parser

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
