# AXOOM Helm Charts

This contains the sources for the following [Helm](https://helm.sh/) Charts:
- [Generic Service Helm Chart](charts/generic-service/README.md)
- [Kubernetes Resource Metrics Helm Chart](charts/k8s-resource-metrics/README.md)
- [Pod Restarter Helm Chart](charts/pod-restarter/README.md)
- [Image Pull Secret Helm Chart](charts/image-pull-secret/README.md)
- [etcd Cluster Helm Chart](charts/etcd-cluster/README.md)
- [MongoDB Helm Chart](charts/mongodb/README.md)

To be able to use these Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/
