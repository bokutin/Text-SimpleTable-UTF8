package Text::SimpleTable::UTF8;
# ABSTRACT: Text::SimpleTable でUTF8が崩れることがあるのを直します。

use strict;
use base qw(Text::SimpleTable);
use File::Spec;
use Text::VisualWidth::PP;

{
    my $source = do { open(my $fh, '<', $INC{'Text/SimpleTable.pm'}) or die $!; local $/; <$fh> };

    my @pairs = (
        [
            q|$text = sprintf "%-${width}s", $text;|,
            q|$text = $text . (' ' x ($width - Text::VisualWidth::PP::width($text)));|,
        ],
        [
            q|while (length $part > $width) {|,
            q|while (Text::VisualWidth::PP::width($part) > $width) {|,
        ],
        [
            q|$subtext = substr $part, 0, $width - length($WRAP), '';|,
            q|$subtext = Text::VisualWidth::PP::trim($part, $width - Text::VisualWidth::PP::width($WRAP)); substr $part, 0, length($subtext), '';|,
        ],
    );

    $source =~ s/^package.*//m or die;
    $source =~ s/\Q$_->[0]\E/$_->[1]/mg or die for @pairs;

    eval $source or die $@;
}

1;
