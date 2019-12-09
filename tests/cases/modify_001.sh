#!/usr/bin/env perl

use strict;
use warnings;
use Data::Compare;
use Data::Dumper;
use OPTiMaDe::Filter::Parser;
use Scalar::Util qw(blessed);

$Data::Dumper::Sortkeys = 1;

my $parser = new OPTiMaDe::Filter::Parser;
my $tree = $parser->parse_string( 'a >= 5 OR b <= 2 AND c > 10' );

my $tree_now = OPTiMaDe::Filter::modify( $tree,
    sub {
        my( $node ) = @_;
        if( blessed $node && $node->isa( OPTiMaDe::Filter::Comparison:: ) ) {
            $node->{operator} =~ s/([<>])=/$1/;
        }
        return $node;
    } );

print Dumper $tree_now;
