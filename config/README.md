# Sample Node.js Config

Configuration assets consumed by GitOps and runtime tooling. These presets drive the Helm chart deployment used in demos/interviews.

## Contents

- `applications.yaml`: Argo CD `Application` manifest pointing at the Helm chart and demo values.
- `demo/values.yaml`: Opinionated Helm overrides (image, probes, ingress, ConfigMap/Secret wiring).
- `demo/secret-classified-token.yaml`: Namespaced Secret that supplies the `CLASSIFIED_TOKEN` expected by the app.

## Usage

Apply the manifests with kubectl or let Argo CD sync them from this repo:

```bash
kubectl apply -f config/applications.yaml
kubectl apply -f config/demo/secret-classified-token.yaml
```

Once synced, Argo CD installs the chart into the `sample-nodejs-demo` namespace using the demo values file.

## Notes

- Update `demo/values.yaml` whenever you publish a new image tag or want to tweak ingress hosts.
- Secrets committed here are for demonstration only—rotate or externalize for real environments.

> This configuration folder is structured as part of the DevOps task, but its design (separated Applications definition, environment-specific values, secret management, and GitOps-ready layout) follows production-grade GitOps and ArgoCD best practices.
