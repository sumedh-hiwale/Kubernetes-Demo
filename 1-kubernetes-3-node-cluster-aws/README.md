# Kubernetes 3-Node Cluster on AWS EC2

This project demonstrates how to create and configure a 3-node Kubernetes cluster on AWS EC2 using kubeadm.

The cluster consists of:

- 1 Kubernetes Control Plane
- 2 Kubernetes Worker Nodes
- containerd as the container runtime
- kubeadm for cluster initialization and node joining
- kubelet for managing Pods
- kubectl for interacting with the Kubernetes cluster
- Calico as the Container Network Interface (CNI)

---

## 1. AWS EC2 Instance Setup

Create three EC2 instances for the Kubernetes cluster.

### Control Plane Instance

- Name: control-plane
- AMI: Ubuntu Server 24.04 LTS
- Instance Type: t3.small
- vCPU: 2
- Memory: 2 GiB
- Storage: 30 GiB gp3
- Key Pair: kucl-key
- VPC: Same VPC as Worker Nodes
- Security Group: Control Plane Security Group

### Worker Node 1

- Name: worker-node-1
- AMI: Ubuntu Server 24.04 LTS
- Instance Type: t3.small
- vCPU: 2
- Memory: 2 GiB
- Storage: 30 GiB gp3
- Key Pair: kucl-key
- VPC: Same VPC as Control Plane
- Security Group: Worker Node Security Group

### Worker Node 2

- Name: worker-node-2
- AMI: Ubuntu Server 24.04 LTS
- Instance Type: t3.small
- vCPU: 2
- Memory: 2 GiB
- Storage: 30 GiB gp3
- Key Pair: kucl-key
- VPC: Same VPC as Control Plane
- Security Group: Worker Node Security Group

All three EC2 instances should be inside the same AWS VPC.

### Why t3.small?

t3.micro provides around 1 GiB of memory, which can cause kubeadm init to fail the minimum memory preflight check.

For this Kubernetes lab, t3.small is used.

---

## 2. Security Groups

Two Security Groups are used:

- Control Plane Security Group
- Worker Node Security Group

### Control Plane Security Group

Allow:

- SSH — TCP 22 — Source: My IP
- Kubernetes API Server — TCP 6443 — Source: Worker Node Security Group

Port 6443 is used by the Kubernetes API Server.

### Worker Node Security Group

Allow:

- SSH — TCP 22 — Source: My IP

Use the same Worker Node Security Group for both Worker Nodes.

Note: For a new setup, descriptive Security Group names such as k8s-control-plane-sg and k8s-worker-sg are recommended.

---

## 3. SSH Connection

Connect to each EC2 instance from a terminal or PowerShell using SSH.

### Control Plane

ssh -i "kucl-key.pem" ubuntu@<CONTROL_PLANE_PUBLIC_DNS>

### Worker Node 1

ssh -i "kucl-key.pem" ubuntu@<WORKER_1_PUBLIC_DNS>

### Worker Node 2

ssh -i "kucl-key.pem" ubuntu@<WORKER_2_PUBLIC_DNS>

Replace the Public DNS with the actual Public DNS of each EC2 instance.

Never upload the .pem private key to GitHub.

---

## 4. Installation Scripts

After creating and connecting to the instances:

- control-plane-install.sh → Control Plane installation
- worker-node-install.sh → Worker Node installation

The worker-node-install.sh script is used on both Worker Node 1 and Worker Node 2.

The installation scripts contain:

- Kubernetes prerequisites
- Swap configuration
- containerd installation
- Kubernetes networking configuration
- kubeadm installation
- kubelet installation
- kubectl installation

---

## 5. Run the Installation Scripts

### Control Plane

Connect to the Control Plane and run:

chmod +x control-plane-install.sh

./control-plane-install.sh

### Worker Node 1

Connect to Worker Node 1 and run:

chmod +x worker-node-install.sh

./worker-node-install.sh

### Worker Node 2

Connect to Worker Node 2 and run:

