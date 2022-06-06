package OPTIMADE::Filter::True;

use strict;
use warnings;

use parent 'OPTIMADE::Filter::Modifiable';

# VERSION

sub new {
    my( $class ) = @_;
    return bless {}, $class;
}

sub to_filter
{
    return 'TRUE';
}

sub to_SQL
{
    die "no SQL representation\n";
}

sub modify
{
    my $self = shift;
    my $code = shift;

    return $code->( $self, @_ );
}

1;
