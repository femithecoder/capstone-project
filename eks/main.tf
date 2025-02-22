module "vpc" {
  source = "../../capstone-project/modules/vpc"
  main-region = var.main-region
}

module "eks" {
  source = "./modules/cluster"
  private_subnets = module.vpc.private_subnets
  public_subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
}