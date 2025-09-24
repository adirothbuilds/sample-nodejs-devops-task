# DevOps Sample Node.js App

## Overview

A lightweight Node.js application. It exposes health endpoints, a Prometheus metrics feed, and a handful of demo routes that showcase how ConfigMaps and Secrets can influence runtime behavior.

## Endpoints

- `/my-app`: demo hello world route
- `/about`: returns message configured via `ABOUT_MESSAGE` (ConfigMap)
- `/classified`: requires `CLASSIFIED_TOKEN` (Secret); returns 403 otherwise
- `/ready`: readiness probe endpoint
- `/live`: liveness probe endpoint
- `/metrics`: Prometheus-compatible metrics feed

## Prerequisites

- Node.js (v22.1.0)
- npm

## Environment variables

| Name | Default | Purpose |
| ---- | ------- | ------- |
| `PORT` | `8080` | Port the Express server binds to |
| `NODE_ENV` | `production` | Standard Node.js runtime environment flag |
| `ABOUT_MESSAGE` | `This is a sample Node.js application for Kubernetes deployment testing.` | Text returned by the `/about` route (ideal for ConfigMap injection) |
| `CLASSIFIED_TOKEN` | _empty_ | Token required to receive a positive response from `/classified` (ideal for Secret injection) |

## Running locally

```bash
npm install   # or: npm ci
npm run start
```

The application listens on `http://localhost:8080` by default. Use the environment variables above to customize responses.

## Container image

`Dockerfile` implements a two-stage build:

- Builder stage based on `node:22.1.0-slim` installs production dependencies using `npm ci` when a lockfile is present.
- Runtime stage uses `gcr.io/distroless/nodejs22:nonroot`, copies in the compiled app, exposes port `8080`, sets `NODE_ENV=production`, and runs as the `nonroot` user.

See `.dockerignore` for the files excluded from the build context.

## Build Docker locally

Prerequisites:

- Docker (tested with v27.4.0)
- Access to `gcr.io` (for distroless base image)

Build the image:

```bash
docker build -t docker-image-name:tag .
```

## Kubernetes integration

- Configurable via **ConfigMap** and **Secret** (injected as environment variables)
- Exposes readiness and liveness probes for Kubernetes health checks
- Provides a `/metrics` endpoint compatible with Prometheus
- Includes a Helm chart for deployment (Deployment, Service, Ingress, ConfigMap)

> This project is designed as a DevOps task, but the patterns used (multi-stage Docker build, non-root distroless runtime, Helm chart with ConfigMap/Secret integration) reflect production-grade practices.
