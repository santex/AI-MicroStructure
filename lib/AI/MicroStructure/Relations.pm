#!/usr/bin/perl -X
package AI::MicroStructure::Relations;
use strict;
use warnings;
use utf8; # for translator credits
use Data::Dumper;
use AI::MicroStructure::Cache;
use WWW::Wikipedia;
use JSON::XS;
use Statistics::Basic qw(:all);

our $supports = {};
our $scale = 1;

sub new {
    my $class = shift;

    no strict 'refs';
    my $self = bless { @_,storage=> AI::MicroStructure::Cache->new,
                          cache=>{},
                          dominant => [] }, $class;

    return $self;
}

sub gofor {
    my $self = shift;
    my $next = shift;
    my $opt  = shift;


   
my   $wiki = WWW::Wikipedia->new();
my   $result = $wiki->search($next);


    	eval( 'use IO::Page' );

      if(defined($result) and $result){

        use AnyEvent::Subprocess::Easy qw(qx_nonblock);
        my $micosense = qx_nonblock("micro-sense $next")->recv;
        my $sense = JSON::XS->new->pretty(1)->decode($micosense);
        delete($sense->{rows}->{search});
        
        push @{$self->{storage}->{category}},{$next=>$sense} unless(!@{$sense->{senses}});
        
        $self->{storage}->{related}->{$next} = [grep{!/\(/}map{$_=~ s/ /_/g; $_=ucfirst $_;} $result->related()];
        

        foreach my $elem ($result->related()){

         $elem =~ s/ /_/g;
         
         $self->{storage}->{data}->{$elem} = defined($self->{storage}->{data}->{$elem}) ?
         $self->{storage}->{data}->{$elem}+1:1; 


#         if($_ &&
 #          !defined($self->{storage}->{data}->{$elem})) {

          # $wiki = WWW::Wikipedia->new();
          # $result = $wiki->search($_);
         
 #        $result = $wiki->search($_);

#         $self->{storage}->{$_}->{related} = [grep{!/\(/}map{$_=~ s/ /_/g; $_=ucfirst $_;}$result->related()] unless(!$result);


         #  $self->{storage}->{$_}->{related} = [grep{!/\(/}map{$_=~ s/ /_/g; $_=ucfirst $_;}$result->related()] unless(!$result);

  #       }




        }

        $self->{storage}->store($self->{storage});
      }
      return ();


}


sub inspect {


   my $self = shift;
   my $times = shift;

   
  foreach(sort {$a cmp $b} keys %{$self->{storage}->{data}} ){


    $self->{storage}->{dominant}->{$self->{storage}->{data}->{$_}} = $_;

  }
  
  $self->{storage}->insert($self->{storage});
  return $self->{storage};
}


1;
# ABSTRACT: this is part of AI-MicroStructure the package handels relations between concepts


=head1 NAME

  AI::MicroStructure::Relations

=head1 DESCRIPTION

  Gets Relations for Concepts based on  words

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

  ☞ [sample using concepts](http://quantup.com)

  ☞ [PDF info on my works](https://github.com/santex)

  
=head1 SEE ALSO

  AI-MicroStructure
  AI-MicroStructure-Cache
  AI-MicroStructure-Deamon
  AI-MicroStructure-Relations
  AI-MicroStructure-Concept
  AI-MicroStructure-Data
  AI-MicroStructure-Driver
  AI-MicroStructure-Plugin-Pdf
  AI-MicroStructure-Plugin-Twitter
  AI-MicroStructure-Plugin-Wiki

  
__END__
__DATA__

