package AI::MicroStructure::Context;
use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION);

require Carp;
require Symbol;
require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = ();

@EXPORT_OK = ();

%EXPORT_TAGS = (all => [@EXPORT_OK]);

$VERSION = "0.1";


##  bootstrap AI::MicroStructure::Context $VERSION;

my $Class = __PACKAGE__;    ##  This class's name
my $Table = $Class . '::';  ##  This class's symbol table

my $Count = 0;  ##  Counter for generating unique names for all locations
my $Alive = 1;  ##  Flag for disabling auto-dump during global destruction

  *print  = \&PRINT;        ##  Define public aliases for internal methods
  *printf = \&PRINTF;
  *read   = \&READLINE;

sub _usage_
{
    my($text) = @_;

    Carp::croak("Usage: $text");
}

sub tie
{

    my($location,$filehandle) = @_;

    &_usage_('$location->tie( [ "FH" | *FH | \*FH | *{FH} | \*{FH} | $fh ] );')
      if ((@_ != 2) || !ref($_[0]));

    $filehandle =~ s/^\*//;
    $filehandle = Symbol::qualify($filehandle, caller);
    no strict "refs";
    tie(*{$filehandle}, $Class, $location);
    use strict "refs";
}

1;

