module "jenkins-server" {
  source = "./modules/jenkins-server"
  key_name = var.key_name
  instance_type = var.instance_type
  ami = var.ami
  main-region = var.main-region
  depends_on = [ module.vpc ]
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
}
module "sonarqube-docker-server" {
  source = "./modules/sonarqube-docker-server"
  key_name = var.key_name
  instance_type = var.instance_type
  ami = var.ami
  main-region = var.main-region
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[1]
  depends_on = [ module.vpc ]
}
# module "terraform-server" {
#   source = "./modules/terraform-server"
#   key_name = var.key_name
#   instance_type = var.instance_type
#   ami = var.ami
#   main-region = var.main-region
#   vpc_id = module.vpc.vpc_id
#   subnet_id = module.vpc.public_subnets[2]
#   depends_on = [ module.vpc ]
# }
module "vpc" {
  source = "./modules/vpc"
  main-region = var.main-region
}