# infrastructure

Cloud infrastructure, configurations.

- `terraform/` contains Terraform environments to provision cloud resources, including Kubernetes clusters.

- `kubernetes-gcp/` contains manifests and resources deployed onto the Google Kubernetes Engine (GKE) clusters after they've been provisioned with Terraform. After initial setup, these are automatically synced by ArgoCD within the clusters. 
