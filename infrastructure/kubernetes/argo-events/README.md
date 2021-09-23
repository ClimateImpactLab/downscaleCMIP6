# argo-events

This component adds an event-based framework to the cluster for general automation.


## Deploy (`argocd`)

You can deploy this in a dev environment with `argocd` from the CLI with

```bash
argocd app create argo-events \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path infrastructure/kubernetes/argo-events \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argo-events \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```