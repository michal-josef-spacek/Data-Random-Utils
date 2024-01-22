use strict;
use warnings;

use Data::Random::Utils qw(uniq_item_from_list);
use Test::More 'tests' => 8;
use Test::NoWarnings;

# Test.
my @input = ('one', 'two', 'three');
my @output;
my $ret = uniq_item_from_list(\@input, \@output);
is($ret, undef, 'First round.');
is(@output, 1, 'One item in output.');
$ret = uniq_item_from_list(\@input, \@output);
is($ret, undef, 'Second round.');
is(@output, 2, 'Two items in output.');
$ret = uniq_item_from_list(\@input, \@output);
is($ret, undef, 'Third round.');
is(@output, 3, 'Three items in output.');
my @sort_input = sort @input;
my @sort_output = sort @output;
is_deeply(
	\@sort_input,
	\@sort_output,
	'Input and output are same.',
);
