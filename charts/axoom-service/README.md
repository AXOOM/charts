# AXOOM Service Helm Chart

This Helm chart serves as a template for running a service. It handles monitoring, ingress, etc..  

You can usually delete the entire `templates` directory when using this chart. Pull it in to your Chart as dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: axoom-service
    version: 2.0.0
    repository: '@axoom-base'
    alias: app
```

You can then add static configuration to your `values.yaml` like this:

```yaml
app:
  name: myservice

  image:
    registry: docker.axoom.cloud # replaced with docker-ci.axoom.cloud for pre-release builds by build server
    repository: services/myvendor-myservice
    tag: latest # replaced with specific version number by build server

  # resources:
  #   ...

  # livenessProbe:
  #   ...

  # readinessProbe:
  #   ...

  env:
    SOME_CONFIG: some-value
```

For configuration that varies between instances add something like this to your `helmfile.yaml`:

```yaml
releases:
  - name: '{{ requiredEnv "TENANT_ID" }}-myservice' # Sets the release specific asset name, containing the tenant's id.
    namespace: '{{ requiredEnv "TENANT_ID" }}' # Sets the release specific k8s namespace: the tenant's id.
    chart: ./ # Use the chart from this repository.
    values:
      - global:
          tenant:
            id: '{{ requiredEnv "TENANT_ID" }}'
            domain: '{{ requiredEnv "PUBLIC_DOMAIN" }}'

        app:
          ingress:
            enabled: true
            domain: 'myservice-{{ requiredEnv "PUBLIC_DOMAIN" }}'
          env:
            OTHER_CONFIG: '{{ env "MYSERVICE_OTHER_CONFIG" | default "other-value" }}'
```

## Values

| Value                       | Default                 | Description                                                                                                              |
| --------------------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `global.tenant.id`          | __required__            | The tenant's id (used for labeling)                                                                                      |
| `global.tenant.domain`      | __required__            | The tenant's domain name (used for labeling)                                                                             |
| `name`                      | __required__            | The name of the service                                                                                                  |
| `image.registry`            | `docker.axoom.cloud`    | The Docker registry containing the image of the service                                                                  |
| `image.authenticated`       | `true`                  | Controls whether to use credentials for pulling the image                                                                |
| `image.repository`          | __required__            | The Docker Repository containing the image (excluding the Registry)                                                      |
| `image.tag`                 | __required__            | The Docker Tag of the image to use                                                                                       |
| `image.pullPolicy`          | `IfNotPresent`          | Set to `Always` to try to pull new versions of the image                                                                 |
| `replicas`                  | `1`                     | The number of instances of the service to run                                                                            |
| `rbac.roles`                | `[]`                    | The names of [namespaced Roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) the service shall have.   |
| `rbac.clusterRoles`         | `[]`                    | The names of [cluster-wide Roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) the service shall have. |
| `persistence.enabled`       | `false`                 | Enables persistent storage for the service                                                                               |
| `persistence.storageClass`  | `standard`              | The type of disk to use for storage (`standard` or `ssd`)                                                                |
| `persistence.size`          | `1G`                    | The size of the persistent volume to create for the service                                                              |
| `persistence.mountPath`     | __required if enabled__ | The mount path for the storage inside the container                                                                      |
| `secrets.enabled`           | `false`                 | Enables mounting of secret values into the service's container                                                           |
| `secrets.mountPath`         | __required if enabled__ | The mount path for the secrets inside the container                                                                      |
| `secrets.values`            | `{}`                    | A dictionary mapping file names to file contents for secrets with base64 encoded values                                  |
| `ingress.enabled`           | `false`                 | Enables HTTP ingress into the service                                                                                    |
| `ingress.port`              | `80`                    | The container port ingress traffic is forwarded to                                                                       |
| `ingress.class`             | `traefik-public`        | `traefik-public` for public internet, `traefik-internal` for AXOOM network, `cluster` for Kubernetes cluster only        |
| `ingress.domain`            |                         | The domain name under which the service is exposed (only for `traefik-public` and `traefik-internal`)                    |
| `ingress.annotations`       |                         | Additional annotations besides the ingress class to be added to the ingress. Put as `key: value` pairs                   |
| `ingress.externalDnsTarget` |                         | Domain name for the external-dns target (explicitly setting `external-dns.alpha.kubernetes.io/target` annotation)        |
| `monitoring.enabled`        | `true`                  | Enables Prometheus monitoring                                                                                            |
| `monitoring.port`           | `5000`                  | The port which is scraped for monitoring data                                                                            |
| `livenessProbe`             |                         | Probe that causes the service to be restarted when failing                                                               |
| `readinessProbe`            |                         | Probe that prevents the service from receiving traffic when failing                                                      |
| `resources`                 | Limits to 128M mem      | The resources requests and limits for the service                                                                        |
| `env`                       | `{}`                    | The environment variables passed to the service                                                                          |
