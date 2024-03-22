use strict;
use warnings;

use Data::Random::Utils qw(item_from_list);
use List::Util 1.45 qw(uniq);
use Test::More 'tests' => 42;
use Test::NoWarnings;

# Test.
my @input = ('one', 'three', 'two');
my @output;
foreach my $num (1 .. 20) {
	my $ret = item_from_list(\@input, \@output);
	is($ret, undef, $num.' round.');
	is(@output, $num, 'Number of items: '.$num.' in output ('.$output[-1].').');
}
my @uniq = sort { $a cmp $b } uniq(@output);
is_deeply(
	\@input,
	\@uniq,
	'All items are in output.',
);
