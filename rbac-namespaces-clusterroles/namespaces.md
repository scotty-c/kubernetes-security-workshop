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
