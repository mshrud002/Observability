locals {
  namespace     = var.namespace
  global_labels = merge(var.global_labels, { environment = var.environment, cluster = var.cluster_name })

  loki_address    = var.loki_address != "" ? var.loki_address : "http://loki-gateway.${local.namespace}.svc.cluster.local:80"
  tempo_address   = var.tempo_address != "" ? var.tempo_address : "http://tempo.${local.namespace}.svc.cluster.local:3100"
  tempo_otlp_addr = var.tempo_otlp_address != "" ? var.tempo_otlp_address : "tempo.${local.namespace}.svc.cluster.local:4317"
  prometheus_addr = var.prometheus_address != "" ? var.prometheus_address : "http://kube-prometheus-stack-prometheus.${local.namespace}.svc.cluster.local:9090"
}

# ──────────────────────────────────────────────
# Namespace
# ──────────────────────────────────────────────
resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name   = local.namespace
    labels = local.global_labels
  }
}

# ──────────────────────────────────────────────
# Loki — Log aggregation
# ──────────────────────────────────────────────
resource "helm_release" "loki" {
  count = var.loki_enabled ? 1 : 0
  name  = "loki"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = var.loki_chart_version

  namespace        = local.namespace
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  lint             = true

  values = concat([
    file("${path.module}/values/loki.yaml"),
    yamlencode({
      persistence = merge({
        size = var.loki_storage_size
      }, var.loki_storage_class != "" ? {
        storageClassName = var.loki_storage_class
      } : {})
    })
  ], [yamlencode(var.loki_values)])

  depends_on = [kubernetes_namespace.this]
}

# ──────────────────────────────────────────────
# Tempo — Distributed tracing
# ──────────────────────────────────────────────
resource "helm_release" "tempo" {
  count = var.tempo_enabled ? 1 : 0
  name  = "tempo"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  version    = var.tempo_chart_version

  namespace        = local.namespace
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  lint             = true

  values = concat([
    file("${path.module}/values/tempo.yaml"),
    yamlencode({
      persistence = merge({
        size = var.tempo_storage_size
      }, var.tempo_storage_class != "" ? {
        storageClassName = var.tempo_storage_class
      } : {})
    })
  ], [yamlencode(var.tempo_values)])

  depends_on = [kubernetes_namespace.this]
}

# ──────────────────────────────────────────────
# Promtail — Log collection
# ──────────────────────────────────────────────
resource "helm_release" "promtail" {
  count = var.promtail_enabled ? 1 : 0
  name  = "promtail"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = var.promtail_chart_version

  namespace        = local.namespace
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  lint             = true

  values = concat([
    file("${path.module}/values/promtail.yaml"),
    yamlencode({
      config = {
        clients = [{
          url = "${local.loki_address}/loki/api/v1/push"
        }]
      }
    })
  ], [yamlencode(var.promtail_values)])

  depends_on = [helm_release.loki, kubernetes_namespace.this]
}

# ──────────────────────────────────────────────
# OpenTelemetry Collector — Trace collection
# ──────────────────────────────────────────────
resource "helm_release" "opentelemetry_collector" {
  count = var.opentelemetry_collector_enabled ? 1 : 0
  name  = "otel-collector"

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = var.opentelemetry_collector_chart_version

  namespace        = local.namespace
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  lint             = true

  values = concat([
    file("${path.module}/values/opentelemetry-collector.yaml"),
    yamlencode({
      config = {
        exporters = {
          otlp = {
            endpoint = local.tempo_otlp_addr
            tls = {
              insecure = true
            }
          }
        }
      }
    })
  ], [yamlencode(var.opentelemetry_collector_values)])

  depends_on = [helm_release.tempo, kubernetes_namespace.this]
}

# ──────────────────────────────────────────────
# Kube-Prometheus-Stack — Metrics, Alerting, Grafana
# ──────────────────────────────────────────────
resource "helm_release" "kube_prometheus_stack" {
  count = var.kube_prometheus_stack_enabled ? 1 : 0
  name  = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.kube_prometheus_stack_chart_version

  namespace        = local.namespace
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  lint             = true

  values = concat([
    file("${path.module}/values/kube-prometheus-stack.yaml"),
    yamlencode({
      grafana = {
        adminPassword = var.grafana_admin_password
        ingress = var.grafana_ingress_enabled ? {
          enabled  = true
          hosts    = [var.grafana_ingress_host]
          annotations = var.grafana_ingress_annotations
        } : { enabled = false }
        additionalDataSources = [
          {
            name   = "Loki"
            type   = "loki"
            url    = local.loki_address
            access = "proxy"
          },
          {
            name   = "Tempo"
            type   = "tempo"
            url    = local.tempo_address
            access = "proxy"
          }
        ]
      }
      prometheus = {
        prometheusSpec = {
          retention = var.kube_prometheus_stack_retention
          storageSpec = {
            volumeClaimTemplate = {
              spec = merge({
                resources = {
                  requests = {
                    storage = var.kube_prometheus_stack_storage_size
                  }
                }
              }, var.kube_prometheus_stack_storage_class != "" ? {
                storageClassName = var.kube_prometheus_stack_storage_class
              } : {})
            }
          }
        }
      }
    })
  ], [yamlencode(var.kube_prometheus_stack_values)])

  depends_on = [
    helm_release.loki,
    helm_release.tempo,
    kubernetes_namespace.this,
  ]
}
