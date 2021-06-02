# History

## v0.X.X (XXXX-XX-XX)

* Decreased `amaterasu` "worker" node pool max node count to 20. This is to avoid the node pool scaling beyond the subscription quota during development.

## v0.6.0 (2021-04-14)

* Add `support` storage container into `dc6` storage account for "support" data, like domain files.
* Add `clean-dev` storage container into `dc6` for manual testing and dev GCM data and workflows.
* Fix bug where AKS core node pool does not follow `kubernetes_version` setting.
* Upgrade `amaterasu` cluster to Kubernetes v1.19.7.

## v0.5.0 (2021-01-29)

* Several improvements to documentation.
* Migrated provisioned AZ resources to West Europe.
* Refactored, cleaned up Terraform dependency graph. It's tricky to provision a Kubernetes cluster *and* resources within the cluster. Hopefully, this will be easier with this refactoring.
* Kubernetes `Namespaces` are now provisioned. This is so we can provision `Secrets` onto the cluster.
* Resource prefix shortened to `dc6-`. The ACR retains the old `downscaleCmip6` name, though.
* Azure resources managed by Terraform are now tagged with `managed-by:terraform`, where possible.
* `storage_account` module outputs name and access key.
* Climate data Storage Account credentials are automatically stored as a k8s `Secret`, `workerstoragecreds-secret`, in provisioned `aks_cluster`'s 'argo' namespace.

## v0.4.0 (2021-01-27)

* Upgrade AKS cluster to k8s 1.17.16.
* Set 15-day "cleanup" policy for `dc6/scratch`.
* Add production-ready `dc6` storage account with `raw`, `scratch`, and `clean` ADL Gen 2. containers.
* Improve security on `aks_cluster` module output.

## v0.3.0 (2021-01-11)

* Add container registry with AKS access.
* Create data lake for longterm GCM storage.
* Refactor AKS cluster into TF module.

## v0.2.0 (2020-10-26)

* Add spot node pool to AKS cluster for job workers.
* Internal refactoring for automated CI/CD.

## v0.1.0 (2020-10-21)

Initial release.
