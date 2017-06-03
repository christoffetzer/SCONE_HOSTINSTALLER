# SCONE: Host Installation Guide

This documentation describes how 

* to set up a host such that it can run SCONE secure containers, i.e., containers in which processes run inside of SGX enclaves,

The installation script

* installs the Intel SGX drive (if it is not yet installed), 

* installs a patched docker engine, and

* starts/joins a docker swarm - if requested by command line options.


**Prerequisite**:  We assume that you have Ubuntu 16.04LTS (or later) installed. 

## SCONE Documentation

To read more about our SCONE secure container framework, read the online
documentation at [https://sconedocs.github.io/](https://sconedocs.github.io/).

For offline reading, please ensure that docker is installed and then execute the following:


```bash
docker pull sconecuratedimages/sconedocu
docker run -d -p 8080:80  sconecuratedimages/sconedocu
open http://127.0.0.1:8080
```

## Patched Docker Engine

For an container to be able to use SGX, it has to have access to a device (/dev/isgx). This device permits the container to talk to the SGX driver, e.g., to create SGX enclaves. Some docker commands (like *docker run*) support an option --device (i.e., *--device /dev/isgx*) which allows us to give a container access to the SGX device. We need to point out that some docker commands (like *docker build*) do, however, not support the device option. Therefore, we maintain and install a slightly patched docker engine (i.e., a variant of moby): this engine ensures that each container has access to the SGX device (/dev/isgx).  With the help of this patched engine, we can use Dockerfiles to generate container images (see this [Tutorial](SCONE_Dockerfile.md)).

## Installation

To install all necessary software to run secure containers on a host, clone the script:

```bash
git clone https://github.com/christoffetzer/SCONE_HOSTINSTALLER.git
```

ensure that you are permitted to execute sudo and execute the following command:

```bash
cd SCONE_HOSTINSTALLER
```

In case you have already a docker engine installed, executing the
**installation script will remove the installed docker engine first.**

### Installing the Swarm Manager

Each Docker Swarm requires at least one manager. The installation script
can set up the first manager via:

```bash
./install.sh --manager
```

The IP address of this manager is used for the nodes of the swarm to find each other. The above script will output how to install other nodes and 'OK' on success:

```bash
# to install another machine and add as a manager, execute
./install.sh --token SWMTKN-1-2f98skv0z2vdhnyw9liwbqtgocts6comdr81o6e3u6kd9olbrc-48zv9ho4f3poid4d34767nucj 192.168.4.101:2377
# to install another machine and add as worker, execute
./install.sh --token SWMTKN-1-2f98skv0z2vdhnyw9liwbqtgocts6comdr81o6e3u6kd9olbrc-91z9bxu0exqli87elwasyjj5w 192.168.4.101:2377
OK
```
If you do not remember the tokens, you can output the token by executing the following script (on a manager node):

```bash
./show-tokens.sh 
```

### Installing a Swarm Worker

To install a new worker node, execute something like this (use the correct worker token - which is printed during the master installation):

```bash
./install.sh --token SWMTKN-1-2f98skv0z2vdhnyw9liwbqtgocts6comdr81o6e3u6kd9olbrc-91z9bxu0exqli87elwasyjj5w 192.168.4.101:2377
```

### Installing another Manager Node

In a small installation, we might only have one manager. However, in
larger installation it makes sense to have 3 or 5 manager nodes.
To install a new manager node, execute something like this (use the manager token):

```bash
./install.sh --token SWMTKN-1-2f98skv0z2vdhnyw9liwbqtgocts6comdr81o6e3u6kd9olbrc-48zv9ho4f3poid4d34767nucj 192.168.4.101:2377
```


The install.sh script outputs 'OK' on success.

## Checking your Installation


To test the installation, one can run a simple hello-world container:

```bash
sudo docker run hello-world
```


## Future Work

* we plan to support hosts managed by Ubuntu MaaS to simplify the process of installing Docker and DockerSwarm. 
We plan to provide a preconfigured SCONE host images for MaaS - as soon as custom MaaS images are supported (again).

Author: Christof Fetzer, 2017
