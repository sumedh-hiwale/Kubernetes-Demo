# 🌐 Kubernetes Service Demo — Part 2

## 🔵 NodePort Service

This demo explains how to expose a Kubernetes Service using **NodePort**.

A NodePort Service allows you to access the application using:

```text
<NodeIP>:<NodePort>
```

---

## 🎯 What We Will Learn

* 🔵 Create a NodePort Service
* 🔗 Use a Service selector
* 🔍 Check the automatically assigned NodePort
* 🌐 Access the Service using Node IP and NodePort

---

## 📦 Prerequisite

In the previous demo, we created the Pod:

```text
myhttpd2
```

with the label:

```yaml
labels:
  class: cka
  name: sumedh
```

The Service will use this label to select the Pod.

---

# 📝 Step 1: Configure NodePort Service

Edit the Service YAML file:

```bash
vi svc.yaml
```

Use the following configuration:

```yaml
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

### 🧠 Important

Here we added:

```yaml
type: NodePort
```

This changes the Service from the default **ClusterIP** to **NodePort**.

---

# 🚀 Step 2: Apply the Service

```bash
k apply -f svc.yaml
```

---

# 🔍 Step 3: Check the Service

```bash
k get svc
```

Example output:

```text
NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)
kubernetes    ClusterIP  10.96.0.1       <none>        443/TCP
my-service1   NodePort   10.105.113.27   <none>        18080:32217/TCP
```

---

# 📌 Understanding the Ports

The output shows:

```text
18080:32217/TCP
```

It means:

```text
18080 → Service Port
32217 → NodePort
```

Kubernetes automatically assigned `32217` as the NodePort.

---

# 🌐 Step 4: Access the Service

The NodePort Service can be accessed using:

```text
<NodeIP>:32217
```

For example:

```bash
curl <NodeIP>:32217
```

The request flow is:

```text
🌐 Client
   │
   ↓
🖥️ NodeIP:32217
   │
   ↓
🔵 NodePort Service
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

# 🔎 Step 5: Verify Service Details

```bash
k describe svc my-service1
```

Check these fields:

```text
Type:         NodePort
Selector:     name=sumedh
Port:         18080/TCP
TargetPort:   80/TCP
NodePort:     32217/TCP
Endpoints:    <Pod-IP>:80
```

---

# ⭐ Key Points

* 🔵 `NodePort` exposes the Service through a port on each Kubernetes Node.
* 🌐 The Service can be accessed using `NodeIP:NodePort`.
* 🔢 Kubernetes automatically assigns the NodePort if you don't specify one.
* 🎯 The Service still uses a selector to find the target Pod.
* 🚪 `port` is the Service port.
* 📦 `targetPort` is the application port inside the Pod.
* 🔗 `nodePort` is the port exposed on the Node.
* 🟢 The default Service type is `ClusterIP`; here we explicitly changed it to `NodePort`.

---

# 📊 Port Mapping

| Port    | Purpose                            |
| ------- | ---------------------------------- |
| `80`    | 🌐 Application port inside Pod     |
| `18080` | 🔵 Service port                    |
| `32217` | 🌐 Automatically assigned NodePort |

```text
Pod
 ↓
Port 80
 ↓
Service Port 18080
 ↓
NodePort 32217
 ↓
NodeIP:32217
```

---

# 📌 Important Commands

```bash
# Edit Service
vi svc.yaml

# Apply Service
k apply -f svc.yaml

# Check Service
k get svc

# Describe Service
k describe svc my-service1

# Access Service
curl <NodeIP>:32217
```

---

## 🎯 Demo Summary

**Topic:** Kubernetes Service
**Part:** 2️⃣ NodePort Service
**Service:** `my-service1`
**Service Type:** `NodePort`
**Service Port:** `18080`
**Target Port:** `80`
**NodePort:** Automatically assigned

✨ **Part 2 — NodePort Service completed successfully!**
