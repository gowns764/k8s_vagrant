#!/usr/bin/env bash

# 쿠버네티스 시작
kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
--pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=192.168.1.10
      
# 마스터노드 설정
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Helm 설치
sudo apt install -y helm

# Calico 설치
helm repo add calico https://docs.tigera.io/calico/charts
kubectl create namespace
helm install calico calico/tigera-operator -n calico

# Cilium 설치
cilium install

# Cilium 상태 확인
cilium status --wait

# 22번 포트 허용 정책
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.13/examples/policies/host/demo-host-policy.yaml