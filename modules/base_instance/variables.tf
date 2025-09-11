# The AMI ID for the base instance.
variable "ami_id" {
  description = "The ID of the AMI for the base instance."
  type        = string
}

# The instance type (e.g., "t2.micro").
variable "instance_type" {
  description = "The instance type."
  type        = string
}

# The subnet to launch the instance in.
variable "subnet_id" {
  description = "The subnet ID to launch the instance in."
  type        = string
}

# The security group to apply to the instance.
variable "security_group_id" {
  description = "The ID of the security group to attach to the instance."
  type        = string
}

# The key pair name for SSH access.
variable "key_name" {
  description = "The key pair name for SSH access."
  type        = string
}

# The administrative password for the instance.
variable "admin_password" {
  description = "The administrative password for the instance."
  type        = string
  sensitive   = true
}

# The AWS region.
variable "aws_region" {
  description = "The AWS region."
  type        = string
}
