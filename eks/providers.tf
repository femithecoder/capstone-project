provider "kubernetes" {
  host = module.eks.cluster.endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command = "aws"
  }
}

provider "helm" {
  kubernetes {
    host = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args = ["eks", "get-token", "--cluster-name", var.cluster_ca_certificate]
      command = "aws"
    }
  }
}