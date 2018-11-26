# Securing our pods.

## Deploying our application

```
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: webapp-deployment
spec:
  selector:
    matchLabels:
      app: webapp
  replicas: 2 # tells deployment to run 2 pods matching the template
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
Then we expose the deployment   
`kubectl expose deployment webapp-deployment --type=LoadBalancer`  
We should have a button pop up that will allow us to click through to our application.  
In the image below you can see mine has exposed `32185`  
![console](images/button.png)  

## The hack
Now we have our application running, lets look at a few things.  
Firstly we will get our pod name `kubectl get pods` mine is `webapp-deployment-865fb4d7c-8c5sv`   
We will then exec into the running container  `kubectl exec -it webapp-deployment-865fb4d7c-8c5sv sh`