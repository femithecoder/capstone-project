module "vpc" {
  source = "../tools/modules/vpc"
  main-region = var.main_region
}

module "eks" {
  source = "./modules/cluster"
  private_subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
#   grafana_admin_password = var.grafana_admin_password

  depends_on = [ module.vpc ]
  
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
  depends_on = [ module.eks ]
#   grafana_admin_password = var.grafana_admin_password


}

