#!/usr/bin/perl

use Data::Freq;

use Data::Dumper;
use Data::Printer;
use Term::ShellUI;
use File::stat qw(:FIELDS);
use AI::MicroStructure;
use Storable qw(lock_store lock_retrieve);
use Search::ContextGraph;
use Try::Tiny;
use Getopt::Long;
use JSON;
use JSON::XS;

our @cmds = qw/index search new cat files load/;
our %name = (action=>[@cmds],#search get set   change plot cloudy
                        type=>[qw(match dir indices)],# know growing fit term
                        location=>[@cmds]);
use File::Find::Rule;
use File::Temp qw(tempdir);
use Thread;


my$UNDERLINE=`tput smul`;
my $CYAN=`tput setaf 6`;
my $REVERSE=`tput smso`;
my $BRIGHT=`tput bold`;
my $NORMAL=`tput sgr0`;
our $rows   = `tput lines`;
our $column = `tput cols`;
    $column = $column;
my $quaters = (int $column/9);
my $curSysDate = `date +"%Y%m%d"`;
        $curSysDate=~ s/\n//g;

my @name = ();
my @vals =();
our $context = {};
our $cache = {};
our %opts = (
                  max_cache_age => 18000,
                  cache_file    => sprintf("./realtime.cache"),
                  match          =>"",
                  dir => "  archive/multi/www.nicap.org/",
                  cache         => 1,
    );
    GetOptions (\%opts, "query=s",
                        "max_cache_age=i",
                        "cache_file=s",
                        "match=s",
                        "dir=s",
                        "cache!",
                        );



sub SHOW_LINE{
    my $leng = shift;
    $leng = $column unless($leng);
    return sprintf("%s","-"x$leng);

}

sub getBaseCache {    return $cache;  }
sub trim
{
  my $string = shift;
  $string =  "" unless  $string;
  $string =~ s/^\s+//;
  $string =~ s/\s+$//;
  $string =~ s/\t//;
  $string =~ s/^\s//;
  return $string;
}
sub  initCache {
eval {
    local $^W = 0;  # because otherwhise doesn't pass errors


    if(! -f $opts{cache_file}){
      $cache = {};
       lock_store($cache,$opts{cache_file});
    }else{
      $cache = lock_retrieve($opts{cache_file});
    }


    if(!defined($cache->{tempdir}) ||
          ! -d $cache->{tempdir}){
            $cache->{"tempdir"} = tempdir();




      }



    $cache->{cache_version} = (defined($cache->{cache_version}) ? $cache->{cache_version} +1 : 1);
    $cache->{time} = time();
    $cache->{files} = {} unless(defined($cache->{files}));
    $cache->{files}->{cng} = [] unless(defined($cache->{files}->{cng}));
    $cache->{structures} = [] unless($cache->{structures});
    $opts{"match"} = [split(" ",$opts{"match"})];# unless($opts{"match"} eq "");
    $opts{"preg"}   = join("|",@{$opts{"match"}});
    $cache->{structures} = [grep{/$opts{"preg"}/}  AI::MicroStructure->new()->structures()];



    $cache->{structures_from} = AI::MicroStructure->new()->{state}->{path}->{"cwd/structures"};
    $cache->{preg} = $opts{preg};
    $cache->{search_in} = $opts{dir};

    $opts{"preg"}   = join("|",@{$cache->{structures}});
    $cache->{require} = [grep{!/$opts{"preg"}/}@{$opts{"match"}}];
    $cache->{opts}=\%opts;


    if(!$cache->{files} ->{cng} || !$cache->{files} ->{cng}->[0]){
      $cache->{files} ->{$_}= [find( file    =>
      name =>["*.".$_ ],
      size    => '>1k',
      in      => [grep { -d $_ } @INC])]   for qw(cng);
    }
    warn "New cache!\n" unless defined $cache;
};



}
initCache();

