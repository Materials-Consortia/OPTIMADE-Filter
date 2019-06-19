package OPTiMaDe::FilterParser::ListComparison;

use strict;
use warnings;
use Scalar::Util qw(blessed);

sub new {
    my( $class, $operator ) = @_;
    return bless { identifier => undef,
                   operator => $operator,
                   values => undef }, $class;
}

sub set_identifier {
    my( $self, $identifier ) = @_;
    $self->{identifier} = $identifier;
}

sub set_operator {
    my( $self, $operator ) = @_;
    $self->{operator} = $operator;
}

sub set_values {
    my( $self, $values ) = @_;
    $self->{values} = $values;
}

1;
