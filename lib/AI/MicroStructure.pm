#!/usr/bin/perl 
package AI::MicroStructure;
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Digest::SHA1  qw(sha1 sha1_hex sha1_base64);
use File::Basename;
use File::Spec;
use File::Glob;
use Data::Dumper;
use AI::MicroStructure::Util;
use Carp qw(croak);

our $absstructdir = "";
our $structdir = "";
our @CWD=();
our $VERSION = '0.015';
our $Structure = 'any'; # default structure
our $CODESET = 'utf8';
our $LANG = '';
our %MICRO;
our %MODS;
our %ALIEN;
our $str = "[A-Z]";
our $special = "any";
our $search;
our $data={};
our $item="";
our @items;
our @a=();


our ($init,$new,$drop,$available,$lib,
     $list,$use,$off,$switch,$mirror,
     $version,$help,$write)  = (0,0,0,0,0,0,0,0,0,0,0,0,0);

eval "\$$_=1; " for @ARGV;



if( grep{/\bnew\b/} @ARGV ){ $new = 1; cleanArgs("new"); }
if( grep{/\bwrite\b/} @ARGV ){ $write = 1; cleanArgs("write");  };
if( grep{/\bdrop\b/} @ARGV ){ $drop = 1; cleanArgs("drop");  };

our $StructureName = $ARGV[0]; # default structure
our $structure = $ARGV[0]; # default structure




our $micro = AI::MicroStructure->new($Structure);
$absstructdir = $micro->{state}->{path}->{"cwd/structures"};


push @CWD,$absstructdir;
#push @CWD,$_ for @INC;



$MICRO{$_} = 0 for keys %{{__PACKAGE__->find_structures(@CWD)} };
$MODS{$_} = $_ for keys %{{__PACKAGE__->find_modules(@INC)} };
$search = join("|",keys %MICRO);

#if( grep{/$search/} @ARGV ){ $Structure = $ARGV[0] unless(!$ARGV[0]); }

# fetch the list of standard structures

#print Dumper keys %MICRO;





sub cleanArgs{
    my ($key) = @_;
    my @tmp=();
    foreach(@ARGV){
    push @tmp,$_ unless($_=~/$key/);}

    @ARGV=@tmp;
}


# private class method
sub find_structures {
   my ( $class, @dirs ) = @_;


   $ALIEN{"base"} =  [map  @$_,
   map  { [ ( fileparse( $_, qr/\.pm$/ ) )[0] => $_ ] }
   map  { File::Glob::bsd_glob(


   File::Spec->catfile( $_, "*.pm" ) ) } @dirs];

   $ALIEN{"store"}=[];



   return @{$ALIEN{"base"}};
}

# fetch the list of standard structures


sub find_modules {


 my $structures = {};
   foreach(@INC)
   {

   my @set =  grep /($str)/,   map  @$_,
   map  { [ ( fileparse( $_, qr/\.pm$/ ) )[0] => $_ ] }
   map  { File::Glob::bsd_glob(
     File::Spec->catfile( $_, qw( AI MicroStructure *.pm ) ) ) } $_;

   foreach(@set){
   $structures->{$_}=$_;# unless($_=~/(usr\/local|basis)/);
   }
  }
  return %$structures;
}



sub getComponents(){

  my $x= sprintf("%s",Dumper keys %MICRO);

  return $x;
}


# the functions actually hide an instance
# END OF INITIALISATION

# support for use AI::MicroStructure 'stars'
# that automatically loads the required classes
sub import {
   my $class = shift;
   # 'stars' is still first
   my @structures = ( grep { $_ eq ':all' } @_ )
   ? ( 'stars', grep { !/^(?:stars|:all)$/ } keys %MICRO )
   : @_;

   $Structure = $structures[0] if @structures;
   my $micro = AI::MicroStructure->new( $Structure );

   $absstructdir = $micro->{state}->{path}->{"cwd/structures"};

   # export the microname() function
   no strict 'refs';
   my $callpkg = caller;
   *{"$callpkg\::microname"} = \&microname;   # standard structure

   # load the classes in @structures
   for my $structure( @structures ) {
   eval "require '$absstructdir/$structure.pm';".
        "import  '$absstructdir/$structure.pm';";
   croak $@ if $@;
   *{"$callpkg\::micro$structure"} = sub { $micro->name( $structure, @_ ) };
   }
}

