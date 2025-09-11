provider "aws" {
  region = var.aws_region
  
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs = var.azs
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  
}