# cert-manager

This component handles TLS certificate issuing and renewing.

This depends `kubernetes-external-secrets`.

## Pre-deployment

Be sure the `cert-manager` Namespace exists on the cluster. Create the Namespace with

```bash
kubectl create namespace "cert-manager"
```

If you're using Google Cloud for DNS you need to create a service account with correct permissions to interact with DNS.

For example

```bash
PROJECT_ID="compute-impactlab"
GCP_SA_NAME="azuredc6-dns01-solver"

gcloud iam service-accounts create "${GCP_SA_NAME}" \
  --display-name "dns01-solver for downscaleCMIP6 Azure cluster"

# Can just use roles/dns.admin, but here is a preferred least privilege 
# role. This does not need to be created if it already exists.
gcloud iam roles create "dns01Solver" \
  --project "${PROJECT_ID}" \
  --title="DNS01 Solver" \
  --description="Role used to resolve dns01 challenges for cert-manager and TLS certificates" \
  --stage "alpha" \
  --permissions "dns.resourceRecordSets.create,dns.resourceRecordSets.delete,\
dns.resourceRecordSets.get,dns.resourceRecordSets.list,dns.resourceRecordSets.update,\
dns.changes.create,dns.changes.get,dns.changes.list,dns.managedZones.list"
  
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
   --member "serviceAccount:${GCP_SA_NAME}@$PROJECT_ID.iam.gserviceaccount.com" \
   --role "projects/${PROJECT_ID}/roles/dns01Solver"
   
# You can then grab a service account key and upload it to the Azure KeyVault. 
gcloud iam service-accounts keys create key.json \
  --iam-account "${GCP_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
# but best practice is to use Terraform or value to rotate these keys.

```

## Deploy (`argocd`)

You can deploy this in a dev environment with `argocd` from the CLI with

```bash
argocd app create cert-manager \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path infrastructure/kubernetes/cert-manager \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace cert-manager \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```
