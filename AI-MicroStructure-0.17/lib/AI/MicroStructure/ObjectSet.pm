#!/usr/bin/perl


package AI::MicroStructure::Object;


 use Cache::Memcached::Fast;

         our $memd = new Cache::Memcached::Fast({
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


use strict;
use Digest::MD5 qw(md5_hex);
use Data::Printer;
use Data::Dumper;

sub new {
  my $pkg = shift;
  my $self = bless {}, $pkg;


  my $i = 0;

  $self->{md5} = md5_hex(@_);
  $self->{name} = "@_";

  $self->{micro} = [split("\n",$self->check("@_","micrownet"))] ;
  $self->{second}->{$_}=[split("\n",$self->check("$_","micrownet")  )] for @{$self->{micro}};
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

 #   foreach(keys %{$self->{weight}}){
#      delete $self->{weight}->{$_} unless($self->{weight}->{$_}>1);
  #  }



  return $self;
}

sub  xdecruft  {
  my  $self  =  shift;
  my($file)  =  @_;
  my($cruftSet)  =  q{%§&|#[^+*(  ]),'";  };
  my  $clean  =  $file;
  $clean=~s/\Q$_//g  for  split("",$cruftSet);

  return  $clean;
}

sub xTO_JSON {
    my $self = shift;
    return { class => 'Object', data => { %$self } };
}


sub tools {
  my $self = shift;
  $self->{tools} = \@_;


}

sub check { my $self = shift;
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
use Carp;
use Digest::MD5 qw(md5_hex);
use Statistics::Basic qw(:all);
use List::Util qw(max min);
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

sub final {

  my $self = shift;




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

  $self->{obj}->{mean} = sprintf "%d.3", mean values %{$self->{obj}->{center}};


  foreach ( keys %{$self->{obj}->{center}}) {

    next unless $self->{obj}->{center}->{$_}>=$self->{obj}->{mean};


    $self->{obj}->{dense}->{$_} = $self->{obj}->{center}->{$_};

  }

  $self->{obj}->{max} = sprintf max values %{$self->{obj}->{dense}};
  $self->{obj}->{min} = sprintf min values %{$self->{obj}->{dense}};



  foreach ( keys %{$self->{obj}->{dense}}) {

    next if $self->{obj}->{dense}->{$_}!=$self->{obj}->{max};


    $self->{obj}->{menu}->{$_} = $self->{obj}->{dense}->{$_};

  }

  $self->{obj}->{www} = [split("\n",`micro-relation $self->{obj}->{name} | data-freq --limit 100`)];

#5   my $check = "";

#foreach ( keys %{$self->{obj}->{dense}}) {
#   my $arg = sprintf("micro-relation %s",$_);
#    my $check .=  sprintf("\n%s",`$arg`);
#}


  return $self;
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
    if($element->{files}){
    foreach(values $element->{files}){
  $self->{files}->{  $element->name } = $_; }
    }}
    $self->{obj}->{center}->{$_} = defined($self->{obj}->{center}->{$_}) ?
                                    $self->{obj}->{center}->{$_} + 1 : 1
                                      for keys %{$element->{weight}};
  }



 # `clear`;
#  p $self->{obj}->{center};

}

sub domain {
  my $self = shift;
  croak("neds args") unless($ARGV[0]);
  $self->{obj}->{domain}=sprintf("%s_%s",$ARGV[0] ,md5_hex(@ARGV));
  $self->{obj}->{name} = $ARGV[0];
  foreach(@ARGV){
  my $ob = AI::MicroStructure::Object->new();
  my   @t = split("\n",$ob->check($_,"micrownet")) unless(!@ARGV);

  foreach my $e(@t){
      $ob = AI::MicroStructure::Object->new($e);
      $self->insert($ob);
    }
  }

}
sub retrieve { $_[0]->{$_[1]} }
sub includes { exists $_[0]->{ $_[1]->name } }
sub includes_name  { exists $_[0]->{ $_[1] } }

1;
