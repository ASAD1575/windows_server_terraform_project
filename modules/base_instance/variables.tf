# The AMI ID for the base instance.
variable "ami_id" {
  description = "The ID of the AMI for the base instance."
  type        = string
}

# The instance type (e.g., "t3.medium").
variable "instance_type" {
  description = "The instance type."
  type        = string
}

# The public subnets to launch the instance in.
variable "public_subnet_ids" {
  description = "The list of public subnet IDs to launch the instance in."
  type        = list(string)
}

# The security group to apply to the instance.
variable "security_group_id" {
  description = "The ID of the security group to attach to the instance."
  type        = string
}

# The key pair name for RDP access.
variable "key_pair_name" {
  description = "The key pair name for RDP access."
  type        = string
}

# The AWS region.
variable "aws_region" {
  description = "The AWS region."
  type        = string
}
