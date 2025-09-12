provider "aws" {
  region = var.aws_region
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
  source            = "./modules/base_instance"
  ami_id            = var.windows_server_2022_ami_id
  instance_type     = var.base_instance_type
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.app_sg_id
  key_pair_name     = module.key_pair.key_pair_name
  aws_region        = var.aws_region
  iam_instance_profile = module.IAM_role.instance_profile_name  # Attach IAM instance profile
}

# Null Resource to Wait for User Data Completion
resource "null_resource" "wait_userdata" {
  provisioner "remote-exec" {
    inline = [
      "while (!(Test-Path 'C:\\Windows\\Temp\\install_complete.flag')) {",
      "  Write-Host 'Waiting for user data script to complete...'",
      "  Start-Sleep -Seconds 10",
      "} ",
      "Write-Host 'User data script completed successfully.'"
    ]

    connection {
      type        = "winrm"
      host        = module.base_instance.public_ip
      user        = "Administrator"
      password    = module.base_instance.password_data  # Reference the password output from the base_instance module
      https       = true
      insecure    = true
      port        = 5986
    }
  }

  depends_on = [module.base_instance]
}

# AMI Creation from the Base Instance
module "ami_creation" {
  source             = "./modules/ami_creation"
  source_instance_id = module.base_instance.instance_id
  depends_on         = [null_resource.wait_userdata]
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
  iam_instance_profile  = module.IAM_role.instance_profile_name  # Attach IAM instance profile
  depends_on            = [module.ami_creation]
}
