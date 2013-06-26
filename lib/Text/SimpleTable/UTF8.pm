package Text::SimpleTable::UTF8;
# ABSTRACT: Text::SimpleTable でUTF8が崩れることがあるのを直します。

use strict;
use base qw(Text::SimpleTable);
use File::Spec;
use Text::VisualWidth::PP;
use Unicode::Normalize qw(NFC);

{
    my $source = do { open(my $fh, '<', $INC{'Text/SimpleTable.pm'}) or die $!; local $/; <$fh> };

    my @pairs = (
        [
            q|$text = sprintf "%-${width}s", $text;|,
            q|$text = $text . (' ' x ($width - Text::VisualWidth::PP::width(NFC($text))));|,
        ],
        [
            q|while (length $part > $width) {|,
            q|while (Text::VisualWidth::PP::width(NFC($part)) > $width) {|,
        ],
        [
            q|$subtext = substr $part, 0, $width - length($WRAP), '';|,
            q|$subtext = Text::VisualWidth::PP::trim($part, $width - Text::VisualWidth::PP::width(NFC($WRAP))); substr $part, 0, length($subtext), '';|,
        ],
    );

    $source =~ s/^package.*//m or die;
    $source =~ s/\Q$_->[0]\E/$_->[1]/mg or die for @pairs;

    eval $source or die $@;
}

__END__

=pod

=encoding utf-8

=head1 NAME

Text::SimpleTable::UTF8 - Text::SimpleTable のUTF8対応版です。

=head1 SYNOPSIS

.-------------------------------------+------------.
| Parameter                           | Value      |
+-------------------------------------+------------+
| hello                               | goodbye    |
| こんにちは                          | さようなら |
'-------------------------------------+------------'

.-------------------------------------+-----.
| Parameter                           | Va- |
|                                     | lue |
+-------------------------------------+-----+
| hello                               | go- |
|                                     | od- |
|                                     | bye |
| こんにちは                          | さ- |
|                                     | よ- |
|                                     | う- |
|                                     | な- |
|                                     | ら  |
'-------------------------------------+-----'

.-------------------------------------+------.
| Parameter                           | Val- |
|                                     | ue   |
+-------------------------------------+------+
| hello                               | goo- |
|                                     | dbye |
| こんにちは                          | さy- |
|                                     | oう- |
|                                     | なら |
'-------------------------------------+------'

=cut

1;
