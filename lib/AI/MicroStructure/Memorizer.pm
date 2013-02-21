#!/usr/bin/perl -W
package AI::MicroStructure::Memorizer;
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use File::Spec;
use Data::Dumper;
use Search::ContextGraph;
use Cache::Memcached::Fast;
my $count;
my %known_ips;
my %known_names;
my @output;
my @thread;
my $thread_support;
my @common_cnames;
my $threads;
my $book= "";
$count = 0;

# try and load thread modules, if it works import their functions
BEGIN {
  eval {
    require threads;
    require threads::shared;
    require Thread::Queue;
    $thread_support = 1;
  };
  if ($@) { # got errors, no ithreads :(
    $thread_support = 0;
  } else { #safe to haul in the threadding functions
    import threads;
    import threads::shared;
    import Thread::Queue;
  }
}

# turn errors back on
BEGIN {
  $SIG{__DIE__}  = 'DEFAULT';
  $SIG{__WARN__} = 'DEFAULT';
}


sub threadSupport{
    my $self = shift;
    my $bookpath = shift;

  my @books = $self->getBookList($bookpath);
  my $buffer={};

  if ($threads) {
    share($count);
    share(%known_ips);
    share(%known_names);
    share(@output);
    my $stream = new Thread::Queue;
    foreach my $book (@books) {

      $stream->enqueue($book);
    }
    for (0..$threads) {
      my $kid = new threads($self->store($book), $stream);
      $stream->enqueue(undef); #for each thread
    }
    foreach my $thread (threads->list) {
     $thread->join if ($thread->tid && !threads::equal($thread, threads->self));
    }
  } else {
    foreach my $book (@books) {
      $self->search($book);
    }
  }
  # write to file any output generated by child threads
  print  @output;

}


sub search {

  my $self= shift;
  my $namehex = "";
  my $upstream;
  my $tid;
  my $resbf;
  if ($threads && threads->self->tid()) {
    $upstream = shift;
    $tid      = threads->self->tid();
    $resbf    = 1;
    warn $tid;
  } else {
    $resbf = 0;
  }

my $i=0;
my  $returns = {};
my  $content = {};
my $name="";
      # only runs once if not threaded
  while (my $search_item = $threads ? $upstream->dequeue : shift) {

    $namehex = md5_hex($search_item);

    next if($search_item eq "." || $search_item eq "..");

    $content = $self->{cache}->retrieve($namehex);
    $name = sprintf("%s",$search_item);

    if(defined($content->{body})){

      $returns->{$namehex} =
        {subject => $content->{subject},
         body    => $content->{body},
         name    => $name,
         md5hex  => $namehex};

    }else{

      $content  = $self->catfile($_);

      $returns->{$namehex} =
        {subject=>$content->{subject},
         body=>$content->{body},
         name=>$name,
         md5hex=>$namehex};

      $self->{cache}->store($namehex,$content);

    }


    $self->{booknames}->{$namehex}=$name;

    $self->{chaps}->{$namehex} = {subject=>$content->{subject},
                      body=>$content->{body}};
  # print $search_item."\n";
    return  $self->{chaps};


  }
}


sub new {
  my $this = shift;
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);

  return $self;
}

