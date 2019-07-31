# Kubernetes Resource Metrics Helm Chart

Uses [Kubernetes Resource Metrics](https://github.com/AXOOM/k8s-resource-metrics) to exposes the status field of a specific kind of Kubernetes Resource (e.g. Pod) as a [Prometheus](https://prometheus.io/) metric.

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

You can then install it like this:

    helm install axoom-github/k8s-resource-metrics

## Values

| Value           | Default            | Description                                                                                 |
|-----------------|--------------------|---------------------------------------------------------------------------------------------|
| `apiGroup`      | *empty* (core API) | The API Group of the Kubernetes resource to monitor (e.g. `servicecatalog.k8s.io/v1beta1`). |
| `resource`      | `pods`             | The plural name of the Kubernetes resource to monitor (e.g. `serviceinstances`).            |
| `statusColumn`  | `4`                | The `kubectl get` column that contains status of the resource (e.g. `5`).                   |
| `allNamespaces` | `true`             | Monitor resources in all namespaces rather than just the current one.                       |
| `rbac`          | `true`             | Create service accounts and role bindings.                                                  |
