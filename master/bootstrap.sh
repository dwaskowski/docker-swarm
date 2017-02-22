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

# Docker Machine
curl -L https://github.com/docker/machine/releases/download/v0.9.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

docker swarm init --advertise-addr 192.168.254.2 
docker swarm join-token worker -q > /swarm/node-token
token=`cat /swarm/node-token`

docker-machine create --driver generic --swarm --swarm-master --swarm-discovery token://$token --generic-ip-address=192.168.254.2 --generic-ssh-key=/swarm/cluster-key --generic-ssh-user=vagrant default

# Docker Compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "
alias dc='_(){ docker-compose \$*; }; _'
alias d='_(){ docker \$*; }; _'
alias dm='_(){ docker-machine \$*; }; _'
" > /root/.bash_profile

echo "
alias dc='_(){ docker-compose \$*; }; _'
alias d='_(){ docker \$*; }; _'
alias dm='_(){ docker-machine \$*; }; _'
" > /home/vagrant/.bash_profile

echo $1 > /etc/hostname
hostname -F /etc/hostname

chown vagrant: /home/vagrant/.bash_profile

#eval "$(docker-machine env --swarm default)"
