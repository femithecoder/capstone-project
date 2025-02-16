module "jenkins-server" {
  source = "./modules/jenkins-server"
  key_name = var.key_name
  instance_type = var.instance_type
  ami = var.ami
  main-region = var.main-region
}
module "sonarqube-docker-server" {
  source = "./modules/sonarqube-docker-server"
  key_name = var.key_name
  instance_type = var.instance_type
  ami = var.ami
  main-region = var.main-region
}
module "terraform-server" {
  source = "./modules/terraform-server"
  key_name = var.key_name
  instance_type = var.instance_type
  ami = var.ami
  main-region = var.main-region
}
module "vpc" {
  source = "./modules/vpc"
  main-region = var.main-region

}