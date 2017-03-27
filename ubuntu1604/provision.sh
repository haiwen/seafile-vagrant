#!/bin/bash

set -e -x

cat >/etc/apt/sources.list<<EOF
deb http://mirror.hetzner.de/ubuntu/packages  xenial           main restricted universe multiverse
deb http://mirror.hetzner.de/ubuntu/packages  xenial-backports main restricted universe multiverse
deb http://mirror.hetzner.de/ubuntu/packages  xenial-updates   main restricted universe multiverse
deb http://mirror.hetzner.de/ubuntu/security  xenial-security  main restricted universe multiverse
EOF

rm -f /etc/apt/sources.list.d/puppetlabs.list

apt-get update -q
apt-get install -y tmux htop vim software-properties-common

cat >/home/vagrant/.bashrc<<'EOF'
if [[ $- == *i* ]]; then
    PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\u@\h \w]\\$ \[$(tput sgr0)\]"
fi
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF
