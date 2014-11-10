#!/bin/bash

set -e -x

apt-get update -qq

# TODO: use 163 apt mirrors

# remove unused services
service puppet stop
update-rc.d -f puppet remove
service chef-client stop
update-rc.d -f cheif-client remove

apt-get -qy install ubuntu-desktop unity git autoconf automake libtool libevent-dev libcurl4-openssl-dev libgtk2.0-dev \
        uuid-dev intltool sqlite3 libsqlite3-dev valac libjansson-dev libqt4-dev cmake libfuse-dev \
        re2c flex mysql-server-5.6 libmysqlclient-dev libarchive-dev python-dev python-mysqldb rlwrap


cat /home/vagrant/.bashrc <<EOF
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
EOF

cat /etc/default/seafile-server <<EOF
export CCNET_CONF_DIR=/vagrant/data/ccnet
export SEAFILE_CONF_DIR=/vagrant/data/seafile-data
export EVENTS_CONFIG_FILE=/vagrant/src/seafevents/events.conf
export PYTHONPATH=/vagrant/data/python-libs:$PYTHONPATH
EOF

cd /vagrant/src/seahub/ 
pip install -r requirements.txt --allow-all-external --allow-unverified Djblets --allow-unverified PIL
