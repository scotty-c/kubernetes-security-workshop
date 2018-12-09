# Minikube
To use the workshop with minikube firstly install minikube. We assume that has already been done.  
If you need to install minikube please follow the offfical documentation https://kubernetes.io/docs/tasks/tools/install-minikube/  
Once the install is done, please use the instructions below to start the cluster for your os 

## Linux 

For Virtualbox 
```
minikube start --memory=8192 --cpus=4 \
  --kubernetes-version=v1.12.2 \
  --vm-driver=virtualbox \
  --bootstrapper=kubeadm \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
  ```

  For kvm
  ```
  minikube start --memory=8192 --cpus=4 \
  --kubernetes-version=v1.12.2 \
  --vm-driver=kvm2 \
  --bootstrapper=kubeadm \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
  ```

## Macos

For Hyperkit

```
minikube start --memory=8192 --cpus=4 \
  --kubernetes-version=v1.12.2 \
  --vm-driver=hyperkit \
  --bootstrapper=kubeadm \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
```

For VMware fusion

```
minikube start --memory=8192 --cpus=4 \
  --kubernetes-version=v1.12.2 \
  --vm-driver=vmwarefusion\
  --bootstrapper=kubeadm \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
```

For Virtualbox
```
minikube start --memory=8192 --cpus=4 \
  --kubernetes-version=v1.12.2 \
  --vm-driver=virtualbox \
  --bootstrapper=kubeadm \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
```  
