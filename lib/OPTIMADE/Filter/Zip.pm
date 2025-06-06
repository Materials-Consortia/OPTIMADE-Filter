package OPTIMADE::Filter::Zip;

use strict;
use warnings;

use parent 'OPTIMADE::Filter::Modifiable';
use List::Util qw(any);
use Scalar::Util qw(blessed);

# VERSION

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

sub operator {
    my( $self, $operator ) = @_;
    my $previous_operator = $self->{operator};
    $self->{operator} = $operator if defined $operator;
    return $previous_operator;
}

sub values {
    my( $self, $values ) = @_;
    my $previous_values = $self->{values};
    $self->{values} = $values if defined $values;
    return $previous_values;
}

sub to_filter {
    my( $self ) = @_;
    $self->validate;

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

sub to_SQL
{
    die "no SQL representation\n";
}

sub modify
{
    my $self = shift;
    my $code = shift;

    $self->{properties} = [ map { $_->modify( $code, @_ ) } @{$self->{properties}} ];
    $self->{values} = [ map { [ OPTIMADE::Filter::Modifiable::modify( $_->[0], $code, @_ ),
                                OPTIMADE::Filter::Modifiable::modify( $_->[1], $code, @_ ) ] }
                            @{$self->{values}} ];
    return $code->( $self, @_ );
}

sub validate
{
    my $self = shift;

    if( !$self->{properties} ) {
        die 'properties undefined for OPTIMADE::Filter::Zip';
    }
    if( !$self->operator ) {
        die 'operator undefined for OPTIMADE::Filter::Zip';
    }
    if( !$self->values ) {
        die 'values undefined for OPTIMADE::Filter::Zip';
    }
    if( any { scalar @$_ != scalar @{$self->{properties}} }
            @{$self->values} ) {
        die 'different number of properties and values for OPTIMADE::Filter::Zip';
    }
}

1;