chmod +x worker-node-install.sh

./worker-node-install.sh

The same worker-node-install.sh script is used for both Worker Nodes.

---

## 6. Post-Installation Steps

After running the installation scripts on all three nodes, complete the following steps.

### Step 1: Initialize the Control Plane

Run on the Control Plane:

sudo kubeadm init

After successful initialization, kubeadm will display a Worker Node join command.

---

### Step 2: Configure kubectl

Run on the Control Plane:

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

Verify:

kubectl get nodes

At this stage, the Control Plane may show NotReady until the Pod network is installed.

---

### Step 3: Install Calico CNI

Run on the Control Plane:

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.2/manifests/calico.yaml

Verify:

kubectl get pods -n kube-system

---

### Step 4: Generate Worker Node Join Command

Run on the Control Plane:

kubeadm token create --print-join-command

This generates the complete kubeadm join command.

Example:

kubeadm join <CONTROL_PLANE_PRIVATE_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>

Do not publish the real token or discovery hash in a public GitHub repository.

---

### Step 5: Join Worker Node 1

Run the generated join command on Worker Node 1:

sudo kubeadm join <CONTROL_PLANE_PRIVATE_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>

If successful, the Worker Node will join the Kubernetes cluster.

---

### Step 6: Join Worker Node 2

Run the same generated join command on Worker Node 2:

sudo kubeadm join <CONTROL_PLANE_PRIVATE_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>

If successful, the Worker Node will join the Kubernetes cluster.

---

### Step 7: Verify All Nodes

Run on the Control Plane:

kubectl get nodes

Expected:

NAME               STATUS   ROLES           VERSION
<control-plane>    Ready    control-plane   v1.37.0
<worker-1>         Ready    <none>          v1.37.0
<worker-2>         Ready    <none>          v1.37.0

The Worker Nodes are part of the cluster even if their ROLES column shows <none>.

---

### Step 8: Add Worker Role Labels

If Worker Nodes show <none> under the ROLES column, add the worker labels.

Run on the Control Plane:

kubectl label node worker-1 node-role.kubernetes.io/worker=worker

kubectl label node worker-2 node-role.kubernetes.io/worker=worker

Verify:

kubectl get nodes

Expected:

NAME               STATUS   ROLES           VERSION
<control-plane>    Ready    control-plane   v1.37.0
worker-1           Ready    worker          v1.37.0
worker-2           Ready    worker          v1.37.0

---

### Step 9: Verify Kubernetes System Pods

Run on the Control Plane:

kubectl get pods -A

Important components include:

- etcd
- kube-apiserver
- kube-controller-manager
- kube-scheduler
- CoreDNS
- kube-proxy
- Calico

The required Pods should eventually show Running.

---

### Step 10: Deploy a Test nginx Pod

Run on the Control Plane:

kubectl run nginx --image=nginx

Verify:

kubectl get pods

Check which node is running the nginx Pod:

kubectl get pods -o wide

Example:

NAME    READY   STATUS    IP                NODE
nginx   1/1     Running   192.168.x.x       worker-1

This confirms that Kubernetes can successfully schedule and run a Pod on a Worker Node.

---

## 7. Final Cluster Verification

Run on the Control Plane:

kubectl get nodes

kubectl get pods -A

kubectl get pods -o wide

Expected final cluster:

Control Plane → Ready
Worker Node 1 → Ready
Worker Node 2 → Ready
Calico        → Running
nginx Pod     → Running

---

## 8. Troubleshooting

### Insufficient Memory

If you see:

[ERROR Mem]: the system RAM is less than the minimum

Use:

t3.small
2 vCPU
2 GiB RAM

instead of t3.micro.

---

### containerd Not Running

Check:

sudo systemctl status containerd

Start and enable containerd:

sudo systemctl enable --now containerd

---

### Worker Cannot Connect to Control Plane

Test from the Worker Node:

nc -zv <CONTROL_PLANE_PRIVATE_IP> 6443

