package OPTiMaDe::FilterParser::Negation;

use strict;
use warnings;

sub new {
    my( $class, $inner ) = @_;
    return bless { inner => $inner }, $class;
}

sub inner
{
    my( $self, $inner ) = @_;
    my $previous_inner = $self->{inner};
    $self->{inner} = $inner if defined $inner;
    return $previous_inner;
}

sub to_filter
{
    my( $self ) = @_;
    return '(NOT ' . $self->inner->to_filter . ')';
}

sub to_SQL
{
    my( $self, $delim ) = @_;

    return '(NOT ' . $self->inner->to_SQL( $delim ) . ')';
}

sub modify
{
    my $self = shift;
    my $code = shift;

    $self->inner( OPTiMaDe::FilterParser::modify( $self->inner, $code, @_ ) );
    return $code->( $self, @_ );
}

1;
