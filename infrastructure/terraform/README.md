# downscaleCMIP6-infra

General managed infrastructure for CMIP6 downscaling project.

Change and provision resources by opening Pull Requests to the `main` branch.

## Things not covered by Terraform

Kubernetes internals are deployed from `/infrastructure/kubernetes/` using `argocd`.

### Creating Service Principal for Github Actions for container CI/CD

Terraform also does not handle some Active Directory and IAM tasks due to limited permissions. Because of this the Service Principal (SP) used by Github Actions can be provisioned manually, along with permissions for the SP to push containers to the container registry.

Read the full directions before running these commands.

```
# Some setup
RESOURCE_GROUP="myAzResourceGroup"
GROUPID=$(az group show \
  --name "${RESOURCE_GROUP}" \
  --query id --output tsv)

# Creates an RBAC SP. Note the output from this.
az ad sp create-for-rbac --scope $GROUPID --role Contributor --sdk-auth

# Based on output from the above command, fill out these:
REGISTRYNAME="myAzContainerRegistryName
CLIENTID="insertRealClientIdHere"
REGISTRYID=$(az acr show \
  --name "${REGISTRYNAME}" \
  --query id --output tsv)

# And give the new SP a "push" role to the registry.
az role assignment create \
  --assignee "${CLIENTID}" \
  --scope "${REGISTRYID}" \
  --role AcrPush
```

Now that I think about it, we might be able to skip much of this and just run 

```
az ad sp create-for-rbac --scope "${REGISTRYID}" --role AcrPush --sdk-auth
```

Regardless, you pay attention to the output above and plug the values into *Secret* environment variable on the intended Github repo: `ACR_PASSWORD`, `ACR_USERNAME`. `ACR_USERNAME` is `"clientId"` and `ACR_PASSWORD` is
`"clientSecret"` in the output from `az ad sp create-for-rbac`, above.