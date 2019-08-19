#!/usr/bin/env perl

use strict;
use warnings;
use Data::Compare;
use Data::Dumper;
use OPTiMaDe::FilterParser;
use Scalar::Util qw(blessed);

$Data::Dumper::Sortkeys = 1;

my $parser = new OPTiMaDe::FilterParser;
my $tree = $parser->parse_string( 'a >= 5 OR b <= 2 AND c > 10' );

my $tree_now = OPTiMaDe::FilterParser::modify( $tree,
    sub {
        my( $node ) = @_;
        if( blessed $node && $node->isa( OPTiMaDe::FilterParser::Comparison:: ) ) {
            $node->{operator} =~ s/([<>])=/$1/;
        }
        return $node;
    } );

print Dumper $tree_now;
