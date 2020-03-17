#!/usr/bin/perl

use strict;
use warnings;
use OPTiMaDe::Filter::Property;
use Test::More tests => 2;

my $property = OPTiMaDe::Filter::Property->new( "Some", "Property" );
is( $property->to_filter, 'some.property' );

my $error = '';
eval {
    push @$property, 'HAS SPACES';
    my $filter = $property->to_filter;
    print STDERR $filter;
};
$error = $@ if $@;
ok( $error =~ /^name 'has spaces' does not match/ );
