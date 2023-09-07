# University Adolfo Ibáñez Kubernetes Cluster Setup

This repository contains detailed instructions and configuration files to help you set up a Kubernetes cluster for educational purposes at the University Adolfo Ibáñez.

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Building the cluster](#building-the-cluster)
  - [Disable swap](#disable-swap)
  - [Configure the Cluster](#configure-the-cluster)
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


Ensure that you thoroughly review the official [kubernetes](https://kubernetes.io/docs/home/) documentation and the documentation of any specific tools or plugins you plan to use, as requirements may vary depending on your environment and use case.


## Building the cluster

Follow these steps to set up your Kubernetes cluster:

### Disable swap

We disable the swap for kubetel to function properly, first shutdown swap

```bash
sudo swapoff -a
```

and then we deactivate the swap, to do this we open the file /etc/fstab in a text editor
```bash
sudo vim /etc/fstab
```
there we will find this line 
```
/swap.img   none    swap    sw  0   0
```
and then we document the line 

```
#/swap.img   none    swap    sw  0   0
```

### Install all kubernetes prerequisites 



```bash
git clone https://github.com/your-username/kubernetes-cluster.git
```

### Configure the cluster

Edit the config.yaml file to customize your cluster settings. You can find an example configuration file in config.example.yaml

