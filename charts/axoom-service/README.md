# AXOOM Service Helm Chart

This Helm chart serves as a template for running a service. It handles monitoring, ingress, etc..  

You can usually delete the entire `templates` directory when using this chart. Pull it in to your Chart as dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: axoom-service
    version: 1.1.0
    repository: '@axoom-base'
    alias: app
```

You can then add static configuration to your `values.yaml` like this:

```yaml
app:
  name: myservice

  image:
    registry: docker.axoom.cloud
    repository: services/myservice
    tag: latest

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

| Value                  | Default              | Description                                                           |
|------------------------|----------------------|-----------------------------------------------------------------------|
| `global.tenant.id`     | __required__         | The tenant's id (used for labeling)                                   |
| `global.tenant.domain` | __required__         | The tenant's domain name (used for labeling)                          |
| `name`                 | __required__         | The name of the service                                               |
| `image.registry`       | `docker.axoom.cloud` | The Docker registry containing the image of the service               |
| `image.authenticated`  | `true`               | Controls whether to Docker Registry credentials for pulling the image |
| `image.repository`     | __required__         | The Docker Repository containing the image (excluding the Registry)   |
| `image.tag`            | __required__         | The Docker Tag of the image to use                                    |
| `image.pullPolicy`     | `IfNotPresent`       | Set to `Always` to try to pull new versions of the image              |
| `replicas`             | `1`                  | The number of instances of the service to run                         |
| `ingress.enabled`      | `false`              | Enables HTTP ingress into the service from outside of the cluster     |
| `ingress.class`        | `traefik-public`     | The class of ingress (`traefik-public`/`traefik-internal`)            |
| `ingress.domain`       |                      | The domain name under which the service is exposed                    |
| `ingress.port`         | `80`                 | The container port ingress traffic is forwarded to                    |
| `monitoring.enabled`   | `true`               | Enables Prometheus monitoring                                         |
| `monitoring.port`      | `5000`               | The port which is scraped for monitoring data                         |
| `monitoring.interval`  | `30s`                | The interval in which Prometheus will scrape the endpoint                       |
| `livenessProbe`        |                      | Probe that causes the service to be restarted when failing            |
| `readinessProbe`       |                      | Probe that prevents the service from receiving traffic when failing   |
| `resources`            | Limits to 128M mem   | The resources requests and limits for the service                     |
| `env`                  | `{}`                 | The environment variables passed to the service                       |
