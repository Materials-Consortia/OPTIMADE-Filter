#!/usr/bin/env perl

use strict;
use warnings;
use Data::Compare;
use Data::Dumper;
use OPTIMADE::Filter::Modifiable;
use OPTIMADE::Filter::Parser;
use Scalar::Util qw(blessed);
use Test::More tests => 1;

$Data::Dumper::Sortkeys = 1;

my $parser = new OPTIMADE::Filter::Parser;
my $tree = $parser->parse_string( 'value.list HAS ALL "a", "b", "c"' );

my $tree_now = OPTIMADE::Filter::Modifiable::modify( $tree,
    sub {
        my( $node ) = @_;
        if( blessed $node && $node->isa( OPTIMADE::Filter::ListComparison:: ) ) {
            my @values = @{$node->{values}};
            my $node_now;
            while( @values ) {
                my $value = shift @values;
                my $comparison = OPTIMADE::Filter::Comparison->new( 'CONTAINS' );
                $comparison->push_operand( $node->{property} );
                $comparison->push_operand( $value->left );
                if( $node_now ) {
                    $node_now = [ $node_now, 'AND', $comparison ];
                } else {
                    $node_now = $comparison;
                }
            }
            $node = $node_now;
        }
        return $node;
    } );

my $expected = <<'END';
$VAR1 = [
          [
            bless( {
                     'operands' => [
                                     bless( {
                                              'name' => [
                                                          'value',
                                                          'list'
                                                        ]
                                            }, 'OPTIMADE::Filter::Property' ),
                                     'a'
                                   ],
                     'operator' => 'CONTAINS'
                   }, 'OPTIMADE::Filter::Comparison' ),
            'AND',
            bless( {
                     'operands' => [
                                     $VAR1->[0][0]{'operands'}[0],
                                     'b'
                                   ],
                     'operator' => 'CONTAINS'
                   }, 'OPTIMADE::Filter::Comparison' )
          ],
          'AND',
          bless( {
                   'operands' => [
                                   $VAR1->[0][0]{'operands'}[0],
                                   'c'
                                 ],
                   'operator' => 'CONTAINS'
                 }, 'OPTIMADE::Filter::Comparison' )
        ];
END

is( Dumper( $tree_now ), $expected );
