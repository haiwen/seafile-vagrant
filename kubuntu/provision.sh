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

apt-add-repository http://archive.neon.kde.org/stable
curl -s http://archive.neon.kde.org/public.key| sudo apt-key add -
apt-get update -q

apt-get install -y neon-desktop

apt-get -qy install git autoconf automake libtool libevent-dev libcurl4-openssl-dev libgtk2.0-dev \
        uuid-dev intltool sqlite3 libsqlite3-dev valac libjansson-dev cmake \
        libarchive-dev python-dev rlwrap python-pip \
        libssl-dev libevent-dev tmux htop \
        qtbase5-dev libqt5webkit5-dev qttools5-dev qttools5-dev-tools

cat >/home/vagrant/.bashrc<<'EOF'
if [[ $- == *i* ]]; then
    PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\u@\h \w]\\$ \[$(tput sgr0)\]"
fi
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF

## Add kde auto login of vagrant user
sddm --example-config > /etc/sddm.conf
sed -i -e '0,/User=/{s/^User=.*$/User=vagrant/}' /etc/sddm.conf
sed -i -e '0,/Session=/{s/^Session=.*$/Session=plasma.desktop/}' /etc/sddm.conf
