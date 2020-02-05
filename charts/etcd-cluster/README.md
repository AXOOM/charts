# etcd Cluster Helm Chart

This Helm chart deploys a stateful etcd cluster with a Network Policy for access control. The cluster does **not** support resized using `kubectl scale`.

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

You can then install it like this:

    helm install axoom-github/etcd-cluster

## Access

This etcd setup uses no authentication. All network access to the etcd instances is blocked by default via a [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/). You will need to set the `networkPolicy.ingressFromApps` value (see [Values](#values)) or create your own Network Policy to allow other Pods in the Kubernetes Cluster to connect to the etcd instances.

## Values

| Value                           | Default                             | Description                                                                                                  |
|---------------------------------|-------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `name`                          | `etcd`                              | The name of the `Service` and `StatefulSet`.                                                                 |
| `image.registry`                | `quay.io`                           |                                                                                                              |
| `image.repository`              | `coreos/etcd`                       |                                                                                                              |
| `image.tag`                     | `v3.3.12`                           |                                                                                                              |
| `image.pullPolicy`              | `IfNotPresent`                      |                                                                                                              |
| `replicas`                      | `5`                                 | The number of replicas. Do not change this after first deployment!                                           |
| `labels`                        | `{}`                                | Additional labels to set on all generated resources                                                          |
| `annotations`                   | `{}`                                | Additional annotations to set on the `Pod`s                                                                  |
| `persistence.storageClass`      |                                     | The type of disk to use for storage instead of the cluster default                                           |
| `persistence.size`              | `2G`                                | The disk size per node.                                                                                      |
| `resources`                     | 256Mi mem                           | The resource requests and limits for the nodes.                                                              |
| `metrics.enabled`               | `true`                              | Controls whether resources for [Prometheus Operator](https://coreos.com/operators/prometheus) are created.   |
| `metrics.namespaceSelector`     | `{matchLabels: {role: monitoring}}` | Selects the namespace in which Prometheus is running. Used for network policy.                               |
| `networkPolicy.enabled`         | `true`                              | Creates a Kubernetes Network Policy restricting access to etcd.                                              |
| `networkPolicy.ingressFromApps` | `[]`                                | Array of values for `app` or `app.kubernetes.io/name` label of the services that should have access to etcd. |
