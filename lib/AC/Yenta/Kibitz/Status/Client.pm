# -*- perl -*-

# Copyright (c) 2009 AdCopy
# Author: Jeff Weisberg
# Created: 2009-Mar-30 10:20 (EDT)
# Function: 
#
# $Id: Client.pm,v 1.12 2010/12/07 19:11:42 jaw Exp $

package AC::Yenta::Kibitz::Status::Client;
use AC::Yenta::Protocol;
use AC::Yenta::Config;
use AC::Yenta::Debug 'status_client';
use AC::Yenta::IO::TCP::Client;
use strict;
our @ISA = 'AC::Yenta::IO::TCP::Client';


my $HDRSIZE = AC::Yenta::Protocol->header_size();
my $TIMEOUT = 2;
my $msgid   = $$;

sub new {
    my $class = shift;

    debug('starting kibitz status client');
    my $me = $class->SUPER::new( @_ );
    return unless $me;

    $me->set_callback('timeout',  \&timeout);
    $me->set_callback('read',     \&read);
    $me->set_callback('shutdown', \&shutdown);

    return $me;
}

sub start {
    my $me = shift;

    $me->SUPER::start();

    # build request
    my $yp  = AC::Yenta::Protocol->new();
    my $pb  = AC::Yenta::Kibitz::Status::myself();
    my $hdr = $yp->encode_header(
        type		=> 'yenta_status',
        data_length	=> length($pb),
        content_length	=> 0,
        want_reply	=> 1,
        msgid		=> $msgid++,
       );

    # write request
    $me->write( $hdr . $pb );
    $me->timeout_rel($TIMEOUT);
    return $me;
}


sub timeout {
    my $me = shift;
    $me->shut();
}

sub shutdown {
    my $me = shift;

    unless( $me->{status_ok} ){
        AC::Yenta::Kibitz::Status::isdown( $me->{status_peer} );
    }
}

sub read {
    my $me  = shift;
    my $evt = shift;

    debug("recvd reply");

    my $yp = AC::Yenta::Protocol->new( secret => conf_value('secret') );
    my($proto, $data, $content) = $yp->read_protocol( $me, $evt );
    return unless $proto;

    $me->{status_ok} = 1;
    AC::Yenta::Kibitz::Status::update( $data );

    $me->shut();
}


1;
