# -*- perl -*-

# Copyright (c) 2009 AdCopy
# Author: Jeff Weisberg
# Created: 2009-Apr-13 12:34 (EDT)
# Function: defs
#
# $Id: Conf.pm,v 1.4 2010/12/27 19:03:10 jaw Exp $

package AC::Yenta::Conf;
use AC::Yenta::SixtyFour;
use AC::Import;
use strict;

our @EXPORT = qw(timet_to_yenta_version_factor timet_to_yenta_version);

my $TTVF = x64_one_million();


# deprecated
sub timet_to_yenta_version_factor {
    return $TTVF;
}

sub timet_to_yenta_version {
    my $t = shift;

    return unless defined $t;
    return $t * $TTVF unless ref $TTVF;

    # math::bigint does not like to multiply floats
    my $ti = int $t;
    my $tf = $t - $ti;

    return $ti * $TTVF + int($TTVF->numify() * $tf);
}

1;
