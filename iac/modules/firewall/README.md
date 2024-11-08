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

## Application Rule Collections

Create an application collection rule and __Allow__ :

| Name                              | Protocol  | Priority    |
|-----------------------------------|-----------|-------------|
| `<firewall-name>-AppRuleCollection`  |  `Https`   | `110`        |

### Rules

Name: `allow-logservices`

| Destination FQDN Address         |Description                   |
|----------------------------------|------------------------------|
| `login.microsoftonline.com`           | Required for Microsoft Entra authentication. |
| `acs-mirror.azureedge.net`            | Repository required to download and install binaries like kubenet and Azure CNI. |
| `packages.microsoft.com`              | Microsoft packages repository used for cached apt-get operations. |
| `dc.services.visualstudio.com`            | This endpoint is used by Azure Monitor for Containers Agent Telemetry. |
| `*.ods.opinsights.azure.com`            | This endpoint is used by Azure Monitor for ingesting log analytics data. |
| `*.oms.opinsights.azure.com`            | This endpoint is used by omsagent, which is used to authenticate the log analytics service. |
| `*.monitoring.azure.com`                | This endpoint is used to send metrics data to Azure Monitor. |
| `<cluster-region-name>.ingest.monitor.azure.com` | This endpoint is used by Azure Monitor managed service for Prometheus metrics ingestion. |
| `<cluster-region-name>.handler.control.monitor.azure.com`  | This endpoint is used to fetch data collection rules for a specific cluster. |
| `mcr.microsoft.com`           | Required to access images in Microsoft Container Registry (MCR)       |
| `dc.services.visualstudio.com`                           | This endpoint is used by Azure Monitor for Containers Agent Telemetry. |

| Destination FQDN Address   |Description                   |
|----------------------------|------------------------------|
| `*.blob.storage.azure.net` | This dependency is due to some internal mechanisms of Azure Managed Disks.   |
| `*.blob.core.windows.net`  | This endpoint is used to store manifests for Azure Linux VM Agent & Extensions and is regularly checked to download new versions. |

| Destination FQDN Address           |Description                   |
|------------------------------------|------------------------------|
| `*docker.io`                       | For pulling Docker images from the Docker repository. |
| `production.cloudflare.docker.com` | For pulling Docker images from the Docker repository. |
| `registry-1.docker.io`             | For pulling Docker images from the Docker repository. |
| `<cluster-region-name>.ingest.monitor.azure.com` | This endpoint is used by Azure Monitor managed service for Prometheus metrics ingestion. |
| `<cluster-region-name>.handler.control.monitor.azure.com`  | This endpoint is used to fetch data collection rules for a specific cluster. |
