#!/bin/bash

set -e -x

MYSQL_PASSWORD='root'

cat <<! |debconf-set-selections
mysql-server mysql-server/root_password password $MYSQL_PASSWORD
mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD
mysql-server-5.1 mysql-server/root_password password $MYSQL_PASSWORD
mysql-server-5.1 mysql-server/root_password_again password $MYSQL_PASSWORD
!

apt-get -qy install ubuntu-desktop unity git autoconf automake libtool libevent-dev libcurl4-openssl-dev libgtk2.0-dev \
        uuid-dev intltool sqlite3 libsqlite3-dev valac libjansson-dev libqt4-dev cmake libfuse-dev \
        re2c flex libmysqlclient-dev libarchive-dev python-dev python-mysqldb rlwrap python-pip \
        libssl-dev openjdk-7-jdk libevent-dev libonig-dev tmux python-sqlalchemy python-simplejson mysql-server-5.6

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
