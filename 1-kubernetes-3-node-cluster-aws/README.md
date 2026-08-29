# ☸️ Kubernetes 3-Node Cluster on AWS EC2

> 🚀 A hands-on Kubernetes cluster setup using AWS EC2, kubeadm, containerd, and Calico CNI.

This project demonstrates how to build a **3-node Kubernetes cluster** on AWS EC2 from scratch.

---

## 🏗️ Cluster Architecture

```text
                         ☁️ AWS VPC
                              │
             ┌────────────────┼────────────────┐
             │                │                │
             ▼                ▼                ▼
      🧠 Control Plane    👷 Worker-1      👷 Worker-2
         t3.small           t3.small         t3.small
             │                │                │
             └────────────────┼────────────────┘
                              │
                       ☸️ Kubernetes
                              │
                         🌐 Calico CNI
                              │
                         🧪 nginx Pod
```

---

## 🎯 Project Overview

The cluster contains:

- 🧠 1 Control Plane
- 👷 2 Worker Nodes
- 📦 containerd as the container runtime
- 🔧 kubeadm for cluster initialization
- ⚙️ kubelet for managing Pods
- 🖥️ kubectl for cluster management
- 🌐 Calico CNI for Pod networking

---

# ☁️ 1. AWS EC2 Instance Setup

Create **three EC2 instances** inside the same AWS VPC.

### 🧠 Control Plane

- **Name:** `control-plane`
- **AMI:** Ubuntu Server 24.04 LTS
- **Instance Type:** `t3.small`
- **vCPU:** 2
- **Memory:** 2 GiB
- **Storage:** 30 GiB gp3
- **Key Pair:** `kucl-key`
- **Security Group:** Control Plane Security Group

### 👷 Worker Node 1

- **Name:** `worker-node-1`
- **AMI:** Ubuntu Server 24.04 LTS
- **Instance Type:** `t3.small`
- **vCPU:** 2
- **Memory:** 2 GiB
- **Storage:** 30 GiB gp3
- **Key Pair:** `kucl-key`
- **Security Group:** Worker Node Security Group

### 👷 Worker Node 2

- **Name:** `worker-node-2`
- **AMI:** Ubuntu Server 24.04 LTS
- **Instance Type:** `t3.small`
- **vCPU:** 2
- **Memory:** 2 GiB
- **Storage:** 30 GiB gp3
- **Key Pair:** `kucl-key`
- **Security Group:** Worker Node Security Group

> 💡 `t3.small` is used because `t3.micro` has around 1 GiB RAM and may fail Kubernetes memory preflight checks.

---

# 🔐 2. Security Groups

## 🧠 Control Plane Security Group

Allow:

| Type | Protocol | Port | Source |
|---|---|---:|---|
| SSH | TCP | `22` | My IP |
| Custom TCP | TCP | `6443` | Worker Node Security Group |

Port `6443` is used by the Kubernetes API Server.

## 👷 Worker Node Security Group

Allow:

| Type | Protocol | Port | Source |
|---|---|---:|---|
| SSH | TCP | `22` | My IP |

Use the same Worker Node Security Group for both Worker Nodes.

---

# 🔑 3. SSH Connection

Connect to the EC2 instances using SSH from a Terminal or PowerShell.

### 🧠 Control Plane

```bash
ssh -i "kucl-key.pem" ubuntu@<CONTROL_PLANE_PUBLIC_DNS>
```

### 👷 Worker Node 1

```bash
ssh -i "kucl-key.pem" ubuntu@<WORKER_1_PUBLIC_DNS>
```

### 👷 Worker Node 2

```bash
ssh -i "kucl-key.pem" ubuntu@<WORKER_2_PUBLIC_DNS>
```

Replace the Public DNS with the actual Public DNS of each EC2 instance.

> 🔒 Never upload the `.pem` private key to GitHub.

---

# 📁 4. Repository Structure

```text
kubernetes-3-node-cluster-aws/
│
├── 📄 README.md
├── ⚙️ control-plane-install.sh
└── ⚙️ worker-node-install.sh
```

### Scripts

- `control-plane-install.sh` → Control Plane installation
- `worker-node-install.sh` → Worker Node installation

> ♻️ The same `worker-node-install.sh` script is used on both Worker Node 1 and Worker Node 2.

---

# ⚙️ 5. Installation Scripts

## 🧠 Control Plane

Run on the Control Plane:

```bash
chmod +x control-plane-install.sh
./control-plane-install.sh
```

The script installs:

- Required packages
- Swap configuration
- containerd
- Kubernetes networking configuration
- kubeadm
- kubelet
- kubectl

## 👷 Worker Node 1

Run on Worker Node 1:

```bash
chmod +x worker-node-install.sh
./worker-node-install.sh
```

## 👷 Worker Node 2

Run the same script on Worker Node 2:

