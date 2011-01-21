# -*- perl -*-
# example myself

# $Id: myself.pm,v 1.1 2011/01/12 19:43:54 jaw Exp $

package Local::Yenta::MySelf;
use Sys::Hostname;
use strict;

my $SERVERID;

sub init {
    my $class = shift;
    my $port  = shift;	# our tcp port
    my $id    = shift;  # from cmd line

    $SERVERID = $id;
    unless( $SERVERID ){
        (my $h = hostname()) =~ s/\.example.com//;	# remove domain
        $SERVERID = "yenta/$h";
    }
    verbose("system persistent-id: $SERVERID");
}

sub my_server_id {
    return $SERVERID;
}

1;

