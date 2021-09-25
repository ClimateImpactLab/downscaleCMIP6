# cert-manager

This component handles TLS certificate issuing, renewing.

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