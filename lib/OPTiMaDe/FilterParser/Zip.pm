package OPTiMaDe::FilterParser::Zip;

use strict;
use warnings;
use Scalar::Util qw(blessed);

sub new {
    my( $class ) = @_;
    return bless { properties => [],
                   operator => undef,
                   values => [] }, $class;
}

sub push_property {
    my( $self, $property ) = @_;
    push @{$self->{properties}}, $property;
}

sub unshift_property {
    my( $self, $property ) = @_;
    unshift @{$self->{properties}}, $property;
}

sub set_operator {
    my( $self, $operator ) = @_;
    $self->{operator} = $operator;
}

sub set_values {
    my( $self, $values ) = @_;
    $self->{values} = $values;
}

sub to_filter {
    my( $self ) = @_;

    my @zip_list;
    foreach my $zip (@{$self->{values}}) {
        my @zip;
        for my $i (0..$#$zip) {
            my( $operator, $arg ) = @{$zip->[$i]};
            if( blessed $arg && $arg->can( 'to_filter' ) ) {
                $arg = $arg->to_filter;
            } else {
                $arg =~ s/\\/\\\\/g;
                $arg =~ s/"/\\"/g;
                $arg = "\"$arg\"";
            }
            push @zip, "$operator $arg";
        }
        push @zip_list, join( ' : ', @zip );
    }

    return '(' . join( ':', map { $_->to_filter } @{$self->{properties}} ) .
                 ' ' . $self->{operator} . ' ' .
                 join( ', ', @zip_list ) . ')';
}

sub modify
{
    my( $self, $code ) = @_;

    $self->{properties} = [ map { $_->modify( $code ) } @{$self->{properties}} ];
    $self->{values} = [ map { [ OPTiMaDe::FilterParser::modify( $_->[0], $code ),
                                OPTiMaDe::FilterParser::modify( $_->[1], $code ) ] }
                            @{$self->{values}} ];
    return $code->( $self );
}

1;
