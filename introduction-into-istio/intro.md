# Introduction into Istio

In this module we will look at istio and its components.

# Istio

Cloud platforms provide a wealth of benefits for the organizations that use them. There’s no denying, however, that adopting the cloud can put strains on DevOps teams. Developers must use microservices to architect for portability, meanwhile operators are managing extremely large hybrid and multi-cloud deployments. Istio lets you connect, secure, control, and observe services.

At a high level, Istio helps reduce the complexity of these deployments, and eases the strain on your development teams. It is a completely open source service mesh that layers transparently onto existing distributed applications. It is also a platform, including APIs that let it integrate into any logging platform, or telemetry or policy system. Istio’s diverse feature set lets you successfully, and efficiently, run a distributed microservice architecture, and provides a uniform way to secure, connect, and monitor microservices.

Istio makes it easy to create a network of deployed services with load balancing, service-to-service authentication, monitoring, and more, without any changes in service code. You add Istio support to services by deploying a special sidecar proxy throughout your environment that intercepts all network communication between microservices, then configure and manage Istio using its control plane functionality, which includes:

Automatic load balancing for HTTP, gRPC, WebSocket, and TCP traffic.

Fine-grained control of traffic behavior with rich routing rules, retries, failovers, and fault injection.

A pluggable policy layer and configuration API supporting access controls, rate limits and quotas.

Automatic metrics, logs, and traces for all traffic within a cluster, including cluster ingress and egress.

Secure service-to-service communication in a cluster with strong identity-based authentication and authorization.  

## Pilot and Envoy  
The core component used for traffic management in Istio is Pilot, which manages and configures all the Envoy proxy instances deployed in a particular Istio service mesh. Pilot lets you specify which rules you want to use to route traffic between   Envoy proxies and configure failure recovery features such as timeouts, retries, and circuit breakers. It also maintains a canonical model of all the services in the mesh and uses this model to let Envoy instances know about the other Envoy  
instances in the mesh via its discovery service.

Each Envoy instance maintains load balancing information based on the information it gets from Pilot and periodic health-checks of other instances in its load-balancing pool, allowing it to intelligently distribute traffic between destination   instances while following its specified routing rules.  

Pilot is responsible for the lifecycle of Envoy instances deployed across the Istio service mesh.  
<img src="https://istio.io/docs/concepts/traffic-management/PilotAdapters.svg" height="800" width="800" >   

## Communication between services  
<img src="https://istio.io/docs/concepts/traffic-management/ServiceModel_Versions.svg" height="800" width="800" >  

## Ingress and egress   
Istio assumes that all traffic entering and leaving the service mesh transits through Envoy proxies. By deploying an Envoy proxy in front of services, you can conduct A/B testing, deploy canary services, etc. for user-facing services. Similarly, by routing traffic to external web services (for instance, accessing a maps API or a video service API) via the Envoy sidecar, you can add failure recovery features such as timeouts, retries, and circuit breakers and obtain detailed metrics on the connections to these services.  
<img src="https://istio.io/docs/concepts/traffic-management/ServiceModel_RequestFlow.svg" height="800" width="800" >   

## Discovery and load balancing
Istio load balances traffic across instances of a service in a service mesh.

Istio assumes the presence of a service registry to keep track of the pods/VMs of a service in the application. It also assumes that new instances of a service are automatically registered with the service registry and unhealthy instances are automatically removed. Platforms such as Kubernetes and Mesos already provide such functionality for container-based applications, and many solutions exist for VM-based applications.

Pilot consumes information from the service registry and provides a platform-independent service discovery interface. Envoy instances in the mesh perform service discovery and dynamically update their load balancing pools accordingly.
<img src="https://istio.io/docs/concepts/traffic-management/LoadBalancing.svg" height="800" width="800" >  

## Certificate architecture

Security in Istio involves multiple components:

* Citadel for key and certificate management

* Sidecar and perimeter proxies to implement secure communication between clients and servers

* Pilot to distribute authentication policies and secure naming information to the proxies

* Mixer to manage authorization and auditing  
<img src="https://istio.io/docs/concepts/security/architecture.svg" height="800" width="800" >  









