package Data::Random::Utils;

use base qw(Exporter);
use strict;
use warnings;

use DateTime;
use List::Util 1.33 qw(any);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(is_object_currently_valid item_from_list
	uniq_item_from_list);

our $VERSION = 0.02;

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
	my ($input_ar, $output_ar) = @_;

	my $index = int(rand(scalar @{$input_ar}));
	push @{$output_ar}, $input_ar->[$index];

	return;
}

sub uniq_item_from_list {
	my ($input_ar, $output_ar, $cb) = @_;

	if (! $cb) {
		$cb = sub {
			my ($a, $b) = @_;
			return $a eq $b;
		};
	}

	my ($index, $item);
	while (! defined $index
		|| (any { $cb->($item, $_) } @{$output_ar})) {

		$index = int(rand(scalar @{$input_ar}));
		$item = $input_ar->[$index];
	}
	push @{$output_ar}, $item;

	return;
}

1;

__END__
