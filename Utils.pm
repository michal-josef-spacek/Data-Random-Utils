package Data::Random::Utils;

use base qw(Exporter);
use strict;
use warnings;

use DateTime;
use Error::Pure qw(err);
use List::Util 1.33 qw(any);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(is_object_currently_valid item_from_list
	item_from_list_remove uniq_item_from_list);

our $VERSION = 0.06;

sub is_object_currently_valid {
	my $self = shift;

	my $dt_actual = DateTime->now;
	if (DateTime->compare($self->valid_from, $dt_actual) != -1) {
		return 0;
	}
	if (defined $self->valid_to
		&& DateTime->compare($dt_actual, $self->valid_to) == 1) {

		return 0;
	}

	return 1;
}

sub item_from_list {
	my ($input_ar, $output_ref) = @_;

	return _item_from_list($input_ar, $output_ref, sub {
		my ($input_ar, $index) = @_;
		return $input_ar->[$index];
	});
}

sub item_from_list_remove {
	my ($input_ar, $output_ref) = @_;

	return _item_from_list($input_ar, $output_ref, sub {
		my ($input_ar, $index) = @_;
		my $value = splice @{$input_ar}, $index, 1;
		return $value;
	});
}

sub uniq_item_from_list {
	my ($input_ar, $output_ar, $cb) = @_;

	if (! defined $cb) {
		$cb = sub {
			my ($a, $b) = @_;
			return $a eq $b;
		};
	}

	my $item;
	while (! defined $item
		|| (any { $cb->($item, $_) } @{$output_ar})) {

		$item = item_from_list($input_ar);
	}
	push @{$output_ar}, $item;

	return;
}

sub _item_from_list {
	my ($input_ar, $output_ref, $cb) = @_;

	my $index = int(rand(scalar @{$input_ar}));
	my $ret;
	if (! defined $output_ref) {
		$ret = $cb->($input_ar, $index);
	} elsif (ref $output_ref eq 'ARRAY') {
		push @{$output_ref}, $cb->($input_ar, $index);
	} elsif (ref $output_ref eq 'SCALAR') {
		${$output_ref} = $cb->($input_ar, $index);
	} else {
		err 'Not supported output reference.',
			'Reference', (ref $output_ref),
		;
	}

	return $ret;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Data::Random::Utils - Utilities for Data::Random modules.

=head1 SYNOPSIS

 use Data::Random::Utils qw(is_object_currently_valid item_from_list item_from_list_remove uniq_item_from_list);

 my $bool = is_object_currently_valid($self);
 my $value = item_from_list($input_ar, $output_ref);
 my $value = item_from_list_remove($input_ar, $output_ref);
 uniq_item_from_list($input_ar, $output_ar, $cb);

=head1 DESCRIPTION

Common utilities for Data::Random modules.

=head1 SUBROUTINES

=head2 C<is_object_currently_valid>

 my $bool = is_object_currently_valid($self);

This is helper subroutine which check if the data object is valid.

Validity is defined by C<valid_from> and C<valid_to> object parameters/methods
which contain L<DateTime> instance. Valid object is object which has
C<valid_from> oldest than current date and time and C<valid_to> is undefined or
newer than current date. See L<EXAMPLE1> example.

Returns bool (0/1).

=head2 C<item_from_list>

 my $value = item_from_list($input_ar, $output_ref);

Get random item from input C<$input_ar> which is reference to array with items.

There are three possible functionalities:

=over

=item * Return item from subroutine

=item * Save item to C<$output_ref> scalar

=item * Save item to C<$output_ref> array.

=back

The functionality depends on type of C<$output_ref> variable.

Returns value from the list or undef.

=head2 C<item_from_list_remove>

 my $value = item_from_list_remove($input_ar, $output_ref);

Same functionality as L<item_from_list> with removing of item from the input C<$input_ar> which is reference to array with items.

Returns value from the list or undef.

=head2 C<uniq_item_from_list>

 uniq_item_from_list($input_ar, $output_ar, $cb);

Get random item from input C<$input_ar> and push it to output C<$output_ar>
only if there isn't same item in C<$output_ar> already.

Without explicit C<$cb> callback the item uniqueness is checked by string
comparison (C<eq>).

Callback in C<$cb> accepts two items and must return true if they should be
treated as equal. This is useful for complex structures like hashes.

Returns undef.

This subroutine expects there is at least one unique item in C<$input_ar> which
isn't already present in C<$output_ar>. Otherwise it can loop forever.

=head1 ERRORS

 item_from_list():
         Not supported output reference.
                 Reference: %s

 item_from_list_remove():
         Not supported output reference.
                 Reference: %s

=head1 EXAMPLES

=head2 EXAMPLE1

=for comment filename=is_object_currently_valid.pl

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

=head2 EXAMPLE2

=for comment filename=item_from_list.pl

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

=head2 EXAMPLE3

=for comment filename=item_from_list_remove.pl

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

=head2 EXAMPLE4

=for comment filename=uniq_item_from_list.pl

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

=head1 DEPENDENCIES

L<DateTime>,
L<Error::Pure>,
L<Exporter>,
L<List::Util>,
L<Readonly>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Data-Random-Utils>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2024-2026 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.06

=cut
