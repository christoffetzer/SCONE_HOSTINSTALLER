#!/bin/bash
#
# - install sgx driver - unless already installed
# - install docker engine - unless already installed
# - install git-lfs - unless already installed
#
# (C) Christof Fetzer, 2017

set -x -e

REPO="deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main"

sudo apt install -y make
sudo apt install -y gcc

m=`lsmod | grep isgx | wc -l`
if [ !  $m "==" "1" ] ; then
   if [ ! -d linux-sgx-driver/ ] ; then
        git clone https://github.com/01org/linux-sgx-driver
   fi

   cd linux-sgx-driver/
   make
   make install
   sudo insmod isgx.ko 

   m=`lsmod | grep isgx | wc -l`
   if [ ! $m "==" "1" ] ; then
        echo "Error: sgx driver not loaded"
        exit -1
   fi

   cd ..
fi

./install_patched_docker.sh

./install_git_lfs.sh

echo "OK"
