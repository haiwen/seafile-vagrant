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
        libssl-dev openjdk-7-jdk libevent-dev libonig-dev tmux python-sqlalchemy python-simplejson mysql-server-5.6 htop nginx

cat <<EOF >>/home/vagrant/.bashrc
export CDPATH=.:/vagrant/src/:/vagrant/data:/vagrant
EOF

cat  <<EOF >/etc/default/seafile-server
export CCNET_CONF_DIR=/vagrant/data/ccnet
export SEAFILE_CONF_DIR=/vagrant/data/seafile-data
export EVENTS_CONFIG_FILE=/vagrant/src/seafevents/events.conf
export PYTHONPATH=/vagrant/data/python-libs:$PYTHONPATH
EOF

sudo mv /etc/nginx/sites-enabled/default /etc/nginx/default.backup
cat <<'EOF' > /etc/nginx/sites-enabled/seafile.conf
server {
    listen 80;
    server_name _ default_server;

    gzip on;
    gzip_proxied any;
    gzip_comp_level 9;
    gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    location / {
        proxy_pass http://127.0.0.1:8000;
    }
    location /seafhttp {
        rewrite ^/seafhttp(.*)$ $1 break;
        proxy_pass http://127.0.0.1:8082;
        client_max_body_size 0;
        proxy_connect_timeout  36000s;
        proxy_read_timeout  36000s;
    }
}
EOF
service nginx restart

if [[ $USE_CN_MIRROR == "true" ]]; then
    PIP_MIRROR="-i http://pypi.douban.com/simple --trusted-host pypi.douban.com"
fi

cd /vagrant/src/seahub/
pip install -r requirements.txt \
    --allow-all-external --allow-unverified Djblets \
    --allow-unverified PIL $PIP_MIRROR

pip install flup pytest $PIP_MIRROR

ln -sf /vagrant/sfdev /usr/local/bin
