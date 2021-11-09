# kubernetes-external-secrets
This component allows us to securely reference, access, and update sensitive data while keeping our Kubernetes setup public.

## Pre-deployment
This requires manual setup to create Azure Key Vault, create a Service Principal for Kubernetes to access the vault, and finally, create the namespace and placing the Service Principal Credentials into a Secret for access to the vault.

We generally use Terraform for this setup. However, we need to do this manually because of Terraform has limited permissions to create and edit Service Principals.
```bash
# BE SURE KUBECTL CONFIG CONTEXT IS POINTING TO THE CORRECT CLUSTER BEFORE YOU BEGIN!

AZURE_RESOURCE_GROUP="dc6-resources"
KEYVAULT_NAME="dc6-general-20210701"
EXTERNALSECRETS_NAMESPACE="kubernetes-external-secrets"

## Create Azure Key Vault. This may take several moments.
az keyvault create -n "${KEYVAULT_NAME}" \
  -g "${AZURE_RESOURCE_GROUP}"

## Get service principal for k8s external secrets. Put credentials on cluster secret
SP=$(az ad sp create-for-rbac --skip-assignment)
APPID=$(echo $SP | jq .appId)
APPID=$(echo "${APPID//\"/}")
SECRETID=$(echo $SP | jq .password)
SECRETID=$(echo "${SECRETID//\"/}")
TENANT=$(echo $SP | jq .tenant)
TENANT=$(echo "${TENANT//\"/}")

# Set service principal->keyvault permissions required by k8s external secrets.
az keyvault set-policy -n "${KEYVAULT_NAME}" \
  --spn "${APPID}" \
  --secret-permissions get list

# Place the secret in the cluster.
kubectl create namespace "${EXTERNALSECRETS_NAMESPACE}"  # If it doesn't already exist.
kubectl create secret generic azure-credentials \
  -n "${EXTERNALSECRETS_NAMESPACE}" \
  --from-literal clientid="${APPID}" \
  --from-literal clientsecret="${SECRETID}" \
  --from-literal tenantid="${TENANT}"
```

## Deploy (`argocd`)

You can deploy this in a dev environment with `argocd` from the CLI with

```bash
argocd app create "kubernetes-external-secrets" \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path "infrastructure/kubernetes-az/kubernetes-external-secrets" \
    --values values.yaml \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace kubernetes-external-secrets \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```
