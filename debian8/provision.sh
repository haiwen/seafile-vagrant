#!/bin/bash

set -e -x

apt-get update -q
apt-get install -y tmux htop vim software-properties-common

cat >/home/vagrant/.bashrc<<'EOF'
if [[ $- == *i* ]]; then
    PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\u@\h \w]\\$ \[$(tput sgr0)\]"
fi
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF
