# SCONE: Host Installation Guide

This documentation describes how 

* to set up a host such that it can run SCONE secure containers, i.e., containers in which processes run inside of SGX enclaves,

* to run a local Docker registry, and

The installation script

* installs the Intel SGX drive (if it is not yet installed),

* installs the docker engine (if it is not yet installed), and

* installs git-lfs - which is required to store / retrieve large files on github.


**Prerequisite**:  We assume that you have Ubuntu 16.04LTS (or later) installed. 

## SCONE

To read more about our SCONE secure container framework, please ensure that docker is installed and then execute the following:

```bash
docker pull sconecuratedimages/sconedocu
docker run -d -p 8080:80  sconecuratedimages/sconedocu
open http://127.0.0.1:8080
```

## Installation

To install all necessary software to run secure containers on a host, clone the script:

```bash
git clone git@github.com:christoffetzer/SCONE_HOSTINSTALLER.git
```

ensure that you are permitted to execute sudo and execute the following command:

```bash
cd SCONE_HOSTINSTALLER; sudo ./install.sh
```
The script should output 'OK' on success.

## Checking your Installation


To test the installation, one can run a simpla hello-world container:

```bash
sudo docker run hello-world
```

### To starting a local docker repository

To run a docker repository on this host, just execute this

```bash
sudo docker run -d -p 5000:5000 --name registry registry:2
```


## Script Details

This is an advanced topic that only needs to be read by developers that want to adapt the installation process.

The installation script has no dependencies on SCONE itself. It depends on the underlying operating system and needs to adapted for production (i.e., one probably wants to use one private Docker repository per cluster and that is only available via TLS).

### Configuration Parameter
This installation is for Ubuntu. For other distributions, we need to adjust the docker repo by updating this link:

```bash
REPO="deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main"
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

## Future Work

* show how to install our patched Docker engine instead

* provide a local Docker registry with TLS access only.  

* we plan to support hosts managed by Ubuntu MaaS: 
we plan to provide preconfigured SCONE host images for MaaS - as soon as custom MaaS images are supported (again).

Author: Christof Fetzer, 2017
