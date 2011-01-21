# -*- perl -*-

# Copyright (c) 2009 AdCopy
# Author: Jeff Weisberg
# Created: 2009-Apr-13 11:55 (EDT)
# Function: auto-expire old data
#
# $Id: Expire.pm,v 1.8 2010/12/23 19:09:39 jaw Exp $

package AC::Yenta::Store::Expire;
use AC::Yenta::Config;
use AC::Yenta::Debug 'expire';
use AC::Yenta::Conf;
use AC::DC::Sched;
use strict;

AC::DC::Sched->new(
    info	=> 'expire',
    freq	=> 60,
    func	=> \&AC::Yenta::Store::Expire::periodic,
   );

sub periodic {

    my $maps = conf_value('map');
    for my $map (keys %$maps){
        my $cf = conf_map($map);
        next unless $cf->{expire};

        my $expire = timet_to_yenta_version($^T - $cf->{expire});
        debug("running expire from $expire");
        AC::Yenta::Store::store_expire( $map, $expire );
    }
}

################################################################


1;
