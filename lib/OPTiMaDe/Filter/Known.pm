package OPTiMaDe::Filter::Known;

use strict;
use warnings;

sub new {
    my( $class, $is_known, $property ) = @_;
    return bless { is_known => $is_known, property => $property }, $class;
}

sub is_known
{
    my( $self, $is_known ) = @_;
    my $previous_is_known = $self->{is_known};
    $self->{is_known} = $is_known if defined $is_known;
    return $previous_is_known;
}

sub property
{
    my( $self, $property ) = @_;
    my $previous_property = $self->{property};
    $self->{property} = $property if defined $property;
    return $previous_property;
}

sub to_filter
{
    my( $self ) = @_;
    return $self->property->to_filter . ' IS ' .
           ($self->is_known ? 'KNOWN' : 'UNKNOWN');
}

sub to_SQL
{
    my( $self, $options ) = @_;

    my( $sql, $values ) = $self->property->to_SQL( $options );
    $sql = "$sql IS " . ($self->is_known ? 'NOT NULL' : 'NULL');
    if( wantarray ) {
        return ( $sql, $values );
    } else {
        return $sql;
    }
}

sub modify
{
    my $self = shift;
    my $code = shift;

    $self->property( OPTiMaDe::Filter::modify( $self->property, $code, @_ ) );
    return $code->( $self, @_ );
}

1;
