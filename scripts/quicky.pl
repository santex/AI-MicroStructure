#!/usr/bin/perl -X

use JSON::XS;
use Data::Freq;
use Data::Printer;
use Data::Dumper;
use IO::Capture::Stdout;
use WWW::Wikipedia;
use Statistics::Basic qw(mean);
use Getopt::Long;

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




our %opts = (dumpdir        => "/mnt/myramdisk/incomming/",cmd=>"freq",search=>"");

GetOptions (\%opts, "dumpdir=s","cmd=s","search=s");



if($opts{'search'} eq ""){
  print " please call with option's";
  p @{["--cmd  freq","--cmd  relation","--cmd  build","--cmd  file"]};
  
}


my $wiki = WWW::Wikipedia->new();


sub  decruft  {
  my($file)  =  @_;
  my($cruftSet)  =  q{%Â§&|#[^+*(  ]),'";  };
  my  $clean  =  $file;
  $clean=~s/\Q$_//g  for  split("",$cruftSet);

  return  $clean;
}


sub rel {
  my $arg = shift;
  my $result = $wiki->search($opts{"search"});
  my @return = ();
  if (defined($result) && $result->text() ) {

    return $result->related();
    
    
  }
  return @return;
  
}



  sub freq {
    my $arg = shift;
    my $result = $wiki->search($arg);
     
    my @buffer = ();
    
    if (defined($result) && $result->text() ) {
      my @set = $result->related();
      my $data = Data::Freq->new();
      foreach my $n( @set){
        $n =~s/ /_/g;
        $data->add($n);         
       }

   
      my $capture =  IO::Capture::Stdout->new;
          $capture->start;

    $data->output();


    $capture->stop();
    @buffer = grep{/\w|\d/}$capture->read;
    
      
    }

    return @buffer;
   # my @num = grep{/\d/}@buffer;
    
    
    #return  (mean(@num),@buffer);
  }


  sub buildMicro {
    my $arg = shift;
    my $mod = shift;
       $mod = 0 unless $mod;
    my $main = {"name"=>$arg,"children"=>[]};
    my $new = {"name"=>"","size"=>0};
    

    my @all = freq($arg);
      

    #my $mean = shift @all;
    my @freq = @all;
    
    $new = {"name"=>"","size"=>0};
    
    foreach my $line (@freq){
     
     if($line =~ m/\d/){
      $new->{size} = $line;
     }else{
       $new->{name} = $line;
       $new->{name} = decruft($new->{name});
       if($mod ==1)
        {
          $new->{children} = [buildMicro($new->{name},$mod++)];
        }

        
     #  unless ($mod && $new->{size}<=$mean);
      #  my @keys = keys %{$new->{children}};
       #$new->{size} = $#keys;
      # $new->{size} = 1 unless($new->{size}>1);
       #delete $new->{children} unless($new->{size}>1);
       push @{$main->{children}},$new;

       $new = {"name"=>"","size"=>0};

     }
      
     
      
      
    }

    #my $cmd = JSON::XS->new->pretty(0)->encode($main);
    
    return $main;  
  }
  
  sub fread {
    my $fn = shift;
	 	
	 if (-f $fn ) {
       open (IN, "<$fn") || warn "Could not open $fn: $!\n", return (0);
       my @lines = <IN>;
       close IN;

      my @file = split("/",$fn);

      
       
       my $child = {"name"=>pop @file,"size"=>$#lines,"children"=>[]};

       my @xxx = ();
       my $new = {"name"=>"","size"=>0};
       foreach(@lines){
         chomp;
         $new = {"name"=>"","size"=>0};

         @xxx = split(" ",$_);

         $new->{size} = shift @xxx;
         $new->{size} = 1 unless($new->{size}>0);
         $new->{name} = pop @xxx;
         $new->{name} =~ s/.json//g;
         $new->{name} = decruft($new->{name});
         push @{$child->{children}},$new unless($new->{name}=~/total/);
         
       }

       my $cmd = JSON::XS->new->pretty(0)->encode($child);

       return $cmd;
       
    }
}




  print fread($opts{"search"}) unless($opts{"cmd"}!~/file/);
  print rel($opts{"search"})  unless($opts{"cmd"}!~/rel/);  
  print freq($opts{"search"}) unless($opts{"cmd"}!~/freq/);

  if($opts{"cmd"}=~/build/){

     
    my $cmd = $memd->get(sprintf("%s%s",$opts{"cmd"},$opts{"search"}));
    if(!$cmd){
      my $set = buildMicro($opts{"search"},1);
         $memd->set(sprintf("%s%s",$opts{"cmd"},$opts{"search"}),$set);
	  $cmd = JSON::XS->new->pretty(0)->encode($set);
    }


    print  $cmd;
  }
       
   
   

1;
__DATA__
