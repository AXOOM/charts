# Pod Restarter Helm Chart

This Helm chart deploys a Kubernetes Cronjob that periodically restarts Pods controlled by Deployments or StatefulSets. This uses `kubect rollout restart` internally.

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

Pull it in to your Chart as dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: pod-restarter
    version: 5.1.3
    repository: '@axoom-github'
```

You can then add configuration to your `values.yaml` like this:

```yaml
pod-restarter:
  target:
    name: myservice
```

## Values

| Value             | Default       | Description                                                                                    |
|-------------------|---------------|------------------------------------------------------------------------------------------------|
| `target.apiGroup` | `extensions`  | The Kubernetes API Group of the  resource to restart.                                          |
| `target.type`     | `deployments` | The plural name of the Kubernetes resource to restart (e.g. `deployments` or `statefulesets`). |
| `target.name`     | __required__  | The name of the the Kubernetes resource to restart.                                            |
| `schedule`        | `0 3 * * *`   | The restart schedule in [Cron format](https://en.wikipedia.org/wiki/Cron).                     |
