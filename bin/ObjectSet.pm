#!/usr/bin/perl -W

 use Cache::Memcached::Fast;

         my $memd = new Cache::Memcached::Fast({
             servers => [ { address => 'localhost:11211', weight => 2.5 }],
             namespace => 'my:',
             connect_timeout => 0.2,
             io_timeout => 0.1,
             close_on_error => 1,
             compress_threshold => 100_000,
             compress_ratio => 0.9,
             max_failures => 1,
             max_size => 512 * 1024,
         });

1;

package AI::MicroStructure::Object;
use strict;
use Digest::MD5 qw(md5_hex);

use Data::Printer;
use Data::Dumper;
#use AnyEvent::Subprocess::Easy qw(qx_nonblock);
sub new {
  my $pkg = shift;
  my @tools = pop;
  my $self = bless {}, $pkg;
     $self->{tools} = shift @tools;
#  p $self;
  my $i = 0;

  $self->{md5} = md5_hex(@_);
  $self->{name} = "@_";

  $self->{micro} = [split("\n",$self->check("@_","micrownet"))]  ;
  $self->{second}->{$_}=[split("\n",$self->check("$_","micrownet")  )] for @{$self->{micro}};
  $self->{files}->{micro} = [split("\n",$self->check("@_","micro-index"))] ;
  $self->{files}->{second}->{$_}=[split("\n",$self->check("$_","micro-index")  )] for @{$self->{micro}};
  $self->{weight} = {};

    foreach(@{$self->{micro}}){

      foreach(@{$self->{second}->{$_}}){

        if($self->{weight}->{$_})
          {
            $self->{weight}->{$_}++;
          }else{
            $self->{weight}->{$_} = 1;
          }
      }
    }

    foreach(keys %{$self->{weight}}){
      delete $self->{weight}->{$_} unless($self->{weight}->{$_}>1);
    }



  return $self;
}

sub  decruft  {
  my  $self  =  shift;
  my($file)  =  @_;
  my($cruftSet)  =  q{%§&|#[^+*(  ]),'";  };
  my  $clean  =  $file;
  $clean=~s/\Q$_//g  for  split("",$cruftSet);

  return  $clean;
}

sub tools {
  my $self = shift;
  $self->{tools} = \@_;


}
sub check {
 my $self = shift;
 my $name = shift;
 my $prog = shift;
    $name = $self->decruft($name);

  if(defined(my $ret = $memd->get(sprintf("%s_%s",$name,$prog)))){
    return $ret;
  }else{
    my $ret = `$prog $name`;
     $memd->set(sprintf("%s_%s",$name,$prog),$ret);
     return $ret;
  }
}

sub name {

    my $self = shift;
    return $self->{name};
}
1;

package AI::MicroStructure::ObjectSet;
use strict;
use Statistics::Basic qw(:all);
use Data::Printer;
sub new {
  my $pkg = shift;
  my $self = bless {obj=>{IN=>[@_]}}, $pkg;
  my $syntetic = {};

  $self->insert(@_) if @_;

  return $self;
}

sub  decruft  {
  my  $self  =  shift;
  my($file)  =  @_;
  my($cruftSet)  =  q{%§&|#[^+*(  ]),'";  };
  my  $clean  =  $file;
  $clean=~s/\Q$_//g  for  split("",$cruftSet);

  return  $clean;
}

sub members {
  return values %{$_[0]};
}

sub size {
  return scalar keys %{$_[0]};
}

sub insert {
  my $self = shift;
  foreach my $element (@_) {
    if(ref $element eq "AI::MicroStructure::Object")
    {

    $self->{ $element->name } = $element;
    foreach(values $element->{files}){


    $self->{files}->{  $element->name } = $_; }
    $self->{obj}->{center}->{$_} = defined($self->{obj}->{center}->{$_}) ?
                                    $self->{obj}->{center}->{$_} + 1 : 1
                                      for keys %{$element->{weight}};


    }

  }

}

sub domain {
  my $self = shift;
  $self->{obj}->{domain}="@ARGV";


}
sub doit {
  my $self = shift;
  $self->{tools} = \@_;


  my $ob = AI::MicroStructure::Object->new();
  my  @t = split("\n",$ob->check(@ARGV,"micrownet")) unless(!@ARGV);


  foreach my $e(@t){
    $ob = AI::MicroStructure::Object->new($e,$self->{tools});
    $self->insert($ob);
  }

  if(grep{!/search/}@{$self->{tools}}){

      $self->{search} = $self->check($self->{obj}->{domain},"micro-search --full 1 --match");
  }
  if(grep{!/relation/}@{$self->{tools}}){
      my @relation = split("\n",$self->check($self->{obj}->{domain},"micro-relation"));
      @relation = sort @relation;
      $self->{relation} =  \@relation;
      $self->{match} = [grep{/$self->{domain}/}@relation];

    $self->{obj}->{center}->{$_} = defined($self->{obj}->{center}->{$_}) ?
                                    $self->{obj}->{center}->{$_} + 1 : 1
                                      for @relation;




  $self->{obj}->{mean} = sprintf mean values %{$self->{obj}->{center}};
  foreach ( keys %{$self->{obj}->{center}}) {

    next unless $self->{obj}->{center}->{$_}>$self->{obj}->{mean};


    $self->{obj}->{dense}->{$_} = $self->{obj}->{center}->{$_};



  }




#      foreach (@relation){
      #    $self->{relation}

  #      $ob = AI::MicroStructure::Object->new($_,$self->{tools});
   #     $self->insert($ob);
 #     }


  }

}


sub check {
 my $self = shift;
 my $name = shift;
 my $prog = shift;
    $name = $self->decruft($name);

  if(defined(my $ret = $memd->get(sprintf("%s_%s",$name,$prog)))){
    return $ret;
  }else{
    my $ret = `$prog $name`;
     $ret = "empty" unless($ret);
     $memd->set(sprintf("%s_%s",$name,$prog),$ret);
     return $ret;
  }
}sub retrieve { $_[0]->{$_[1]} }
sub includes { exists $_[0]->{ $_[1]->name } }
sub includes_name  { exists $_[0]->{ $_[1] } }

1;
package main;
BEGIN{
  if(!@ARGV){
my $k=  `micro`;
   $k =~s/\n//g;
   push @ARGV,$k;
}}

use Data::Printer;
use Data::Dumper;
use AI::MicroStructure;
our @t = ();
our $micro = AI::MicroStructure->new();
my $set = AI::MicroStructure::ObjectSet->new(@t);
   $set->domain(sprintf(@ARGV));
   $set->doit(qw(search index relation micrownet));


p $set;

#print Dumper $set;