our $cmd = {
"h" =>      { alias => "help", exclude_from_completion => 1 },
 "?" =>     { alias => "help", exclude_from_completion =>0},
"quit" => { alias => "exit", exclude_from_completion =>1},
"help" => { desc => "Print helpful information", args => sub { shift->help_args(undef, @_); }, method => sub { shift->help_call(undef, @_); } },
 "exit" => { desc => "Exits the program.", maxargs => 0, method => sub { shift->exit_requested(1); }, },
 "is" => { desc => "Shows whether files exist", args => sub { shift->complete_files(@_); }, exclude_from_completion =>0 , proc => sub {  print "exists: " .  join(", ", map {-e($_) ? "<$_>":$_} @_) . "\n"; },
 "quit" => { desc => "Quit using Fileman", maxargs => 0, method => sub { shift->exit_requested(1); }, },
 '' => {  proc => "No command here by that name!\n", desc => "No help for unknown commands.", doc => "Well, here's a little help: don't type them.\n", },
 "show" => { desc => "An example of using subcommands", cmds => {  "warranty" => { proc => "You have no warranty!\n" },  exclude_from_completion =>1 , "args" => {
 args => [ sub {['create', 'delete']},  \&Term::ShellUI::complete_files ],  desc => "Print the passed arguments", method => sub {  my $self = shift;  my $parms = shift;  print $self->get_cname($parms->{cname}) . ": " . join(" ",@_), "\n";  }, }, }, },
 "string" => { desc => "String operations", cmds => { "subs" => { args => ["(string)", "(pos)", "(len)"], desc => "Take STRING,POS,LEN and return a substring.", minargs => 1, maxargs => 3,proc => sub { print "Substring=".substr(shift,shift||0,shift||0)."\n" }, },
 "len" => { args => "(any number of strings)", desc => "Calculate length of arguments", proc => sub { print "Length=" . join(", ", map { length } @_) . "\n" }, }, }, },
 doc =>
<<EOL
Pass any number of filename.
If a file exists, it is
printed in <angle brackets>.
EOL
 },
 "history" => { desc => "Prints the command history", doc => "Specify a number to list the last N lines of history\nPass -c to clear the command history,-d NUM to delete a single item\n",
                        args => "[-c] [-d] [number]",
                        method => sub { shift->history_call(@_) },
                        exclude_from_history => 1,},

 };


END{


  my $encoder = JSON->new->allow_blessed->pretty(1);
  my $json = $encoder->encode($cache);

  lock_store($cache, sprintf("%s/%s",$cache->{ "tempdir"},$opts{cache_file}));
  open my $fh, ">", sprintf("%s/cache.json",$cache->{ "tempdir"});
  print $fh $json;
  close $fh;

  #initCache();
  p $cache;

  }

sub status {
      my $cont = shift ;
      my $b = shift ;
      $b = "" unless($b);
      print "\n\n";
      SHOW_LINE(19);
      my $txt = "";
      my @keys = keys %$cont;

      my @structures = @{$cont->{structures}} if($cont->{structures});
      @structures = () unless(@structures);
      my @files = @{$cont->{files}->{cng}} if($cont->{files}->{cng});
      @files = () unless(@files);

      my       $qq = sprintf("\t${REVERSE} cache_version %".($quaters)."s  |  micro-dir:%-".($quaters)."s  |  indices: %-".($quaters*2)."s  |  structures:%-".($quaters*2)."s  $NORMAL"
                  ,$cont->{cache_version},$cont->{structures_from},scalar(@files),scalar(@structures));
      print "\n\n";

}



sub actionBar {

 my $cont = shift ;
      my $b = shift ;
     $b .=sprintf("$BRIGHT $REVERSE%".($quaters-1)."s$NORMAL",`for i in {16..21} {21..16} ; do echo -en "\e[48;5;\${i}m \e[0m" ; done ;`) for 0..8 ;
#     system q/perl -le 'print "line $_" for 1..20; <>'/;
 #    my @many =  glob "{apple,tomato,cherry}={green,yellow,red}";
  #   p @many;
#    printf($b);

}


our $ms = AI::MicroStructure->new();

our $descriptions = {action=>{},type=>{},location=>{}};
    $descriptions->{action} = {

   #                 'new'     =>"get something !",
      #              'knowen'     =>"set something !",
         #           'find'     =>"get something !",


                    #  'desc'    =>"show a description about something",
                    #  'delete'  =>"remove something",
                    # 'search'    =>"search something",
                    # 'change'  =>"modify something",
                    # 'plot'    =>"create vissualisation of something",
                    # 'cloudy'  =>"create optimal query surface for something",
};

