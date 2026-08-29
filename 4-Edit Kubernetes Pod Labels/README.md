# 🏷️ Edit Kubernetes Pod Labels

This demo explains how to **add and modify Pod labels using `kubectl edit`**.

---

## 📝 1. Create the Pod YAML File

Create the YAML file:

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
    newlbl: gaurav
spec:
  containers:
    - name: container-name
      image: nginx:latest
```

---

## 🚀 2. Create the Pod

```bash
k apply -f firstpod.yaml
```

---

## 🔍 3. Verify the Pod

```bash
k get pods
```

---

## 🏷️ 4. Check Pod Labels

```bash
k get pods myfirstpod --show-labels
```

Expected output:

```text
NAME         READY   STATUS    RESTARTS   AGE   LABELS
myfirstpod   1/1     Running   0          91s   newlbl=gaurav
```

---

## ✏️ 5. Edit the Pod

Open the Pod configuration for editing:

```bash
k edit pod myfirstpod
```

Find the **Labels** section and add another label:

```yaml
labels:
  newlbl: gaurav
  newlbl11: gaurav1
```

Save and exit the editor.

---

## ✅ 6. Verify the Updated Labels

```bash
k get pods myfirstpod --show-labels
```

Expected output:

```text
NAME         READY   STATUS    RESTARTS   AGE     LABELS
myfirstpod   1/1     Running   0          5m58s   newlbl11=gaurav1,newlbl=gaurav
```

---

## 📌 Important Commands

| Command                                   | Purpose                    |
| ----------------------------------------- | -------------------------- |
| 📝 `vi firstpod.yaml`                     | Create the Pod YAML file   |
| 🚀 `k apply -f firstpod.yaml`             | Create the Pod             |
| 🔍 `k get pods`                           | Check Pod status           |
| 🏷️ `k get pods myfirstpod --show-labels` | Display Pod labels         |
| ✏️ `k edit pod myfirstpod`                | Edit the Pod configuration |

---

## ⭐ Key Points

* 🏷️ A Pod can have **multiple labels**.
* ✏️ `kubectl edit` opens the live Pod configuration for editing.
* ➕ New labels can be added from the **Labels** section.
* 🔍 `--show-labels` displays all labels attached to the Pod.
* 📦 Labels are stored under `metadata.labels`.

---

## 🧠 Demo Flow

```text
📝 Create YAML
      ↓
🚀 Create Pod
      ↓
🏷️ Check Existing Label
      ↓
✏️ Edit Pod using kubectl edit
      ↓
➕ Add New Label
      ↓
🔍 Verify Labels
```

---

## 🎯 Demo Summary

**Topic:** Edit Kubernetes Pod Labels
**Resource:** Pod
**Image:** `nginx:latest`
**Command:** `kubectl edit`
**Key Option:** `--show-labels`

✨ **Practice completed successfully!**
