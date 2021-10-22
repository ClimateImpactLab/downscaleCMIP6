# argo-events

This component adds an event-based framework to the cluster for general automation.

## Pre-deployment

Be sure the `argo-events` Namespace exists on the cluster.
Create the Namespace with

```bash
kubectl create namespace "argo-events"
```

## Deploy (`argocd`)

You can deploy this in a dev environment with `argocd` from the CLI with

```bash
argocd app create argo-events \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --revision master \
    --path infrastructure/kubernetes/argo-events \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argo-events \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```