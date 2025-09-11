provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "key_pair" {
  source = "./modules/key_pair"
}

module "base_instance" {
  source            = "./modules/base_instance"
  ami_id            = var.windows_server_2022_ami_id
  instance_type     = var.base_instance_type
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.app_sg_id
  key_pair_name     = module.key_pair.key_pair_name
  aws_region        = var.aws_region
}

module "ami_creation" {
  source             = "./modules/ami_creation"
  source_instance_id = module.base_instance.instance_id
  depends_on         = [module.base_instance]
}

module "cloned_instance" {
  source                = "./modules/cloned_instance"
  cloned_instance_count = var.cloned_instance_count
  ami_id                = module.ami_creation.ami_id
  instance_type         = var.cloned_instance_type
  subnet_id             = element(module.vpc.public_subnet_ids, 0)
  security_group_id     = module.security_group.app_sg_id
  key_name              = module.key_pair.key_pair_name
  depends_on            = [module.ami_creation]
}
