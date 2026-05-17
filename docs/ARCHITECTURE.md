# Observability Stack Architecture

## Overview

A fully open-source observability stack designed to be deployed on any Kubernetes cluster. Built entirely with CNCF-graduated and popular open-source projects — no vendor lock-in, no proprietary agents.

## Stack Components

```
                    ┌─────────────────────────────────────────────────┐
                    │                   Grafana                       │
                    │   Dashboards · Alerting · Explore               │
                    └────┬──────────┬──────────────┬──────────────────┘
                         │          │              │
                    ┌────┴──┐ ┌─────┴──────┐ ┌────┴──────────┐
                    │Prometheus│  │   Loki     │ │    Tempo      │
                    │ Metrics  │  │   Logs     │ │   Traces      │
                    └────┬────┘  └─────┬──────┘ └────┬──────────┘
                         │             │              │
                    ┌────┴────┐  ┌────┴───────┐ ┌────┴──────────┐
                    │Node Exp.│  │  Promtail   │ │  OTel Col.    │
                    │kube-st. │  │  (FluentB.) │ │  (OTLP)       │
                    └─────────┘  └────────────┘ └───────────────┘
```

### Metrics — Prometheus + kube-prometheus-stack
- **kube-prometheus-stack**: Bundles Prometheus, Alertmanager, kube-state-metrics, node-exporter, and Grafana
- **kube-state-metrics**: Generates metrics about K8s object states
- **node-exporter**: Hardware and OS metrics from worker nodes
- **Alertmanager**: Deduplicates and routes alerts

### Logging — Loki + Promtail
- **Loki**: Horizontally-scalable, multi-tenant log aggregation system
- **Promtail**: Log collector that discovers targets, attaches labels, and pushes to Loki
- File-based storage by default (no cloud dependency)

### Tracing — Tempo + OpenTelemetry Collector
- **Tempo**: Cost-effective, scalable distributed tracing backend
- **OpenTelemetry Collector**: Vendor-agnostic agent for collecting traces (OTLP protocol)
- Local storage by default; can be configured for S3/GCS/Azure

### Visualization — Grafana
- Deployed as part of kube-prometheus-stack
- Pre-configured data sources: Prometheus, Loki, Tempo
- Includes all standard Kubernetes dashboards

## Deployment Methods

### 1. Terraform Module (Recommended)
Deploys the full stack via the Helm provider with sensible defaults and full configuration support.

### 2. Helm Umbrella Chart
Coming soon — a single `helm install` that deploys all components.

## Prerequisites

- Kubernetes cluster 1.24+
- Helm 3.x
- Terraform 1.5+ (for Terraform deployment)
- 8GB+ available memory across cluster nodes
- Persistent volume support (for Loki, Tempo, Prometheus)

## Default Storage

All components use ephemeral or PVC-backed local storage by default:
- **Prometheus**: PVC — 10Gi, 30-day retention
- **Loki**: PVC — 10Gi, 24h retention
- **Tempo**: PVC — 10Gi, 7-day retention
- **Grafana**: EmptyDir (config is ephemeral)

For production, configure external storage (S3/GCS/Azure Blob).
