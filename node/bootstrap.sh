#!/usr/bin/env bash

# Docker install
apt-get -qq purge lxc-docker*
apt-get -qq purge docker.io*
apt-get -qq update
apt-get -qq install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get -qq update
apt-get -qq install docker-engine curl python-pip cron nano git htop
service docker start

cat /swarm/cluster-key.pub >> /home/vagrant/.ssh/authorized_keys

token=`cat /swarm/node-token`
docker swarm join  --token $token 192.168.254.2:2377

ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i /swarm/cluster-key vagrant@192.168.254.2 "sudo docker-machine create --driver generic --swarm --swarm-discovery token://$token --generic-ip-address=$2 --generic-ssh-key=/swarm/cluster-key --generic-ssh-user=vagrant $1"

# Docker Compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "
alias dc='_(){ docker-compose \$*; }; _'
alias d='_(){ docker \$*; }; _'
" > /root/.bash_profile

echo "
alias dc='_(){ docker-compose \$*; }; _'
alias d='_(){ docker \$*; }; _'
" > /home/vagrant/.bash_profile

echo $1 > /etc/hostname
hostname -F /etc/hostname

chown vagrant: /home/vagrant/.bash_profile