```bash
chmod +x worker-node-install.sh
./worker-node-install.sh
```

> ♻️ One Worker Node script is used for both Worker Nodes.

---

# 🚀 6. Post-Installation Steps

After running the installation scripts, complete the Kubernetes cluster setup.

## Step 1 — Initialize Control Plane

Run on the Control Plane:

```bash
sudo kubeadm init
```

After successful initialization, kubeadm provides the Worker Node join command.

---

## Step 2 — Configure kubectl

Run on the Control Plane:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Verify:

```bash
kubectl get nodes
```

The Control Plane may initially show `NotReady` until the CNI is installed.

---

## Step 3 — Install Calico CNI

Run on the Control Plane:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.2/manifests/calico.yaml
```

Verify:

```bash
kubectl get pods -n kube-system
```

Once Calico is running, the Control Plane should become `Ready`.

---

## Step 4 — Generate Worker Join Command

Run on the Control Plane:

```bash
kubeadm token create --print-join-command
```

This generates the complete `kubeadm join` command.

Example:

```bash
kubeadm join <CONTROL_PLANE_PRIVATE_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

> 🔒 Do not publish the real token or discovery hash in a public GitHub repository.

---

## Step 5 — Join Worker Node 1

Run the generated command on Worker Node 1:

```bash
sudo kubeadm join <CONTROL_PLANE_PRIVATE_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

---

## Step 6 — Join Worker Node 2

Run the same generated command on Worker Node 2:

```bash
sudo kubeadm join <CONTROL_PLANE_PRIVATE_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

---

## Step 7 — Verify All Nodes

Run on the Control Plane:

```bash
kubectl get nodes
```

Expected:

```text
NAME               STATUS   ROLES           VERSION
<control-plane>    Ready    control-plane   v1.37.0
<worker-1>         Ready    <none>          v1.37.0
<worker-2>         Ready    <none>          v1.37.0
```

---

# 🏷️ 7. Add Worker Node Labels

Worker Nodes may initially show `<none>` in the `ROLES` column.

### Worker Node 1

```bash
kubectl label node worker-1 node-role.kubernetes.io/worker=worker
```

### Worker Node 2

```bash
kubectl label node worker-2 node-role.kubernetes.io/worker=worker
```

Verify:

```bash
kubectl get nodes
```

Expected:

```text
NAME               STATUS   ROLES           VERSION
<control-plane>    Ready    control-plane   v1.37.0
worker-1           Ready    worker          v1.37.0
worker-2           Ready    worker          v1.37.0
```

> ℹ️ Kubernetes Node names are based on the node hostname. The AWS EC2 Name tag does not automatically become the Kubernetes Node name.

---

# 🌐 8. Verify Kubernetes System Pods

Run:

```bash
kubectl get pods -A
```

Important components include:

- 🗄️ etcd
- ☸️ kube-apiserver
- 🎛️ kube-controller-manager
- 📅 kube-scheduler
- 🌐 CoreDNS
- 🔌 kube-proxy
- 🐯 Calico

Required Pods should eventually show `Running`.

---

# 🧪 9. Deploy Test nginx Pod

Create an nginx Pod:

```bash
kubectl run nginx --image=nginx
```

Check the Pod:

```bash
kubectl get pods
```

Check where the Pod is running:

```bash
kubectl get pods -o wide
```

Example:

```text
NAME    READY   STATUS    IP                NODE
nginx   1/1     Running   192.168.x.x       worker-1
```

This confirms:

- ✅ Kubernetes Scheduler is working
- ✅ Worker Nodes are available
- ✅ containerd is working
- ✅ Calico networking is working
- ✅ Pods can run on Worker Nodes

---

# 🔍 10. Final Verification

Run:

```bash
kubectl get nodes
kubectl get pods -A
kubectl get pods -o wide
```

Expected:

- 🧠 Control Plane → `Ready`
- 👷 Worker Node 1 → `Ready`
- 👷 Worker Node 2 → `Ready`
- 🌐 Calico → `Running`
- 🧪 nginx Pod → `Running`

---

# 🛠️ 11. Troubleshooting

## ❌ Insufficient Memory

If you see:

```text
[ERROR Mem]: the system RAM is less than the minimum
```

Use:

```text
t3.small
2 vCPU
2 GiB RAM
```

instead of `t3.micro`.

---

## ❌ Worker Cannot Connect to Control Plane

Test from the Worker Node:

```bash
nc -zv <CONTROL_PLANE_PRIVATE_IP> 6443
```

Expected:

```text
Connection ... 6443 port ... succeeded!
```

If it fails, check:

1. Control Plane Security Group
2. Worker Node Security Group
3. VPC networking
4. Control Plane private IP
5. Kubernetes API Server

---

## ❌ kubeadm Join: Existing Configuration

If you see:

```text
/etc/kubernetes/kubelet.conf already exists
/etc/kubernetes/pki/ca.crt already exists
Port 10250 is in use
```

