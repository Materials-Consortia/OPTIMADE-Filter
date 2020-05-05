#!/usr/bin/perl

use Math::BigInt;
use Data::Dumper;
use OPTIMADE::Filter::Comparison;
use OPTIMADE::Filter::Property;
use Test::More tests => 3;

my $clause = OPTIMADE::Filter::Comparison->new( '=' );
$clause->left( OPTIMADE::Filter::Property->new( 'column' ) );
$clause->right( Math::BigInt->new( '1' ) );

my( $SQL, $values ) = $clause->to_SQL( { placeholder => '?' } );
is( $SQL, '(\'column\' = ?)' );
ok( $values->[0]->isa( Math::BigInt:: ) );
is( $values->[0] . '', '1' );
