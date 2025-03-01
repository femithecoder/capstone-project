module "vpc" {
  source = "../tools/modules/vpc"
  main-region = var.main_region
}

module "eks" {
  source = "./modules/cluster"
  private_subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id

  depends_on = [ module.vpc ]
  
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
  
}

module "grafana_prometheus" {
  source = "./modules/grafana_prometheus"
  depends_on = [ module.eks ]
}