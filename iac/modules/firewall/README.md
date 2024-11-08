# Azure Firewall

## Contents

- [Network Rule Collections](#network-rule-collections)
- [Application Rule Collections](#application-rule-collections)

## Network Rule Collections

Create a network collection rule and __Allow__ these FQDN Address:

| Protocol | Destination Address | Destination Ports | Description |
|----------|----------------------|-------------------|-------------|
| TCP      | `AzureCloud.<cluster-region-name>` | `9000`, `443`     | Interaction between AKS node and Cluster API Server.      |
| UDP      | `AzureCloud.<cluster-region-name>` | `1194`            | Interaction between AKS node and Cluster API Server.      |

## Application Rule Collections Allow

Create an application collection rule and __Allow__ :

| Name                                 | Protocol  | Priority    |
|--------------------------------------|-----------|-------------|
| `<firewall-name>-AppRuleCollectionAllow`  |  `Https`  | `110`       |

### Allowed Rules

Name: `allow-microsoftservices`

| Destination FQDN Address         |Description                   |
|----------------------------------|------------------------------|
| `login.microsoftonline.com`           | Required for Microsoft Entra authentication. |
| `acs-mirror.azureedge.net`            | Repository required to download and install binaries like kubenet and Azure CNI. |
| `packages.microsoft.com`              | Microsoft packages repository used for cached apt-get operations. |
| `dc.services.visualstudio.com`            | This endpoint is used by Azure Monitor for Containers Agent Telemetry. |
| `management.azure.com`            | Required for Kubernetes operations against the Azure API. |
| `mcr.microsoft.com`           | Required to access images in Microsoft Container Registry (MCR)       |
| `*.monitoring.azure.com`                | This endpoint is used to send metrics data to Azure Monitor. |

Name: `allow-microsoftblob`

| Destination FQDN Address   |Description                   |
|----------------------------|------------------------------|
| `*.blob.storage.azure.net` | This dependency is due to some internal mechanisms of Azure Managed Disks.   |
| `*.blob.core.windows.net`  | This endpoint is used to store manifests for Azure Linux VM Agent & Extensions and is regularly checked to download new versions. |

| Destination FQDN Address           |Description                   |
|------------------------------------|------------------------------|
| `*docker.io`                       | For pulling Docker images from the Docker repository. |
| `production.cloudflare.docker.com` | For pulling Docker images from the Docker repository. |
| `registry-1.docker.io`             | For pulling Docker images from the Docker repository. |

Name: `allow-microsoftcom`

_This rules are specified for firewall rule testing._

| Destination FQDN Address           |Description          |
|------------------------------------|---------------------|
| `*microsoft.com`                   | For web app access. |

## Application Rule Collections Deny

_This rules are specified for firewall rule testing._

Create an application collection rule and __Deny__ :

| Name                                     | Protocol  | Priority    |
|------------------------------------------|-----------|-------------|
| `<firewall-name>-AppRuleCollectionDeny`  |  `Https`  | `105`       |

### Denied Rules

Name: `deny-learnmicrosoftcom`

| Destination FQDN Address         |Description                   |
|----------------------------------|------------------------------|
| `learn.microsoft.com`           | Required for Microsoft Entra authentication. |
