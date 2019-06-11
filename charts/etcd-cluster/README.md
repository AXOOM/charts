# etcd Cluster Helm Chart

This Helm chart deploys a stateful etcd cluster. The cluster does **not** support resized using `kubectl scale`.

This etcd setup uses no authentication. All network access to the etcd instances is blocked by default via a Network Policy. You will need to create your own [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) to allow other Pods in the Kubernetes Cluster to connect to the etcd instances.

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

You can then install it like this:

    helm install axoom-github/etcd-cluster

## Values

| Value                          | Default                             | Description                                                                                                |
|--------------------------------|-------------------------------------|------------------------------------------------------------------------------------------------------------|
| `name`                         | `etcd`                              | The name of the `Service` and `StatefulSet`.                                                               |
| `image.registry`               | `quay.io`                           |                                                                                                            |
| `image.repository`             | `coreos/etcd`                       |                                                                                                            |
| `image.tag`                    | `v3.3.12`                           |                                                                                                            |
| `image.pullPolicy`             | `IfNotPresent`                      |                                                                                                            |
| `replicas`                     | `5`                                 | The number of replicas. Do not change this after first deployment!                                         |
| `persistence.storageClass`     | cluster default                     | The type of storage to use.                                                                                |
| `persistence.size`             | `2G`                                | The disk size per node.                                                                                    |
| `resources`                    | 256Mi mem                           | The resource requests and limits for the nodes.                                                            |
| `networkPolicy.enabled`        | `true`                              |                                                                                                            |
| `prometheus.enabled`           | `true`                              | Controls whether resources for [Prometheus Operator](https://coreos.com/operators/prometheus) are created. |
| `prometheus.namespaceSelector` | `{matchLabels: {role: monitoring}}` | Selects the namespace in which Prometheus is running. Used for network policy.                             |
