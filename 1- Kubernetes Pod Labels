# 🏷️ Kubernetes Pod Labels.

This demo explains how to **create Pods, add labels, update labels, delete labels, and apply labels to multiple Pods** using `kubectl`.

---

## 🚀 1. Create the First Pod

Create a Pod using the custom NGINX image:

```bash
kubectl run firstpod --image=coolgourav147/nginx-custom
```

🔍 Verify the Pod:

```bash
k get pods
```

📋 Check Pod details:

```bash
k describe pod firstpod | less
```

---

## 🏷️ 2. Add a Label to the Pod

Add the label `env=testing`:

```bash
k label pod firstpod env=testing
```

🔍 Verify the label:

```bash
k get pod firstpod --show-labels
```

---

## ➕ 3. Add Another Label

Add `env1=dev`:

```bash
k label pod firstpod env1=dev
```

🔍 Verify:

```bash
k get pod firstpod --show-labels
```

---

## 🔄 4. Update an Existing Label

Try to change the existing `env` label:

```bash
k label pod firstpod env=prod
```

⚠️ Kubernetes will not overwrite an existing label by default.

Use `--overwrite` to update it:

```bash
k label --overwrite pod firstpod env=prod
```

✅ Verify the updated label:

```bash
k get pod firstpod --show-labels
```

---

## 🗑️ 5. Delete a Label

Delete the `env1` label:

```bash
k label pod firstpod env1-
```

🔍 Verify:

```bash
k get pod firstpod --show-labels
```

---

## 🚀 6. Create Another Pod

Create a second Pod:

```bash
kubectl run secondpod --image=coolgourav147/nginx-custom
```

🔍 Verify both Pods:

```bash
k get pods
```

---

## 🌐 7. Apply a Label to All Pods

Apply `status=xyz` to **all Pods**:

```bash
k label pods --all status=xyz
```

🔍 Verify the label:

```bash
k get pod secondpod --show-labels
```

📋 Display labels of all Pods:

```bash
k get pods --show-labels
```

---

## 📌 Important Commands

| Command                                        | Purpose                   |
| ---------------------------------------------- | ------------------------- |
| 🏷️ `k label pod firstpod env=testing`         | Add a label               |
| 🔄 `k label --overwrite pod firstpod env=prod` | Update an existing label  |
| 🗑️ `k label pod firstpod env1-`               | Delete a label            |
| 🔍 `k get pod firstpod --show-labels`          | Display Pod labels        |
| 🌐 `k label pods --all status=xyz`             | Apply a label to all Pods |

---

## ⭐ Key Points

* 🏷️ Labels are **key-value pairs** attached to Kubernetes objects.
* 📦 A Pod can have **multiple labels**.
* 🔄 Existing labels require `--overwrite` to be changed.
* 🗑️ A label can be deleted by adding `-` after the label key.
* 🔍 `--show-labels` displays labels with Pod information.
* 🌐 `--all` applies the command to **all matching Pods**.

---

## 🧠 Demo Flow

```text
🚀 Create Pod
      ↓
🏷️ Add Label
      ↓
➕ Add Another Label
      ↓
🔄 Update Label using --overwrite
      ↓
🗑️ Delete Label
      ↓
🚀 Create Second Pod
      ↓
🌐 Apply Label to All Pods
      ↓
🔍 Verify Labels
```

---

## 🎯 Demo Summary

**Topic:** Kubernetes Pod Labels
**Resource:** Pod
**Tool:** `kubectl`
**Key Options:** `--show-labels`, `--overwrite`, `--all`

✨ **Practice completed successfully!**
