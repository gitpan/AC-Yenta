# -*- perl -*-

# Copyright (c) 2009 AdCopy
# Author: Jeff Weisberg
# Created: 2009-Mar-30 10:20 (EDT)
# Function: exchange status info via gossip protocol
#
# $Id: Status.pm,v 1.16 2010/09/07 15:31:56 jaw Exp $

package AC::Yenta::Kibitz::Status;
use AC::Yenta::Kibitz::Status::Server;
use AC::Yenta::Kibitz::Status::Client;
use AC::Yenta::Debug 'kibitz_status';
use AC::Yenta::Config;
use AC::Yenta::Stats;
use AC::Yenta::MySelf;
use AC::Misc;

use Sys::Hostname;
use Socket;
require 'AC/protobuf/yenta_status.pl';
use strict;


my $HOSTNAME = hostname();
my $ipinfo;

################################################################

sub _myself {

    my $maps = conf_value('map');

    unless( $ipinfo ){
        my $natinfo = my_network_info();
        for my $i ( @$natinfo ){
            push @$ipinfo, { ipv4 => inet_atoi($i->{ipa}), port => AC::Yenta::Status->my_port(), natdom => $i->{natdom} };
        }
    }

    return {
        hostname	=> $HOSTNAME,
        datacenter	=> my_datacenter(),
        subsystem	=> 'yenta',
        environment	=> conf_value('environment'),
        via		=> AC::Yenta::Status->my_server_id(),
        server_id	=> AC::Yenta::Status->my_server_id(),
        instance_id	=> AC::Yenta::Status->my_instance_id(),
        path		=> '.',
        status		=> 200,
        uptodate	=> AC::Yenta::Store::AE->up_to_date(),
        timestamp   	=> $^T,
        lastup		=> $^T,
        ip		=> $ipinfo,
        map		=> [ keys %$maps ],
        sort_metric	=> loadave() * 1000,
    };
}


################################################################

sub myself {

    # tell server about ourself
    return ACPYentaStatusRequest->encode({
        myself => _myself(),
    });
}

sub response {

    # send client everything we know
    my @peer = AC::Yenta::Status->allpeers();
    push @peer, _myself();
    # add the items we monitor
    push @peer, AC::Yenta::Monitor::export();

    return ACPYentaStatusReply->encode({
        status	=> \@peer,
    });
}

################################################################

# do not believe a client that says it is up
# put it on the sceptical queue, and check for ourself
sub update_sceptical {
    my $gpb = shift;

    return unless $gpb;
    my $c;
    eval {
        $c = ACPYentaStatusRequest->decode( $gpb );
        $c = $c->{myself};
    };
    if(my $e = $@){
        problem("cannot decode status data: $e");
        return;
    }

    my $id = $c->{server_id};

    # don't track myself
    return if AC::Yenta::Status->my_server_id() eq $id;

    AC::Yenta::Status->update_sceptical($id, $c);
}

sub update {
    my $gpb = shift;

    return unless $gpb;
    my $c;
    eval {
        $c = ACPYentaStatusReply->decode( $gpb );
    };
    if(my $e = $@){
        problem("cannot decode status data: $e");
        return;
    }

    debug("rcvd update");
    my $myself = AC::Yenta::Status->my_server_id();

    for my $up (@{$c->{status}}){
        my $id = $up->{server_id};
        next if $up->{via} eq $myself;
        next if $id eq $myself;
        AC::Yenta::Status->update($id, $up);
    }
}

# unable to connect to server. mark it down
sub isdown {
    my $id = shift;

    return unless $id;

    AC::Yenta::Status->isdown( $id );
}
1;
