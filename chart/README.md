# Simple Node.js Helm Chart

Helm chart that deploys [sample Node.js application](../app) with Kubernetes best practices.
Designed for interview assignments and demos.

## Requirements

- Helm 3
- Kubernetes cluster (Minikube, k3d, or managed cluster)

## What this chart installs

- **Deployment** with configurable replicas, probes, resource requests/limits, and environment variables
- **Service** exposing the app port (default `8080`)
- **ConfigMap** with application configuration injected as environment variables
- **Optional Secret** reference for sensitive values (e.g., tokens)
- **Ingress** (optional) with TLS and annotations, when enabled
- **ServiceAccount** (optional, defaults to `default`)

## Key values

| Key | Description |
| --- | ----------- |
| `replicaCount` | Number of pods |
| `image.repository` / `image.tag` | Container image reference |
| `service.type` / `service.port`  | Service configuration |
| `config.*` | Default ConfigMap values: `nodeEnv`, `appPort`, `aboutMessage` |
| `secret.classifiedToken` | Reference to an existing Secret (disabled by default) |
| `resources` | CPU/memory requests and limits |
| `ingress.*` | Enable ingress, configure hosts, annotations, TLS |

See [`values.yaml`](./sample-nodejs/values.yaml) for the full list of configurable options.

## Common commands

```bash
# Lint the chart
helm lint ./simple-nodejs

# Render manifests locally (using defaults)
helm template test ./simple-nodejs > render.yaml

# Install/upgrade into a cluster
helm upgrade --install test ./simple-nodejs \
  --namespace demo --create-namespace
```

Override values inline with `--set key=value` or provide a custom `values.yaml` file.

> This project is designed as a DevOps task, but the design choices (configurable values, probe definitions, optional Ingress, ConfigMap/Secret integration) are aligned with production-grade Kubernetes practices.
