#!/bin/bash
#
# - install sgx driver - unless already installed
# - install docker engine - unless already installed
# - install git-lfs - unless already installed
#
# (C) Christof Fetzer, 2017

set -e

function usage {
    echo "Usage: $0 [--token <TOKEN> <Docker Manager Address>]"
    echo "          [--manager]"
    echo "   Installs sgx driver - unless already installed."
    echo "   Removes existing docker engine and installs patched docker engines."
    echo "   Joins docker swarm in case a manager addr and a token is given."
    echo "   Create a new Swarm manager if --manage is given"
    exit -1
}

function restart_swarm {
    envsubst < docker-swarm.service.template > docker-swarm.service
    sudo mv docker-swarm.service /etc/systemd/system/docker-swarm.service
    sudo systemctl daemon-reload
    sudo systemctl enable docker-swarm
}

if [[ $# != 0 && $# != 1 && $# != 3 ]] ; then
    usage
fi

if [[ $# == 3 && $1 != "--token" ]] ; then
    echo "Error: exepect '--token' as first argument"
    usage
fi

if [[ $# == 1 && $1 != "--manager" ]] ; then
    echo "Error: exepect '--manager' as first argument"
    usage
fi

sudo apt update
sudo apt install -y make
sudo apt install -y gcc

m=`lsmod | grep isgx | wc -l`
if [ !  $m "==" "1" ] ; then
    rm -rf linux-sgx-driver
    git clone https://github.com/01org/linux-sgx-driver

    cd linux-sgx-driver/
    make

#    make install
#    sudo insmod isgx.ko 

    sudo mkdir -p "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"    
    sudo cp isgx.ko "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"    
    sudo sh -c "cat /etc/modules | grep -Fxq isgx || echo isgx >> /etc/modules"    
    sudo /sbin/depmod
    sudo /sbin/modprobe isgx

    m=`lsmod | grep isgx | wc -l`
    if [ ! $m "==" "1" ] ; then
            echo "Error: sgx driver not loaded"
            exit -1
    fi

    cd ..
fi

./install_patched_docker.sh


## git_lfs is not needed anymore
#./install_git_lfs.sh

# shall we spawn the first docker swarm manager? 

if [[ $1 == "--manager" ]] ; then
    export PORT=2377
    export MANAGER_IP=`hostname --ip-address`
    docker swarm init --advertise-addr $MANAGER_IP:$PORT --listen-addr 0.0.0.0:$PORT

    export manager_addr=`docker info --format '{{(index .Swarm.RemoteManagers 0).Addr}}'`

    export worker_token=`docker swarm join-token -q worker`
    export manager_token=`docker swarm join-token -q manager`

    echo "# to install another machine and add as a manager, execute"
    echo "./install.sh --token $manager_token $manager_addr"

    echo "# to install another machine and add as worker, execute"
    echo "./install.sh --token $worker_token $manager_addr"

    export token=$manager_token
    restart_swarm
fi

# join docker cluster ?
if [[ $1 == "--token" ]] ; then
    export token=$2
    export manager_addr=$3
    restart_swarm
    (sudo systemctl start docker-swarm) || true
fi

echo "OK"