sub new {
   my ( $class, @tools ) = ( @_ );
   my $structure;
   $structure = shift @tools if @tools % 2;
   $structure = $Structure unless $structure; # same default everywhere
  #  my $driver = {};
   #   $driver = AI::MicroStructure::Driver->new;

   # defer croaking until name() is actually called
   my $self = bless { structure => $structure,
                     tools => { @tools }, micro => {}}, $class;


    $self->{state}  =   AI::MicroStructure::Util::load_config();
    $absstructdir = $self->{state}->{path}->{"cwd/structures"};

#    print Dumper $self;

    return $self;

}

sub _rearrange{
   my $self = shift;
   $self->{'payload'} = shift if @_;
   return %$self;
}

# CLASS METHODS
sub add_structure {
   my $class  = shift;
   my %structures = @_;

   for my $structure ( keys %structures ) {
   croak "The structure $structure already exists!" if exists $MICRO{$structure};
   my @badnames = grep { !/^[a-z_]\w*$/i } @{$structures{$structure}};
   croak "Invalid names (@badnames) for structure $structure"
   if @badnames;

   my $code = << "EOC";
package AI::MicroStructure::$structure;
use strict;
use AI::MicroStructure::List;
our \@ISA = qw( AI::MicroStructure::List );
our \@List = qw( @{$structures{$structure}} );
__PACKAGE__->init();
1;
EOC
   eval $code;
   $MICRO{$structure} = 1; # loaded

   # export the microstructure() function
   no strict 'refs';
   my $callpkg = caller;
   *{"$callpkg\::micro$structure"} = sub { $callpkg->name( $structure, @_ ) };
   }
}





# load the content of __DATA__ into a structure
# this class method is used by the other AI::MicroStructure classes
sub load_data {
   my ($class, $structure ) = @_;
   $data = {};

   my $fh;
   { no strict 'refs'; $fh = *{"$structure\::DATA"}{IO}; }

   my $item;
   my @items;
   $$item = "";

   {
   if(defined($fh)){
   local $_;
   while (<$fh>) {
   /^#\s*(\w+.*)$/ && do {
   push @items, $item;
   $item = $data;
   my $last;
   my @keys = split m!\s+|\s*/\s*!, $1;
   $last = $item, $item = $item->{$_} ||= {} for @keys;
   $item = \( $last->{ $keys[-1] } = "" );
   next;
   };
   $$item .= $_;
   }
   }
}
   # clean up the items
   for( @items, $item ) {
   $$_ =~ s/\A\s*//;
   $$_ =~ s/\s*\z//;
   $$_ =~ s/\s+/ /g;
   }


   return $data;
}


#fitnes

sub fitnes {

    my $self = shift;
    return sha1_hex($self->structures());
   ##my ($config,$structure, $config ) = (shift,[$self->structures()]); FIXME

}

# main function
sub microname { my $self = shift; $self->name( @_ ) };




sub name {
   my $self = shift;
   my ( $structure, $count ) = ("any",1);

   if (@_) {
   ( $structure, $count ) = @_;
   ( $structure, $count ) = ( $self->{structure}, $structure )
   if defined($structure) && $structure =~ /^(?:0|[1-9]\d*)$/;
   }
   else {
   ( $structure, $count ) = ( $self->{structure}, 1 );
   }

   if( ! exists $self->{micro}{$structure} ) {
   if( ! $MICRO{$structure} ) {
   eval "require '$absstructdir/$structure.pm';";
   croak "MicroStructure list $structure does not exist!" if $@;
   $MICRO{$structure} = 1; # loaded
   }
   $self->{micro}{$structure} =
   "AI::MicroStructure::$structure"->new( %{ $self->{tools} } );
   }

   $self->{micro}{$structure}->name( $count );
}


