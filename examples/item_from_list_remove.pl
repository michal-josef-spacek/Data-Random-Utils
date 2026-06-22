#!/usr/bin/env perl

use strict;
use warnings;

use Data::Random::Utils qw(item_from_list_remove);

my @input = ('foo');
my @output;

item_from_list_remove(\@input, \@output);

print "Removed value: $output[0]\n";
print "Items left: ".scalar @input."\n";

# Output:
# Removed value: foo
# Items left: 0