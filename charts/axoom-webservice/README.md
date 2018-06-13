# AXOOM Webservice Helm Chart

[Source code](https://tfs.inside-axoom.org/tfs/axoom/axoom/_git/Axoom.Platform.BaseAssets?path=%2Fcharts%2Faxoom-webservice)

This Helm chart serves as a template for running a service that is exposed via an ingress.  
If you don't need an ingress, use `axoom-service` instead.

You can usually delete the entire `templates` directory when using this chart. Pull it in to your Chart as dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: axoom-service
    version: 1.0.0
    repository: '@axoom-base'
    alias: app
```

You can then add static configuration to your `values.yaml` like this:

```yaml
app:
  name: myapp
  image:
    registry: docker.axoom.cloud
    repository: apps/myapp
    tag: latest
  monitoring:
    port: 5000
  resources:
    requests:
      memory: "16M"
    limits:
      memory: "64M"
  livenessProbe:
    initialDelaySeconds: 10 # Allow for long startup
    httpGet:
      port: ingress
      path: /
  readinessProbe:
    initialDelaySeconds: 2 # Accept traffic quickly
    httpGet:
      port: ingress
      path: /
  env:
    SOME_CONFIG: some-value
```

For configuration that varies between instances add something like this to your `helmfile.yaml`:

```yaml
    values:
      - global:
          tenant:
            id: '{{ requiredEnv "TENANT_ID" }}'
            domain: '{{ requiredEnv "PUBLIC_DOMAIN" }}'

        app:
          ingress:
            domain: 'myapp-{{ requiredEnv "PUBLIC_DOMAIN" }}'
          env:
            OTHER_CONFIG: '{{ env "MYAPP_OTHER_CONFIG" | default "other-value" }}'
```

## Values

| Value                  | Default              | Description                                                                     |
|------------------------|----------------------|---------------------------------------------------------------------------------|
| `global.tenant.id`     | __required__         | The tenant's id (used for labeling)                                             |
| `global.tenant.domain` | __required__         | The tenant's domain name (used for labeling)                                    |
| `name`                 | __required__         | The name of the service                                                         |
| `image.registry`       | `docker.axoom.cloud` | The docker registry                                                             |
| `image.authenticated`  | `true`               | Uses docker registry credentials (for configured the registry) if set to `true` |
| `image.repository`     | __required__         | The docker repository (exluding the registry)                                   |
| `image.tag`            | __required__         | The docker tag                                                                  |
| `image.pullPolicy`     | `IfNotPresent`       | The policy telling when shall be pulled from the docker registry                |
| `replicas`             | `1`                  | The amount of replicas                                                          |
| `monitoring.enabled`   | `true`               | Enables/Disables monitoring                                                     |
| `monitoring.class`     | `default`            | The class of monitoring (`default`/`xetics`)                                    |
| `monitoring.port`      | `5000`               | The port which is used to get monitoring data                                   |
| `livenessProbe`        |                      | Probe that causes the service to be restarted when failing.                     |
| `readinessProbe`       |                      | Probe that prevents the service from receiving traffic when failing.            |
| `resources`            | Limits to 128M mem   | The resources requests and limits for this service                              |
| `env`                  | `{}`                 | The environment variables passed to this service                                |
