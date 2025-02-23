module "vpc" {
  source = "../tools/modules/vpc"
  main-region = var.main-region
}

module "eks" {
  source = "./modules/cluster"
  cluster_name = var.cluster_name
  private_subnets = module.vpc.private_subnets
  # public_subnets = module.vpc.public_subnets[0]
  vpc_id = module.vpc.vpc_id
  
}
module "aws_alb_controller" {
  source = "./modules/alb"
  env_name = var.env_name
  main-region = var.main-region
  oidc_provider_arn = module.eks.oidc_provider_arn
  vpc_id = module.vpc.vpc_id
  cluster_name = var.cluster_name
}