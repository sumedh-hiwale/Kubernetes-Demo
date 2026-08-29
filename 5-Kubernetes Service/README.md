# 🌐 Kubernetes Service Demo

This demo explains how to expose Kubernetes Pods using a **Service**.

In this demo, we cover three important Service configurations:

* 🟢 **Part 1 — ClusterIP Service**
* 🔵 **Part 2 — NodePort Service**
* 🟣 **Part 3 — Specific NodePort**

---

# 🟢 Part 1: ClusterIP Service

**ClusterIP** is the default Service type in Kubernetes.

It provides network access to Pods **inside the Kubernetes cluster**.

---

## 📦 Step 1: Create Pod 1

Create the YAML file:

```bash id="v1k8g2"
vim pod1.yml
```

```yaml id="m7f3s9"
apiVersion: v1
kind: Pod
metadata:
  name: myhttpd1
  labels:
    class: cka
spec:
  containers:
    - name: httpd
      image: httpd
      ports:
        - containerPort: 80
```

Create the Pod:

```bash id="d8k2p1"
k apply -f pod1.yml
```

---

## 📦 Step 2: Create Pod 2

Create the YAML file:

```bash id="r4m7x2"
vi pod2.yaml
```

```yaml id="q9w3e6"
apiVersion: v1
kind: Pod
metadata:
  name: myhttpd2
  labels:
    class: cka
    name: sumedh
spec:
  containers:
    - name: httpd
      image: httpd
      ports:
        - containerPort: 80
```

Create the Pod:

```bash id="t6n1c8"
k apply -f pod2.yaml
```

---

## 🔍 Step 3: Verify Pods

```bash id="y5p2k7"
k get pods
```

Expected:

```text id="b8v4m1"
NAME       READY   STATUS    RESTARTS   AGE
myhttpd1   1/1     Running   0          12m
myhttpd2   1/1     Running   0          8m
```

---

## 🔗 Step 4: Create ClusterIP Service

Create the Service file:

```bash id="c3x8n5"
vi svc.yaml
```

```yaml id="j6r2v9"
apiVersion: v1
kind: Service
metadata:
  name: my-service1
spec:
  selector:
    name: sumedh
  ports:
    - protocol: TCP
      port: 18080
      targetPort: 80
```

Create the Service:

```bash id="p7m4q2"
k apply -f svc.yaml
```

---

## 🔍 Step 5: Check the Service

```bash id="n9w5c3"
k get svc
```

Example:

```text id="h2k7m4"
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)
kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP
my-service1   ClusterIP   10.101.148.112   <none>        18080/TCP
```

---

## 🧪 Step 6: Test ClusterIP

```bash id="x4p8j1"
curl 10.101.148.112:18080
```

Expected response:

```html id="f6k2m8"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
<title>It works! Apache httpd</title>
</head>
<body>
<p>It works!</p>
</body>
</html>
```

---

## 🔎 Step 7: Describe the Service

```bash id="s7v3n9"
k describe svc my-service1
```

Important information:

```text id="q1m5x8"
Selector:     name=sumedh
Type:         ClusterIP
IP:           10.101.148.112
Port:         18080/TCP
TargetPort:   80/TCP
Endpoints:    <Pod-IP>:80
```

### 🧠 How ClusterIP Selects the Pod

Service selector:

```yaml id="w8k4p2"
selector:
  name: sumedh
```

Matching Pod label:

```yaml id="e3n7c5"
labels:
  class: cka
  name: sumedh
```

Therefore, the Service selects `myhttpd2`.

```text id="z6r1v9"
Client
  ↓
🟢 ClusterIP Service
  ↓
Selector: name=sumedh
  ↓
📦 myhttpd2
  ↓
Port 80
```

---

# 🔵 Part 2: NodePort Service

**NodePort** allows the Service to be accessed using a port on a Kubernetes Node.

---

## 📝 Step 1: Configure NodePort

Edit the Service:

```bash id="k8m2v6"
vi svc.yaml
```

```yaml id="r5x9p3"
apiVersion: v1
kind: Service
metadata:
  name: my-service1
spec:
  type: NodePort
  selector:
    name: sumedh
  ports:
    - protocol: TCP
      port: 18080
      targetPort: 80
```

Apply:

```bash id="n4c7j1"
k apply -f svc.yaml
```

---

## 🔍 Step 2: Check NodePort

```bash id="v9p3m6"
k get svc
```

Example:

