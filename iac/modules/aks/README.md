# Azure Kubernetes Service (AKS)

## Provisoin configs

### Preset configuration

POC: Dev/Test: (Fits for demonstrating the proof-of-concept of scenario)

Recommended: Production Standard (Best for most applications)

### AKS pricing tier

Proof-of-Concept: Free (Best for nodes fewer that 10 nodes, fits for testing)

Recommended: Standard (Mission-critical and production application, auto-scale, up to 5000 nodes with 99.95% SLA)

### Region

Sweden Central (Near the hypothetical clients’ location).

### Availability zones

POC: [none]

Recommended: Zone1, Zone2. Zone3 (for high availability, resistance to datacenter outage in a region)

### Kubernetes version

Use Kubernetes version 1.29 (highly recommended not to use upstream versions due to potential stability issues)

### Node security channel type

Recommended: NodeImage (security fixes and bug fixes)

### Authentication and Authorization

POC: Local Kubernetes RBAC

Recommended: Microsoft Entra ID with Azure RBAC authorization (unified management and access control across Azure resources, AKS, and Kubernetes resources)

## Networking

### Azure CNI Overlay

Like Azure CNI Overlay, Kubenet assigns IP addresses to pods from an address space logically different from the VNet, but it has scaling and other limitations. The below table provides a detailed comparison between Kubenet and Azure CNI Overlay. If you don't want to assign VNet IP addresses to pods due to IP shortage, we recommend using Azure CNI Overlay.

### IP address planning

Cluster Nodes:  A /24 subnet has 256 IPs while since some first IP addresses are reserved for management tasks.

### Private cluster AKS

#### Pros

+ No public endpoint exposed on internet (which helps implement Zero Trust Network).  
+ Worker nodes connect to control plane using private endpoint.  
+ More work should be done to get access to the cluster for DevOps pipelines and cluster operators.

#### Cons

+ Choosing private cluster is only possible during cluster creation. Not possible for existing clusters.

### An AKS manifest includes a simple web app and an intenal load balancer that is accessible through VNet

```yaml
[!INCLUDE [aks manifest](../../../web-app/aks-manifest.yaml)]
```
