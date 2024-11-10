# Azure Firewall Policy Configuration

Needed Firewall Policy rules for our scenario in order to AKS works well.

## Contents

- [NAT Policy Rule Collection Group](#nat-policy-rule-collection-group)
  - [Nat Rule Collection](#nat-rule-collection)
- [Application Rule Collection Groups](#application-rule-collection-groups)
  - [Allow Application Rule Collections](#allow-application-rule-collections)
    - [Application Allow Rules](#application-allow-rules)
      - [Allow access to Microsoft services](#allow-access-to-microsoft-services)
      - [Allow HTTP access to AKS nodes patch update](#allow-http-access-to-aks-nodes-patch-update)
      - [Allow HTTPS access to AKS nodes patch update](#allow-https-access-to-aks-nodes-patch-update)
      - [Allow access to Docker Hub](#allow-access-to-docker-hub)
      - [Allow access to Github](#allow-access-to-github)
      -[Allow access to `*microsoft.com`](#allow-access-to-microsoftcom)
  - [Deny Application Rule Collections](#deny-application-rule-collections)

## NAT Policy Rule Collection Group

Create a dNAT rules to route inboud traffic to AKS internal load balancer.

Priority: `200`

### Nat Rule Collection

| Nat Rule Collection name           | Action  | Priority     |
|------------------------------------|---------|------------|
| `dnat`                             |  `dnat`  | `200`       |

### DNAT Rules

| Rule name | protocols | source_addresses | destination_address  | destination_ports | translated_address | translated_port |
|----------|---------------|----------|--------|-----------|------------|------------|
| `nat-aks-ilb`  | `TCP`, `UDP`  | `*`  | `<fw-public-ip>` | `<fw-public-port>` | `<aks-ilb-private-ip>`   | `aks-ilb-port`  |

## Application Rule Collection Groups

Create an application rules collection group to control egress traffic from vnet. It includes two `application_rule_collection`s.

Priority: `200`

Create two app rule collections, one for __Allow__, another one for __Deny__ accesses.

### Allow Application Rule Collections

| Application Rule Collection name   | Action  | Priority     |
|------------------------------------|---------|------------|
| `allow-app-rule-collection`        |  `Allow`  | `200`       |

#### Application Allow Rules

##### Allow access to Microsoft services

Rule name: `microsoft-services`
Protocol: `Https`
Port: `443`

| FQDN Destination                   | Description         |
|------------------------------------|---------------------|
| `*.hcp.<aks-cluster-location>.azmk8s.io`  | Required for Node <-> API server communication. |
| `login.microsoftonline.com`        | Required for Microsoft Entra authentication. |
| `acs-mirror.azureedge.net`         | This address is for the repository required to download and install required binaries like kubenet and Azure CNI.|
| `packages.microsoft.com`           | This address is the Microsoft packages repository used for cached apt-get operations. |
| `dc.services.visualstudio.com`     | This endpoint is used by Azure Monitor for Containers Agent Telemetry. |
| `management.azure.com`             | Required for Kubernetes operations against the Azure API. |
| `mcr.microsoft.com`                | Required to access images in Microsoft Container Registry (MCR). |
| `*.monitoring.azure.com`           | This endpoint is used to send metrics data to Azure Monitor. |
| `*.blob.storage.azure.net` | This dependency is due to some internal mechanisms of Azure Managed Disks.   |
| `*.blob.core.windows.net`  | This endpoint is used to store manifests for Azure Linux VM Agent & Extensions and is regularly checked to download new versions. |

##### Allow HTTP access to AKS nodes patch update

Rule name: `node-update-http`
Protocol: `Http`
Port: `80`

| Destination FQDN Address           | Description                   |
|------------------------------------|------------------------------|
| `changelogs.ubuntu.com`            | This address lets the Linux cluster nodes download the required security patches and updates. |
| `azure.archive.ubuntu.com`         | This address lets the Linux cluster nodes download the required security patches and updates. |
| `changelogs.ubuntu.com`             | This address lets the Linux cluster nodes download the required security patches and updates. |

##### Allow HTTPS access to AKS nodes patch update

Rule name: `node-update-https`
Protocol: `Https`
Port: `443`

| Destination FQDN Address           | Description                  |
|------------------------------------|------------------------------|
| `snapshot.ubuntu.com`              |   This address lets the Linux cluster nodes download the required security patches and updates from ubuntu snapshot service. |

##### Allow access to Docker Hub

Rule name: `docker`
Protocol: `Https`
Port: `443`

| Destination FQDN Address           | Description                                           |
|------------------------------------|-------------------------------------------------------|
| `*docker.io`                       | For pulling Docker images from the Docker repository. |
| `production.cloudflare.docker.com` | For pulling Docker images from the Docker repository. |
| `registry-1.docker.io`             | For pulling Docker images from the Docker repository. |

##### Allow access to Github

Rule name: `github`
Protocol: `Https`
Port: `443`

| Destination FQDN Address               | Description                             |
|----------------------------------------|-----------------------------------------|
| `ghcr.io`                              | For pulling from the Github repository. |
| `pkg-containers.githubusercontent.com` | For pulling from the Github repository. |

##### Allow access to `*microsoft.com`

Rule name: `all-microsoft-com`
Protocol: `Https`

_This rules are specified for firewall policy rule testing._

| Destination FQDN Address           |Description          |
|------------------------------------|---------------------|
| `*microsoft.com`                   | Allow AKS web app to access. |

### Deny Application Rule Collections

_This rules are specified for firewall rule testing._

Create an application collection rule and __Deny__ :

| Application Rule Collection name   | Action  | Priority   |
|------------------------------------|---------|------------|
| `deny-app-rule-collection`         |  `Deny` | `150`      |

#### Deny Application Rules

##### Deny access rules

Name: `deny-learnmicrosoftcom`

| Destination FQDN Address         |Description                   |
|----------------------------------|------------------------------|
| `learn.microsoft.com`            | Deny AKS web app to access.  |
