package OPTiMaDe::FilterParser::Identifier;

use strict;
use warnings;

sub new {
    my( $class, $name ) = @_;
    return bless { name => $name }, $class;
}

1;