# other methods
sub structures { wantarray ? ( sort keys %MICRO ) : scalar keys %MICRO }
sub has_structure { $_[1] ? exists $MICRO{$_[1]} : 0 }
sub configure_driver { $_[1] ? exists $MICRO{$_[1]} : 0 }
sub count {
   my $self = shift;
   my ( $structure, $count );

   if (@_) {
   ( $structure, $count ) = @_;
   ( $structure, $count ) = ( $self->{structure}, $structure )
   if $structure =~ /^(?:0|[1-9]\d*)$/;
   }


   if( ! exists $self->{micro}{$structure} ) {
   return scalar ($self->{micro}{$structure}->new);
   }

   return 0;
}


sub trim
{
   my $self = shift;
   my $string = shift;
   $string =  "" unless  $string;
   $string =~ s/^\s+//;
   $string =~ s/\s+$//;
   $string =~ s/\t//;
   $string =~ s/^\s//;
   return $string;
}


sub getBundle {

   my $self = shift;

    $absstructdir = $self->{state}->{path}->{"cwd/structures"};


my @structures = grep { !/^(?:any)/ } AI::MicroStructure->structures;
my @micros;
my @search=[];





for my $structure (@structures) {
   no strict 'refs';
   eval "require '$absstructdir/$structure.pm';";

   my %isa = map { $_ => 1 } @{"AI::MicroStructure::$structure\::ISA"};
   if( exists $isa{'AI::MicroStructure::Locale'} ) {
   for my $lang ( "AI::MicroStructure::$structure"->languages() ) {
   push @micros,
   ["AI::MicroStructure::$structure"->new( lang => $lang ),$lang];


   }
   }
   elsif( exists $isa{'AI::MicroStructure::MultiList'} ) {
   for my $cat ( "AI::MicroStructure::$structure"->categories(), ':all' ) {
   push @micros,
   [ "AI::MicroStructure::$structure"->new( category => $cat ),$cat];
   }
   }
   else {
   push @micros, ["AI::MicroStructure::$structure"->new(),''];
   }
}

my  $all ={};

for my $test (@micros) {
   my $micro = $test->[0];
   my %items;
   my $items = $micro->name(0);
   $items{$_}++ for $micro->name(0);
   my $key=sprintf("%s",$micro->structure);
   $all->{$key}=[$test->[1],$micro->name($items)];

}


 return $all;

}


sub save_cat {

  my $self = shift;
  my $data = shift;
  my $dat;
  my $ret = "";


  foreach my $key(sort keys %{$data} ) {
   next unless($_);
   #ref $hash->{$_} eq "HASH"
   if(ref $data->{$key} eq "HASH"){
   $ret .= "\n".$self->save_cat($data->{$key});
   }else{
   $dat = $data->{$key};
   $dat =~ s/^|,/\n/g;
   $dat =~ s/\n\n/\n/g;
   $dat =~ s/->\n|[0-9]\n//g;

   $ret .= "# ".($key=~/names|default|[a-z]/?$key:"names ".$key);
   $ret .= "\n ".$dat."\n";
   }

  }

  return $ret;

}

sub save_default {

  my $self = shift;
  my $data = shift;
  my $line = shift;
  my $dat = {};
  my @in = ();
  my $active=0;
  $line = $Structure unless($line);

  foreach(@{$data->{rows}->{"coordinate"}}){

   if($_ eq $line){ $active=1; }

   if(1+$line eq $_){ $active=0; }

   if($active==1){
   $_=~s/,//g;
   $_ = $self->trim($_);
   $dat->{names}->{$_}=$_ unless(defined($dat->{names}->{$_}));
   }

}

foreach(@{$data->{rows}->{"search"}}){

   if($_ eq $line){  $active=1; }


   if(1+$line eq $_){ $active=0; }

   if($active==1){
   $_=~s/,//g;
   $_ = $self->trim($_);
   $dat->{names}->{$_}=$_ unless(defined($dat->{names}->{$_}));


   }

}

push @in , keys %{$dat->{names}};
push @in , values %{$data->{names}};
$dat->{names} = join(" ",@in);
$dat->{names} =~ s/$line(.*?)\-\>(.*?) [1-9] /$1 $2/g;
$dat->{names} =~ s/  / /g;
my @file = grep{/$Structure/}map{File::Glob::bsd_glob(
 File::Spec->catfile( $_, ($structdir,"*.pm") ) )}@CWD;


  if(@file){
  open(SELF,"+<$file[0]") || die $!;

  while(<SELF>){last if /^__DATA__/}

   truncate(SELF,tell SELF);

   print SELF $self->save_cat($dat);

   truncate(SELF,tell SELF);
   close SELF;
  }

}

