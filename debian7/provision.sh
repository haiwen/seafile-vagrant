#!/bin/bash

set -e -x

cat >/home/vagrant/.bashrc<<'EOF'
if [[ $- == *i* ]]; then
    PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\u@\h \w]\\$ \[$(tput sgr0)\]"
fi
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF

apt-get update -q
apt-get install -y tmux htop vim software-properties-common

# http://forums.debian.net/viewtopic.php?p=404227
# https://wiki.debian.org/Gnome
# apt-get install -y --no-install-recommends gnome-core
aptitude -q --without-recommends -o APT::Install-Recommends=no -y install ~t^desktop$ ~t^gnome-desktop$

