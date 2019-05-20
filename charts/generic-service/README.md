# Generic Service Helm Chart

This Helm chart serves as a template for running a service. It handles monitoring, ingress, etc..

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

You can usually delete your entire `templates` directory when using this chart. Pull it in to your Chart as a dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: generic-service
    version: 4.0.0
    repository: '@axoom-github'
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

    alerting:
      enabled: true
      labels:
        team: myteam

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

| Value                                     | Default                                               | Description                                                                                                               |
|-------------------------------------------|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| `global.tenant.id`                        |                                                       | The tenant's id (used for labeling)                                                                                       |
| `global.tenant.domain`                    |                                                       | The tenant's domain name (used for labeling)                                                                              |
| `name`                                    | __required__                                          | The name of the service                                                                                                   |
| `image.registry`                          | __required__ (`docker.io` for images from Docker Hub) | The Docker registry containing the image of the service                                                                   |
| `image.authenticated`                     | `true`                                                | Controls whether to use credentials for pulling the image                                                                 |
| `image.repository`                        | __required__                                          | The Docker Repository containing the image (excluding the Registry)                                                       |
| `image.tag`                               | __required__                                          | The Docker Tag of the image to use                                                                                        |
| `image.pullPolicy`                        | `IfNotPresent`                                        | Set to `Always` to try to pull new versions of the image                                                                  |
| `replicas`                                | `1`                                                   | The number of instances of the service to run                                                                             |
| `updateStrategy`                          | `RollingUpdate` (`Recreate` if `persistence.enabled`) | Controls whether all existing instances of the service must be shut down before new versions may be started.              |
| `rbac.roles`                              | `[]`                                                  | The names of [namespaced Roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) the service shall have.    |
| `rbac.clusterRoles`                       | `[]`                                                  | The names of [cluster-wide Roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) the service shall have.  |
| `persistence.enabled`                     | `false`                                               | Enables persistent storage for the service                                                                                |
| `persistence.storageClass`                | `standard`                                            | The type of disk to use for storage (`standard` or `ssd`)                                                                 |
| `persistence.size`                        | `1G`                                                  | The size of the persistent volume to create for the service                                                               |
| `persistence.mountPath`                   | __required if enabled__                               | The mount path for the storage inside the container                                                                       |
| `secrets[0].name`                         | __required if used__                                  | The name of the Kubernetes secret to create                                                                               |
| `secrets[0].mountPath`                    | __required if used__                                  | The mount path for the secret inside the container                                                                        |
| `secrets[0].files`                        | `{}`                                                  | A dictionary mapping file names to file contents for secrets with base64 encoded values                                   |
| `providedSecrets[0].name`                 | __required if used__                                  | The name of an existing Kubernetes secret                                                                                 |
| `providedSecrets[0].mountPath`            | __required if used__                                  | The mount path for the secret inside the container                                                                        |
| `providedSecrets[0].subPath`              |                                                       | The path of a single file in the secret relative to the given `mountPath`                                                 |
| `hostAliases`                             | `[]`                                                  | [HostAliases](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/)    |
| `sidecars`                                | `[]`                                                  | Additional sidecar containers to be added to the pod.                                                                     |
| `ingress.enabled`                         | `false`                                               | Enables HTTP ingress into the service                                                                                     |
| `ingress.port`                            | `80`                                                  | The container port ingress traffic is forwarded to                                                                        |
| `ingress.class`                           | `traefik-public`                                      | `traefik-public` for public internet, `traefik-internal` for AXOOM network, `cluster` for Kubernetes cluster only         |
| `ingress.domain`                          |                                                       | The domain name under which the service is exposed (only for `traefik-public` and `traefik-internal`)                     |
| `ingress.annotations`                     |                                                       | Additional annotations besides the ingress class to be added to the ingress. Put as `key: value` pairs                    |
| `ingress.externalDnsTarget`               |                                                       | Domain name for the external-dns target (explicitly setting `external-dns.alpha.kubernetes.io/target` annotation)         |
| `monitoring.enabled`                      | `true`                                                | Enables Prometheus monitoring                                                                                             |
| `monitoring.port`                         | `5000`                                                | The port which is scraped for monitoring data                                                                             |
| `alerting.enabled`                        | `false`                                               | Enables default alert rules (unavailable pods, high memory usage, HTTP 4xx/5xx responses, slow response times)            |
| `alerting.labels`                         | `{}`                                                  | Additional labels to apply to default alert rules                                                                         |
| `alerting.memoryUsage.thresholdFactor`    | `0.9`                                                 | The maximum factor (between `0` and `1`) of memory usage to allow before alerting                                         |
| `alerting.http4xxRatio.sampleInterval`    | `5m`                                                  | The time interval in which to measure ratio of HTTP 4xx responses for the current state                                   |
| `alerting.http4xxRatio.referenceInterval` | `1d`                                                  | The time interval in which to measure ratio of HTTP 4xx responses as a reference for the normal state                     |
| `alerting.http4xxRatio.thresholdFactor`   | `1.5`                                                 | The maximum factor between the current state and the normal state of HTTP 4xx response ratio to allow before alerting     |
| `alerting.responseTime.sampleInterval`    | `1h`                                                  | The time interval in which to measure average HTTP response times for the current state                                   |
| `alerting.responseTime.referenceInterval` | `1d`                                                  | The time interval in which to measure average HTTP response times for the normal state                                    |
| `alerting.responseTime.thresholdFactor`   | `1.5`                                                 | The maximum factor between the current state and the normal state of HTTP response times to allow before alerting         |
| `livenessProbe`                           |                                                       | Probe that causes the service to be restarted when failing                                                                |
| `readinessProbe`                          |                                                       | Probe that prevents the service from receiving traffic when failing                                                       |
| `resources`                               | Limits to 128M mem                                    | The resources requests and limits for the service                                                                         |
| `env`                                     | `{}`                                                  | The environment variables passed to the service                                                                           |
| `envFromField`                            | `{}`                                                  | Environment variables from fields. Key is the name of the env var and value is the fieldPath (e.g. `metadata.namespace`). |
| `dns.policy`                              | `ClusterFirst`                                        | [DNS resolution policy](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy)        |
| `dns.config`                              | `{}`                                                  | [DNS Config](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-config)                   |
| `podAntiAffinity`                         | based on `app.kubernetes.io/instance` label           | [Anti-Affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)                                       |
