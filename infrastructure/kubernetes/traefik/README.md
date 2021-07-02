# traefik
This component is the cluster ingress. We use this one because it can terminate TLS and both TCP and HTTP connections on the same port. Hooray for less work.

## Pre-deployment
Be sure the `traefik` Namespace exists on the cluster.
Create the Namespace with
```bash
kubectl create namespace "traefik"
```

## Deploy (`argocd`)

You can deploy this in a dev environment with `argocd` from the CLI with

```bash
argocd app create traefik \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path infrastructure/kubernetes/traefik \
    --values values.yaml \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace traefik \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```
