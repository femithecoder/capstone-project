module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-001"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  
  
  # Tagging public subnets for EKS Load Balancers
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  # Tagging private subnets for internal Load Balancers
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}