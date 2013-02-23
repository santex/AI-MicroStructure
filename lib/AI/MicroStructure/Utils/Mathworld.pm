package AI::MicroStructure::Utils::Mathworld;

use strict;
use warnings;
use LWP::UserAgent;
use HTML::SimpleLinkExtor;
use Data::Printer;

use feature "say";

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
                 get_topics
                 make_request
                );

my $url = "http://mathworld.wolfram.com/";

sub get_topics
{
    my $item = shift;
    my $ignore_extensions = join '|', qw( js css gif png );
    my $extor = make_request($item);
    return  map { $_ => 1 } grep { ! /\.$ignore_extensions$/ } $extor->links;
}

sub make_request
{
    my $request_item = shift;
    my $extor = undef;
    $request_item =~ m#^(?:/?[^/]+)/(.*)$#;
    if ( -f $1 || -f $request_item ) {
        $request_item = $1 || $request_item;
        $extor = HTML::SimpleLinkExtor->new();
        $extor->parse_file($request_item);
    }
    else {
        my $ua = LWP::UserAgent->new();
        my $response = $ua->get($request_item);
        # fail if response dosen't succeed
        $extor = HTML::SimpleLinkExtor->new($response->base);
        $extor->parse($response->decoded_content);
    }
    return $extor;
}

1;
__END__
