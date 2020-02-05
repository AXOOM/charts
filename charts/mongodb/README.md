# MongoDB Helm Chart

This Helm chart deploys a MongoDB database with a Network Policy for access control and an optional Cronjob for automatic backups.

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

Then pull it in to your Chart as a dependency by adding this to your `requirements.yaml`:

```yaml
dependencies:
  - name: mongodb
    version: 5.3.0
    repository: '@axoom-github'
```

You can then add static configuration to your `values.yaml` like this:

```yaml
mongodb:
  service:
    fullnameOverride: myservice-mongodb
  network:
    ingressFromApps:
      - myservice
  backup:
    enabled: true
    image: example.com/my-mongo-backup
```

## Access

This MongoDB setup uses no authentication. All network access to the MongoDB instances is blocked by default via a [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/). You will need to set the `networkPolicy.ingressFromApps` value (see [Values](#values)) or create your own Network Policy to allow other Pods in the Kubernetes Cluster to connect to the MongoDB instances.

## Backups

You can provide your own backup image to be run as a Cronjob. (see [Values](#values))

The job is started with these environment variables:

- `MONGO_HOST` points to the MongoDB instance to create a backup for.
- `BACKUP_NAME` provides a cluster-wide unique name for the backup job.
- Custom environment variables specified in the `backup.env` value (see [Values](#values)).

## Values

| Value                               | Default                             | Description                                                                                                  |
|-------------------------------------|-------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `service.fullnameOverride`          | __required__                        | The name of the database service itself.                                                                     |
| `service.persistentVolume.enabled`  | `true`                              | Controls whether the database gets a persistent volume.                                                      |
| `service.persistentVolume.size`     | `1G`                                | Size of the volume used to store the database.                                                               |
| `service.resources`                 | RAM >64M, <512M                     | Resource requests and limits for the database.                                                               |
| `service.metrics.enabled`           | `true`                              | Controls whether resources for [Prometheus Operator](https://coreos.com/operators/prometheus) are created.   |
| `service.metrics.namespaceSelector` | `{matchLabels: {role: monitoring}}` | Selects the namespace in which Prometheus is running. Used for network policy.                               |
| `networkPolicy.enabled`             | `true`                              | Creates a Kubernetes Network Policy restricting access to MongoDB.                                           |
| `networkPolicy.ingressFromApps`     | `[]`                                | Array of values for `app` or `app.kubernetes.io/name` label of the services that should have access to etcd. |
| `backup.enabled`                    | `false`                             | Controls whether automatic period backups are performed.                                                     |
| `backup.schedule`                   | `0 0 * * *`                         | The backup schedule in [Cron format](https://en.wikipedia.org/wiki/Cron).                                    |
| `backup.env`                        | `{}`                                | Additional environment variables to pass to the backup job.                                                  |
| `backup.image`                      | __required if enabled__             | The image to use for backup job.                                                                             |
| `backup.imagePullPolicy`            | `IfNotPresent`                      | The pull policy to use for the backup image.                                                                 |
| `backup.imagePullSecret`            |                                     | The pull secret to use for the backup image.                                                                 |

All values starting with `service.` are passed through to the [official MongoDB chart](https://hub.kubeapps.com/charts/stable/mongodb-replicaset).
