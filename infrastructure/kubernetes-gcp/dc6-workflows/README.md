# dc6-workflows

Argo Workflow templates and RBAC specific to downscaling CMIP6. This does not install Argo Workflows itself.


Deploy into the `default` cluster namespace with

```bash
argocd app create dc6-workflows \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path "infrastructure/kubernetes/dc6-workflows" \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace "default" \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```
