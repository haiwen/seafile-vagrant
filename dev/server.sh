#!/bin/bash

set -e

DATADIR=/vagrant/data
SRCDIR=/vagrant/src
VMIP=172.16.90.100

. /etc/default/seafile-server


init() {
    mkdir -p $DATADIR
    [[ -f $CCNET_CONF_DIR/ccnet.conf ]] || ccnet-init -c $CCNET_CONF_DIR --name vagrant-vm --port 10001 --host $VMIP
    [[ -f $SEAFILE_CONF_DIR/seafile.conf ]] || seaf-server-init --seafile-dir $SEAFILE_CONF_DIR
}

_terminate() {
    for name in $@; do
        pkill -f $name || true
    done
}

ccnet_server=$SRCDIR/ccnet/net/server/ccnet-server
seaf_server=$SRCDIR/seafile/server/seaf-server
fileserver=$SRCDIR/seafile/fileserver/fileserver

run_pro() {
    seaf_server=$SRCDIR/seafile-priv/server/seaf-server
    fileserver=$SRCDIR/seafile-priv/fileserver/fileserver
    run;
}

run() {
    _terminate ccnet-server seaf-server fileserver

    $ccnet_server -c $CCNET_CONF_DIR -d
    sleep 3
    $seaf_server -c $CCNET_CONF_DIR -d $SEAFILE_CONF_DIR
    if [[ -f $fileserver ]]; then
        $fileserver -c $CCNET_CONF_DIR -d $SEAFILE_CONF_DIR
    fi
}

gc() {
    seafserv-gc -c $CCNET_CONF_DIR -d $SEAFILE_CONF_DIR
}


main() {
    local action=$1; shift
    case $action in
        init) init "$@"
              ;;
        run) run "$@"
             ;;
        run_pro) run_pro "$@"
             ;;
        gc) gc "$@"
             ;;
        *) echo "WARNING: no action found"
           ;;
    esac
}


main "$@"