```text id="b5x1r8"
NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)
kubernetes    ClusterIP  10.96.0.1       <none>        443/TCP
my-service1   NodePort   10.105.113.27   <none>        18080:32217/TCP
```

Here:

```text id="m2q8v4"
18080 → Service Port
32217 → Automatically Assigned NodePort
```

---

## 🌐 Step 3: Access the Service

```text id="t7x3n1"
<NodeIP>:32217
```

Example:

```bash id="p6k9w2"
curl <NodeIP>:32217
```

Flow:

```text id="h4m8c1"
🌐 Client
  ↓
🖥️ NodeIP:32217
  ↓
🔵 NodePort Service
  ↓
🎯 Selector: name=sumedh
  ↓
📦 myhttpd2
  ↓
🌐 Apache httpd :80
```

---

# 🟣 Part 3: Specific NodePort

By default, Kubernetes automatically assigns a NodePort.

You can also specify your own NodePort.

In this demo, we use **`30030`**.

---

## 📝 Step 1: Configure Specific NodePort

Edit the Service:

```bash id="q5n8m2"
vi svc.yaml
```

```yaml id="j3r7v9"
apiVersion: v1
kind: Service
metadata:
  name: my-service1
spec:
  type: NodePort
  selector:
    name: sumedh
  ports:
    - protocol: TCP
      port: 18080
      targetPort: 80
      nodePort: 30030
```

---

## 🚀 Step 2: Apply the Configuration

```bash id="x8c4p1"
k apply -f svc.yaml
```

---

## 🔍 Step 3: Verify

```bash id="m6v2k9"
k get svc
```

Expected:

```text id="r3n7x5"
my-service1   NodePort   ...   18080:30030/TCP
```

Here:

```text id="y1p8q4"
18080 → Service Port
30030 → Manually Specified NodePort
```

---

## 🌐 Step 4: Access the Service

```text id="w7k2m5"
<NodeIP>:30030
```

Example:

```bash id="c9x4n1"
curl <NodeIP>:30030
```

---

# 📊 Kubernetes Service Port Mapping

| Port    | Purpose                            |
| ------- | ---------------------------------- |
| `80`    | 🌐 Application port inside the Pod |
| `18080` | 🔵 Service port                    |
| `32217` | 🔢 Automatically assigned NodePort |
| `30030` | 🟣 Manually specified NodePort     |

### 🧠 Remember

```text id="p4m8x2"
Application
    ↓
Port 80
    ↓
Service
    ↓
Port 18080
    ↓
NodePort
    ↓
Port 30030
    ↓
NodeIP:30030
```

---

# 📌 Important Commands

```bash id="x7n2c5"
# Check Pods
k get pods

# Check Services
k get svc

# Describe Service
k describe svc my-service1

# Apply YAML
k apply -f svc.yaml

# Test ClusterIP
curl <ClusterIP>:18080

# Test NodePort
curl <NodeIP>:<NodePort>
```

---

# ⭐ Key Points

* 🌐 A **Service** provides stable network access to Pods.
* 🟢 **ClusterIP** provides internal cluster access.
* 🔵 **NodePort** exposes the Service through a Node port.
* 🟣 **Specific NodePort** allows you to manually choose the NodePort.
* 🎯 Service selectors are used to find matching Pods.
* 🏷️ Pod labels must match the Service selector.
* 🚪 `port` is the Service port.
* 📦 `targetPort` is the application port inside the Pod.
* 🌐 `nodePort` is the port exposed on the Node.

---

# 🧠 Easy Memory Trick

```text id="q8m3v6"
🟢 ClusterIP
      ↓
Inside Cluster

🔵 NodePort
      ↓
NodeIP + Auto-Assigned Port

🟣 Specific NodePort
      ↓
NodeIP + Your Selected Port
```

---

# 🎯 Demo Summary

| Part      | Service Type      | Access            |
| --------- | ----------------- | ----------------- |
| 🟢 Part 1 | ClusterIP         | Internal Cluster  |
| 🔵 Part 2 | NodePort          | `NodeIP:AutoPort` |
| 🟣 Part 3 | Specific NodePort | `NodeIP:30030`    |

**Topic:** Kubernetes Service
**Pods:** `myhttpd1`, `myhttpd2`
**Service:** `my-service1`
**Application:** Apache HTTP Server
**Service Port:** `18080`
**Target Port:** `80`
**Specific NodePort:** `30030`

✨ **Kubernetes Service Demo completed successfully!**
