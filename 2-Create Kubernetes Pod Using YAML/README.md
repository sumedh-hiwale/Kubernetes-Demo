# 📦 Create Kubernetes Pod Using YAML

This demo explains **two different ways to create a Kubernetes Pod YAML file** and deploy the Pod using `kubectl`.

---

## 📝 Method 1: Manually Create the YAML File

### 📄 Step 1: Create the YAML File

```bash
vi firstpod.yaml
```

Add the following configuration:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myfirstpod
  labels:
    env: prod
spec:
  containers:
    - name: container-name
      image: nginx:latest
```

---

### 🧪 Step 2: Validate the YAML

Use `--dry-run=client` to check the configuration without creating the Pod:

```bash
k apply -f firstpod.yaml --dry-run=client
```

---

### 🚀 Step 3: Create the Pod

```bash
k apply -f firstpod.yaml
```

---

### 🔍 Step 4: Verify the Pod

```bash
k get pods
```

---

### 📚 Step 5: Explore Pod YAML Fields

```bash
kubectl explain pod --recursive | less
```

This command helps you understand the available fields and structure of a Kubernetes Pod YAML configuration.

---

# ⚡ Method 2: Generate YAML Using `kubectl run`

Instead of manually writing the YAML, Kubernetes can generate a basic Pod YAML file for you.

### 🛠️ Step 1: Generate the YAML

```bash
kubectl run secondpod --image=nginx:latest --dry-run=client -o yaml > mysecondpod.yaml
```

📌 Here:

* `--dry-run=client` → Generates the YAML without creating the Pod.
* `-o yaml` → Outputs the configuration in YAML format.
* `>` → Saves the output into a file.

---

### 📄 Step 2: View the Generated YAML

```bash
vi mysecondpod.yaml
```

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secondpod
  name: secondpod
spec:
  containers:
    - image: nginx:latest
      name: secondpod
```

---

### 🚀 Step 3: Create the Pod

```bash
k apply -f mysecondpod.yaml
```

---

### 🔍 Step 4: Verify the Pods

```bash
k get pods
```

Expected output:

```text
NAME         READY   STATUS    RESTARTS   AGE
myfirstpod   1/1     Running   0          13m
secondpod    1/1     Running   0          3s
```

---

## 📌 Important Commands

| Command                                        | Purpose                                |
| ---------------------------------------------- | -------------------------------------- |
| 📝 `vi firstpod.yaml`                          | Manually create a Pod YAML file        |
| 🧪 `k apply -f firstpod.yaml --dry-run=client` | Validate YAML without creating the Pod |
| 🚀 `k apply -f firstpod.yaml`                  | Create the Pod from YAML               |
| 📚 `kubectl explain pod --recursive \| less`   | Explore Pod YAML fields                |
| ⚡ `kubectl run ... --dry-run=client -o yaml`   | Generate Pod YAML                      |
| 🔍 `k get pods`                                | Verify Pods                            |

---

## ⭐ Two Ways to Create Pod YAML

### 📝 Method 1 — Manual

```text
Create YAML File
      ↓
Write Pod Configuration
      ↓
--dry-run=client
      ↓
kubectl apply
      ↓
Pod Created 🚀
```

### ⚡ Method 2 — Generate Using kubectl

```text
kubectl run
      ↓
--dry-run=client -o yaml
      ↓
YAML File Generated
      ↓
kubectl apply
      ↓
Pod Created 🚀
```

---

## 🧠 Key Points

* 📦 A Kubernetes Pod can be created using a YAML manifest.
* 📝 YAML can be written **manually**.
* ⚡ YAML can also be **generated using `kubectl run`**.
* 🧪 `--dry-run=client` generates or validates configuration without creating the resource.
* 📄 `-o yaml` displays the generated configuration in YAML format.
* 🚀 `kubectl apply -f` creates the resource from a YAML file.
* 📚 `kubectl explain` helps understand Kubernetes resource fields.

---

## 🎯 Demo Summary

**Topic:** Create Kubernetes Pod Using YAML
**Resource:** Pod
**Image:** `nginx:latest`
**Methods:** Manual YAML + `kubectl run` YAML generation
**Tool:** `kubectl`

✨ **Practice completed successfully!**