sub initialize {
  my $self = shift;
  %$self=@_;

  $self->{cache} =   new Cache::Memcached::Fast({
      servers => [ { address => 'localhost:11211',
                     weight => 2.5 }],
      namespace => 'my:',
      connect_timeout => 0.2,
      io_timeout => 0.5,
      close_on_error => 1,
      compress_threshold => 100_000,
      compress_ratio => 0.9,
      compress_methods =>
       [ \&IO::Compress::Gzip::gzip,
         \&IO::Uncompress::Gunzip::gunzip ],
      max_failures => 3,
      failure_timeout => 2,
      ketama_points => 150,
      nowait => 1,
      hash_namespace => 1,
      serialize_methods => [ \&Storable::freeze,
                             \&Storable::thaw ],
      utf8 => ($^V ge v5.8.1 ? 1 : 0),
      max_size => 4*512 * 1024,
  });




#AI::MicroStructure::Driver::Memcached->new();


  $self->{context} = Search::ContextGraph->new( use_file  => $self->{contextgraph}, auto_reweight => 0);

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


sub catfile{
  my $self = shift;
  my $file=shift;
     return unless($file);

my $path = sprintf("%s/%s",$self->{bookpath},$file);
#  print $path;
  my $cat = {};
  my @cat = map{
               my @x = split(":",$_);
                  $_ = $self->trim($x[1]);
               }split("\n",
    `microdict $path | data-freq --limit 500`);

  $cat->{subject} = [@cat[0..10]];
  $cat->{body}    = [@cat];

  return $cat;

}



sub store{

my $self = shift;
my $xname = shift;
my    $content = {};
my    $namehex = md5_hex($xname);
      $content = $self->{cache}->retrieve($namehex);


    if(defined($content->{body})){

      $self->{returns}->{$namehex} =
        {subject => $content->{subject},
         body    => $content->{body},
         name    => $xname,
         md5hex  => $namehex};

    }else{

      $content  = $self->catfile($_);

      $self->{returns}->{$namehex} =
        {subject=>$content->{subject},
         body=>$content->{body},
         name=>$xname,
         md5hex=>$namehex};

      $self->{cache}->store($namehex,$content);

    }



}
sub getBookList{

  my $self = shift;
  my $dir  = shift;

  $dir = $self->{bookpath}      unless defined($dir);
  die "$dir is not a directory" unless -d $dir;
  opendir(DIR, $dir) or die $!;

  my @mp3s = grep { $_ = sprintf("%s",$_);  }
              sort grep /^[\x20-\x7E]+$/,
              readdir(DIR);

  closedir DIR;

  return @mp3s;
}

sub analyseBookNames{

  my $self = shift;
  my $bookpath = shift;
  my $returns = {};
  my @books = $self->getBookList($bookpath);
  my @data = ();
  my $content = {};
  my $name = "";
  my $namehex = "";



  foreach(@books) {
    $content = {};
    $namehex = md5_hex($_);

    next if($_ eq "." || $_ eq "..");

    $content = $self->{cache}->retrieve($namehex);
    $name = sprintf("%s",$_);

    if(defined($content->{body})){

      $returns->{$namehex} =
        {subject => $content->{subject},
         body    => $content->{body},
         name    => $name,
         md5hex  => $namehex};

    }else{

      $content  = $self->catfile($_);

      $returns->{$namehex} =
        {subject=>$content->{subject},
         body=>$content->{body},
         name=>$name,
         md5hex=>$namehex};

      $self->{cache}->store($namehex,$content);

    }

    next if($name=~/dvd/);

    $self->{booknames}->{$namehex}=$name;

    $self->{chaps}->{$namehex} = {subject=>$content->{subject},
                      body=>$content->{body}};


  }


  return $returns;

}




sub perform_standard_tests {

  my $self = shift;
     $self->analyseBookNames();

  my $booklist = $self->{chaps};

   foreach my $k ( reverse sort { $b cmp $a } keys %{$self->{chaps}}){
   if(defined($k)){
      my @sub = @{$booklist->{$k}->{subject}};
      my @body = @{$booklist->{$k}->{body}};


      $self->{out} .= sprintf("%s\t[s=%d,b=%d]\t%s\n",$k,$#sub,$#body,$self->{booknames}->{$k});


      if($#body>0){
        $self->{context}->add_document($self->{booknames}->{$k}, \@body);
      }
    }
  }


  return $self->{chaps};


}
sub getTermList{
  my $self = shift;
  return $self->{context}->term_list;


}

sub query_simple_search{

    my $self = shift;

    my $term = shift;

    return $self->{context}->simple_search($term);

}



sub query_similareDocs {

        my $self = shift;
        my $term = shift;

        $self->{out}="";

        my @ranked_docs = $self->simple_search($term);

        my ($s1,$s2) = $self->{context}->find_similar(@ranked_docs);

        #print Dumper $s2;
        foreach (sort {$a cmp $b} keys %$s1)
        {
          next unless($s1->{$_}>=0.75);

          $self->{out} .=  sprintf("\n%s = %s",$_, $s1->{$_});
        }

          $self->{out} .=  sprintf "\n<br>\n<b>compute strong similar terms</b>";

        #print Dumper $s2;
        foreach (sort {$a cmp $b} keys %$s2)
        {
          next unless($s2->{$_}>=0.75);

        $self->{out} .=  sprintf("\n%s = %s",$_, $s2->{$_});
        }


$self->{out} .=  sprintf "\n<br>\n<b>worndnet suport / compute strong similar terms</b>";

        #print Dumper $s2;
        foreach (sort {$a cmp $b} keys %$s2)
        {
          next unless($s2->{$_}>=0.75);

$self->{out} .=  sprintf("\n(%s%s)\n%3.3f",sprintf($self->trim(`micro-wnet $_`)),$_,$s2->{$_});
        }


    return $self->{out};
}

sub query_simple_intersection{

    my $self = shift;

    my @terms = @_;

    my @ranked_docs = $self->{context}->intersection(terms=>@terms);

    return \@ranked_docs;
}

sub query_simple_mixed{

    my $self = shift;

    my @terms =  shift;

    my ( $docs, $words ) = $self->{context}->mixed_search(
        { docs=>[$self->{context}->doc_list],
         terms => [@terms]});

    return ( $docs, $words );

}

sub sampleRun{

    my $self = shift;
    my $intrest = {};


    $intrest->{base}="physics";
    $intrest->{second}=lc `micro`;

    $intrest->{base}=~s/_|\n/ /g;
    $intrest->{second}=~s/_|\n/ /g;

    my @ranked_docs = $self->{context}->simple_search($intrest->{base});



    my $out = "";
$self->{out} .=  sprintf "<hr/><h1>%s only</h1>\n",$intrest->{base};

  printf Dumper [
      $self->{context}->intersection(
        terms => [$intrest])];

$self->{out} .=  sprintf "<hr/><h1>%s + %s</h1>\n",$intrest->{base},$intrest->{second};

printf Dumper [
      $self->{context}->intersection(
        terms => [$intrest->{base},$intrest->{second}])];


$self->{out} .=  sprintf "<hr/><h1>%s + %s + synthetic</h1>\n",$intrest->{base},$intrest->{second};
$self->{out} .=  sprintf Dumper [
      $self->{context}->intersection(
        terms => [$intrest->{base},$intrest->{second}] )];

$self->{out} .=  sprintf "<hr/><h1>drill down</h1>\n\n";


    @ranked_docs = $self->{context}->intersection(
      terms=>[$intrest->{base},$intrest->{second}]);

$self->{out} .=  sprintf
      "<hr/><h1>intersection[programming,computer]".
      "</h1>\n\n",
      join "<br />\n",@ranked_docs;

$self->{out} .=  sprintf "<hr/><h1>mixed_search on intersection</h1>\n\n";

    my ( $docs, $words ) =
      $self->{context}->mixed_search(
        {docs=>[@ranked_docs],
         terms => ['genetic',
                   'dreaming',
                   'evolutionary']});

        my $similarToAi = {};

         # Print out result set of returned documents
         foreach my $k ( sort { $docs->{$b} <=> $docs->{$a} }
             keys %{ $docs } ) {

             if($docs->{$k}>=100.01) {

            $self->{out} .=  sprintf "alpha\trelevance ",
                  $docs->{$k},"\tDoc ",$k,"\n";

            }elsif($docs->{$k}<=101.0 && $docs->{$k}>=100.0){

            $self->{out} .=  sprintf "dominant\trelevance",
                   $docs->{$k},"\tDoc ",$k,  "\n";

            }
         }

        push @ranked_docs , $self->{context}->simple_search({
          docs=>[$self->{context}->doc_list] ,
          terms=>['programming']});


#        print Dumper @ranked_docs;

      $self->{out} .=   sprintf "<hr/><h1>simple_search on fuzzy $#ranked_docs</h1>".
              "\n<br>\n<b>compute strong similar docs</b>";

        #$self->{context}->reweight_graph();

        my ($s1,$s2) = $self->{context}->find_similar(@ranked_docs);

        #print Dumper $s2;
        foreach (sort {$a cmp $b} keys %$s1)
        {
          next unless($s1->{$_}>=0.75);

$self->{out} .=  sprintf("\n%s = %s",$_, $s1->{$_});
        }

$self->{out} .=  sprintf "\n<br>\n<b>compute strong similar terms</b>";

        #print Dumper $s2;
        foreach (sort {$a cmp $b} keys %$s2)
        {
          next unless($s2->{$_}>=0.75);

        $self->{out} .=  sprintf("\n%s = %s",$_, $s2->{$_});
        }


$self->{out} .=  sprintf "\n<br>\n<b>worndnet suport / compute strong similar terms</b>";

        #print Dumper $s2;
        foreach (sort {$a cmp $b} keys %$s2)
        {
          next unless($s2->{$_}>=0.995);

$self->{out} .=  sprintf("\n(%s=%3.3f)",$_,$s2->{$_});
        }

return $self->{out};

    }

sub getDocList{
  my $self = shift;
  return $self->{context}->doc_list;

}


1;

# ABSTRACT: this is part of AI-MicroStructure the package handels relations between concepts


=head1 NAME

  AI::MicroStructure::Memorizer

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

=cut

__END__
__DATA__


package main;
use Data::Printer;
my $configure = {};
my $memo   = AI::MicroStructure::Memorizer->new();
$memo->getBookList();
p $memo
__DATA__


  new Cache::Memcached::Fast({
      servers => [ { address => 'localhost:11211',
                     weight => 2.5 }],
      namespace => 'my:',
      connect_timeout => 0.2,
      io_timeout => 0.5,
      close_on_error => 1,
      compress_threshold => 100_000,
      compress_ratio => 0.9,
      compress_methods =>
       [ \&IO::Compress::Gzip::gzip,
         \&IO::Uncompress::Gunzip::gunzip ],
      max_failures => 3,
      failure_timeout => 2,
      ketama_points => 150,
      nowait => 1,
      hash_namespace => 1,
      serialize_methods => [ \&Storable::freeze,
                             \&Storable::thaw ],
      utf8 => ($^V ge v5.8.1 ? 1 : 0),
      max_size => 4*512 * 1024,
  });

