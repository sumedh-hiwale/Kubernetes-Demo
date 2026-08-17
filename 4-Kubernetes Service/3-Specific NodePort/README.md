# 🌐 Kubernetes Service Demo — Part 3

## 🟣 Specific NodePort

In the previous demo, Kubernetes automatically assigned a NodePort.

In this demo, we will **manually specify a NodePort**, for example `30030`.

---

## 🎯 What We Will Learn

* 🟣 Configure a specific NodePort
* 🔢 Use the `nodePort` field
* 🔍 Verify the assigned NodePort
* 🌐 Access the Service using the selected port

---

# 📝 Step 1: Edit the Service YAML

Edit the Service configuration:

```bash id="yq8p5h"
vi svc.yaml
```

Use the following configuration:

```yaml id="h4t6d1"
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

## 🔑 Important Change

The important field here is:

```yaml id="z6h2w8"
nodePort: 30030
```

This tells Kubernetes:

> 🟣 Use `30030` as the NodePort instead of automatically assigning a port.

---

# 🚀 Step 2: Apply the Service

```bash id="9d7l8a"
k apply -f svc.yaml
```

---

# 🔍 Step 3: Verify the Service

```bash id="r6z3pq"
k get svc
```

Expected output:

```text id="w8f1xk"
NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)
kubernetes    ClusterIP  10.96.0.1       <none>        443/TCP
my-service1   NodePort   10.105.113.27   <none>        18080:30030/TCP
```

The important part is:

```text id="0l8k2m"
18080:30030/TCP
```

Here:

```text id="h6y9xq"
18080 → Service Port
30030 → Manually Specified NodePort
```

---

# 🌐 Step 4: Access the Service

Now access the Service using:

```text id="8c4p4z"
<NodeIP>:30030
```

For example:

```bash id="d0x8av"
curl <NodeIP>:30030
```

If the Service is working correctly, you should receive the Apache HTTP server response:

```html id="8c9z2p"
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

# 🔎 Step 5: Describe the Service

Check the Service details:

```bash id="p9h4w6"
k describe svc my-service1
```

Look for:

```text id="v7d2k1"
Type:         NodePort
Selector:     name=sumedh
Port:         18080/TCP
TargetPort:   80/TCP
NodePort:     30030/TCP
Endpoints:    <Pod-IP>:80
```

---

# 🧠 How It Works

```text id="7y6k2m"
🌐 Client
   │
   ↓
🖥️ NodeIP:30030
   │
   ↓
🟣 NodePort Service
   │
   ↓
🎯 Selector: name=sumedh
   │
   ↓
📦 myhttpd2 Pod
   │
   ↓
🌐 Apache httpd :80
```

---

# 📊 Port Mapping

| Port    | Purpose                        |
| ------- | ------------------------------ |
| `80`    | 🌐 Application port inside Pod |
| `18080` | 🔵 Service port                |
| `30030` | 🟣 Manually specified NodePort |

```text id="d1v5k7"
Pod
 ↓
targetPort: 80
 ↓
Service port: 18080
 ↓
nodePort: 30030
 ↓
NodeIP:30030
```

---

# ⭐ Key Points

* 🟣 `nodePort` allows you to specify a particular NodePort.
* 🔢 In this demo, we manually selected `30030`.
* 🌐 The Service can be accessed using `NodeIP:30030`.
* 🎯 The Service still uses `selector: name=sumedh` to select the target Pod.
* 🚪 `port` is the Service port.
* 📦 `targetPort` is the application port inside the Pod.
* 🔵 `NodePort` exposes the Service on each Kubernetes Node.
* ⚠️ The selected NodePort must be available and within Kubernetes' configured NodePort range.

---

# 📌 Important Commands

```bash id="l8v4t2"
# Edit Service
vi svc.yaml

# Apply Service
k apply -f svc.yaml

# Check Service
k get svc

# Describe Service
k describe svc my-service1

# Access Service
curl <NodeIP>:30030
```

---

## 🎯 Demo Summary

**Topic:** Kubernetes Service
**Part:** 3️⃣ Specific NodePort
**Service:** `my-service1`
**Service Type:** `NodePort`
**Service Port:** `18080`
**Target Port:** `80`
**Specific NodePort:** `30030`

✨ **Part 3 — Specific NodePort completed successfully!**
