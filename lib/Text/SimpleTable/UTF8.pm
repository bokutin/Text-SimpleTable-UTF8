package Text::SimpleTable::UTF8;
# ABSTRACT: Text::SimpleTable でUTF8が崩れることがあるのを直します。

use strict;
use base qw(Text::SimpleTable);
use Scalar::Util qw(reftype);
use Text::VisualWidth::PP;

our $TOP_LEFT      = '.-';
our $TOP_BORDER    = '-';
our $TOP_SEPARATOR = '-+-';
our $TOP_RIGHT     = '-.';

# Middle
our $MIDDLE_LEFT      = '+-';
our $MIDDLE_BORDER    = '-';
our $MIDDLE_SEPARATOR = '-+-';
our $MIDDLE_RIGHT     = '-+';

# Left
our $LEFT_BORDER  = '| ';
our $SEPARATOR    = ' | ';
our $RIGHT_BORDER = ' |';

# Bottom
our $BOTTOM_LEFT      = "'-";
our $BOTTOM_SEPARATOR = "-+-";
our $BOTTOM_BORDER    = '-';
our $BOTTOM_RIGHT     = "-'";

# Wrapper
our $WRAP = '-';


sub draw {
    my $self = shift;

    # Shortcut
    return unless $self->{columns};

    my $rows    = @{$self->{columns}->[0]->[1]} - 1;
    my $columns = @{$self->{columns}} - 1;
    my $output  = '';

    # Top border
    for my $j (0 .. $columns) {

        my $column = $self->{columns}->[$j];
        my $width  = $column->[0];
        my $text   = $TOP_BORDER x $width;

        if (($j == 0) && ($columns == 0)) {
            $text = "$TOP_LEFT$text$TOP_RIGHT";
        }
        elsif ($j == 0)        { $text = "$TOP_LEFT$text$TOP_SEPARATOR" }
        elsif ($j == $columns) { $text = "$text$TOP_RIGHT" }
        else                   { $text = "$text$TOP_SEPARATOR" }

        $output .= $text;
    }
    $output .= "\n";

    my $title = 0;
    for my $column (@{$self->{columns}}) {
        $title = @{$column->[2]} if $title < @{$column->[2]};
    }

    if ($title) {

        # Titles
        for my $i (0 .. $title - 1) {

            for my $j (0 .. $columns) {

                my $column = $self->{columns}->[$j];
                my $width  = $column->[0];
                my $text   = $column->[2]->[$i] || '';

                #$text = sprintf "%-${width}s", $text;
                #warn "|$text|";
                $text = $text . (' ' x ($width - Text::VisualWidth::PP::width($text)));

                if (($j == 0) && ($columns == 0)) {
                    $text = "$LEFT_BORDER$text$RIGHT_BORDER";
                }
                elsif ($j == 0) { $text = "$LEFT_BORDER$text$SEPARATOR" }
                elsif ($j == $columns) { $text = "$text$RIGHT_BORDER" }
                else                   { $text = "$text$SEPARATOR" }

                $output .= $text;
            }

            $output .= "\n";
        }

        # Title separator
        $output .= $self->_draw_hr;

    }

    # Rows
    for my $i (0 .. $rows) {

        # Check for hr
        if (!grep { defined $self->{columns}->[$_]->[1]->[$i] } 0 .. $columns)
        {
            $output .= $self->_draw_hr;
            next;
        }

        for my $j (0 .. $columns) {

            my $column = $self->{columns}->[$j];
            my $width  = $column->[0];
            my $text = (defined $column->[1]->[$i]) ? $column->[1]->[$i] : '';

            #$text = sprintf "%-${width}s", $text;
            $text = $text . (' ' x ($width - Text::VisualWidth::PP::width($text)));

            if (($j == 0) && ($columns == 0)) {
                $text = "$LEFT_BORDER$text$RIGHT_BORDER";
            }
            elsif ($j == 0)        { $text = "$LEFT_BORDER$text$SEPARATOR" }
            elsif ($j == $columns) { $text = "$text$RIGHT_BORDER" }
            else                   { $text = "$text$SEPARATOR" }

            $output .= $text;
        }

        $output .= "\n";
    }

    # Bottom border
    for my $j (0 .. $columns) {

        my $column = $self->{columns}->[$j];
        my $width  = $column->[0];
        my $text   = $BOTTOM_BORDER x $width;

        if (($j == 0) && ($columns == 0)) {
            $text = "$BOTTOM_LEFT$text$BOTTOM_RIGHT";
        }
        elsif ($j == 0) { $text = "$BOTTOM_LEFT$text$BOTTOM_SEPARATOR" }
        elsif ($j == $columns) { $text = "$text$BOTTOM_RIGHT" }
        else                   { $text = "$text$BOTTOM_SEPARATOR" }

        $output .= $text;
    }

    $output .= "\n";

    return $output;
}

sub _wrap {
    my ($self, $text, $width) = @_;

    my @cache;
    my @parts = split "\n", $text;

    for my $part (@parts) {

        while (Text::VisualWidth::PP::width($part) > $width) {
            my $subtext;
            #$subtext = substr $part, 0, $width - length($WRAP), '';
            $subtext = Text::VisualWidth::PP::trim($part, $width - Text::VisualWidth::PP::width($WRAP));
            substr $part, 0, length($subtext), '';
            push @cache, "$subtext$WRAP";
        }

        push @cache, $part if defined $part;
    }

    return \@cache;
}

# http://cpansearch.perl.org/src/MRAMBERG/Text-SimpleTable-2.03/lib/Text/SimpleTable.pm
#sub _wrap {
#    my ($self, $text, $width) = @_;
#
#    my @cache;
#    my @parts = split "\n", $text;
#
#    for my $part (@parts) {
#
#        while (length $part > $width) {
#            my $subtext;
#            $subtext = substr $part, 0, $width - length($WRAP), '';
#            push @cache, "$subtext$WRAP";
#        }
#
#        push @cache, $part if defined $part;
#    }
#
#    return \@cache;
#}

1;
