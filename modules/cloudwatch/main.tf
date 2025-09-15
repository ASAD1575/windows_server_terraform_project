# modules/cloudwatch_logs/main.tf

provider "aws" {
  region = var.region
}

# Log group for Base EC2 Instance
resource "aws_cloudwatch_log_group" "ec2_base_log_group" {
  name              = "/ec2/${var.base_instance_name}/logs"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name        = "${var.base_instance_name}-logs"
    Environment = var.environment
    Type        = "Base"
  }
}

# Log group for Cloned EC2 Instance
resource "aws_cloudwatch_log_group" "ec2_clone_log_group" {
  name              = "/ec2/${var.clone_instance_name}/logs"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name        = "${var.clone_instance_name}-logs"
    Environment = var.environment
    Type        = "Clone"
  }
}
