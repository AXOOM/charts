# AXOOM Service Helm Chart

[Source code](https://tfs.inside-axoom.org/tfs/axoom/axoom/_git/Axoom.Platform.BaseAssets?path=%2Fcharts%2Faxoom-service)

This Helm chart serves as a template for running a service with no ingress.  
If you need an ingress, use `axoom-webservice` instead.

Pull it in to your Chart as dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: axoom-service
    version: 0.1.0
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
  monitoring:
    port: 5000
  resources:
    requests:
      memory: "16M"
    limits:
      memory: "64M"
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
          env:
            OTHER_CONFIG: '{{ env "MYSERVICE_OTHER_CONFIG" | default "other-value" }}'
```
