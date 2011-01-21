# -*- perl -*-

# Copyright (c) 2009 AdCopy
# Author: Jeff Weisberg
# Created: 2009-Mar-30 10:19 (EDT)
# Function: 
#
# $Id: Server.pm,v 1.8 2010/12/07 17:56:07 jaw Exp $

package AC::Yenta::Kibitz::Status::Server;
use AC::Yenta::Debug 'status_server';
use strict;


sub handler {
    my $class   = shift;
    my $io      = shift;
    my $proto   = shift;
    my $gpb     = shift;
    my $content = shift;


    if( $gpb ){
        AC::Yenta::Kibitz::Status::update_sceptical( $gpb );
    }

    unless( $proto->{want_reply} ){
        $io->shut();
        return;
    }

    # respond with all known peers
    my $response = AC::Yenta::Kibitz::Status::response();
    my $yp  = AC::Yenta::Protocol->new();

    my $hdr = $yp->encode_header(
        type		=> 'yenta_status',
        data_length	=> length($response),
        content_length  => 0,
        msgid		=> $proto->{msgid},
        is_reply	=> 1,
       );

    debug("sending status reply");
    $io->write_and_shut( $hdr . $response );
}

1;
