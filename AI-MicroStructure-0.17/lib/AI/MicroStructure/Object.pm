#!/usr/bin/perl -W


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
#  $self->{files}->{micro} = [split("\n",$self->check("@_","micro-index"))] ;
#  $self->{files}->{second}->{$_}=[split("\n",$self->check("$_","micro-index")  )] for @{$self->{micro}};
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

sub TO_JSON {
    my $self = shift;
    return { class => 'Object', data => { %$self } };
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
