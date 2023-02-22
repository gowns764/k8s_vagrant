#!/usr/bin/env bash

# 패키지 설치
sudo apt -y update   
sudo apt install -y vim git net-tools apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# 도커 설치
sudo apt install -y docker-ce docker-ce-cli containerd.io
#sed -i '/"cri"/ s/^/#/' /etc/containerd/config.toml
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# 쿠버네티스 설치
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl