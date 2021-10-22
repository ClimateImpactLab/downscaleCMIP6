# kubernetes-external-secrets
This component allows us to securely reference, access, and update sensitive data while keeping our Kubernetes setup public.

## Deploy (`argocd`)

You can deploy this in a dev environment with `argocd` from the CLI with

```bash
argocd app create kubernetes-external-secrets \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path infrastructure/kubernetes/kubernetes-external-secrets \
    --values values.yaml \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace kubernetes-external-secrets \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```