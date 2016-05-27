#!/bin/bash

set -e -x

SRCDIR=/vagrant/src

ALL_PROJECTS="
ninja
libsearpc
ccnet
seafile
seafile-client
"

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH

__autotools() {
    [[ -f configure ]] || ./autogen.sh
    [[ -f Makefile ]] || ./configure "$@"
    make -j2
    sudo make install
}

__cmake() {
    local noinstall
    if [[ $1 == "noinstall" ]]; then
        shift
        noinstall="yes"
    fi
    cmake -GNinja $@ .
    ninja
    if [[ "noinstall" != "yes" ]]; then
        sudo ninja install
    fi
}

_build_ninja() {
    ./bootstrap.py
    sudo ln -s "$SRCDIR/ninja/ninja" /usr/local/bin/ninja
}

_build_libsearpc() {
    __autotools
}

_build_ccnet() {
    __autotools --disable-server
}

_build_seafile() {
    __autotools --disable-server --disable-fuse
}

_build_seafile_client() {
    __cmake "noinstall"
}

_build_project() {
    local proj=$1
    local force=$2
    local projname=$(sed -e 's/-/_/g' <<<$proj)
    echo
    echo "building $proj"
    echo
    stamp=/etc/ok-$proj
    [[ $force != "-f" && -f $stamp ]] || {
        cd $SRCDIR/$proj
        _build_$projname
        sudo touch $stamp
    }
}

main() {
    if [[ $# > 0 ]]; then
        projects=$1
        force=$2
    else
        projects=$ALL_PROJECTS
    fi
    for proj in $projects; do
        _build_project $proj $force
    done
    sudo ldconfig
}

##############
# Entrypoint #
##############
main "$@"
