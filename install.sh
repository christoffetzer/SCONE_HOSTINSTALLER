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

sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual

sudo apt-get update
sudo sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv \
  --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo $REPO | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update

apt-cache policy docker-engine

sudo apt-get install -y docker-engine

# remove the need for sudo
groupadd -f docker
sudo gpasswd -a ${USER} docker
sudo service docker restart

# do not restart registry in case it is already running
r=`sudo docker ps --filter "name=^/registry$" | wc -l`
if [  $r "<" "1" ] ; then
    sudo docker run -d -p 5000:5000 --name registry registry:2
fi

./install_git_lfs.sh

echo "OK"

