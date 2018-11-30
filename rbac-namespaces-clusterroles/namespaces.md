# rbac, namespaces and cluster roles

Now we have learnt how to secure our pods, its a good idea to separate our applications from each other via namespaces and give them the appropriate level of access   
within the cluster to run. So we will first look at namespaces to separate our applications.

## Namespaces

Lets look at the default namespaces available to us.  
We do this by issuing `kubectl get namespaces`
In the last lab we deployed our deployment to the default namespace as we did not define anything.
Kubernetes will place any pods in the default namespace unless another one is specified.

For the next part of the lab we will create a namespace to use for the rest of the lab. We will do that by issuing  
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: workshop
EOF
```

Then if we check our namespaces again via `kubectl get namespaces` if we were successful then we should see the new namespace.

## Cluster roles

Now we have our namespace set up we are going to create a user and give it full access to that namespace only.
So follow the instructions below for the setup you have

### Minikube

The first thing we will do is create a certificate for our user to be able to talk to the kube api server. You will notice on the last command we   
are signing the request with our cluster CA. 
```
openssl genrsa -out user.key 2048
openssl req -new -key user.key -out user.csr -subj "/CN=user/O=workshop"
openssl x509 -req -in user.csr -CA ~/.minikube/certs/ca.pem -CAkey ~/.minikube/certs/ca-key.pem -CAcreateserial -out user.crt -days 500
```
We will then use the certificate and set up our kubectl

```
kubectl config set-credentials user --client-certificate=user.crt  --client-key=user.key
kubectl config set-context user-context --cluster=minikube --namespace=workshop --user=user
```

### Play with kubernetes
The first thing we will do is create a certificate for our user to be able to talk to the kube api server. You will notice on the last command we   
are signing the request with our cluster CA. 
```
openssl genrsa -out user.key 2048
openssl req -new -key user.key -out user.csr -subj "/CN=user/O=workshop"
openssl x509 -req -in user.csr -CA /etc/kubernetes/pki/ca.pem -CAkey /etc/kubernetes/pki/ca-key.pem -CAcreateserial -out user.crt -days 500
```
We will then use the certificate and set up our kubectl.

```
kubectl config set-credentials user --client-certificate=user.crt  --client-key=user.key
kubectl config set-context user-context --cluster=node1 --namespace=workshop --user=user
```

Now no matter if you are using Play with kubernetes or minikube issue the below command.  

```
kubectl --context=user-context get pods
```
Now if we did everything correctly we should get an error. Thats totally fine as we have not set up a role for this user.  


We are now going to create a deployment role for the namespace that we created earlier.
```
cat <<EOF | kubectl apply -f -
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: workshop
  name: deployment-role
rules:
- apiGroups: ["extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["*"]
EOF
```  

Now we will bind it to our user cleverly named user
```
cat <<EOF | kubectl apply -f -
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: deployment-binding
  namespace: workshop
subjects:
- kind: User
  name: user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: deployment-role
  apiGroup: rbac.authorization.k8s.io
EOF
```

Now lets deploy our application into our new namespace with our new user
```
cat <<EOF | kubectl --context=user-context  apply -f -
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: webapp-deployment
  namespace: workshop
spec:
  selector:
    matchLabels:
      app: webapp
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: scottyc/webapp:latest
        ports:
        - containerPort: 3000
          hostPort: 3000
EOF
```

Then we can check our pods with `kubectl --context=user-context get pods`
To make sure we can see anything we are not meant too `kubectl --context=user-context get pods --namespace=default`