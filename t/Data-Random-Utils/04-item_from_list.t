use strict;
use warnings;

use Data::Random::Utils qw(item_from_list);
use English;
use Error::Pure::Utils qw(clean);
use List::Util 1.45 qw(uniq);
use Test::More 'tests' => 46;
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

# Test.
@input = ('one');
my $output;
my $ret = item_from_list(\@input, \$output);
is($ret, undef, 'item_from_list() returns undef.');
is($output, 'one', 'Set right value in output scalar variable (one).');

# Test.
@input = ('one');
$output = item_from_list(\@input);
is($output, 'one', 'Set right value in output scalar variable (one via return).');

# Test.
@input = ('one');
eval {
	item_from_list(\@input, {});
};
is($EVAL_ERROR, "Not supported output reference.\n",
	"Not supported output reference (hash ref).");
clean();
