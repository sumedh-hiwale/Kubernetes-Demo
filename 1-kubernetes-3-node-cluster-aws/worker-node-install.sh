#!/bin/bash

set -e

echo "=========================================="
echo " Kubernetes Worker Node Setup"
echo "=========================================="

# Update system
sudo apt-get update

# Install required packages
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Install containerd
sudo apt-get install -y containerd

sudo mkdir -p /etc/containerd

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# Configure kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Add Kubernetes repository
sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key \
  | sudo gpg --dearmor \
  -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.37/deb/ /' \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

# Install Kubernetes components
sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

# Verify installation
echo ""
echo "=========================================="
echo " Kubernetes Components Installed"
echo "=========================================="

kubeadm version
kubelet --version
kubectl version --client

echo ""
echo "=========================================="
echo " Worker Node Setup Completed!"
echo "=========================================="
echo ""
echo "Next step:"
echo "Run the kubeadm join command generated"
echo "on the Control Plane."
echo ""
