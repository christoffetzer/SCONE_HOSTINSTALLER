# SCONE: Installation Guide

This documentation describes how 

* to set up a host to run secure containers, i.e., containers in which processes run inside of SGX enclaves

* to run a local Docker registry.


Our objective is to support hosts managed by Ubuntu MaaS. Hence, we plan to provide preconfigured MaaS images - as soon as custom MaaS images are supported (again).

## Installation

To install all necessary software to run secure containers on a host, clone the script:

```bash
git clone https://github.com/christoffetzer/SCONE_HOSTINSTALLER.git
```

ensure that you are permitted to execute sudo and execute the following command:

```bash
cd SCONE_HOSTINSTALLER; ./install.sh
```
The script should output 'OK' on success.


## Script Details

We use bash scripts to install the host:

```bash
#!/bin/bash

set -x -e
```

### Configuration Parameter
This installation is for Ubuntu 16.04LTS. For other distributions, we need to adjust the docker repo by updating this link:

```bash
REPO="deb https://apt.dockerproject.org/repo ubuntu-xenial main"
```

### Installing the SGX driver:

```bash
sudo apt-get update
sudo apt install -y make
sudo apt install -y gcc

m=`lsmod | grep isgx | wc -l`
if [ !  $m "==" "1" ] ; then
   if [ ! -d linux-sgx-driver/ ] ; then
        git clone https://github.com/01org/linux-sgx-driver
   fi

   cd linux-sgx-driver/
   make
   sudo insmod isgx.ko 

   m=`lsmod | grep isgx | wc -l`
   if [ ! $m "==" "1" ] ; then
        echo "Error: sgx driver not loaded"
        exit -1
   fi
   cd ..
fi
```

### Installing the docker engine

This is based on the installation instruction by Docker:

```bash
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual

sudo sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv \
  --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo $REPO | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update

apt-cache policy docker-engine

sudo apt-get install -y docker-engine
sudo service docker start

```

To test the installation, one can run a
simpla hello-world container:

```bash
sudo docker run hello-world
```

### Starting a new local docker repository

To run a docker repository on this host, just execute this

```bash
docker run -d -p 5000:5000 --name registry registry:2
```

## Future Work

Objective: instead of installing this code everytime we install a new host, we could plan to provide custom MaaS images. However, that image builder for MaaS does not seem to work right now.

