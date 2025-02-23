provider "aws" {
  region = var.main-region
}

provider "kubernetes" {
  host = module.eks.cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command = "aws"
  }
}

provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_certificate_authority_data]
      command = "aws"
    }
  }
}
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}