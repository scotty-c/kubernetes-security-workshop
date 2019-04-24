# kubernetes-security-workshop

# Table of contents
1. [Introduction](#introduction)
2. [Setup](#setup)
    1. [Azure](setup/azure.md)
    2. [Minikube](setup/minikube.md)
    3. [Play with Kubernetes](setup/play-with-k8s.md)
3. [Kubernetes architecture overview ](#overview)
4. [Securing Kubernetes components ](#components)
5. [Securing our pods](#pods)
6. [Rbac, namespaces and cluster roles](#roles)
7. [Introduction to istio](#istio)
8. [Securing application communication with istio](#secistio)

The slides can be found [here](slides/securing-kubernetes-dockercon.pdf)

## Introduction <a name="introduction"></a>
This is the Kubernetes security workshop, we have three ways to run this workshop depending on the setup you have. You can run it on the cloud in Azure, locally via Minikube or on a low resource machine in Play with Kubernetes. 

## Setup <a name="setup"></a>
There are four methods to set up this workshop either to use in the classroom or after the workshop at your own pace. They are as follows  
[Azure](setup/azure.md)  
[Minikube](setup/minikube.md)  
[Play with Kubernetes](setup/play-with-k8s.md)

Then familarise yourself with the application that we are going to [deploy](code/webapp/Dockerfile)  
All the code lives [here](code/webapp)

## Kubernetes architecture overview <a name="overview"></a>
This module walks through the Kubernetes components and gives us a solid foundation for the rest of the workshop.    
To run through the lab start [here](kubernetes-architecture/architecture.md)

## Securing Kubernetes components <a name="components"></a>
In this module we are going to look at securing all the kubernetes components with tls  
To run through the lab start [here](securing-kubernetes-components/securing.md)

## Securing our pods <a name="pods"></a>
In this module we will look at how to secure a Kubernetes deployment using our web application with pod security context.  
To run through the lab start [here](securing-our-pods/securing.md)

## Rbac, namespaces and cluster roles <a name="roles"></a>
In this module we will take the application we deployed in pervious module but this time create a namespace and limit  
the application to only have access to any resource in that namespace using service accounts, roles and role bindings.  
To run through the lab start [here](rbac-namespaces-clusterroles/namespaces.md)

## Introduction to istio <a name="istio"></a>
In this module we will look at what makes up istio   
To run through the lab start [here](introduction-into-istio/intro.md)

## Securing application communication with istio <a name="secistio"></a>
In this module we will look at how to configure engress with istio  
To run through the lab start [here](securing-application-communication-with-istio/istio.md)

### Instructors
If you are giving this workshop there are some instructor notes [here](instructor-notes/notes.md)





