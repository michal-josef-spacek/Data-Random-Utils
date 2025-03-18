use strict;
use warnings;

use Data::Random::Utils qw(item_from_list_remove);
use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 10;
use Test::NoWarnings;

# Test.
my @input = ('one', 'three', 'two');
my @output;
is(scalar @input, 3, 'Initial state of input (3 items).');
is(scalar @output, 0, 'Initial state of output (0 items).');
my $ret = item_from_list_remove(\@input, \@output);
is(scalar @input, 2, 'Input after first round (2 items).');
is(scalar @output, 1, 'Output after first round (1 item).');
$ret = item_from_list_remove(\@input, \@output);
is(scalar @input, 1, 'Input after second round (1 item).');
is(scalar @output, 2, 'Output after second round (2 items).');
$ret = item_from_list_remove(\@input, \@output);
is(scalar @input, 0, 'Input after third round (0 items).');
is(scalar @output, 3, 'Output after third round (3 items).');

# Test.
@input = ('one');
eval {
	item_from_list_remove(\@input, {});
};
is($EVAL_ERROR, "Not supported output reference.\n",
	"Not supported output reference (hash ref).");
clean();
