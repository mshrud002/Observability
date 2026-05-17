module "observability" {
  source = "../../modules/observability-stack"

  cluster_name = "my-cluster"
  environment  = "production"
  namespace    = "observability"

  # Uncomment to set a Grafana admin password
  # grafana_admin_password = "admin123"

  # Uncomment to expose Grafana via ingress
  # grafana_ingress_enabled = true
  # grafana_ingress_host    = "grafana.example.com"

  # Uncomment to use a specific storage class
  # loki_storage_class               = "gp3"
  # tempo_storage_class              = "gp3"
  # kube_prometheus_stack_storage_class = "gp3"

  # Uncomment to adjust resource retention
  # kube_prometheus_stack_retention = "15d"

  # Uncomment to disable specific components
  # opentelemetry_collector_enabled = false
  # promtail_enabled                = false
}
