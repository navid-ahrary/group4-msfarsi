# MSFarsi Scholarship

This project is part of scenario which is assigned to our group in MSFarsi Scholarship 1 - 2024.

## Contents

- [Provision Azure Container Registry (ACR) service](#provision-azure-container-registry-acr-for-hosting-docker-images)
- [Pull the web app docker image to ACR](#pull-the-web-app-docker-image-to-acr)

### Provision Azure Container Registry (ACR) for hosting Docker images

Log in to Azure:

```bash
az login
```

```bash
export RG="YOUR_RESOURCE_GROUP_NAME" # Replace with your resource group name
export SUB_ID="YOUR_SUBSCRIPTION_ID" # Replace with your current subscription id
export LOCATION="swedencentral"
export ACR_NAME="acrswcdev$RANDOM" ## Must be unique universally
```

Set this subscription as a default one for the rest of commands.
**It is necessary when you logged-in azure cli with multiple accounts.**

```bash
az account set --subscription $SUB_ID
```

Create a Azure Container Registry (ACR):

```bash
az acr create --resource-group $RG --name $ACR_NAME --location $LOCATION --sku Basic
```

### Pull the web app docker image to ACR

Build a docker image from web app and pull to ACR in order to use in Azure Kuberenets Service (AKS).

Clone the project:

```bash
git clone git@github.com:navid-ahrary/group4-msfarsi.git
cd group4-msfarsi/web-app
```

Build the docker image and pull to the ACR:

```bash
az acr build -t msfarsi/group4-app:v1 --registry $ARC_NAME .
```
