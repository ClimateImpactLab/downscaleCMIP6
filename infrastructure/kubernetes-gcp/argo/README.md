# downscaleCMIP6-infra-argo
Argo Workflow configuration for CMIP6 downscaling project.

## Updating

If there is already a deployment -- file a pull request with changes to `main`. Merged changes are automatically pulled into the cluster through ArgoCD.

## Deploying

### Setup (`argocd`)
To begin, you need to have `argocd` deployed on a cluster. If it is not already deployed, you can do so with

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.1.16/manifests/install.yaml
kubectl patch deploy argocd-server -n argocd -p '[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--disable-auth"}]' --type json
```

### Argo Workflows

Deploy `argo` onto the cluster with

```bash
argocd app create argo \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path "infrastructure/kubernetes-gcp/argo" \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace "argo" \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```

Test either deployment method with

```bash
argo submit -n argo --serviceaccount workflows-default --watch https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/hello-world.yaml 
```

This assumes you have the `argo` CLI application installed locally. From the output, grab the workflow name and run

```bash
argo logs -n argo <workflow-name>
```

If all is well, you will see a happy whale:

```
hello-world-kqvvg:  _____________ 
hello-world-kqvvg: < hello world >
hello-world-kqvvg:  ------------- 
hello-world-kqvvg:     \
hello-world-kqvvg:      \
hello-world-kqvvg:       \     
hello-world-kqvvg:                     ##        .            
hello-world-kqvvg:               ## ## ##       ==            
hello-world-kqvvg:            ## ## ## ##      ===            
hello-world-kqvvg:        /""""""""""""""""___/ ===        
hello-world-kqvvg:   ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~   
hello-world-kqvvg:        \______ o          __/            
hello-world-kqvvg:         \    \        __/             
hello-world-kqvvg:           \____\______/   
```
