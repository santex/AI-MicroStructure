use strict;
use warnings;
use Test::More;
use LWP::UserAgent;
use HTML::SimpleLinkExtor;
use Data::Printer;

use feature "say";

my $url = "http://mathworld.wolfram.com/";
my $file = "mathworld_index.html";

my $ignore_extensions = join '|', qw( js css gif );


sub get_topics
{
    my $item = shift;
    my @content = @_;
    my @tmp = ();
    my $extor = make_request($item);
    my @all_content_links = grep { /^\/topics/ && ! /\.$ignore_extensions$/ && s#(?:^/[^/]+)/(.*)$#$1# } $extor->links;
    if ( @content ) {
        my $limit = ($#content > $#all_content_links) ? $#content : $#all_content_links;
        for (0..$limit) {
            if ($content[$_] xor $all_content_links[$_]) {
                push @tmp, $all_content_links[$_];
            }
        }
    }
    else {
        @tmp = @all_content_links;
    }
    return @tmp if -f $item;
    my @links = map { $url.$_ } @tmp;
    return @links;
}

my @links = get_topics($file,());
# say $_ for (@links);
# p @links;

for (@links) {
    say ;
    my @all_links = get_topics($_,@links);
    printf "\t%s\n", $_ for (@all_links);
}

# p @all_links;
# `wget --user-agent=Mozilla5/0 $_` for (@links);

sub make_request
{
    my $request_item = shift;
    my $extor = undef;
    if ( -f $request_item ) {
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

