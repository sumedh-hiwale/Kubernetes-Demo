#!/bin/bash

set -e

echo "=========================================="
echo " Kubernetes Control Plane Installation"
echo "=========================================="

# 1. Update system packages
echo "[1/8] Updating system packages..."
sudo apt-get update

# 2. Install required packages
echo "[2/8] Installing required packages..."
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# 3. Disable swap
echo "[3/8] Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# 4. Install containerd
echo "[4/8] Installing containerd..."
sudo apt-get install -y containerd

sudo mkdir -p /etc/containerd

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# 5. Configure kernel modules
echo "[5/8] Configuring kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# 6. Add Kubernetes repository
echo "[6/8] Adding Kubernetes repository..."
sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key \
  | sudo gpg --dearmor \
  -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.37/deb/ /' \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

# 7. Install Kubernetes components
echo "[7/8] Installing kubeadm, kubelet and kubectl..."
sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

# 8. Verify installation
echo "[8/8] Verifying Kubernetes installation..."

kubeadm version
kubelet --version
kubectl version --client

echo ""
echo "=========================================="
echo " Control Plane installation completed!"
echo "=========================================="
echo ""
echo "Next step:"
echo "Run: sudo kubeadm init"
echo ""
