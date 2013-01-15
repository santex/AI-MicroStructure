
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "AI::MicroStructure   Creates Concepts for words",
  "AUTHOR" => "santex <santex\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "AI-MicroStructure",
  "EXE_FILES" => [
    "bin/micro-wiki",
    "bin/micro-deamon",
    "bin/micro",
    "bin/micrownet",
    "bin/micro-ontology",
    "bin/micro-sense",
    "bin/micro-wnet"
  ],
  "LICENSE" => "perl",
  "NAME" => "AI::MicroStructure",
  "PREREQ_PM" => {
    "AnyDBM_File" => 0,
    "AnyEvent::Subprocess::Easy" => 0,
    "Carp" => 0,
    "Data::Dumper" => 0,
    "Data::Format::Pretty::Console" => 0,
    "Data::Printer" => 0,
    "Digest::MD5" => 0,
    "Fcntl" => 0,
    "File::Basename" => 0,
    "File::Glob" => 0,
    "File::Spec" => 0,
    "Getopt::Long" => 0,
    "HTML::Strip" => 0,
    "IO::Page" => 0,
    "JSON" => 0,
    "JSON::XS" => 0,
    "List::Util" => 0,
    "Statistics::Basic" => 0,
    "Storable" => 0,
    "Storable::CouchDB" => 0,
    "Term::ReadKey" => 0,
    "URI::Escape" => 0,
    "WWW::Wikipedia" => 0,
    "strict" => 0,
    "utf8" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.009",
  "test" => {
    "TESTS" => ""
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



