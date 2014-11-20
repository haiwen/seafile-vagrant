#!/bin/bash

set -e -x

cat >>/etc/hosts <<!
127.0.0.1       localhost
172.16.2.10 lb
172.16.2.11 node1
172.16.2.12 node2
!

provision_load_balancer() {
    apt-get install -qy haproxy
    ln -sf /vagrant/seafile-haproxy.cfg /etc/haproxy/haproxy.cfg
    sed -i -re 's/^#?ENABLED=0/ENABLED=1/' /etc/default/haproxy || true
cat >>/etc/rsyslog.conf <<!
\$ModLoad imudp
\$UDPServerAddress 127.0.0.1
\$UDPServerRun 514
!
    service rsyslog restart
}

provision_normal_node() {
    apt-get install -qy python-mysqldb python-pip python-imaging openjdk-7-jre
    _install_nginx;
}

provision_background_node() {
    provision_normal_node;
    apt-get install -qy libreoffice python3-uno ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy \
            poppler-utils

    _install_mysql;
    _install_memcached;
}

_install_nginx() {
    apt-get install -qy nginx
    ln -sf /vagrant/seafile-nginx.conf /etc/nginx/sites-enabled/seafile.conf
    service nginx reload
}

_install_memcached() {
    apt-get install -qy memcached
    sed -i -re 's/^-l 127.0.0.1/-l 0.0.0.0/' /etc/memcached.conf || true
    service memcached restart
}

_install_mysql() {
    MYSQL_PASSWORD='root'
cat <<! |debconf-set-selections
mysql-server mysql-server/root_password password $MYSQL_PASSWORD
mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD
mysql-server-5.1 mysql-server/root_password password $MYSQL_PASSWORD
mysql-server-5.1 mysql-server/root_password_again password $MYSQL_PASSWORD
!

    apt-get install -qy mysql-server-5.6
    sed -i -re 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf || true
    service mysql restart
    sql="
GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.16.%'
    IDENTIFIED BY 'root'
    WITH GRANT OPTION;
FLUSH PRIVILEGES;
"
    echo $sql | mysql -u root -p${MYSQL_PASSWORD}
}

main() {
  case $1 in
      lb) provision_load_balancer
        ;;
      normal) provision_normal_node
        ;;
      background) provision_background_node
        ;;
      *) echo "WARNING: invalid argument $1"
      ;;
  esac
}
main "$@"
