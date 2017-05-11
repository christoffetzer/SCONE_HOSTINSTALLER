#!/bin/bash
#
# - update sgx driver or install in case it is not yet installed
#
# (C) Christof Fetzer, 2017

set -x -e


sudo apt install -y make
sudo apt install -y gcc

rm -rf linux-sgx-driver
git clone https://github.com/01org/linux-sgx-driver

cd linux-sgx-driver/
make
sudo make install

errormsg="ERROR: unloading of module isgx has failed. You can either 
   - reboot the machine (sudo reboot -now) or
   - force the removal of the isgx (sudo rmmod -f isgx) and retry."

m=`lsmod | grep isgx | wc -l`
if [  $m ">" "0" ] ; then
    sudo rmmod isgx
    m=`lsmod | grep isgx | wc -l`
    if [ !  $m "==" "1" ] ; then
        echo  $errormsg >&2
        exit 1
    fi
fi

sudo insmod isgx.ko 

m=`lsmod | grep isgx | wc -l`
if [ ! $m "==" "1" ] ; then
    echo "Error: sgx driver not loaded"
    exit -1
fi
