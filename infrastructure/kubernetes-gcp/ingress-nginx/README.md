# ingress-nginx
This component is a basic cluster ingress.

Be sure the IP address in `ingress-nginx.controller.service.loadBalancerIP` matches the IP address provisioned in Terraform.

## Deploy (`argocd`)

You can deploy this in a dev environment with `argocd` from the CLI with

```bash
argocd app create ingress-nginx \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path "infrastructure/kubernetes-gcp/ingress-nginx" \
    --values values.yaml \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace ingress-nginx \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```
