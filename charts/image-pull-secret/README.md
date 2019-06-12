# Image Pull Secret Helm Chart

This Helm chart deploys an [Image Pull Secret](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) for a private Docker Registry.

To be able to use this Charts you must first run:

    helm repo add axoom-github https://axoom.github.io/charts/

You can then install it like this:

    helm install axoom-github/image-pull-secrets --namespace mynamespace --name mynamespace-gcr.io-image-pull-secret --set domain=gcr.io,username=myuser,password=mypass

Or by using [helmfile](https://github.com/roboll/helmfile):

    TENANT_ID=mynamespace REGISTRY_DOMAIN=gcr.io REGISTRY_USERNAME=myuser REGISTRY_PASSWORD=mypass helmfile sync

## Values

| Helm value  | Environment variable | Description                                                                    |
|-------------|----------------------|--------------------------------------------------------------------------------|
| `TENANT_ID` |                      | The Kubernetes namespace to deploy to.                                         |
| `domain`    | `REGISTRY_DOMAIN`    | The domain name of the Docker Registry. Also used as the name of the `Secret`. |
| `username`  | `REGISTRY_USERNAME`  | The username to use for authenticating with the Docker Registry.               |
| `password`  | `REGISTRY_PASSWORD`  | The password to use for authenticating with the Docker Registry.               |
