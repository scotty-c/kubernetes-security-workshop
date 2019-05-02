#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	OS="linux"
    ARCH="linux-amd64"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	OS="osx"
    ARCH="darwin-amd64"
fi
	
ISTIO_VERSION=1.0.4
HELM_VERSION=2.11.0

check_tiller () {
POD=$(kubectl get pods --all-namespaces|grep tiller|awk '{print $2}'|head -n 1)
kubectl get pods -n kube-system $POD -o jsonpath="Name: {.metadata.name} Status: {.status.phase}" > /dev/null 2>&1 | grep Running
}

pre_reqs () {
curl -sL "https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istio-$ISTIO_VERSION-$OS.tar.gz" | tar xz
if [ ! -f /usr/local/bin/istioctl ]; then  
	echo "Installing istioctl binary"
    chmod +x ./istio-$ISTIO_VERSION/bin/istioctl
    sudo mv ./istio-$ISTIO_VERSION/bin/istioctl /usr/local/bin/istioctl
fi       	

if [ ! -f /usr/local/bin/helm ]; then  
	echo "Installing helm binary"
    curl -sL "https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-$ARCH.tar.gz" | tar xz
    chmod +x $ARCH/helm 
    sudo mv linux-amd64/helm /usr/local/bin/
fi    
}    
 
install_tiller () {
echo "Checking if tiller is running"
check_tiller
if [ $? -eq 0 ]; then
    echo "Tiller is installed and running"
else
echo "Deploying tiller to the cluster"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF
helm init --service-account tiller
fi       	
check_tiller
while [ $? -ne 0 ]; do
  echo "Waiting for tiller to be ready"
  sleep 30
done

}

install () {
echo "Deploying istio"

helm install istio-$ISTIO_VERSION/install/kubernetes/helm/istio --name istio --namespace istio-system \
    --set global.controlPlaneSecurityEnabled=true \
    --set grafana.enabled=true \
    --set tracing.enabled=true \
    --set kiali.enabled=true
}

pre_reqs
install_tiller
install
