#!/usr/bin/env perl

use strict;
use warnings;
use Data::Compare;
use Data::Dumper;
use OPTiMaDe::FilterParser;
use Scalar::Util qw(blessed);

$Data::Dumper::Sortkeys = 1;

my $parser = new OPTiMaDe::FilterParser;
my $tree = $parser->parse_string( 'value.list HAS ALL "a", "b", "c"' );

my @traverse_order;
OPTiMaDe::FilterParser::modify( $tree,
    sub {
        my( $node, $traverse_order ) = @_;

        push @$traverse_order, $node;
        return $node;
    },
    \@traverse_order );

print Dumper \@traverse_order;
