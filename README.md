# University Adolfo Ibáñez Kubernetes Cluster Setup

This repository contains detailed instructions and configuration files to help you set up a Kubernetes cluster for educational purposes at the University Adolfo Ibáñez.

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Building the cluster](#building-the-cluster)
  - [Configuring the static network](#configuring-the-static-network)
  - [Running the script](#running-the-script)
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

To be able to define the static ip, we will have to define some parameters in the file:``` /etc/netplan/<name_of_config.yaml>"```

```yaml
network:
    ethernets:
        <ethernet port>:
            dhcp4: no
            addresses:
              - <ip address>
            gateway4: <gateway>
            nameservers:
              addresses:
                - 8.8.8.8
                - 8.8.4.4
    version: 2
    wifis: {}
``` 
you can see your ethernet port by executing the command ```ip a``` in linux

### Running the script

In this case we are using ubuntu server, so the delivered script to create our cluster is for the above mentioned operating system. 

To run the script we need 2 things :
 - be in sudo user (```sudo su```)
 - give administrator permissions to the script (```chmod +x install.sh```)

 Now we can run the script, it has the option to choose whether to configure the Head node, simply select this for the master node.

 In order to join the worker nodes with the Head node, we have to use the command provided by the script. This is like this:

```
kubeadm join 192.168.0.100:6443 --token 8tchu0.jrgzw1owketyocrd --discovery-token-ca-cert-hash sha256:05b1fc56c15434e3a4f318e612095b2f4134cde27cdc1e8ff5589977eb957c16 --cri-socket=unix:///var/run/cri-dockerd.sock
```
WARNING: it is very important to add the following argument at the end of the command:```--cri-socket=unix:///var/run/cri-dockerd.sock```

## Usage

Now that we have our cluster built correctly, we have to learn how to use it.

### Concepts to Know

- **Pod**: The smallest deployable unit in Kubernetes that contains one or more containers.
- **Deployment**: Manages the deployment and scaling of Pods.
- **Service**: Exposes Pods to the network, allowing external or internal access to your applications.
- **Namespace**: A virtual environment in the cluster that groups resources and isolates applications.

### Steps to Deploy and Test a Simple NGINX Application

#### Step 1: Create a Deployment

First, we will deploy an NGINX server as an example in your Kubernetes cluster.

1. Create a deployment definition file called `nginx-deployment.yaml`:

    ```bash
    nano nginx-deployment.yaml
    ```

2. Paste the following content into the file:

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deployment
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx:1.21
            ports:
            - containerPort: 80
    ```

    This defines a deployment that creates 3 replicas of the `nginx` server across your cluster.

3. Apply the deployment:

    ```bash
    kubectl apply -f nginx-deployment.yaml
    ```

4. Verify that the Pods were created:

    ```bash
    kubectl get pods
    ```

    You should see output similar to:

    ```plaintext
    NAME                                READY   STATUS    RESTARTS   AGE
    nginx-deployment-7b6894b6bb-xxxxx   1/1     Running   0          10s
    nginx-deployment-7b6894b6bb-yyyyy   1/1     Running   0          10s
    nginx-deployment-7b6894b6bb-zzzzz   1/1     Running   0          10s
    ```

#### Step 2: Expose the Deployment as a Service

To access the NGINX application from outside the cluster, you need to create a **Service** that exposes the application on a NodePort.

1. Create the service directly from the command line:

    ```bash
    kubectl expose deployment nginx-deployment --type=NodePort --name=nginx-service
    ```

2. Check the service created:

    ```bash
    kubectl get services
    ```

    You should see something like this:

    ```plaintext
    NAME            TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
    nginx-service   NodePort   10.96.0.1      <none>        80:32000/TCP   1m
    ```

    In this example, Kubernetes assigned the port `32000` to the service. This means you can access the application using any node's IP and port `32000`.

#### Step 3: Test the Application

1. Use `curl` or your browser to access the NGINX application by going to one of your node's IP addresses and the assigned port:

    ```bash
    curl http://<NODE_IP>:<PORT>
    ```

    For example, if the Node IP is `192.168.3.3` and the port is `32000`, run:

    ```bash
    curl http://192.168.3.3:32000
    ```

    You should see the default NGINX welcome page.

#### Step 4: Scale the Deployment

You can easily scale the deployment to increase the number of replicas, which will distribute the application across more nodes.

1. To scale the deployment to 5 replicas:

    ```bash
    kubectl scale deployment nginx-deployment --replicas=5
    ```

2. Verify that new Pods have been created:

    ```bash
    kubectl get pods
    ```

    You should now see 5 Pods running.

## Monitoring the Cluster

Here are a few useful commands to monitor and manage your Kubernetes cluster:

1. **View Nodes**:

    ```bash
    kubectl get nodes
    ```

2. **View Pods**:

    ```bash
    kubectl get pods
    ```

3. **View Cluster Info**:

    ```bash
    kubectl cluster-info
    ```
