module "vpc" {
  source = "../../capstone-project/modules/vpc"
  main-region = var.main-region
}

module "eks" {
  source = "value"
}