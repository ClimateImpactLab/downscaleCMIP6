# workflows

Resources to orchestrate the larger biascorrection/downscaling workflow with Argo Workflows.

- `workflows/parameters/` contains parameters for individual bias-correction/downscaling jobs.
- `workflows/templates/` contains `WorkflowTemplate` manifests. These are resuseable workflows that are automatically pulled onto the cluster.
- `*.yaml` Single use `Workflow` manifests for one-off jobs and prototypes.
