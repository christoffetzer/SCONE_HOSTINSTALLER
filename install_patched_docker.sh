#!/bin/bash
#
# - installs patched docker engine - this engine always maps device /dev/isgx into container
#
# (C) Christof Fetzer, 2017

set -e -x

echo "removing old docker engine - if installed"
(sudo systemctl stop docker-swarm) || true
sudo apt-get remove -y docker-engine || true
sudo apt-get remove -y docker-ce || true

KEYNAME="96B9BADB"
REPO="deb https://sconecontainers.github.io/APT ./"

sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual

sudo apt-get update
sudo sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv \
  --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-keys $KEYNAME

echo $REPO | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update

apt-cache policy docker-engine

## in case file length is wrong - try to uncomment the following:
# sudo apt -o Acquire::https::No-Cache=True -o Acquire::http::No-Cache=True update

sudo apt-get install -y docker-engine

curuser=`id -u -n`
# remove the need for sudo
sudo groupadd -f docker
sudo gpasswd -a ${curuser} docker
sudo service docker restart

## do not restart registry in case it is already running
#r=`sudo docker ps --filter "name=^/registry$" | wc -l`
#if [  $r "<" "1" ] ; then
#    sudo docker run -d -p 5000:5000 --name registry registry:2
#fi

