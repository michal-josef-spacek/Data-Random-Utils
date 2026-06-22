#!/usr/bin/env perl

use strict;
use warnings;

package Foo;

use Mo qw(build is);
use Mo::utils 0.08 qw(check_isa);

has valid_from => (
        is => 'ro',
);

has valid_to => (
        is => 'ro',
);

sub BUILD {
        my $self = shift;
        check_isa($self, 'valid_from', 'DateTime');
        check_isa($self, 'valid_to', 'DateTime');
        return;
}

package main;

use Data::Random::Utils qw(is_object_currently_valid);
use DateTime;

# Valid object.
my $act_date = DateTime->now;
my $some_date_before1 = $act_date->clone;
$some_date_before1->subtract('days' => 10);
my $obj1 = Foo->new(
        'valid_from' => $some_date_before1,
);

# Invalid object.
my $some_date_before2 = $act_date->clone;
$some_date_before2->subtract('days' => 5);
my $obj2 = Foo->new(
        'valid_from' => $some_date_before1,
        'valid_to' => $some_date_before2,
);

my $is_object_currently_valid1 = is_object_currently_valid($obj1);
my $is_object_currently_valid2 = is_object_currently_valid($obj2);

# Print out.
print "First object validity: $is_object_currently_valid1\n";
print "Second object validity: $is_object_currently_valid2\n";

# Output:
# First object validity: 1
# Second object validity: 0