variable "namespace" {
  description = "Kubernetes namespace to deploy the observability stack into"
  type        = string
  default     = "observability"
}

variable "cluster_name" {
  description = "Name of the cluster (used for labels and metadata)"
  type        = string
  default     = "kubernetes"
}

variable "environment" {
  description = "Environment label (e.g. production, staging)"
  type        = string
  default     = "production"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

# Kube-Prometheus-Stack
variable "kube_prometheus_stack_enabled" {
  description = "Deploy kube-prometheus-stack (Prometheus, Alertmanager, Grafana, kube-state-metrics, node-exporter)"
  type        = bool
  default     = true
}

variable "kube_prometheus_stack_chart_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = "58.5.0"
}

variable "kube_prometheus_stack_values" {
  description = "Additional values for kube-prometheus-stack"
  type        = any
  default     = {}
}

variable "kube_prometheus_stack_retention" {
  description = "Prometheus data retention period"
  type        = string
  default     = "30d"
}

variable "kube_prometheus_stack_storage_size" {
  description = "Prometheus PVC storage size"
  type        = string
  default     = "10Gi"
}

variable "kube_prometheus_stack_storage_class" {
  description = "Storage class for Prometheus PVC (empty = cluster default)"
  type        = string
  default     = ""
}

# Loki
variable "loki_enabled" {
  description = "Deploy Loki for log aggregation"
  type        = bool
  default     = true
}

variable "loki_chart_version" {
  description = "Version of the Loki Helm chart"
  type        = string
  default     = "6.6.4"
}

variable "loki_values" {
  description = "Additional values for Loki"
  type        = any
  default     = {}
}

variable "loki_storage_size" {
  description = "Loki PVC storage size"
  type        = string
  default     = "10Gi"
}

variable "loki_storage_class" {
  description = "Storage class for Loki PVC (empty = cluster default)"
  type        = string
  default     = ""
}

# Promtail
variable "promtail_enabled" {
  description = "Deploy Promtail for log collection"
  type        = bool
  default     = true
}

variable "promtail_chart_version" {
  description = "Version of the Promtail Helm chart"
  type        = string
  default     = "6.16.2"
}

variable "promtail_values" {
  description = "Additional values for Promtail"
  type        = any
  default     = {}
}

# Tempo
variable "tempo_enabled" {
  description = "Deploy Tempo for distributed tracing"
  type        = bool
  default     = true
}

variable "tempo_chart_version" {
  description = "Version of the Tempo Helm chart"
  type        = string
  default     = "1.9.1"
}

variable "tempo_values" {
  description = "Additional values for Tempo"
  type        = any
  default     = {}
}

variable "tempo_storage_size" {
  description = "Tempo PVC storage size"
  type        = string
  default     = "10Gi"
}

variable "tempo_storage_class" {
  description = "Storage class for Tempo PVC (empty = cluster default)"
  type        = string
  default     = ""
}

# OpenTelemetry Collector
variable "opentelemetry_collector_enabled" {
  description = "Deploy OpenTelemetry Collector for trace collection"
  type        = bool
  default     = true
}

variable "opentelemetry_collector_chart_version" {
  description = "Version of the OpenTelemetry Collector Helm chart"
  type        = string
  default     = "0.98.0"
}

variable "opentelemetry_collector_values" {
  description = "Additional values for OpenTelemetry Collector"
  type        = any
  default     = {}
}

# Grafana
variable "grafana_admin_password" {
  description = "Grafana admin password (auto-generated if empty)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "grafana_ingress_enabled" {
  description = "Enable ingress for Grafana"
  type        = bool
  default     = false
}

variable "grafana_ingress_host" {
  description = "Hostname for Grafana ingress"
  type        = string
  default     = ""
}

variable "grafana_ingress_annotations" {
  description = "Annotations for Grafana ingress"
  type        = map(string)
  default     = {}
}

# General
variable "loki_address" {
  description = "Override Loki service address (default: auto-computed)"
  type        = string
  default     = ""
}

variable "tempo_address" {
  description = "Override Tempo query-frontend address (default: auto-computed)"
  type        = string
  default     = ""
}

variable "tempo_otlp_address" {
  description = "Override Tempo OTLP gRPC address (default: auto-computed)"
  type        = string
  default     = ""
}

variable "prometheus_address" {
  description = "Override Prometheus service address (default: auto-computed)"
  type        = string
  default     = ""
}

variable "global_labels" {
  description = "Global labels to apply to resources"
  type        = map(string)
  default     = {}
}
