#!/usr/bin/env bash

# 쿠버네티스 시작
kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
--pod-network-cidr=10.217.0.0/16 --apiserver-advertise-address=192.168.1.10 
      
# 마스터노드 설정
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
cp -R $HOME/.kube /home/vagrant/.kube
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# Helm 설치
sudo apt -y install helm

# Cilium 설치
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.9/install/kubernetes/quick-install.yaml