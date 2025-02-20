module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name = "capstone-eks"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true
  
}