sub openData{

my $self = shift;

my @datax = ();

if(<DATA>){

@datax = <DATA>;

while(@datax){
  chomp;
  if($_=~/^#\s*(\w+.*)$/) {
   @a=split(" ",$1);
   if($#a){
   $data->{$a[0]}->{$a[1]}="";
   }else{
   $data->{$1}="";
   }
   $item=$1 unless($#a);

  }else{

   my @keys = split m!\s+|\s*/\s*!,$_;
   foreach(sort @keys){
   if($#a){
   $data->{$a[0]}->{$a[1]} .= " $_" unless($_ eq "");
   }else{
   $data->{$item} .= " $_" unless($_ eq "");
   }
   }

  };

}
}
return $data;


}

sub getBlank {

  my $self = shift;
  my $structure = shift;
  my $data = shift;



my $usage = "";

$usage = "#!/usr/bin/perl -W\n";
$usage .= << "EOC";
package AI::MicroStructure::$structure;
use strict;
use AI::MicroStructure::List;
our \@ISA = qw( AI::MicroStructure::List );
our \@List = qw( \@{\$structures{\$structure}} );
__PACKAGE__->init();
1;
EOC



my $new = {};
foreach my $k
(grep{!/^[0-9]/}map{$_=$self->trim($_)}@{$data->{rows}->{"search"}}){

   $k =~ s/[ ]/_/g;
   $k =~ s/[\(]|[\)]//g;
   next if($k=~/synonyms|hypernyms/);
   print $k;
   $new->{$k}=[map{$_=[map{$_=$self->trim($_)}split("\n|, ",$_)]}
      grep{!/synonyms|hypernyms/}split("sense~~~~~~~~~",
                                      lc `micro-wnet $k`)];
   next unless(@{$new->{$k}});
#   $new->{$k}=~s/Sense*\n(.*?)\n\n/$1/g;
#   @{$new->{$k}} = [split("\n|,",$new->{$k})];
   $data->{rows}->{"ident"}->{md5_base64($new->{$k})} = $new->{$k};

}


my $list = join("\n",sort keys %$new);


#   $list =~ s/_//g;

$usage .= "
__DATA__
# names
".$list;




}

sub save_new {

my $self = shift;
my $StructureName = shift;
my $data = shift;

    $StructureName = lc $self->trim(`micro`) unless($StructureName);
    my $file = "$absstructdir/$StructureName.pm";
    print `mkdir $absstructdir` unless(-d $absstructdir);
    my $fh;

    open($fh,">$file") || die $!;

    print $fh $self->getBlank($StructureName,$data);

    close $fh;
    $Structure = $StructureName;
    push @CWD,$file;
    return 1;
}



sub drop {

my $self = shift;
my $StructureName = shift;

my @fh = grep{/$StructureName.pm/}__PACKAGE__->find_structures(@CWD);


  if(defined($fh[0]) &&  `ls $fh[0]`)
  {
    print  `rm $fh[0]`;

  }else{

   croak "The structure $StructureName does not exist!";

  }


  return 1;
}

sub help {

my $self = shift;
my $usage = << 'EOT';

  #current status
  #did you create a micro structure yet ?
  #try something like this

  $ micro new ufo;      # creates a structure called ufo

  $ micro drop ufo;     # deletes the structure called ufo

  $ micro structures;   # shows all structure's you currently have

  #after creation of a structure you can access it in lots of ways



  $ micro;             # one word of a random structure

  $ micro ufo;         # one word of the ufo structure

  $ micro ufo all;     # all words of the ufo structure

  $ micro ufo 5;       # 5 random words of the ufo structure

  $ micro any 10;      # 10 random words of any structure you have created


  $ micro --init        # initializes active memory

  $ micro --export      # export relations from couchdb into git repo and tag data


  # oneliners i like to use

  $  for i in `micro structures`; do echo $i; done;       # echos all the structures

  $  for i in `micro ufo all`;   do echo $i; done;       # echos all words in ufo

  $  for i in `micro structures`; do micro all $i; done;  # echos all stuctures all words

  $  for i in `micro ufo all`;   do micro new $i; done;  # new structure for all words in ufo

  $  for i in `micro ufo all`;   do micro-wiki $i; done; # push all words against the wiki plugin dont forget setting user & password in /usr/local/bin/micro-wiki

  ###################################################################################
  # try to follow the logic combine
  # your-word=micro new ? ->concept->concepts->relations->node


  $ micro new biology
  $ micro new biological_process

  $ for i in `micro structures`; do
  $ for y in `micro all $i `; do
  $ echo "$i=$y";
  $ micro new $y;
  $ done
  $ done

  #!!!!!###Hard cpu to expect ### make sure couch is on   ######  or disable the store methode in micro-wiki and print $doc or consume otherweise
  # test as single before you loope

  $ micro-wiki ufo

  # proceed

  $ for i in `micro structures`; do
  $ for y in `micro all $i `; do
  $ echo "$i=$y";
  $ micro-wiki $y;
  $ done
  $ done


EOT



return $usage;

}



END{

if($init){}
if($available){}
if($lib){}
if($list){}
if($use){}
if($off){}
if($switch){}
if($mirror){}
if($version){
    printf($VERSION);
    exit(0);
}



if($help) {
    printf(__PACKAGE__->help());
    exit(0);

}





if($drop == 1) {
   __PACKAGE__->drop($StructureName);
   exit 0;
}

if($new==1){

  use Term::ReadKey;
  use JSON;

  my $data = decode_json(lc`micro-sense $StructureName words`);


  my $char;
  my $line;
  my $senses=@{$data->{"senses"}};
   $senses= 0 unless($senses);

  printf("\n
  \033[0;34m
  %s
  Type: the number you choose 1..$senses
  \033[0m",__PACKAGE__->usage($StructureName,$senses,$data));

  $line = 1 unless($senses <= 1);
  chomp($line = <STDIN>) unless($line);

  my $d = join("#",@{$data->{rows}->{search}});

  my  @d = grep{/^$line#/}split("sense~~~~~~~~~",$d);
  @{$data->{rows}->{"search"}}=split("#",join("",@d));

  if($line>0){
   __PACKAGE__->save_new($StructureName,$data,$line);
   exit 0;
  }else{

   printf "your logic is today impaired !!!\n";
   exit 0;

  }



  }

  if($write == 1) {
   __PACKAGE__->save_default();
  }
}





sub usage {

 my $self = shift;


 my $search = shift;
 my $senseNr = shift;
 my $data = shift;


my $usage = << 'EOT';

               .--'"""""--.>_
            .-'  o\\b.\o._o.`-.
         .-'.- )  \d888888888888b.
        /.'   b  Y8888888888888888b.
      .-'. 8888888888888888888888888b
     / o888 Y Y8888888888888888888888b
     / d888P/ /| Y"Y8888888888888888888b
   J d8888/| Y .o._. "Y8888888888888Y" \
   |d Y888b|obd88888bo. """Y88888Y' .od8
   Fdd 8888888888888888888bo._'|| d88888|
   Fd d 88\ Y8888Y "Y888888888b, d888888P
   d-b 8888b Y88P'     """""Y888b8888P"|
  J  8\88888888P    `m.        """""   |
  || `8888888P'       "Ymm._          _J
  |\\  Y8888P  '     .mmm.YM)     .mMF"'
  | \\  Y888J     ' < (@)>.- `   /MFm. |
  J   \  `YY           ""'   ::  MM @)>F
   L  /)  88                  :  |  ""\|
   | ( (   Yb .            '  .  |     L
   \   bo  8b    .            .  J     |        <0>_
    \      "' .      .    .    .  L   F         <1>_
     o._.:.    .        .  \mm,__J/  /          <2>_
     Y8::'|.            /     `Y8P  J           <3>_
     `|'  J:   . .     '   .  .   | F           <4>_
      |    L          ' .    _:    |            <5>_
      |    `:        . .:oood8bdb. |            1>_
      F     `:.          "-._   `" F            2>_
     /       `::.           """'  /             3>_
    /         `::.          ""   /              4>_
_.-d(          `:::.            F               5>_
-888b.          `::::.     .  J                 6>_
Y888888b.          `::::::::::'                 7>_
Y88888888bo.        `::::::d                    8>_
`"Y8888888888boo.._   `"dd88b.                  9>_





"""""""""""""""""""""""""""""""""""""""""""""""

EOT


$usage =~ s/<0>_/\033[0;32mThe word $search\033[255;34m/g;
$usage =~ s/<1>_/\033[0;32mhas $senseNr concept's\033[255;34m/g;
$usage =~ s/<2>_/\033[0;32mwe need to find out the which one\033[255;34m/g;
$usage =~ s/<3>_/\033[0;32mto use for our new,\033[255;34m/g;
$usage =~ s/<4>_/\033[0;32mmicro-structure,\033[255;34m/g;
$usage =~ s/<5>_//g;
my @row = ();
my $ii=0;
foreach my $sensnrx (sort keys %{$data->{"rows"}->{"senses"}})
{



   my $row = $data->{"rows"}->{"senses"}->{$sensnrx};
   my $txt="";

   foreach(@{$row->{"basics"}}[1..2]){
   next unless($_);
   $txt .= sprintf("\033[0;31m %s\033[255;34m",$_);
   }

   $txt .= sprintf("",$_);
   $usage =~ s/$sensnrx>_/($sensnrx):$txt/g;
   if($sensnrx>9){
   $usage .= sprintf("\n(%d):%s",$sensnrx,$txt);

   }
}

  foreach my $ii (0..16){
   $usage =~ s/$ii>_//g;
  }


return $usage;
}


1;

__END__


#print Dumper $micro;

# ABSTRACT: AI::MicroStructure   Creates Concepts for words

=head1 NAME

  AI::MicroStructure

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

 [sample using concepts](http://quantup.com)

 [PDF info on my works](https://github.com/santex)


=head1 SEE ALSO

  AI-MicroStructure
=cut


__DATA__

Fuck lots of stress with the bug series after the config implementation




# corresponding method
sub name {
   my $self = shift;
   my ( $structure, $count ) = ("any",1);

   if (@_) {
   ( $structure, $count ) = @_;
   ( $structure, $count ) = ( $self->{structure}, $structure )
   if defined($structure) && $structure =~ /^(?:0|[1-9]\d*)$/;
   }
   else {
   ( $structure, $count ) = ( $self->{structure}, 1 );
   }


#   croak "MicroStructure does not exist!" if (!defined $structure || $@);

   if( ! exists $self->{micro}{$structure} ) {
   if( ! $MICRO{$structure} ) {
   eval "require '$absstructdir::$structure.pm';";



   $MICRO{$structure} = 1 ;
   }

   if($MICRO{$structure} || $structure=~/any/){
     use AI::MicroStructure::any;
     $self->{micro}{$structure} = AI::MicroStructure::any->new($structure, %{ $self->{tools} } );
     }else {
     $self->{micro}{$structure} = AI::MicroStructure->new(%{ $self->{tools} } );
       }
   }

   $self->{micro}{$structure}->name( $count );
}
