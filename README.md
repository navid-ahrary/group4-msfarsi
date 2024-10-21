# MSFarsi Scholarship

## Provisoin Azure Container Registry to for app image

```bash
export SUB_ID=""
export RG=""
export ACR_NAME=""
export LOCATION=""
```

Login and set this subscription as a default one. _It is needed when you logged in azure-cli with multiple accounts_

```bash
az login
az account --subscription $SUB_ID
```

Create a Azure Container Registry (ACR):

```bash
az acr create --resource-group $RG --name $ACR_NAME --location $LOCATION --sku Basic
```

## Download the project

```bash
git clone git@github.com:navid-ahrary/group4-msfarsi.git`
cd group4-msfarsi/web-app
```

Build docker image and pull the image to the ACR:

```bash
az acr build -t msfarsi/group4-app:v1 --registry $ARC_NAME .
```
