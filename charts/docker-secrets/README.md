# Docker Secrets Helm Chart

[Source code](https://tfs.inside-axoom.org/tfs/axoom/axoom/_git/Axoom.Platform.BaseAssets?path=%2Fcharts%2Fdocker-secrets)

This Helm chart deploys Docker Image Pull Secrets for the AXOOM Docker Registries (`docker.axoom.cloud` and `docker-ci.axoom.cloud`) to a Kubernetes namespace.

Use [Quberneeds](https://github.com/AXOOM/Quberneeds) to deploy this chart with the following environment variables:

| Name                       | Description                                            |
|----------------------------|--------------------------------------------------------|
| `TENANT_ID`                | The Kubernetes namespace to deploy to.                 |
| `DOCKER_REGISTRY_PASSWORD` | TThe password used to log in to the Docker Registries. |
