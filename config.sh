#!/usr/bin/env bash

# 메모리 스왑 끄기
swapoff -a
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# Ubuntu 패키지 저장소를 Kakao로 변경
sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

# 도커 키
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 도커 저장소 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 쿠버네티스 키
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# 쿠버네티스 저장소
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 헬름 키
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

# 헬름 저장소
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# 방화벽 끄기
sudo ufw disable

# ssh 설정
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo systemctl enable sshd

# iptable 설정
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo modprobe br_netfilter
sudo modprobe overlay
sudo sysctl --system

# etc/hosts 설정
echo "192.168.56.10 master" >> /etc/hosts
for (( i=1; i<=$1; i++  )); do echo "192.168.56.1$i worker$i" >> /etc/hosts; done

# DNS 설정
# config DNS  
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8 #Google DNS
EOF