package OPTiMaDe::FilterParser::Identifier;

use strict;
use warnings;

sub new {
    my( $class, $name ) = @_;
    return bless { name => $name }, $class;
}

sub to_SQL
{
    my( $self, $delim ) = @_;
    $delim = "'" unless $delim;

    return "${delim}$self->{name}${delim}";
}

1;
