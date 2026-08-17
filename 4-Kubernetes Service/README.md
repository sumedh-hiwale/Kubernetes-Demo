# 🌐 Kubernetes Service Demo — Part 1

## 🟢 ClusterIP Service

This demo explains how to create a **ClusterIP Service** and use a Service selector to connect the Service with a Pod.

### 🎯 What We Will Learn

* 📦 Create Kubernetes Pods
* 🏷️ Use Pod labels
* 🌐 Create a ClusterIP Service
* 🎯 Use a Service selector
* 🔍 Check Service endpoints
* 🧪 Test the Service using `curl`

---

## 📦 Step 1: Create the First Pod

Create the YAML file:

```bash
vim pod1.yml
```

Add the following configuration:

```yaml
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

```bash
k apply -f pod1.yml
```

---

## 📦 Step 2: Create the Second Pod

Create the YAML file:

```bash
vi pod2.yaml
```

Add the following configuration:

```yaml
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

```bash
k apply -f pod2.yaml
```

---

## 🔍 Step 3: Verify the Pods

```bash
k get pods
```

Expected output:

```text
NAME       READY   STATUS    RESTARTS   AGE
myhttpd1   1/1     Running   0          12m
myhttpd2   1/1     Running   0          8m
```

---

# 🔗 Step 4: Create the ClusterIP Service

Create the Service YAML file:

```bash
vi svc.yaml
```

Add:

```yaml
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

### 🧠 Important

The Service has this selector:

```yaml
selector:
  name: sumedh
```

And `myhttpd2` has the matching label:

```yaml
labels:
  class: cka
  name: sumedh
```

Therefore, the Service selects **`myhttpd2`**.

---

## 🚀 Step 5: Create the Service

```bash
k apply -f svc.yaml
```

---

## 🔍 Step 6: Verify the Service

```bash
k get svc
```

Example:

```text
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)
kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP
my-service1   ClusterIP   10.101.148.112   <none>        18080/TCP
```

---

## 🧪 Step 7: Test the Service

Use the Service's ClusterIP and port:

```bash
curl 10.101.148.112:18080
```

Expected response:

```html
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

✅ The response confirms that the Service is successfully forwarding traffic to the selected Pod.

---

## 🔎 Step 8: Describe the Service

```bash
k describe svc my-service1
```

Important information:

```text
Selector:     name=sumedh
Type:         ClusterIP
IP:           10.101.148.112
Port:         18080/TCP
TargetPort:   80/TCP
Endpoints:    <Pod-IP>:80
```

### 📌 Important Fields

| Field           | Meaning                                |
| --------------- | -------------------------------------- |
| 🎯 `Selector`   | Selects Pods using labels              |
| 🌐 `ClusterIP`  | Internal IP of the Service             |
| 🚪 `Port`       | Port exposed by the Service            |
| 📦 `TargetPort` | Port of the application inside the Pod |
| 🔗 `Endpoints`  | IP and port of the selected Pod        |

---

# 🧠 How ClusterIP Works

```text
                🌐 Client
                    │
                    ↓
          🟢 ClusterIP Service
             my-service1
                    │
             port: 18080
                    │
                    ↓
          🎯 Selector: name=sumedh
                    │
                    ↓
             📦 myhttpd2 Pod
                    │
              targetPort: 80
                    │
                    ↓
             🌐 Apache httpd
```

---

# ⭐ Key Points

* 🟢 **ClusterIP** is the default Kubernetes Service type.
* 🌐 It provides **internal access** to Pods within the cluster.
* 🎯 The Service uses a **selector** to find matching Pods.
* 🏷️ Pod labels must match the Service selector.
* 🚪 `port` is the Service port.
* 📦 `targetPort` is the application port inside the Pod.
* 🔗 `Endpoints` show the Pods receiving Service traffic.
* 🧪 The Service can be tested using `curl`.

---

# 📌 Important Commands

```bash
# Create resources
k apply -f pod1.yml
k apply -f pod2.yaml
k apply -f svc.yaml

# Check Pods
k get pods

# Check Service
k get svc

# Describe Service
k describe svc my-service1

# Test Service
curl <ClusterIP>:18080
```

---

## 🎯 Demo Summary

**Topic:** Kubernetes Service
**Part:** 1️⃣ ClusterIP Service
**Pods:** `myhttpd1`, `myhttpd2`
**Service:** `my-service1`
**Service Type:** `ClusterIP`
**Service Port:** `18080`
**Target Port:** `80`

✨ **Part 1 — ClusterIP Service completed successfully!**
