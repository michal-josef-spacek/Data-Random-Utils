package Data::Random::Utils;

use base qw(Exporter);
use strict;
use warnings;

use List::Util 1.33 qw(any);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(item_from_list uniq_item_from_list);

our $VERSION = 0.01;

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
