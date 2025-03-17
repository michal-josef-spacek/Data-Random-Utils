package Data::Random::Utils;

use base qw(Exporter);
use strict;
use warnings;

use DateTime;
use Error::Pure qw(err);
use List::Util 1.33 qw(any);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(is_object_currently_valid item_from_list
	uniq_item_from_list);

our $VERSION = 0.04;

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

	my $index = int(rand(scalar @{$input_ar}));
	my $ret;
	if (! defined $output_ref) {
		$ret = $input_ar->[$index];
	} elsif (ref $output_ref eq 'ARRAY') {
		push @{$output_ref}, $input_ar->[$index];
	} elsif (ref $output_ref eq 'SCALAR') {
		${$output_ref} = $input_ar->[$index];
	} else {
		err 'Not supported output reference.',
			'Reference', (ref $output_ref),
		;
	}

	return $ret;
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

1;

__END__
