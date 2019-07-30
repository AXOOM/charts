# Kubernetes Resource Metrics Helm Chart

Uses [Kubernetes Resource Metrics](https://github.com/AXOOM/k8s-resource-metrics) to exposes the status field of a specific kind of Kubernetes Resource (e.g. Pod) as a [Prometheus](https://prometheus.io/) metric.

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

You can then install it like this:

    helm install axoom-github/k8s-resource-metrics

## Values

| Value                 | Default            | Description                                                                 |
|-----------------------|--------------------|-----------------------------------------------------------------------------|
| `apiGroup`            | *empty* (core API) | The API Group of the Kubernetes resource to monitor (e.g. `apps/v1`).       |
| `resource`            | `pods`             | The plural name of the Kubernetes resource to monitor (e.g. `deployments`). |
| `allNamespaces`       | `true`             | Monitor resources in all namespaces rather than just the current one.       |
| `statusJsonPath`      | `.status.phase`    | The JSON Path expression for retrieving the status of a resource.           |
| `rbac`                | `true`             | Create service accounts and role bindings.                                  |
