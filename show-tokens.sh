#!/bin/bash
#
# - show manager and worker token for joining docker swarm
#
# note: execute this on a manager node of the swarm
#
# (C) Christof Fetzer, 2017

export manager_addr=`docker info --format '{{(index .Swarm.RemoteManagers 0).Addr}}'`

export worker_token=`docker swarm join-token -q worker`
export manager_token=`docker swarm join-token -q manager`

echo "# to install another machine and add as a manager, execute"
echo "./install.sh --token $manager_token $manager_addr"

echo "# to install another machine and add as worker, execute"
echo "./install.sh --token $worker_token $manager_addr"
