# AXOOM Platform Base Assets

This repository contains [ax Asset Descriptors](https://tfs.inside-axoom.org/tfs/axoom/axoom/_git/Axoom.Provisioning?_a=readme&fullScreen=true) for basic infrastructure components and Mixins.

Mixins allow you define and enforce the intended 
structure, make sure you don't forget about required settings and - maybe most 
importantly - allow us to follow *convention over configuration* by bringing 
things together in a predictable way.

![Hierarchy](doc/hierarchy.png)


## AXOOM Service Mixin

This mixin runs an (usually .NET Core-based) AXOOM Service.

### Feed URI

http://assets.axoom.cloud/mixins/axoom-service.xml

### Parameters

| Name              | Description                                             |
| ----------------- | ------------------------------------------------------- |
| `SERVICE_NAME`    | The name of the Docker service.                         |
| `DOCKER_REGISTRY` | The host name of the Docker Registry holding the image. |
| `VERSION`         | The version number of the service.                      |

Expected Docker image name: `(DOCKER_REGISTRY)/services/(SERVICE_NAME):(VERSION)`

### External environment

| Name                     | Default       | Description                                                                                                                |
| ------------------------ | ------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `PUBLIC_DOMAIN`          | (required)    | The public DNS name the entire stack is exposed under. Used as human-readable instance name.                               |
| `LOG_LEVEL`              | `Information` | The [.NET Core Log Level](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?tabs=aspnetcore2x#log-level). |
| `ASPNETCORE_ENVIRONMENT` | `Production`  | Set to `Development` to enable Swagger documentation, exception pages, etc.                                                |
| `WORKER_ROLE`            | `worker`      | Node Role for wokloads. Set to `manager` for local testing.                                                                |

### Usage sample

```yml
mixins:
  - feed_uri: http://assets.axoom.cloud/mixins/axoom-service.xml
    parameters:
      SERVICE_NAME: myservice
      DOCKER_REGISTRY: <DOCKER_REGISTRY>
      VERSION: <VERSION>
```


## AXOOM Portal App Mixin

This mixin runs an (usually ASP .NET Core-based) AXOOM Portal App. Injects the App's metadata into the Portal and Identity Server using environment variables.

### Feed URI

http://assets.axoom.cloud/mixins/axoom-portal-app.xml

### Parameters

| Name              | Description                                                         |
| ----------------- | ------------------------------------------------------------------- |
| `APPKEY`          | The name of the Docker service and subdomain.                       |
| `DOCKER_REGISTRY` | The host name of the Docker Registry holding the image.             |
| `VERSION`         | The version number of the service.                                  |
| `PORTAL_APP`      | A JSON document describing the App's presence in the Portal.        |
| `IDENTITY_CLIENT` | A JSON document describing the App's client in the Identity Server. |

Expected Docker image name: `(DOCKER_REGISTRY)/apps/(APPKEY):(VERSION)`

### External environment

| Name                     | Default       | Description                                                                                                                |
| ------------------------ | ------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `PUBLIC_DOMAIN`          | (required)    | The public DNS name the entire stack is exposed under.                                                                     |
| `PUBLIC_PROTOCOL`        | `https`       | The protocol the entire stack is exposed under.                                                                            |
| `LOG_LEVEL`              | `Information` | The [.NET Core Log Level](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?tabs=aspnetcore2x#log-level). |
| `ASPNETCORE_ENVIRONMENT` | `Production`  | Set to `Development` to enable Swagger documentation, exception pages, etc.                                                |
| `WORKER_ROLE`            | `worker`      | Node Role for wokloads. Set to `manager` for local testing.                                                                |

### Usage sample

```yml
mixins:
  - feed_uri: http://assets.axoom.cloud/mixins/axoom-portal-app.xml
    parameters:
      APPKEY: axoom-myapp
      DOCKER_REGISTRY: <DOCKER_REGISTRY>
      VERSION: <VERSION>
      PORTAL_APP: <PORTAL_APP>
      IDENTITY_CLIENT: <IDENTITY_CLIENT>
```


## Expose Public HTTP(S) Mixin

This mixin exposes a service to public HTTP(S) traffic.

### Feed URI

http://assets.axoom.cloud/mixins/expose-public.xml

### Parameters

| Name           | Description                                                         |
| -------------- | ------------------------------------------------------------------- |
| `SERVICE_NAME` | The name of the Docker service and subdomain.                       |
| `PORT`         | The port number the service (inside the container) is listening on. |

### External environment

| Name              | Default    | Description                                            |
| ----------------- | ---------- | ------------------------------------------------------ |
| `PUBLIC_DOMAIN`   | (required) | The public DNS name the entire stack is exposed under. |
| `PUBLIC_PROTOCOL` | `https`    | The protocol the entire stack is exposed under.        |

### Usage sample

```yml
mixins:
  - feed_uri: http://assets.axoom.cloud/mixins/expose-public.xml
    parameters:
      SERVICE_NAME: myservice
      PORT: 80
```


## Expose Internal HTTP Mixin

This mixin exposes a service to internal HTTP traffic for management purposes.

### Feed URI

http://assets.axoom.cloud/mixins/expose-internal.xml

### Parameters

| Name           | Description                                                         |
| -------------- | ------------------------------------------------------------------- |
| `SERVICE_NAME` | The name of the Docker service and subdomain.                       |
| `PORT`         | The port number the service (inside the container) is listening on. |

### External environment

| Name              | Default    | Description                                              |
| ----------------- | ---------- | -------------------------------------------------------- |
| `INTERNAL_DOMAIN` | (required) | The internal DNS name the entire stack is exposed under. |

### Usage sample

```yml
mixins:
  - feed_uri: http://assets.axoom.cloud/mixins/expose-internal.xml
    parameters:
      SERVICE_NAME: myservice
      PORT: 80
```


## Expose SSH Jump Mixin

This mixin exposes a service to traffic tunneled via an SSH Jump Host for management purposes.

### Feed URI

http://assets.axoom.cloud/mixins/expose-ssh-jump.xml

### Parameters

| Name           | Description                     |
| -------------- | ------------------------------- |
| `SERVICE_NAME` | The name of the Docker service. |

### Usage sample

```yml
mixins:
  - feed_uri: http://assets.axoom.cloud/mixins/expose-ssh-jump.xml
    parameters:
      SERVICE_NAME: myservice
```