$descriptions->{type} =
{

#'new'     =>"things you dont have yet",
#'my'      =>"things you have already",
#'related' =>"things which are related to you",
#'known' =>"trending things",#
#'growing' =>"expanding things",
#'fit'    =>"usefull things",
};

$descriptions->{location} =
{
};


sub usage {


my @ASCII;
push @ASCII,"
$BRIGHT

        .       .    )        .           .
   .       *             .         .
                 .                      .
   .       .       .'          .
                  '.              *        .
      .   '        .'     .              .
              _.---._   .            .     *
    *       .'       '.
        _.-~===========~-._
       (___________________)       .   *
  __         \_______/       ______        __
    |                       |      |      |  |
    |                       |      |      |  |
    |                       |      |   ___|  |_
  __|_______________________|__..--~~~~ micro    ~--.




";
push @ASCII,"
$BRIGHT.     .       .  .   . .   .   . .    +  .
  .     .  :     .    .. :. .___---------___.
  .  .   .    .  :.:. _''.^ .^ ^.  '.. :''-_. .
    .  :       .  .  .:../:            . .^  :.:\.
        .   . :: +. :.:/: .   .    .        . . .:\
 .  :    .     . _ :::/:               .  ^ .  . .:\
  .. . .   . - : :.:./.                        .  .:\
  .      .     . :..|:                    .  .  ^. .:|
    .       . : : ..||        .                . . !:|
  .     . . . ::. ::\(                           . :)/
 .   .     : . : .:.|. ######              .#######::|
  :.. .  :-  : .:  ::|.#######           ..########:|
 .  .  .  ..  .  .. :\ ########          :######## :/
  .        .+ :: : -.:\ ########       . ########.:/
    .  .+   . . . . :.:\. #######       #######..:/
      :: . . . . ::.:..:.\           .   .   ..:/
   .   .   .  .. :  -::::.\.       | |     . .:/
      .  :  .  .  .-:.'':.::.\             ..:/
 .      -.   . . . .: .:::.:.\.           .:/
.   .   .  :      : ....::_:..:\   ___.  :/
   .   .  .   .:. .. .  .: :.:.:\       :/
        .   .   : . ::. :.:. .:.|\  .:/|
";

