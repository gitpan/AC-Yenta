# -*- perl -*-

# Copyright (c) 2009 AdCopy
# Author: Jeff Weisberg
# Created: 2009-Mar-30 18:39 (EDT)
# Function: interface with Berkeley DB
#
# $Id: BDBI.pm,v 1.16 2010/09/07 15:31:58 jaw Exp $

package AC::Yenta::Store::BDBI;
use AC::Yenta::Debug 'bdbi';
use BerkeleyDB;
use strict;

AC::Yenta::Store::Map->add_backend( bdb 	=> 'AC::Yenta::Store::BDBI' );
AC::Yenta::Store::Map->add_backend( berkeley 	=> 'AC::Yenta::Store::BDBI' );

sub new {
    my $class = shift;
    my $name  = shift;
    my $conf  = shift;

    my $file  = $conf->{dbfile};
    unless( $file ){
        problem("no dbfile specified for '$name'");
        return;
    }

    my $dir = $file;
    $dir =~ s|/[^/]+$||;

    debug("opening Berkeley dir=$dir, file=$file");
    my $env = BerkeleyDB::Env->new(
        -Home       => $dir,
        -Flags      => DB_CREATE| DB_INIT_CDB | DB_INIT_MPOOL
       );

    my $db = BerkeleyDB::Btree->new(
        -Filename   => $file,
        -Env        => $env,
        -Flags      => DB_CREATE,
       );

    problem("cannot open db file $file") unless $db;

    # web server will need access
    chmod 0666, $file;

    return bless {
        dir	=> $dir,
        file	=> $file,
        db	=> $db,
    }, $class;
}

sub get {
    my $me  = shift;
    my $map = shift;
    my $sub = shift;
    my $key = shift;

    my $v;
    debug("get $map/$sub/$key");
    my $r = $me->{db}->db_get( _key($map,$sub,$key), $v );

    return if $r; # not found

    if( wantarray ){
        return ($v, 1);
    }
    return $v;
}

sub put {
    my $me  = shift;
    my $map = shift;
    my $sub = shift;
    my $key = shift;
    my $val = shift;

    debug("put $map/$sub/$key");

    my $r = $me->{db}->db_put( _key($map,$sub,$key), $val);
    return !$r;
}

sub del {
    my $me  = shift;
    my $map = shift;
    my $sub = shift;
    my $key = shift;

    $me->{db}->db_del( _key($map,$sub,$key));
}

sub sync {
    my $me  = shift;

    $me->{db}->db_sync();
}

sub range {
    my $me  = shift;
    my $map = shift;
    my $sub = shift;
    my $key = shift;
    my $end = shift;	# undef => to end of map

    my ($k, $v, @k);
    my $cursor = $me->{db}->db_cursor();
    $k = _key($map,$sub,$key);
    my $e = _key($map,$sub,$end);
    $cursor->c_get($k, $v, DB_SET_RANGE);

    while( !$end || ($k lt $e) ){
        debug("range $k");
        last unless $k =~ m|$map/$sub/|;
        $k =~ s|$map/$sub/||;
        push @k, { k => $k, v => $v };
        my $r = $cursor->c_get($k, $v, DB_NEXT);
        last if $r;	# error
    }
    $cursor->c_close();

    return @k;
}

################################################################

sub _key {
    my $map = shift;
    my $sub = shift;
    my $key = shift;

    return "$map/$sub/$key";
}

1;
