# Kubernetes 3-Node Cluster on AWS EC2

## 1. AWS EC2 Instance Setup

Create three EC2 instances for the Kubernetes cluster.

### Control Plane Instance

- Name: `control-plane`
- AMI: Ubuntu Server 24.04 LTS
- Instance Type: `t3.small`
- vCPU: 2
- Memory: 2 GiB
- Storage: 30 GiB gp3
- Key Pair: `kucl-key`
- VPC: Same VPC as Worker Nodes
- Security Group: Control Plane Security Group

### Worker Node 1

- Name: `worker-node-1`
- AMI: Ubuntu Server 24.04 LTS
- Instance Type: `t3.small`
- vCPU: 2
- Memory: 2 GiB
- Storage: 30 GiB gp3
- Key Pair: `kucl-key`
- VPC: Same VPC as Control Plane
- Security Group: Worker Node Security Group

### Worker Node 2

- Name: `worker-node-2`
- AMI: Ubuntu Server 24.04 LTS
- Instance Type: `t3.small`
- vCPU: 2
- Memory: 2 GiB
- Storage: 30 GiB gp3
- Key Pair: `kucl-key`
- VPC: Same VPC as Control Plane
- Security Group: Worker Node Security Group

## 2. Security Groups

### Control Plane Security Group

Allow:

- SSH — TCP `22` — Source: My IP
- Kubernetes API Server — TCP `6443` — Source: Worker Node Security Group

### Worker Node Security Group

Allow:

- SSH — TCP `22` — Source: My IP

Use the same Worker Node Security Group for both Worker Nodes.

## 3. SSH Connection

Connect to each EC2 instance from a terminal or PowerShell using SSH.

### Control Plane

Use the Control Plane Public DNS.

### Worker Node 1

Use Worker Node 1 Public DNS.

### Worker Node 2

Use Worker Node 2 Public DNS.

## 4. Installation Scripts

After creating and connecting to the instances:

- `control-plane-install.sh` → Control Plane installation
- `worker-node-install.sh` → Worker Node installation

The installation scripts contain the Kubernetes prerequisites, containerd, kubeadm, kubelet, and kubectl installation steps.

## 5. Cluster Setup

After running the installation scripts:

1. Initialize the Control Plane using `kubeadm init`.
2. Configure `kubectl`.
3. Install Calico CNI.
4. Generate the Worker Node join command.
5. Join Worker Node 1.
6. Join Worker Node 2.
7. Verify the cluster using `kubectl get nodes`.

## 6. Final Cluster

The final cluster contains:

- 1 Control Plane
- 2 Worker Nodes
- containerd
- kubeadm
- kubelet
- kubectl
- Calico CNI
