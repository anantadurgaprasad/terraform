module "vpc" {
  source          = "../Modules/VPC"
  environment     = var.environment
  app_name        = var.app_name
  cidr_base       = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}