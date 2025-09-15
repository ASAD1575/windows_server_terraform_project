provider "aws" {
  region = var.aws_region
}

# S3 Module for bucket and script upload
module "s3" {
  source                  = "./modules/S3"
  region                  = var.aws_region
  bucket_name             = var.s3_bucket_name
  aws_dynamodb_table_name = var.dynamodb_table_name
}

# Upload the Windows setup script to S3
resource "aws_s3_object" "windows_setup_script" {
  bucket = module.s3.bucket_id
  key    = "windows_setup.ps1"
  source = "userdata/windows_setup.ps1"
  etag   = filemd5("userdata/windows_setup.ps1")
}

# VPC Module
module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

# Security Group Module
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

# IAM Role Module (for EC2 instances)
module "IAM_role" {
  source = "./modules/IAM_role"
}

# Key Pair Module
module "key_pair" {
  source = "./modules/key_pair"
}

# Base Instance Definition
module "base_instance" {
  source               = "./modules/base_instance"
  ami_id               = var.windows_server_2022_ami_id
  instance_type        = var.base_instance_type
  public_subnet_ids    = module.vpc.public_subnet_ids
  security_group_id    = module.security_group.app_sg_id
  key_pair_name        = module.key_pair.key_pair_name
  aws_region           = var.aws_region
  iam_instance_profile = module.IAM_role.instance_profile_name # Attach IAM instance profile
  s3_bucket_id         = module.s3.bucket_id
}

# Null Resource to Wait for Base Instance to be Ready and Configurations to be Installed
resource "null_resource" "wait_base_instance_ready" {
  provisioner "local-exec" {
    command = "sleep 300 && ./wait_for_flag.sh ${module.base_instance.instance_id}"
  }

  depends_on = [module.base_instance]
}

# AMI Creation from the Base Instance
module "ami_creation" {
  source             = "./modules/ami_creation"
  source_instance_id = module.base_instance.instance_id
  depends_on         = [null_resource.wait_base_instance_ready]
}

# Cloned Instances
module "cloned_instance" {
  source                = "./modules/cloned_instance"
  cloned_instance_count = var.cloned_instance_count
  ami_id                = module.ami_creation.ami_id
  instance_type         = var.cloned_instance_type
  subnet_id             = element(module.vpc.public_subnet_ids, 0)
  security_group_id     = module.security_group.app_sg_id
  key_name              = module.key_pair.key_pair_name
  iam_instance_profile  = module.IAM_role.instance_profile_name # Attach IAM instance profile
  depends_on            = [module.ami_creation]
}
