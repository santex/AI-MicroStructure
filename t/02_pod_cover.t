use Test::More;
require 't/env.pm';

eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD coverage" if $@;
all_pod_coverage_ok(
	{ also_private => [ qr/^[A-Z_]+$/, qr/^(on|do|parse|dump)_.*|^init$/ ] } );
