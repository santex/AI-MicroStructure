#!/usr/bin/perl -W

eval 'exec /usr/bin/perl -W -S $0 ${1+"$@"}'
    if 0; # not running under some shell
package IOMicroy;

use strict;
use warnings;
use strict;
use warnings;
use JSON;
use Data::Dumper;
use AI::MicroStructure ; # loads the default theme
use DBI;
our ($LOG_dbh,$LOG_sth);

sub log {
  my ($table,$number,$item,$structure,$raw,$json,$link)=@_;


  $LOG_sth->{$table}->execute($number,$item,$structure,$raw,$json,$link);

#unless($LOG_dbh->do( "select count(*) from io where structure='".$key."' and structure='".$value."'" ));
}

 # log:


sub GO  {
    our $Logname="/tmp/".(sprintf caller(0))."x.sqlite";

    # Connect
    $LOG_dbh=DBI->connect("DBI:SQLite:$Logname",'','',{ AutoCommit=>0,PrintError=>0,RaiseError=>0 });
    $LOG_dbh->do(<<"__SQL__");
        create table if not exists io (
            number text,
            item text,
            structure text,
            raw text,
            json text,
            link text
             );


__SQL__
$LOG_dbh->do( "create index  if not exists numberIdx on io(number)" );
$LOG_dbh->do( "create index  if not exists sink on io(structure)" );
$LOG_dbh->do( "create unique index if not exists  edge on io(item)" );

    foreach(qw/io/){
    $LOG_sth->{$_}=$LOG_dbh->prepare(<<"__SQL__");
     insert into io (number,item,structure,raw,json,link) values (?,?,?,?,?,?)

__SQL__

}
}

GO();



sub job{

my $ix=0;
my @i=[0,0];
    my $out = {};
    my $meta = AI::MicroStructure->new;
    my @t = $meta->structures;
    foreach my $theme (@t){


          IOMicroy::log("io",$ix++,$theme,`micro $theme all`,`wn $theme -grepn | egrep -v 'Grep'`,"","");
          printf("\n%s", join (" ",($theme)));

      }
return $out->{buff};

}

sub dbg{
my $nl="\n";
return $nl."@"x100;
}

my $out={};
$out->{buff}=job();
# print `echo '$out->{buff}' | data-freq --limit 10`;
#print $out->{buff};

$LOG_dbh->commit(); $LOG_dbh->disconnect();  exit(0);

1;

__END__
