use strict;
use warnings;

use Data::Random::Utils;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Data::Random::Utils::VERSION, 0.02, 'Version.');
