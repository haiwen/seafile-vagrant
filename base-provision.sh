#!/bin/bash

set -e -x
[[ -f /etc/apt/sources.list.bak ]] && exit 0

# remove unused services
service puppet stop || true
update-rc.d -f puppet remove
service chef-client stop || true
update-rc.d -f cheif-client remove || true

# export USE_CN_MIRROR=true
if [[ $USE_CN_MIRROR == "true" ]]; then
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
else
    cat >/etc/apt/sources.list<<EOF
deb http://mirror.hetzner.de/ubuntu/packages  trusty           main restricted universe multiverse
deb http://mirror.hetzner.de/ubuntu/packages  trusty-backports main restricted universe multiverse
deb http://mirror.hetzner.de/ubuntu/packages  trusty-updates   main restricted universe multiverse
deb http://mirror.hetzner.de/ubuntu/security  trusty-security  main restricted universe multiverse
EOF
fi


rm -f /etc/apt/sources.list.d/puppetlabs.list

apt-get update -q

cat >>/home/vagrant/.bashrc<<EOF
export WORKON_HOME=~/.virtualenv
source /usr/local/bin/virtualenvwrapper.sh 2>/dev/null || true
EOF
