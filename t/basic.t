use utf8;
use strict;
use Test::More;
use Data::Section::Simple qw(get_data_section);

use_ok("Text::SimpleTable::UTF8");

# Catalyst
{
    my $params = {
        hello      => "goodbye",
        こんにちは => "さようなら",
    };
    my $column_width = 10;
    my $t = Text::SimpleTable::UTF8->new( [ 35, 'Parameter' ], [ $column_width, 'Value' ] );
    for my $key ( sort keys %$params ) {
        my $param = $params->{$key};
        my $value = defined($param) ? $param : '';
        $t->row( $key, ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
    }
    is( "\n".$t->draw, "\n".get_data_section('good01') );
}

{
    my $params = {
        hello      => "goodbye",
        こんにちは => "さようなら",
    };
    my $column_width = 3;
    my $t = Text::SimpleTable::UTF8->new( [ 35, 'Parameter' ], [ $column_width, 'Value' ] );
    for my $key ( sort keys %$params ) {
        my $param = $params->{$key};
        my $value = defined($param) ? $param : '';
        $t->row( $key, ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
    }
    is( "\n".$t->draw, "\n".get_data_section('good02') );
}

{
    my $params = {
        hello      => "goodbye",
        こんにちは => "さyoうなら",
    };
    my $column_width = 4;
    my $t = Text::SimpleTable::UTF8->new( [ 35, 'Parameter' ], [ $column_width, 'Value' ] );
    for my $key ( sort keys %$params ) {
        my $param = $params->{$key};
        my $value = defined($param) ? $param : '';
        $t->row( $key, ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
    }
    is( "\n".$t->draw, "\n".get_data_section('good03') );
}

done_testing();

__DATA__

@@ good01
.-------------------------------------+------------.
| Parameter                           | Value      |
+-------------------------------------+------------+
| hello                               | goodbye    |
| こんにちは                          | さようなら |
'-------------------------------------+------------'
@@ good02
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
@@ good03
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
