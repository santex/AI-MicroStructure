#!/usr/bin/perl
use strict;
use utf8;
use List::AllUtils qw( shuffle );
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';


$|++;

use constant POCO_HTTP => "ua";
use POE qw(Component::Client::HTTP);

my @urls = [qw(http://www.latest-ufo-sightings.net)];

our @youtubecodes = ();
our @links;
my $TOP = "ufo";

POE::Component::Client::HTTP->spawn(Alias => POCO_HTTP, Timeout => 30);
POE::Component::My::Master->spawn(UA => POCO_HTTP, TODO => @urls);
$poe_kernel->run;
exit 0;

BEGIN {
  package POE::Component::My::Master;
  use POE::Session;             # for constants

  sub spawn {
    my $class = shift;
    POE::Session->create
        (package_states =>
         [$class => [qw(_start ready done)]],
         heap => {KIDMAX => 8, KIDS => 0, @_});
  }

  sub _start {
    my $heap = $_[HEAP];
    for (@{$heap->{TODO}}) {
      $heap->{DONE}{$_ = make_canonical($_)} = 1;
    }
    $_[KERNEL]->yield("ready", "initial");
  }

  sub ready {
    ## warn "ready because $_[ARG0]\n";
    my $heap = $_[HEAP];
    my $kernel = $_[KERNEL];
    return if $heap->{KIDS} >= $heap->{KIDMAX};
    return unless my $url = shift @{$heap->{TODO}};
    ## warn "doing: $url\n";
    $heap->{KIDS}++;
    POE::Component::My::Checker->spawn
        (UA => $heap->{UA},
         URL => $url,
         POSTBACK => $_[SESSION]->postback("done", $url),
        );
    $kernel->yield("ready", "looping");
  }

  sub done {
    my $heap = $_[HEAP];
    my ($request,$response) = @_[ARG0,ARG1];

    my ($url) = @$request;
    my @links = @{$response->[0]};

    for my $n (@links) {
      if($n!~/max-results/){
      $n .="?max-results=5999";
      }else{
            $n =~ s/results=/results=99/g;

        }
      $n = make_canonical($n);
      push @{$heap->{TODO}}, $n;
#        unless $heap->{DONE}{$_}++;
    }

    $heap->{KIDS}--;
    $_[KERNEL]->yield("ready", "child done");
  }

  sub make_canonical {          # not a POE
    require URI;
    my $uri = URI->new(shift);
    $uri->fragment(undef);      # toss fragment
    $uri->canonical->as_string; # return value
  }

}                               # end POE::Component::My::Master

BEGIN {
  package POE::Component::My::Checker;
  use POE::Session;
  use Data::Printer;
  use WWW::YouTube::Download;

  if(-f "/tmp/codes"){

  }else{
    system("echo ''>/tmp/codes");
  }

  sub spawn {
    my $class = shift;
    POE::Session->create
        (package_states =>
         [$class => [qw(_start response)]],
         heap => {@_});
  }

  sub _start {
    require HTTP::Request::Common;
    my $heap = $_[HEAP];
    my $url = $heap->{URL};
    my $request = HTTP::Request::Common::GET($url);
    $_[KERNEL]->post($heap->{UA}, 'request', 'response', $request);
  }



sub test_video_id {
    my ($input) = @_;
    return video_id($input);
}




    sub video_id {
      my $stuff = shift;
      if ($stuff =~ m{/.*?[?&;!]v=([^&#?=/;]+)}) {
          return $1;
      }
      elsif ($stuff =~ m{/(?:e|v|embed)/([^&#?=/;]+)}) {
          return $1;
      }
      elsif ($stuff =~ m{#p/(?:u|search)/\d+/([^&?/]+)}) {
          return $1;
      }
      elsif ($stuff =~ m{youtu.be/([^&#?=/;]+)}) {
          return $1;
      }
      else {
          return $stuff;
      }
  }


  sub response {
    my $url = $_[HEAP]{URL};
    my ($request_packet, $response_packet) = @_[ARG0, ARG1];
    my ($request, $request_tag) = @$request_packet;
    my ($response) = @$response_packet;



    if ($response->is_success) {
        if ($response->content_type eq "text/html") {
          require HTML::SimpleLinkExtor;
          my $e = HTML::SimpleLinkExtor->new($response->base);
          my $content = $response->content;
          $e->parse($content);

          @links = grep m{^http:}, $e->links;
           my $vidurl = "youtube.com/embed";



          warn "doing on: $url\n";

          foreach(grep{/$vidurl/}@links){


            my $a = $_;
            $a =~ s/http:\/\/www\.youtube.*.[\/].*(watch|embed)*.[\/](.?)/$1/gi;
            $a = substr($a,0,11);

            print $_."\t$a\n";

            system("echo $_>>/tmp/codes");




          }


          my @img = grep m{^http:}, $e->img;
#           warn $#links."\n";
           print "\n". join("\n",grep{/$TOP/}@img)unless(!@img);
           @img = grep{/$TOP/}@img;
           @img = grep{!/ico|^fb*|logo|button|user|placehold|mail|loading|twitter|webs|rss|right|left|top|bottom|header|banner|add|campaign|icon/ui}@img;


           map{`wget $_ &`}@img;

#           map{`wget $_ &`}@links;
        } else {
#           warn "not HTML: $url\n";
        }
    } else {
#      warn "BAD (", $response->code, "): $url\n";
    }

    if(-f "/tmp/codesu"){}else{
       system("echo '' > /tmp/codesu");
    }
    system("cat /tmp/codes | sort -u > /tmp/codesu;");
   # system("mv /tmp/codesu /tmp/codes;");
    $_[HEAP]{POSTBACK}(\@links);
  }

}

BEGIN {

  use Data::Printer;

  my $pwd=sprintf `pwd`;

  print $pwd;
    $pwd =~ s/^\s+//;
    $pwd =~ s/\s+$//;
    $pwd =~ s/\t//;
    $pwd =~ s/^\s//;

  foreach(qw(png gif jpg  jpeg)){
    system("for u in \$(ls $pwd/*.$_.*[0-9]);do mv \$u \$u.$_; done");
  }
`for i in \$(ls * | egrep -i "*\.[1-9]\.*(png|jpg|gif)"); do rm \$i; done`;
push @ARGV,  [shuffle split("\n",`mm=\$(mech-dump --links http://www.latest-ufo-sightings.net);  echo -e "\$mm\n"  | egrep "^http.*.html\$"`)];


p @ARGV;

}


END {


  my $pwd=sprintf `pwd`;

  print $pwd;
    $pwd =~ s/^\s+//;
    $pwd =~ s/\s+$//;
    $pwd =~ s/\t//;
    $pwd =~ s/^\s//;

  foreach(qw(png gif jpg  jpeg)){
    system("for u in \$(ls $pwd/*.$_.*[0-9]);do mv \$u \$u.$_; done");
  }



 exit(0);
}

1;
__DATA__
package WWW::YouTube::Download;

use strict;
use warnings;
use 5.008001;

our $VERSION = '0.45';

use Carp ();
use URI ();
use LWP::UserAgent;
use JSON;
use HTML::Entities qw/decode_entities/;

use constant DEFAULT_FMT => 18;

my $base_url = 'http://www.youtube.com/watch?v=';
my $info     = 'http://www.youtube.com/get_video_info?video_id=';

sub new {
    my $class = shift;
    my %args = @_;
    $args{ua} = LWP::UserAgent->new(
        agent      => __PACKAGE__.'/'.$VERSION,
        parse_head => 0,
    ) unless exists $args{ua};
    bless \%args, $class;
}

for my $name (qw[video_id video_url title user fmt fmt_list suffix]) {
    no strict 'refs';
    *{"get_$name"} = sub {
        use strict 'refs';
        my ($self, $video_id) = @_;
        Carp::croak "Usage: $self->get_$name(\$video_id|\$watch_url)" unless $video_id;
        my $data = $self->prepare_download($video_id);
        return $data->{$name};
    };
}

sub playback_url {
    my ($self, $video_id, $args) = @_;
    Carp::croak "Usage: $self->playback_url('[video_id|video_url]')" unless $video_id;
    $args ||= {};

    my $data = $self->prepare_download($video_id);
    my $fmt  = $args->{fmt} || $data->{fmt} || DEFAULT_FMT;
    my $video_url = $data->{video_url_map}{$fmt}{url} || Carp::croak "this video has not supported fmt: $fmt";

    return $video_url;
}

sub download {
    my ($self, $video_id, $args) = @_;
    Carp::croak "Usage: $self->download('[video_id|video_url]')" unless $video_id;
    $args ||= {};

    my $data = $self->prepare_download($video_id);

    my $fmt = $args->{fmt} || $data->{fmt} || DEFAULT_FMT;

    my $video_url = $data->{video_url_map}{$fmt}{url} || Carp::croak "this video has not supported fmt: $fmt";
    $args->{filename} ||= $args->{file_name};
    my $filename = $self->_format_filename($args->{filename}, {
        video_id   => $data->{video_id},
        title      => $data->{title},
        user       => $data->{user},
        fmt        => $fmt,
        suffix     => $data->{video_url_map}{$fmt}{suffix} || _suffix($fmt),
        resolution => $data->{video_url_map}{$fmt}{resolution} || '0x0',
    });

    $args->{cb} = $self->_default_cb({
        filename  => $filename,
        verbose   => $args->{verbose},
        overwrite => defined $args->{overwrite} ? $args->{overwrite} : 1,
    }) unless ref $args->{cb} eq 'CODE';

    my $res = $self->ua->get($video_url, ':content_cb' => $args->{cb});
    Carp::croak "!! $video_id download failed: ", $res->status_line if $res->is_error;
}

sub _format_filename {
    my ($self, $filename, $data) = @_;
    return "$data->{video_id}.$data->{suffix}" unless defined $filename;
    $filename =~ s#{([^}]+)}#$data->{$1} || "{$1}"#eg;
    return $filename;
}

sub _is_supported_fmt {
    my ($self, $video_id, $fmt) = @_;
    my $data = $self->prepare_download($video_id);
    $data->{video_url_map}{$fmt}{url} ? 1 : 0;
}

sub _default_cb {
    my ($self, $args) = @_;
    my ($file, $verbose, $overwrite) = @$args{qw/filename verbose overwrite/};

    Carp::croak "file exists! $file" if -f $file and !$overwrite;
    open my $wfh, '>', $file or Carp::croak $file, " $!";
    binmode $wfh;

    print "Downloading `$file`\n" if $verbose;
    return sub {
        my ($chunk, $res, $proto) = @_;
        print $wfh $chunk; # write file

        if ($verbose || $self->{verbose}) {
            my $size = tell $wfh;
            my $total = $res->header('Content-Length');
            printf "%d/%d (%.2f%%)\r", $size, $total, $size / $total * 100;
            print "\n" if $total == $size;
        }
    };
}

sub prepare_download {
    my ($self, $video_id) = @_;
    Carp::croak "Usage: $self->prepare_download('[video_id|watch_url]')" unless $video_id;
    $video_id = _video_id($video_id);

    return $self->{cache}{$video_id} if ref $self->{cache}{$video_id} eq 'HASH';

    local $Carp::CarpLevel = $Carp::CarpLevel + 1;

    my $content       = $self->_get_content($video_id);
    my $title         = $self->_fetch_title($content);
    my $user          = $self->_fetch_user($content);
    my $video_url_map = $self->_fetch_video_url_map($content);

    my $fmt_list = [];
    my $sorted = [
        map {
            push @$fmt_list, $_->[0]->{fmt};
            $_->[0]
        } sort {
            $b->[1] <=> $a->[1]
        } map {
            my $resolution = $_->{resolution};
            $resolution =~ s/(\d+)x(\d+)/$1 * $2/e;
            [ $_, $resolution ]
        } values %$video_url_map,
    ];

    my $hq_data = $sorted->[0];

    return $self->{cache}{$video_id} = {
        video_id      => $video_id,
        video_url     => $hq_data->{url},
        title         => $title,
        user          => $user,
        video_url_map => $video_url_map,
        fmt           => $hq_data->{fmt},
        fmt_list      => $fmt_list,
        suffix        => $hq_data->{suffix},
    };
}

sub _fetch_title {
    my ($self, $content) = @_;

    my ($title) = $content =~ /<meta name="title" content="(.+?)">/ or return;
    return decode_entities($title);
}

sub _fetch_user {
    my ($self, $content) = @_;

    my ($user) = $content =~ /<span\s+?">([^<]+)<\/span>/ or return;
    return decode_entities($user);
}

sub _fetch_video_url_map {
    my ($self, $content) = @_;

    local $Carp::CarpLevel = $Carp::CarpLevel + 1;

    my $args = $self->_get_args($content);

}

sub _get_content {
    my ($self, $video_id) = @_;

    local $Carp::CarpLevel = $Carp::CarpLevel + 1;

    my $url = "$base_url$video_id";
    my $res = $self->ua->get($url);
    Carp::croak "GET $url failed. status: ", $res->status_line if $res->is_error;

    return $res->content;
}

sub _get_args {
    my ($self, $content) = @_;

    my $data;
    for my $line (split "\n", $content) {
        next unless $line;
        #if ($line =~ /^\s*yt\.playerConfig\s*=\s*({.*})/) {
            $data = JSON->new->utf8(1)->decode($line);
            p $data;
            last;
        #}
    }

    Carp::croak 'failed to extract JSON data.' unless $data->{args};

    return $data->{args};
}

sub _video_id {
    my $stuff = shift;
    if ($stuff =~ m{/.*?[?&;!]v=([^&#?=/;]+)}) {
        return $1;
    }
    elsif ($stuff =~ m{/(?:e|v|embed)/([^&#?=/;]+)}) {
        return $1;
    }
    elsif ($stuff =~ m{#p/(?:u|search)/\d+/([^&?/]+)}) {
        return $1;
    }
    elsif ($stuff =~ m{youtu.be/([^&#?=/;]+)}) {
        return $1;
    }
    else {
        return $stuff;
    }
}

1;
__END__

=head1 NAME
=cut
