# Securing application communication with knative

# Installing knative 

To install knative run the following 

### minikube
```
curl -L https://raw.githubusercontent.com/knative/serving/v0.2.0/third_party/istio-1.0.2/istio.yaml \
          | sed 's/LoadBalancer/NodePort/' \
            | kubectl apply --filename -
kubectl label namespace default istio-injection=enabled
curl -L https://github.com/knative/serving/releases/download/v0.2.0/release-lite.yaml \
          | sed 's/LoadBalancer/NodePort/' \
            | kubectl apply --filename -
```

### Play with kubernetes and Azure
```
kubectl apply --filename https://raw.githubusercontent.com/knative/serving/v0.2.2/third_party/istio-1.0.2/istio.yaml
kubectl label namespace default istio-injection=enabled
kubectl apply --filename https://github.com/knative/serving/releases/download/v0.2.2/release.yaml
```

# Deploy Sample App

Let's deploy a simple app as a knative service:

```
cat <<EOF | kubectl apply -f -
apiVersion: serving.knative.dev/v1alpha1 # Current version of Knative
kind: Service
metadata:
  name: helloworld-go # The name of the app
  namespace: default # The namespace the app will use
spec:
  runLatest:
    configuration:
      revisionTemplate:
        spec:
          container:
            image: gcr.io/knative-samples/helloworld-go # The URL to the image of the app
            env:
            - name: TARGET # The environment variable printed out by the sample app
              value: "Go Sample v1"
EOF
```

Let's see what happened:

```sh
➜ kubectl get ksvc
NAME            DOMAIN                              LATESTCREATED         LATESTREADY           READY   REASON
helloworld-go   helloworld-go.default.example.com   helloworld-go-00001   helloworld-go-00001   True
➜ kg config
NAME            LATESTCREATED         LATESTREADY           READY   REASON
helloworld-go   helloworld-go-00001   helloworld-go-00001   True
➜ kubectl get rev
NAME                  SERVICE NAME                  READY   REASON
helloworld-go-00001   helloworld-go-00001-service   True
➜  kubectl get pod
NAME                                              READY   STATUS    RESTARTS   AGE
helloworld-go-00001-deployment-7cbd588595-rdksw   3/3     Running   0          2m
```

To find the IP address for your service, enter:

```sh
➜ kubectl get svc knative-ingressgateway --namespace istio-system
NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                                                                                                                   AGE
knative-ingressgateway   LoadBalancer   10.19.255.36   35.240.56.33   80:32380/TCP,443:32390/TCP,31400:32400/TCP,15011:30408/TCP,8060:32402/TCP,853:30616/TCP,15030:30291/TCP,15031:30636/TCP   1d
```

Take note of the EXTERNAL-IP address.

You can also export the IP address as a variable with the following command:

```sh
export IP_ADDRESS=$(kubectl get svc knative-ingressgateway --namespace istio-system --output 'jsonpath={.status.loadBalancer.ingress[0].ip}')
```

Now let's try to send a request to the service:

```sh
curl -H "Host: helloworld-go.default.example.com" "http://${IP_ADDRESS}"
Hello World: Go Sample v1!
```

# Configuring outbound network access

Knative blocks all outbound traffic by default. To enable outbound access (when you want to connect 
to the Cloud Storage API, for example), you need to change the scope of the proxy IP range by editing
the `config-network` map.

## Determining the IP scope of your cluster

To set the correct scope, you need to determine the IP ranges of your cluster. The scope varies 
depending on your platform:

* For Minikube use `10.0.0.1/24`

## Setting the IP scope  

The `istio.sidecar.includeOutboundIPRanges` parameter in the `config-network` map specifies 
the IP ranges that Istio sidecar intercepts. To allow outbound access, replace the default parameter  
value with the IP ranges of your cluster.

Run the following command to edit the `config-network` map:

```shell
kubectl edit configmap config-network --namespace knative-serving
```

Then, use an editor of your choice to change the `istio.sidecar.includeOutboundIPRanges` parameter value
from `*` to the IP range you need. Separate multiple IP entries with a comma. For example: 

```
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  istio.sidecar.includeOutboundIPRanges: '10.16.0.0/14,10.19.240.0/20'
kind: ConfigMap
metadata:
  ...
```

By default, the `istio.sidecar.includeOutboundIPRanges` parameter is set to `*`, 
which means that Istio intercepts all traffic within the cluster as well as all traffic that is going 
outside the cluster. Istio blocks all traffic that is going outside the cluster unless
you create the necessary egress rules.

When you set the parameter to a valid set of IP address ranges, Istio will no longer intercept 
traffic that is going to the IP addresses outside the provided ranges, and you don't need to specify
any egress rules.

If you omit the parameter or set it to `''`, Knative uses the value of the `global.proxy.includeIPRanges` 
parameter that is provided at Istio deployment time. In the default Knative Serving
deployment, `global.proxy.includeIPRanges` value is set to `*`.

If an invalid value is passed, `''` is used instead.

If you are still having trouble making off-cluster calls, you can verify that the policy was
applied to the pod running your service by checking the metadata on the pod.
Verify that the `traffic.sidecar.istio.io/includeOutboundIPRanges` annotation matches the
expected value from the config-map.

```shell
$ kubectl get pod ${POD_NAME} --output yaml

apiVersion: v1
kind: Pod
metadata:
  annotations:
    serving.knative.dev/configurationGeneration: "2"
    sidecar.istio.io/inject: "true"
    ...
    traffic.sidecar.istio.io/includeOutboundIPRanges: 10.16.0.0/14,10.19.240.0/20
...
