# module "vpc" {
#   source = "./modules/vpc"
#   main-region = var.main_region
# }

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "capstone-s3-bucket-femi"
    key = "capstone/terraform.state"
    region = "us-east-1"
  }
}
module "eks" {
  source = "./modules/cluster"
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
#   grafana_admin_password = var.grafana_admin_password
#   depends_on = [ module.vpc ]
  
}

module "alb" {
  source = "./modules/alb"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
  depends_on = [ module.eks ]
#   grafana_admin_password = var.grafana_admin_password


}

