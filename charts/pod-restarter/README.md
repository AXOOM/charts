# Pod Restarter Helm Chart

This Helm chart deploys a Kubernetes Cronjob that periodically deletes Pods with a specific app label. The Pods should then be recreated/restarted automatically by the Deployment or StatefulSet that created them.

Pull it in to your Chart as dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: pod-restarter
    version: 2.2.0
    repository: '@axoom-base'
```

You can then add configuration to your `values.yaml` like this:

```yaml
pod-restarter:
  app: myservice
```

## Values

| Value      | Default      | Description                                                                |
| ---------- | ------------ | -------------------------------------------------------------------------- |
| `app`      | __required__ | The value for the `app` label used to find the Pod(s) to be deleted.       |
| `schedule` | `0 3 * * *`  | The restart schedule in [Cron format](https://en.wikipedia.org/wiki/Cron). |