push @ASCII, "
$BRIGHT
             i!~!!))!!!!!!!!!!!!!!!!!!!!!!!!
          i!!!{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!i
       i!!)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    '!h!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  '!!`!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!i
   /!!!~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
' ':)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ~:!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
..!!!!!\!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 `!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 ~ ~!!!)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~
~~'~{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:'~
{-{)!!{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:!
`!!!!{!~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!':!!!
' {!!!{>)`!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)!~..
:!{!!!{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -!!:
    ~:!4~/!!!!!!!!!!!!!!!!!!!~!!!!!!!!!!!!!!!!!!!!!!!!!!
     :~!!~)(!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      ``~!!).~!!!!!!!!!!!!!{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:
            ~  '!\!!!!!!!!!!(!!!!!!!!!!!!!!!!!!!!!!4!!!~:
           '      '--`!!!!!!!!/:\!!{!!((!~.~!!`?~-      :
              ``-.    `~!{!`)(>~/ \~                   :
   .                \  : `{{`. {-   .-~`              /
    .          !:       .\\?.{\   :`      .          :!
    \ :         `      -~!{:!!!\ ~     :!`         .>!
    '  ~          '    '{!!!{!!!t                 ! !!
     '!  !.            {!!!!!!!!!              .~ {~!
      ~!!..`~:.       {!!!!!!!!!!:          .{~ :LS{
       `!!!!!!h:!?!!!!!!!!!!!!!(!!!!::..-~~` {!!!!.
         4!!!!!!!!!!!!!!!!!!!!!~!{!~!!!!!!!!!!!!'
          `!!!!!!!!!!!!!!!!!!!!(~!!!!!!!!!!!!!~
            `!!!!!!!!!!!{\``!!``(!!!!!!!!!~~  .
             `!!!!!!!!!!!!!!!!!!!!!!!!(!:
               .!!!!!!!!!!!!!!!!!!!!!\~
               .`!!!!!!!/`.;;~;;`~!! '
                 -~!!!!!!!!!!!!!(!!/ .
                    `!!!!!!!!!!!!!!'
                      `\!!!!!!!!!~
";

my @rand = split( "\n",$ASCII[rand(3)]);
my $rand = "";

@{$cache->{files}->{cng}} =  sort {length($a)<=>length($b)} @{$cache->{files}->{cng}};

`clear`;
actionBar();

my @cat = @{$cache->{"categorys"}};
my @files = @{$cache->{files}->{cng}};

if(@files){
  printf("\033[0m\n\n\t<indices>\n");
  printf("\n\t|-%s",$_,$rand[$_]) for  @files;
}

if(@cat) {
  printf("\n\n<categorys>\n\t");
  printf("\033[0;31m\n\t|-%s\033[255;34m\n%s",$_,$rand[$_]) for  @cat;
}
printf(" \n\n\t\t$CYAN|<structures>\t
\t%20s
\033[0m",
sprintf("\033[0;31m\t%s\033[255;34m",join( "\n\t\t",grep {!/HASH/} map{$_ = defined($cache->{$_}) ? sprintf("%20s%4s$CYAN%s\033[0;31m" , $_,sprintf("%-2s","="),ref $cache->{$_} eq "ARRAY" ? scalar(@{$cache->{$_}}): ref $cache->{$_} =~/HASH/? join " ",keys %{$cache->{$_}}:$cache->{$_}) : $_;  } reverse sort { length($a) <=> length($b)} keys %$cache))
);

foreach(0..$#rand){


         $led = defined($cache->{"categorys"}->[$_]) ? $cache->{"categorys"}->[$_] : "" unless($led);

        $rand .= sprintf("\n%s%".(($quaters*6)+length($rand[$_])-length($led))."s",$led,);
}




#<index>
#\t%20s
#sprintf("\033[0;31m|->=$CYAN%s\033[0;31m\033[255;34m",join( "\n\t\033[0;31m|->=$CYAN", @{$cache->{files}->{cng}})),
#$rand,


status($cache);

}


sub setUp {
  my (@files) = @_;
  my $g = "";

    foreach(@files){
      if(-f $_) {
        try{
           $g = Search::ContextGraph->retrieve($_);
           $context->{pool}->{$_} = $g;

        }catch{
           printf("error during load %s",$_);
        }
      }
  }
}
sub index{
    my $response = shift;

    if(-d $response){
    $cache->{files} ->{$_}= [find( file    =>
        name =>["*.".$_ ],
        size    => '>1k',
        in      => [$response])]   for qw(cng);
    }

  }
sub promptUser {
  my $default = shift;
  my $defaultValue = sprintf("\n[%s]",$default);
  print $defaultValue;

  chomp(my $input = <STDIN>);
  return $input ? $input : $default;
}
 sub Purge {
    my $dir = shift;
    open my $dh or die "$!, for $dir";
    for my $file ( grep !/^\./, readdir $dh ) {
        my $path = "$dir/$file";
        if ( -d $path ) {
            Purge( $path );
        }
        else {
            ( -z $path ) and unlink $path;
        }
    }
    close $dh or die "$!, for $dir";
}

sub display {
 foreach(@_){
    if($_ =~ m/files/i){
      my $show = join("|",@{$cache->{opts}->{match}});
      my $response = promptUser($show);
      my $match = $response;

        $response = promptUser("specify directory");
      if(!-d $response){
          printf("%s is not a directory",$response);
      }else{
          #my $dir = $cache->{search_in};
          #my $cmd = `atw.pl --dir $dir --match \"$match\" --verbos 1`;
          #print $cmd;


        $cache->{search} ->{$_}= [find( file    =>
            name =>["*$_*.*" ],
            size    => '>0k',
            in      => [$response])] for @{$cache->{opts}->{match}};


          return $cache;
      }

    }elsif($_=~m/load (.*)/) {

      if(defined($1) && -d  $1){

      push @INC,$1;
          $cache->{files} ->{$_}= [find( file    =>
          name =>["*.".$_ ],
          size    => '>1k',
          in      => [grep { -d $_ } @INC])]   for qw(cng);
      }
      my @files =@{$cache->{files}->{cng}};
      @files = () unless(@files);
      printf("\nno index available index\n") unless @files;
      setUp(@files);
      `clear`;
   printf("\n"x100);
   usage($cache);

  }elsif($_=~m/search (.*)/) {

        my @search = ();
         push @search , $1 unless(!$1);

      `micro new  $_ verbose` for @{$cache->{opts}->{match}};
       push @search ,split "\n",trim(`micro all $_`) for @{$cache->{opts}->{match}};
        p @search;

        $context->{pool}->{$_} = Search::ContextGraph->retrieve($_) for  @{$cache->{files}->{cng}};

        foreach my $store (keys %{$context->{pool}}){

        $cache->{match} ->{$store}->{$_}= [$context->{pool}->{$store}->search($_)] for @search;
        foreach(@search){
        delete($cache->{match} ->{$store}->{$_}) unless($cache->{match} ->{$store}->{$_}->[0] || $cache->{match} ->{$store}->{$_}->[1]);
        }
        #$cache->{match} ->{$store}->{all}= [$context->{pool}->{$store}->search([@{$cache->{opts}->{match}}])]

        }
    }elsif($_=~m/new (.*)/) {

      my $response = $1 ? $1 : promptUser("specify directory");
      if(!-d $response){
          printf("%s is not a directory",$response);
      }else{
    }
    }elsif($_=~m/index (.*)/) {
      my $response = $1 ? $1 : promptUser("specify directory");
      if(!-d $response){
          printf("%s is not a directory",$response);
      }else{



      }



    }elsif($_=~m/cat (.*)/) {
        my $search = $1;
        my $cats={};
        my @cats = ();
        my @sp = split("\n" ,`getcat $1|  sed -s "s/Category://"`);
        foreach my $s (@sp){
            my @qq =split(":",$s);
            $cats->{$qq[1]}=$qq[0];
          }


          $cache->{categorys} = [reverse map{$_ = sprintf(( $_ =~/CATEGORYS/ ?  "CATEGORYS:%": "%s%").(length($_)*2 -length($_))."s",$cats->{$_},$_ )}sort {length($a)<=>length($b)}  keys %$cats];


      }

  }
}

our $location = {
  "local" => {
        args => "(path)",
        desc => $descriptions->{location}->{local},
        proc => sub {
                                                my $self = shift;
                                                my $parms = shift;
                                                print get_cname($self,$parms) .
                                                        ": " . join(" ",@_), "\n";
                                        },
                },
"remote" => {
        args => "(none)",
        desc => $descriptions->{location}->{remote},
        proc => sub {
                                                my $self = shift;
                                                my $parms = shift;
                                                print get_cname($self,$parms) .
                                                        ": " . join(" ",@_), "\n";
                                        },
                        }
};



sub println{ return sprintf("%s %s \n",shift,localtime); }
sub show {  my $prod=""; for(@_) { $prod.=$_; }; return $prod; }
sub set { my $sum=0; for(@_) { $sum+=$_; };  return $sum; }
sub mult { my $prod=1;  for(@_) { $prod*=$_; }; return $prod; }
sub ashex {  my $sub = shift; return sprintf("%x", &$sub(map { hex } @_)); }
sub danger { print "Not performing task -- too dangerous!\n"; return 0; }
sub getSubCommands { return {}; }


sub getCommands {


foreach (keys %name){
        @vals = @{$name{$_}};

        #$ms->add_structure(
         #       $_ => $name{$_}
       # );


                my $ams = AI::MicroStructure->new("any");
                push @name , $ams->name(0);

                try {
                foreach my $ele(@vals){
                        if($_ =~ /action/) {
                                $cmd->{$ele} = {
                                        args => sprintf("\033[0;31m%s\033[0m",join( " |", @{$name{type}})),
                                        desc => $descriptions->{action}->{$ele},

                                        proc =>
                                        sub { #my  $thr = Thread->new( \&display,$_);
                                          #my $foo = eval {$thr->join};

                                        my $foo = display($_);




                                             }};

            }

                }
          }catch{
          printf("\nerror");
          }

}


        return $cmd;
}



our $type = {};
our $action = {};
  my $term = new Term::ShellUI(commands =>getCommands (),history_file => '~/.active-memory');

   `clear`;
   printf("\n"x30);
   usage($cache);
   $term->prompt('.'x$column."\n");
  $term->run();

1;
__DATA__
