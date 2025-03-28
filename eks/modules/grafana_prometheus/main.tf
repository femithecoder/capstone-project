module "eks-grafana-prometheus" {
  source  = "DNXLabs/eks-grafana-prometheus/aws"
  version = "0.2.0"

  enabled = true
  namespace_grafana = var.namespace_grafana_prometheus
  create_namespace_grafana = false
  namespace_prometheus = var.namespace_grafana_prometheus
  create_namespace_prometheus = false



  
}