Expected:

Connection ... 6443 port ... succeeded!

If the connection fails, check:

1. Control Plane Security Group
2. Worker Node Security Group
3. VPC networking
4. Control Plane private IP
5. Kubernetes API Server status

The Control Plane must allow TCP port 6443 from the Worker Node Security Group.

---

### kubeadm Join Error: Existing Configuration

If you see:

/etc/kubernetes/kubelet.conf already exists
/etc/kubernetes/pki/ca.crt already exists
Port 10250 is in use

The Worker Node may contain an old Kubernetes configuration.

Run on the affected Worker Node:

sudo kubeadm reset -f

Remove old CNI configuration:

sudo rm -rf /etc/cni/net.d

Restart containerd:

sudo systemctl restart containerd

Generate a fresh join command from the Control Plane:

kubeadm token create --print-join-command

Run the generated command on the Worker Node.

Do not run kubeadm reset -f on the Control Plane unless you intentionally want to reset the cluster.

---

### Port 6443 Connection Timeout

If this command hangs or times out on the Worker Node:

nc -zv <CONTROL_PLANE_PRIVATE_IP> 6443

Check:

1. Control Plane Security Group
2. Worker Node Security Group
3. VPC networking
4. Control Plane private IP
5. Kubernetes API Server status

---

## 9. Useful Kubernetes Commands

### Get Nodes

kubectl get nodes

### Get Nodes with Detailed Information

kubectl get nodes -o wide

### Get All Pods

kubectl get pods -A

### Get Pods with Node Information

kubectl get pods -o wide

### Describe a Node

kubectl describe node <NODE_NAME>

### Check System Pods

kubectl get pods -n kube-system

### Check Node Labels

kubectl get nodes --show-labels

---

## 10. Kubernetes Components

| Component | Purpose |
|-----------|---------|
| kubeadm | Initializes the cluster and joins nodes |
| kubelet | Runs and manages Pods on nodes |
| kubectl | Command-line tool for Kubernetes |
| containerd | Container runtime |
| Calico | Pod networking / CNI |
| etcd | Stores Kubernetes cluster state |
| kube-apiserver | Kubernetes API |
| kube-scheduler | Schedules Pods to nodes |
| kube-controller-manager | Runs Kubernetes controllers |
| CoreDNS | Provides cluster DNS |
| kube-proxy | Handles Kubernetes Service networking |

---

## 11. Final Architecture

                         Kubernetes Cluster
                                |
              +-----------------+-----------------+
              |                 |                 |
              |                 |                 |
       Control Plane        Worker Node 1      Worker Node 2
              |                 |                 |
         kube-apiserver       kubelet           kubelet
         kube-scheduler       containerd        containerd
         controller-manager
         etcd
              |
           kubectl
              |
              +-------------------+
                                  |
                              Calico CNI
                                  |
                              nginx Pod
                                  |
                         Worker Node 1 / 2

---

## 12. Security Notes

Never commit sensitive information to GitHub.

Do NOT upload:

- .pem private keys
- AWS Access Keys
- AWS Secret Keys
- Private Keys
- Kubeconfig files
- Real kubeadm tokens
- Passwords
- Kubernetes Secrets

Recommended .gitignore:

*.pem
*.key
.env
kubeconfig

---

## 13. Cleanup

When the lab is no longer required, stop or terminate the EC2 instances.

For temporary practice:

Stop EC2 instances

For a permanently finished lab:

Terminate EC2 instances

Also check for unused AWS resources such as:

- EBS volumes
- Elastic IPs
- Load Balancers
- Other AWS resources

Stopping EC2 instances does not necessarily eliminate all AWS charges. EBS storage and other resources may continue to incur charges.

---

## 14. Technologies Used

- AWS EC2
- Ubuntu Server 24.04 LTS
- Kubernetes v1.37.0
- kubeadm
- kubelet
- kubectl
- containerd
- Calico CNI

---

## 15. Learning Objectives

This project provides hands-on experience with:

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
