# University Adolfo Ibáñez Kubernetes Cluster Setup

This repository contains detailed instructions and configuration files to help you set up a Kubernetes cluster for educational purposes at the University Adolfo Ibáñez.

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Building the cluster](#building-the-cluster)
  - [Running the script](#running-the-script)
  - [Configuring the static network](#configuring-the-static-network)
  - [Setup the Cluster](#setup-the-cluster)
- [Cluster Components](#cluster-components)
- [Usage](#usage)
  - [Deploying Applications](#deploying-applications)
  - [Scaling Workloads](#scaling-workloads)
  - [Accessing Cluster Services](#accessing-cluster-services)

## Introduction

This project aims to provide a comprehensive guide for setting up a Kubernetes cluster at the University Adolfo Ibáñez. The cluster will serve as a learning and testing environment for students and faculty interested in Kubernetes and container orchestration.

## Prerequisites

Before you start building a Kubernetes cluster, ensure you meet the following prerequisites:

- **Linux Hosts**: Kubernetes primarily runs on Linux. You will need at least two Linux hosts to create a basic cluster. Common choices include Ubuntu, CentOS, or Fedora.

- **Container Runtime**: Kubernetes uses container runtimes to run containers. Docker is a popular choice, but you can also use containerd, cri-o, or others.

- **Hostnames and Network Configuration**:
  - Each host should have a unique hostname.
  - All nodes should have full network connectivity with each other.
  - Ensure that DNS is working correctly between nodes, and each node can resolve the others' hostnames.

- **Hardware Resources**:
  - Each node should have a minimum of 2GB RAM.
  - A CPU with at least two cores is recommended.
  - Sufficient disk space for container images and Kubernetes components.

- **Kubernetes Binaries**: Download the necessary Kubernetes binaries:
  - `kubectl`: The Kubernetes command-line tool.
  - `kubeadm`: The Kubernetes Cluster Bootstrap tool.
  - `kubelet`: The Kubernetes Node Agent.

- **Container Network Interface (CNI)**: Ensure that your chosen CNI plugin is properly configured on all nodes. This involves setting up network routing and policies.

- **Firewall Rules**: Configure firewall rules to allow traffic between Kubernetes nodes and components. Kubernetes uses various ports for communication; consult the official documentation for specific port requirements.

- **Network Plugin**: Choose a network plugin that fits your cluster requirements (e.g., Calico, Flannel, Cilium) and install it on all nodes.

- **Swap Disabled**: Disable swap on all nodes. Kubernetes recommends that swap be disabled for optimal performance and stability.

- **Container Runtime Configuration**: Configure your container runtime (e.g., Docker) to work with Kubernetes. Ensure that it supports the required version of the Container Runtime Interface (CRI).

- **SSH Access**: Ensure that you can SSH into all nodes from your management machine without a password. SSH key-based authentication is recommended.

- **NTP**: Synchronize the system clocks of all nodes using Network Time Protocol (NTP) or a similar time synchronization mechanism to ensure consistency.

- **Optional Ingress Controller**: If your applications will require external access via HTTP/HTTPS, consider setting up an Ingress controller such as Nginx Ingress or Traefik.


Ensure that you thoroughly review the official [kubernetes](https://kubernetes.io/docs/home/) documentation and the documentation of any specific tools or plugins you plan to use, as requirements may vary dependin3g on your environment and use case.


## Building the cluster

Follow these steps to set up your Kubernetes cluster:

### Configuring the static network 

To be able to define the static ip, we will have to define some parameters in the file: /etc/netplan/00-installer-config.yaml

```yaml
network:
  ethernets:
    <ethernet port>:
      dhcp4: false
      addresses:
        - <ip address>
      gateway4: <gateway>
      nameservers:
        addresses: [1.1.1.1, 1.0.0.1]
  version: 2
``` 
you can see your ethernet port by executing the command "ip a" in linux

### Running the script

In this case we are using ubuntu server, so the delivered script to create our cluster is for the above mentioned operating system. 

