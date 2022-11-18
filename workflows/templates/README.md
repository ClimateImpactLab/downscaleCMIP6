# templates

Various `WorkflowTemplate` specifying reuseable jobs or job steps for orchestrating biascorrection/downscaling work. Resources listed in `kustomization.yaml` are automatically pulled onto the cluster.

The most important "top-level" work is in the `e2e-*-jobs.yaml` files which are fed parameter files from `../parameters/`. These download, clean, and biascorrect/downscale CMIP6 data. Manually launched from the command line this might look like:

```shell
argo submit --from workflowtemplate/e2e-tasmax-jobs \
  -f "https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/workflows/parameters/ACCESS-CM2-tasmax.yaml"
```

We might also set labels for the work like so:
```shell
argo submit --from workflowtemplate/e2e-tasmax-jobs \
  -f "https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/workflows/parameters/ACCESS-CM2-tasmax.yaml" \
  --labels "source_id=Access-CM2,variable_id=tasmax,env=prod"
```

The majority of the other `WorkflowTemplate` files specify single-tasks used as steps in larger workflows. Each file is generally 200 - 500 lines long with the hope of being simpler and easier to digest.

A few other files to note:

- `clean-era5.yaml` Needs to be run on its own before the larger workflow is run. This performs preprocessing to ERA5, in addition to the downloading/processing described in `notebooks/`. This is needed so the ERA5 can be used as a reference dataset.
- `create-pr-references.yaml`  Also needs to be run before the larger workflow is run for precipitation. It reads in the cleaned ERA5 data to create precipitation reference dataset. This allows us to carefully handle wet-day adjustments and run the larger precipitation workflow without repeating reference-creation steps. 
