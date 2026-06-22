#!/usr/bin/env perl

use strict;
use warnings;

use Data::Random::Utils qw(item_from_list);

my @input = ('foo');
my @output;
my $scalar;

my $return_value = item_from_list(\@input);
item_from_list(\@input, \@output);
item_from_list(\@input, \$scalar);

print "Return value: $return_value\n";
print "Array value: $output[0]\n";
print "Scalar value: $scalar\n";

# Output:
# Return value: foo
# Array value: foo
# Scalar value: foo