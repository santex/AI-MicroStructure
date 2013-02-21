# Make output flow in sync
$| = 1;

# Hide debug output and print verbose output to STDOUT
# Test::Harness hides output on STDOUT which starts with '#'
# unless verbose=1, so all this output is hidden by default.
my $_show_debug = $Zim::DEBUG || $ENV{ZIM_DEBUG};
my $_verbose =
	qr/^\s*(#|Searching|Indexing|Updating|Updated|Exporting|WARNING)/;
$SIG{__WARN__} = sub {
	if    ($_show_debug)       { print STDOUT @_ }
	elsif ($_[0] =~ /^##/)     { return          }
	elsif ($_[0] =~ $_verbose) { print STDOUT @_ }
	else                       { print STDERR @_ }
};

# Try to catch attempts to load modules for the Zim namespace outside
# the test directory. This should detect references to modules that have
# been removed or renamed.
my ($_i) = grep {$INC[$_] =~ /\b_build\b/} 0 .. $#INC;
if (defined $_i) {
	splice @INC, $_i+1, 0, sub {
		my (undef, $filename) = @_;
		warn "Attempt to use \"$filename\" which is not in this package\n" if $filename =~ /^Zim/;
		return undef;
	} ;
}
#use Data::Dumper; warn Dumper \@INC;

# Set XDG environment 
# make modules find local files and hide system 
$ENV{XDG_CONFIG_HOME} = './t/config/';
$ENV{XDG_CONFIG_DIRS} = './non_existing_path/';
$ENV{XDG_DATA_HOME}   = './t/share/';
$ENV{XDG_DATA_DIRS}   = './share/';
	# should be "./blib/share" but test run before building share
$ENV{XDG_CACHE_HOME}  = './t/cache/';


for my $d (
	't/share',
	't/share/mime',
	't/share/applications'
) {
	next if -d $d;
	mkdir $d or die $!;
}
for my $f (
	't/share/mime/globs',
	't/share/applications/mimeinfo.cache'
) {
	next if -f $f;
	open FOO, '>', $f or die $!;
	print FOO "\n";
	close FOO;
}

# Package to generate new empty object classes. These are used in tests 
# to instantiate mock objects. So each mock object has it's own unique class.
# You can pass methods, attributes and parent classes to the constructor.
#
# Usage:
#
# my $object = Mock::Object->new(
#     ISA => 'Foo::Bar',
#     method1 => sub { .. },
#     attrib1 => 'Foo!'
# );

package Mock::Object;

use strict;
no strict 'refs';

our $I = 1;

sub new {
	my ($class, %param) = @_;
	my $isa = delete($param{ISA}) || '';
	my $package = $class . $I++;
	eval << "EOC";
package $package;

use strict;
use vars qw/\$AUTOLOAD/;

our \%_METHODS_;
our \@ISA = qw/$isa/;

sub AUTOLOAD {
	\$AUTOLOAD =~ s/.*:://;
	return \$_METHODS_{\$AUTOLOAD}->(\@_)
		if exists \$_METHODS_{\$AUTOLOAD};
	return (); # all methods exist by default !
}
1;
EOC
	die $@ if $@;
	my $methods = \%{"$package\:\:_METHODS_"};
	$$methods{$_} = delete $param{$_}
		for grep {ref($param{$_}) eq 'CODE'} keys %param;
	bless \%param, $package;
}

1;

