#!/usr/bin/env perl

use strict;
use warnings;

use Data::Random::Utils qw(uniq_item_from_list);

my @input = ('one', 'two', 'three', 'one');
my @output;

uniq_item_from_list(\@input, \@output);
uniq_item_from_list(\@input, \@output);
uniq_item_from_list(\@input, \@output);

print join(', ', sort @output)."\n";

# Output:
# one, three, two