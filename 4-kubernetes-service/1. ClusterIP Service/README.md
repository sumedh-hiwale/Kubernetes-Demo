🟢 1. ClusterIP Service

ClusterIP is the default Service type in Kubernetes. It provides internal access to Pods within the Kubernetes cluster.

📦 Step 1: Create the First Pod

Create pod1.yml:

vim pod1.yml
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
📦 Step 2: Create the Second Pod

Create pod2.yaml:

vi pod2.yaml
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

🚀 Create both Pods:

k apply -f pod1.yml
k apply -f pod2.yaml

🔍 Verify:

k get pods

Expected:

NAME       READY   STATUS    RESTARTS   AGE
myhttpd1   1/1     Running   0          12m
myhttpd2   1/1     Running   0          8m
🔗 Step 3: Create a ClusterIP Service

Create svc.yaml:

vi svc.yaml
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

🚀 Create the Service:

k apply -f svc.yaml

🔍 Check the Service:

k get svc

Example:

NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)
kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP
my-service1   ClusterIP   10.101.148.112   <none>        18080/TCP
🧪 Step 4: Test the Service

Use the ClusterIP and Service port:

curl 10.101.148.112:18080

Expected response:

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
<title>It works! Apache httpd</title>
</head>
<body>
<p>It works!</p>
</body>
</html>
🔍 Step 5: Describe the Service
k describe svc my-service1

Important output:

Selector:     name=sumedh
Type:         ClusterIP
IP:           10.101.148.112
Port:         18080/TCP
TargetPort:   80/TCP
Endpoints:    192.168.1.117:80
🧠 Important

The Service selector:

selector:
  name: sumedh

matches the label on myhttpd2:

labels:
  class: cka
  name: sumedh

So the Service sends traffic to the matching Pod.

Client
   ↓
Service
   ↓
Selector: name=sumedh
   ↓
myhttpd2 Pod
   ↓
Container Port 80
