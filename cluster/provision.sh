#!/bin/bash

set -e -x

cat >/etc/hosts <<!
127.0.0.1       localhost
172.16.2.10 lb
172.16.2.11 node1
172.16.2.12 node2
!

provision_load_balancer() {
    apt-get install -qy haproxy
}

provision_normal_node() {
    apt-get install -qy python-mysqldb python-pip python-imaging
}

provision_background_node() {
    MYSQL_PASSWORD='root'

cat <<! |debconf-set-selections
mysql-server mysql-server/root_password password $MYSQL_PASSWORD
mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD
mysql-server-5.1 mysql-server/root_password password $MYSQL_PASSWORD
mysql-server-5.1 mysql-server/root_password_again password $MYSQL_PASSWORD
!

    provision_normal_node;
    apt-get install -qy libreoffice python3-uno ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy \
            openjdk-7-jre poppler-utils mysql-server-5.6
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
