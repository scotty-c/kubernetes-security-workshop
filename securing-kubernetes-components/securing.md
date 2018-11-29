# Securing kubernetes components

In the last module we looked at the Kubernetes components. Now lets look at the minimum security profile we should implement tls communication.

## Install

In the minikube and play with Kubernetes setups we are both using [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/)  
In this course we are not going to run through kubeadm in great detail what we will run through is that it will do all the heavy lifting on the tls front for you    
Below is the output of `kubeadm init` for one of my clusters. You will notice that it is setting up multiple CA's with different signing authority depending on the certificate  


```Initializing machine ID from random generator.
[init] using Kubernetes version: v1.11.4
[preflight] running pre-flight checks
        [WARNING Service-Docker]: docker service is not active, please run 'systemctl start docker.service'
        [WARNING FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
I1125 21:35:58.622335     452 kernel_validator.go:81] Validating kernel version
I1125 21:35:58.622960     452 kernel_validator.go:96] Validating kernel config
[preflight] The system verification failed. Printing the output from the verification:
KERNEL_VERSION: 4.4.0-127-generic
DOCKER_VERSION: 18.06.1-ce
OS: Linux
CGROUPS_CPU: enabled
CGROUPS_CPUACCT: enabled
CGROUPS_CPUSET: enabled
CGROUPS_DEVICES: enabled
CGROUPS_FREEZER: enabled
CGROUPS_MEMORY: enabled
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
        [WARNING SystemVerification]: failed to parse kernel config: unable to load kernel module "configs": output - "", err - exit status 1
[preflight/images] Pulling images required for setting up a Kubernetes cluster
[preflight/images] This might take a minute or two, depending on the speed of your internet connection
[preflight/images] You can also perform this action in beforehand using 'kubeadm config images pull'
[kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[preflight] Activating the kubelet service
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] apiserver serving cert is signed for DNS names [node1 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.0.13]
[certificates] Generated apiserver-kubelet-client certificate and key.
[certificates] Generated sa key and public key.
[certificates] Generated front-proxy-ca certificate and key.
[certificates] Generated front-proxy-client certificate and key.
[certificates] Generated etcd/ca certificate and key.
[certificates] Generated etcd/server certificate and key.
[certificates] etcd/server serving cert is signed for DNS names [node1 localhost] and IPs [127.0.0.1 ::1]
[certificates] Generated etcd/peer certificate and key.
[certificates] etcd/peer serving cert is signed for DNS names [node1 localhost] and IPs [192.168.0.13 127.0.0.1 ::1]
[certificates] Generated etcd/healthcheck-client certificate and key.
[certificates] Generated apiserver-etcd-client certificate and key.
[certificates] valid certificates and keys now exist in "/etc/kubernetes/pki"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/scheduler.conf"
[controlplane] wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
[controlplane] wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
[controlplane] wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
[etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
[init] waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"
[init] this might take a minute or longer if the control plane images have to be pulled
[apiclient] All control plane components are healthy after 38.502555 seconds
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.11" in namespace kube-system with the configuration for the kubelets in the cluster
[markmaster] Marking the node node1 as master by adding the label "node-role.kubernetes.io/master=''"
[markmaster] Marking the node node1 as master by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "node1" as an annotation
[bootstraptoken] using token: mmm1c9.nst6naa3cwcmp9di
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/
  ```

  
  ## Cert locations 
  
  ### play with kubernetes 
  `/etc/kubernetes/pki/`
  ### minikube
  `/var/lib/minikube/certs/`  
  
  ## Manifest files

  `/etc/kubernetes/manifests`

  ## Admin credentials

  `/etc/kubernetes/admin.conf`

  ## Kubelet systemd files
  
  ### play with kubernetes 
  `/etc/systemd/system/kubelet.service`  
  ### minikube
  `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`

  In this lab we are going to look at all these folders and files. If you are on play with kubernetes just use the web terminal.  
  If you are using minikube issue `minikube ssh` to access the running vm