The Worker Node may contain an old Kubernetes configuration.

Run on the affected Worker Node:

```bash
sudo kubeadm reset -f
```

Remove old CNI configuration:

```bash
sudo rm -rf /etc/cni/net.d
```

Restart containerd:

```bash
sudo systemctl restart containerd
```

Generate a fresh join command on the Control Plane:

```bash
kubeadm token create --print-join-command
```

Then run the generated command on the Worker Node.

> ⚠️ Do not run `kubeadm reset -f` on the Control Plane unless you intentionally want to reset the cluster.

---

# 📋 12. Useful Kubernetes Commands

### Get Nodes

```bash
kubectl get nodes
```

### Get Nodes with Details

```bash
kubectl get nodes -o wide
```

### Get All Pods

```bash
kubectl get pods -A
```

### Get Pods with Node Information

```bash
kubectl get pods -o wide
```

### Describe a Node

```bash
kubectl describe node <NODE_NAME>
```

### Check System Pods

```bash
kubectl get pods -n kube-system
```

### Check Node Labels

```bash
kubectl get nodes --show-labels
```

---

# 🧩 13. Kubernetes Components

| Component | Purpose |
|---|---|
| `kubeadm` | Initializes and joins Kubernetes nodes |
| `kubelet` | Runs and manages Pods |
| `kubectl` | Command-line tool for Kubernetes |
| `containerd` | Container runtime |
| `Calico` | Kubernetes Pod networking |
| `etcd` | Stores Kubernetes cluster state |
| `kube-apiserver` | Kubernetes API |
| `kube-scheduler` | Schedules Pods |
| `kube-controller-manager` | Runs Kubernetes controllers |
| `CoreDNS` | Provides cluster DNS |
| `kube-proxy` | Handles Service networking |

---

# 🏁 14. Final Cluster

The completed cluster contains:

- 🧠 1 Control Plane
- 👷 2 Worker Nodes
- 📦 containerd
- 🔧 kubeadm
- ⚙️ kubelet
- 🖥️ kubectl
- 🌐 Calico CNI
- 🧪 nginx test Pod

### Final Status

- 🧠 Control Plane → `Ready` ✅
- 👷 Worker Node 1 → `Ready` ✅
- 👷 Worker Node 2 → `Ready` ✅
- 🌐 Calico → `Running` ✅
- 🧪 nginx Pod → `Running` ✅

---

# 🔒 15. Security Notes

Never commit sensitive information to GitHub.

Do NOT upload:

- 🔑 `.pem` private keys
- 🔑 AWS Access Keys
- 🔑 AWS Secret Keys
- 🔐 Private Keys
- 🔐 Kubeconfig files
- 🔐 Real kubeadm tokens
- 🔐 Passwords
- 🔐 Kubernetes Secrets

Recommended `.gitignore`:

```text
*.pem
*.key
.env
kubeconfig
```

---

# 🧹 16. Cleanup

When the lab is no longer required:

### Temporary Practice

Stop the EC2 instances.

### Permanent Cleanup

Terminate the EC2 instances.

Also check for unused AWS resources:

- EBS Volumes
- Elastic IPs
- Load Balancers
- Other AWS resources

> 💰 Stopping EC2 instances does not necessarily eliminate all AWS charges. EBS storage and other resources may continue to incur charges.

---

# 🛠️ 17. Technologies Used

- ☁️ AWS EC2
- 🐧 Ubuntu Server 24.04 LTS
- ☸️ Kubernetes v1.37.0
- 🔧 kubeadm
- ⚙️ kubelet
- 🖥️ kubectl
- 📦 containerd
- 🌐 Calico CNI

---

# 🎯 18. Learning Objectives

Through this project, you will gain hands-on experience with:

- Kubernetes cluster architecture
- Control Plane and Worker Nodes
- kubeadm cluster initialization
- Worker Node joining
- Container runtime configuration
- Kubernetes networking
- Calico CNI
- Node labels and roles
- Pod scheduling
- Kubernetes troubleshooting
- AWS EC2 networking
- AWS Security Groups

---

# ⭐ Project Status

- ✅ AWS EC2 Instances Created
- ✅ Security Groups Configured
- ✅ Kubernetes Components Installed
- ✅ Control Plane Initialized
- ✅ Calico CNI Installed
- ✅ Worker Node 1 Joined
- ✅ Worker Node 2 Joined
- ✅ Worker Nodes Labeled
- ✅ nginx Pod Deployed
- ✅ 3-Node Kubernetes Cluster Ready

---

## 👨‍💻 Project Structure

```text
kubernetes-3-node-cluster-aws/
│
├── 📄 README.md
├── ⚙️ control-plane-install.sh
└── ⚙️ worker-node-install.sh
```

> 🚀 Built as a hands-on Kubernetes learning project using AWS EC2 and kubeadm.
