#!/bin/bash

set -e -x

# Install tmux so we can do things when installing KDE, which takes a long time.
dnf -y install tmux htop

# From https://fedoramagazine.org/installing-kde-plasma-5/
dnf -y group install kde-desktop-environment

# From https://github.com/haiwen/seafile-docs/blob/48a01cad9e5e33107882b4f12865146e9877654a/build_seafile/linux.md#L31
dnf -y install wget gcc libevent-devel openssl-devel gtk2-devel libuuid-devel sqlite-devel jansson-devel intltool cmake libtool vala gcc-c++ qt5-qtbase-devel qt5-qttools-devel qt5-qtwebkit-devel

# Enable GUI
systemctl set-default graphical.target
# From https://fedoraproject.org/wiki/KDE#Command_line
cat >/etc/sysconfig/desktop<<EOF
DESKTOP="KDE"
DISPLAYMANAGER="KDE"
EOF

cat <<EOF >>/home/vagrant/.bashrc
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
EOF
