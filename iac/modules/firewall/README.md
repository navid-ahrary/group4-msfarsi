# Azure Firewall

## Contents

- [Network Rules](#network-rules)
- [Application Rules](#application-rules)

## Network Rules

Create a network collection rule and __Allow__ these FQDN Address:

| Protocol | Destination FQDN Address | Destination Ports | Description |
|----------|----------------------|-------------------|-------------|
| TCP      | `<cluster-api-server-address>` | `9000`, `443`     | Interaction between AKS node and Cluster API Server.      |
| UDP      | `<cluster-api-server-address>` | `1194`            | Interaction between AKS node and Cluster API Server.      |
| TCP       | _ServiceTag_ `AzureMonitor` | `443` | This endpoint is used to send metrics data and logs to Azure Monitor and Log Analytics. |

## Application Rules

Create an application collection rule and __Allow__ `Https` to this destination.

| Destination FQDN Address         |Description                   |
|----------------------------------|------------------------------|
| `*.hcp.<cluster-region-name>.azmk8s.io`       | Required for Node <-> API server communication. Not required for private clusters. |
| `management.azure.com`                | Required for Kubernetes operations against the Azure API. |
| `login.microsoftonline.com`           | Required for Microsoft Entra authentication. |
| `acs-mirror.azureedge.net`            | Repository required to download and install binaries like kubenet and Azure CNI. |
| `docker.io`, `production.cloudflare.docker.com`, `registry-1.docker.io`   | For pulling Docker images from the Docker repository. |
| `packages.microsoft.com`              | Microsoft packages repository used for cached apt-get operations. |
| `dc.services.visualstudio.com`            | This endpoint is used by Azure Monitor for Containers Agent Telemetry. |
| `*.ods.opinsights.azure.com`            | This endpoint is used by Azure Monitor for ingesting log analytics data. |
| `*.oms.opinsights.azure.com`            | This endpoint is used by omsagent, which is used to authenticate the log analytics service. |
| `*.monitoring.azure.com`                | This endpoint is used to send metrics data to Azure Monitor. |
| `<cluster-region-name>.ingest.monitor.azure.com` | This endpoint is used by Azure Monitor managed service for Prometheus metrics ingestion. |
| `<cluster-region-name>.handler.control.monitor.azure.com`  | This endpoint is used to fetch data collection rules for a specific cluster. |