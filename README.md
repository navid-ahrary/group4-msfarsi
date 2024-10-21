# MSFarsi Scholarship

## Contents

- [Provision Azure Container Registry (ACR) service](#provision-azure-container-registry-acr-for-hosting-docker-images)
- [Download and build the web app](#download-and-build-the-web-app)


## Provision Azure Container Registry (ACR) for hosting Docker images

```bash
export SUB_ID=""
export RG=""
export ACR_NAME=""
export LOCATION=""
```

Log in to Azure:

```bash
az login
```

Set this subscription as a default one.
**It is needed when you logged-in with multiple accounts.**

```bash
az account --subscription $SUB_ID
```

Create a Azure Container Registry (ACR):

```bash
az acr create --resource-group $RG --name $ACR_NAME --location $LOCATION --sku Basic
```

## Download and build the web app

```bash
git clone git@github.com:navid-ahrary/group4-msfarsi.git`
cd group4-msfarsi/web-app
```

Build docker image and pull the image to the ACR:

```bash
az acr build -t msfarsi/group4-app:v1 --registry $ARC_NAME .
```
