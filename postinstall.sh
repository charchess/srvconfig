#!/bin/bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common less screen joe shorewall sudo nfs-server pptp-linux


mkdir -p /data/rancher-fs
echo "/data/rancher-nfs 172.18.0.0/24(rw,sync,no_subtree_check) 172.17.0.0/24(rw,sync,no_subtree_check) 127.0.0.1(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
exportfs -a

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update

mkdir -p /etc/systemd/system/docker.service.d
echo "[Service]" > /etc/systemd/system/docker.service.d/docker.root.conf
echo "ExecStart=" >> /etc/systemd/system/docker.service.d/docker.root.conf
echo "ExecStart=/usr/bin/dockerd -g /data/docker --iptables=false -H fd://" >> /etc/systemd/system/docker.service.d/docker.root.conf

apt-get install -y docker-ce docker-ce-cli containerd.io

mkdir -p /data/rancher
docker network create --subnet=172.18.0.0/24 txodockernet
docker run -d -p 8081:8080 -v /data/rancher/mysql:/var/lib/mysql -v /data/rancher/cattle:/var/lib/cattle --net txodockernet --ip 172.18.0.38 --dns 8.8.8.8 --dns 8.8.4.4 --restart=unless-stopped --name=rancher rancher/server:stable




echo 'truxonline\\svc_karen_vpn truxonline coincoin *' >> /etc/chap-secrets


