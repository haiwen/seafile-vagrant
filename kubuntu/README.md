# Seafile 16.04 Development Using Vagrant + Virtualbox

It can be run on Mac OSX or linux.

# Installation

First install `vagrant` and `virtualbox`

## Clone the source code

Clone the source cod of all projects to the `src` folder.

```sh
cd seafile-vagrant/kubuntu/
mkdir src
cd ./src
git clone git://github.com/martine/ninja.git
git clone git://github.com/haiwen/libsearpc
git clone git://github.com/haiwen/ccnet
git clone git://github.com/haiwen/seafile
git clone git://github.com/haiwen/seafile-client
git clone git://github.com/haiwen/seahub
```

Now you can bring up the VM::

```sh
  vagrant up
```

It would install all required software packages, and build libsearpc/ccnet/seafile/seafile-client, so it may take a while.

