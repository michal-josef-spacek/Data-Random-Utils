package Data::Random::Utils;

use base qw(Exporter);
use strict;
use warnings;

use List::Util 1.33 qw(any);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(uniq_item_from_list);

our $VERSION = 0.01;

sub uniq_item_from_list {
	my ($input_ar, $output_ar) = @_;

	my ($index, $item);
	while (! defined $index
		|| (any { $item eq $_ } @{$output_ar})) {

		$index = int(rand(scalar @{$input_ar}));
		$item = $input_ar->[$index];
	}
	push @{$output_ar}, $item;

	return;
}

1;

__END__
