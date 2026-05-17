output "namespace" {
  description = "Kubernetes namespace where the observability stack is deployed"
  value       = local.namespace
}

output "loki_address" {
  description = "Loki gateway service address"
  value       = var.loki_enabled ? local.loki_address : null
}

output "tempo_address" {
  description = "Tempo query frontend address"
  value       = var.tempo_enabled ? local.tempo_address : null
}

output "tempo_otlp_address" {
  description = "Tempo OTLP gRPC endpoint"
  value       = var.tempo_enabled ? local.tempo_otlp_addr : null
}

output "prometheus_address" {
  description = "Prometheus service address"
  value       = var.kube_prometheus_stack_enabled ? local.prometheus_addr : null
}

output "grafana_admin_password" {
  description = "Grafana admin password (empty if auto-generated)"
  value       = var.grafana_admin_password != "" ? var.grafana_admin_password : "(auto-generated — see Helm release notes)"
  sensitive   = true
}

output "kube_prometheus_stack_status" {
  description = "Whether kube-prometheus-stack was deployed"
  value       = var.kube_prometheus_stack_enabled
}

output "loki_status" {
  description = "Whether Loki was deployed"
  value       = var.loki_enabled
}

output "tempo_status" {
  description = "Whether Tempo was deployed"
  value       = var.tempo_enabled
}

output "promtail_status" {
  description = "Whether Promtail was deployed"
  value       = var.promtail_enabled
}

output "opentelemetry_collector_status" {
  description = "Whether OpenTelemetry Collector was deployed"
  value       = var.opentelemetry_collector_enabled
}
