package OPTiMaDe::FilterParser::Zip;

use strict;
use warnings;

sub new {
    my( $class ) = @_;
    return bless { identifiers => [],
                   operator => undef,
                   values => [] }, $class;
}

sub push_identifier {
    my( $self, $identifier ) = @_;
    push @{$self->{identifiers}}, $identifier;
}

sub unshift_identifier {
    my( $self, $identifier ) = @_;
    unshift @{$self->{identifiers}}, $identifier;
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
