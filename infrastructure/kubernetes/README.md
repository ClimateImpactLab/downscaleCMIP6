# downscaleCMIP6-infra-argo
Argo Workflow configuration and deploy for CMIP6 downscaling project.

Manifests for Argo Workflow itself are in `argo/`. The `workflows-default/` directory contains manifests required to run analysis Workflows. `minio/` is a configuration Helm Chart to deploy the artifact repository. Cluster internals are mostly managed with `argocd`.

## Updating

If there is already has a deployment -- file a pull request with changes to `main`. Merged PRs are checked and automatically pulled.

## Deploying

### Setup (`argocd`)
To begin, you need to have `argocd` deployed on a cluster. If it is not already deployed, you can do so with

```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch deploy argocd-server -n argocd -p '[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--disable-auth"}]' --type json
```

### Argo Workflows

Deploy `argo` onto the cluster with

```
argocd app create argo \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6.git \
    --path infrastructure/kubernetes/argo \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argo \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
argocd app create workflows-default \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6.git \
    --path infrastructure/kubernetes/workflows-default \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argo \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```

Test either deployment method with

```
argo submit -n argo --serviceaccount workflows-default --watch https://raw.githubusercontent.com/argoproj/argo/master/examples/hello-world.yaml 
```

This assumes you have the `argo` CLI application installed locally. From the output, grab the workflow name and run

```
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

### Argo Workflow artifact repository (minio)

`minio` works as an S3 wrapper to an underlying Azure Blob Storage. With the S3 interface, we can easily use Azure storage as an Argo Workflows artifact repository.

Deploy `minio` into the `argo` namespace with:

```
argocd app create minio \
    --repo https://github.com/ClimateImpactLab/downscaleCMIP6 \
    --path infrastructure/kubernetes/minio \
    --values values.yaml \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argo \
    --sync-policy automated \
    --auto-prune \
    --port-forward-namespace argocd
```
