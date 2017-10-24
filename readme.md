# AXOOM Platform Base Assets

This repository contains [ax Asset Descriptors](https://tfs.inside-axoom.org/tfs/axoom/axoom/_git/Axoom.Provisioning?_a=readme&fullScreen=true) for basic infrastructure components and Mixins.

## Assets

For a description of the mixins provided in this repository, 
look at the `description` header of the mixin or examine its source code. 
Most of them are so small that describing them here in detail 
would be very redundant.

### Why use mixins?
The rational behind using mixins is that they define and enforce the intended 
structure, make sure you don't forget about required settings and - maybe most 
importantly - allow us to follow *convention over configuration* by bringing 
things together in a predictable way.

### When to use which mixin:
- http://assets.axoom.cloud/mixins/expose-public.xml
    - For all containers that expose a service on standard port to the web.
- http://assets.axoom.cloud/mixins/expose-internal.xml
    - For all containers that expose a service on standard for internal purpose, 
    like monitoring.
- http://assets.axoom.cloud/mixins/axoom-service.xml
    - For everything that is started from a docker image. Sets some default 
    environment for .NET Core runtime.
- http://assets.axoom.cloud/mixins/axoom-portal-app.xml
    - For all portal apps. 
