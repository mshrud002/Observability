# Dashboards

## Built-in Dashboards (from kube-prometheus-stack)

The kube-prometheus-stack ships with a comprehensive set of built-in dashboards for Kubernetes monitoring:

| Dashboard | Description |
|-----------|-------------|
| Kubernetes / API server | API server metrics |
| Kubernetes / Compute Resources / Cluster | Cluster-level CPU, memory, network, disk |
| Kubernetes / Compute Resources / Namespace (Pods) | Per-namespace pod resource usage |
| Kubernetes / Compute Resources / Node (Pods) | Per-node pod resource usage |
| Kubernetes / Compute Resources / Pod | Per-pod resource usage |
| Kubernetes / Networking / Cluster | Cluster network metrics |
| Kubernetes / Networking / Namespace (Pods) | Per-namespace network metrics |
| Kubernetes / Networking / Pod | Per-pod network metrics |
| Kubernetes / Kubelet | Kubelet metrics |
| Kubernetes / USE Method / Cluster | Cluster utilization |
| Kubernetes / USE Method / Node | Node utilization |
| Node Exporter / Nodes | Node-level hardware/OS metrics |
| Node Exporter / USE Method / Node | Node utilization via USE method |
| Prometheus / Overview | Prometheus self-metrics |
| Alertmanager / Overview | Alertmanager metrics |

## Custom Dashboards

These pre-exported dashboards are included in this repository and can be imported into Grafana:

| File | Description |
|------|-------------|
| [kubernetes-cluster-overview.json](kubernetes-cluster-overview.json) | Cluster-level view — node count, pod count, CPU/memory usage, network I/O, top-K pods by resource |
| [kubernetes-pods-overview.json](kubernetes-pods-overview.json) | Per-pod monitoring — CPU, memory, network I/O, container restarts, with namespace/pod filters |

### Importing

1. Open Grafana → Dashboards → New → Import
2. Upload the JSON file or paste its contents
3. Select the Prometheus data source
4. Click Import
