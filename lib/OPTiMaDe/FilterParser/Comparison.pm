package OPTiMaDe::FilterParser::Comparison;

use strict;
use warnings;
use Scalar::Util qw(blessed);

sub new {
    my( $class, $operator ) = @_;
    return bless { operands => [], operator => $operator }, $class;
}

sub set_operator {
    my( $self, $operator ) = @_;
    $self->{operator} = $operator;
}

sub push_operand
{
    my( $self, $operand ) = @_;
    die 'attempt to insert more than two operands' if @{$self->{operands}} >= 2;
    push @{$self->{operands}}, $operand;
}

sub unshift_operand
{
    my( $self, $operand ) = @_;
    die 'attempt to insert more than two operands' if @{$self->{operands}} >= 2;
    unshift @{$self->{operands}}, $operand;
}

sub to_SQL
{
    my( $self, $delim ) = @_;
    $delim = "'" unless $delim;

    my $operator = $self->{operator};
    my @operands;
    for (@{$self->{operands}}) {
        if( !ref $_ ) {
            $_ =~ s/"/""/g;
            $_ = "\"$_\"";
        }
        push @operands, $_;
    }

    # Currently the 2nd operator is quaranteed to be string
    if(      $operator eq 'CONTAINS' ) {
        $operator = 'LIKE';
        $operands[1] =~ s/^"/"%/;
        $operands[1] =~ s/"$/%"/;
    } elsif( $operator =~ /^STARTS( WITH)?$/ ) {
        $operator = 'LIKE';
        $operands[1] =~ s/"$/%"/;
    } elsif( $operator =~ /^ENDS( WITH)?$/ ) {
        $operator = 'LIKE';
        $operands[1] =~ s/^"/"%/;
    }

    return '(' .
           (blessed $operands[0] && $operands[0]->can( 'to_SQL' )
                ? $operands[0]->to_SQL( $delim ) : "$operands[0]") .
           " $operator " .
           (blessed $operands[1] && $operands[1]->can( 'to_SQL' )
                ? $operands[1]->to_SQL( $delim ) : "$operands[1]") .
           ')';
}

1;
