#!/bin/bash 

if [ $USER != 'root' ] 
then
    echo 'should be run in ROOT/SUDO'
    exit 1
fi

apt-get install git shadowsocks-libev autoconf

git clone https://github.com/shadowsocks/simple-obfs.git
cd simple-obfs
git submodule update --init --recursive
./autogen.sh
./configure --disable-documentation
make && make install


