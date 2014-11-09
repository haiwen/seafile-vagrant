# Seafile Development Using Vagrant + Virtualbox

It can be run on Mac OSX or linux.

# Installation

First install `vagrant` and `virtualbox`

## Install on Ubuntu linxu

- Install vagrant by downloading the deb package from vagrant website
- Install virtualbox by `apt-get install virutalbox`

## Clone the source code

Clone the source cod of all projects to the `src` folder.

```sh
cd seafile-vagrant/dev/
mkdir src
cd ./src
git clone git://github.com/martine/ninja.git
git clone haiwen/libzdb
git clone haiwen/libevhtp
git clone haiwen/libsearpc
git clone haiwen/ccnet
git clone haiwen/seafile
git clone haiwen/seahub
git clone haiwen/seafile-client
```

Now you can bring up the VM::

```sh
  vagrant up
```

It would install all required software packages, and build libsearpc/ccnet/seafile/seafile-client, so it may take a while.

## Command Tasks

First install fabric on your HOST OS.

```
sudo pip install fabric
```

### start seafile server

```sh
fab runserver
```

It would build and start ccnet-server/seafile-server.
