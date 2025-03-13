use strict;
use warnings;

use Data::Random::Utils qw(is_object_currently_valid);
use DateTime;
use Test::MockObject;
use Test::More 'tests' => 5;
use Test::NoWarnings;

# Test.
my $obj = Test::MockObject->new;
$obj->mock('valid_from', sub {
	return DateTime->new(
		'day' => 1,
		'month' => 1,
		'year' => 2024,
	);
});
$obj->mock('valid_to', sub { return; });
my $ret = is_object_currently_valid($obj);
is($ret, 1, 'Is valid? (valid_from is time before my, valid_to undef).');

# Test.
$obj = Test::MockObject->new;
$obj->mock('valid_from', sub {
	return DateTime->new(
		'day' => 1,
		'month' => 1,
		'year' => 5024,
	);
});
$obj->mock('valid_to', sub { return; });
$ret = is_object_currently_valid($obj);
is($ret, 0, 'Is valid? (valid_from is time after my, valid_to undef).');

# Test.
$obj = Test::MockObject->new;
$obj->mock('valid_from', sub {
	return DateTime->new(
		'day' => 1,
		'month' => 1,
		'year' => 2024,
	);
});
$obj->mock('valid_to', sub {
	return DateTime->new(
		'day' => 1,
		'month' => 2,
		'year' => 2024,
	);
});
$ret = is_object_currently_valid($obj);
is($ret, 0, 'Is valid? (valid_from/valid_to are in time before my).');

# Test.
$obj = Test::MockObject->new;
$obj->mock('valid_from', sub {
	return DateTime->new(
		'day' => 1,
		'month' => 1,
		'year' => 2024,
	);
});
$obj->mock('valid_to', sub {
	return DateTime->now->add(days => 1);
});
$ret = is_object_currently_valid($obj);
is($ret, 1, 'Is valid? (valid_from is time before my and valid_to is time after my).');
