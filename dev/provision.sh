#!/bin/bash

set -e -x


# Use 163 apt mirrors
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cat <<EOF >/tmp/sources.list
deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF
mv /tmp/sources.list /etc/apt/


# remove unused services
service puppet stop
update-rc.d -f puppet remove
service chef-client stop || true
update-rc.d -f cheif-client remove || true

apt-get update -q
apt-get -qy install ubuntu-desktop unity git autoconf automake libtool libevent-dev libcurl4-openssl-dev libgtk2.0-dev \
        uuid-dev intltool sqlite3 libsqlite3-dev valac libjansson-dev libqt4-dev cmake libfuse-dev \
        re2c flex libmysqlclient-dev libarchive-dev python-dev python-mysqldb rlwrap python-pip \
        libssl-dev openjdk-7-jdk libevent-dev libonig-dev tmux

# Run `apt-get install mysql-server-5.6` by hand, since it requires the user to set the root password


cat <<EOF >>/home/vagrant/.bashrc
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
EOF

cat  <<EOF >/etc/default/seafile-server
export CCNET_CONF_DIR=/vagrant/data/ccnet
export SEAFILE_CONF_DIR=/vagrant/data/seafile-data
export EVENTS_CONFIG_FILE=/vagrant/src/seafevents/events.conf
export PYTHONPATH=/vagrant/data/python-libs:$PYTHONPATH
EOF

cd /vagrant/src/seahub/
pip install -r requirements.txt \
    --allow-all-external --allow-unverified Djblets \
    --allow-unverified PIL \
    -i http://pypi.douban.com/simple

pip install flup pytest -i http://pypi.douban.com/simple
