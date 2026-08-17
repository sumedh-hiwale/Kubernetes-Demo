🔵 2. NodePort Service

NodePort allows the Service to be accessed through a port on each Kubernetes Node.

📝 Step 1: Change Service Type

Edit svc.yaml:

cat svc.yaml

Use:

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

🚀 Apply the configuration:

k apply -f svc.yaml
🔍 Step 2: Check the NodePort
k get svc

Example:

NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)
kubernetes    ClusterIP  10.96.0.1       <none>        443/TCP
my-service1   NodePort   10.105.113.27   <none>        18080:32217/TCP

Here:

18080 → Service Port
32217 → NodePort

🌐 The Service can now be accessed using:

<NodeIP>:32217
