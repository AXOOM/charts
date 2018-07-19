# Docker Secrets Helm Chart

This Helm chart deploys Docker Image Pull Secrets for the AXOOM Docker Registries (`docker.axoom.cloud` and `docker-ci.axoom.cloud`) to a Kubernetes namespace. It also optionally deploys secrets for GCS backups.

Use [Quberneeds](https://github.com/AXOOM/Quberneeds) to deploy this chart with the following environment variables:

| Name                         | Description                                                                                                                          |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `TENANT_ID`                  | The Kubernetes namespace to deploy to.                                                                                               |
| `DOCKER_REGISTRY_PASSWORD`   | The password used to log in to the Docker Registries. **[Password Store](https://password.inside-axoom.org/index.php/pwd/view/789)** |
| `GCS_BACKUP_KEYFILE`         | Content of backup service account JSON key file (optional).                                                                          |
| `GCS_ELASTIC_BACKUP_KEYFILE` | Content of Elasticsearch backup service account JSON key file (optional).                                                            |
